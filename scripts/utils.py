import subprocess
from pathlib import Path
import sys
import xml.etree.ElementTree as ET
from joblib import Parallel, delayed


def run_cmd(cmd: str, cwd: Path, fail_ok: bool = False) -> subprocess.CompletedProcess:
    print(f"running {cmd}")
    result = subprocess.run(
        cmd, shell=True, stdout=sys.stdout, stderr=subprocess.STDOUT, cwd=cwd
    )
    if not fail_ok:
        assert (
            result.returncode == 0
        ), f"{cmd} failed with returncode {result.returncode}"
    return result


def run_cmd_capture(cmd: str, cwd: Path) -> str:
    print(f"running {cmd}")
    result = subprocess.run(cmd, shell=True, capture_output=True, cwd=cwd)
    stdout = result.stdout.decode("UTF-8").strip()
    assert (
        result.returncode == 0
    ), f"{cmd} failed with returncode {result.returncode} and stdout {stdout}"
    return stdout


def split_pdf(pdf: Path, dest_dir: Path, prefix: str, wd: Path) -> None:
    pdf_path = str(pdf.absolute()).replace(
        " ", "\\ "
    )  # pdfseparate is very picky about spaces in the path
    run_cmd(f"pdfseparate {pdf_path} {dest_dir.absolute()}/{prefix}%d.pdf", wd)


def num_pages_in_pdf(pdf: Path, wd: Path) -> int:
    pages = run_cmd_capture(
        f"pdfinfo \"{pdf.absolute()}\" | grep Pages | cut --delimiter=':' --fields=2",
        wd,
    )
    return int(pages.strip())


def single_pdf_to_svg(pdf: Path, page: int, svg: Path, poppler: bool, wd: Path) -> None:
    extra_arg = "" if not poppler else "--pdf-poppler"
    # fail_ok=True, since inkscape exits with bad exit code randomly
    # https://gitlab.com/inkscape/inkscape/-/issues/4163
    run_cmd(
        f'inkscape {extra_arg} --pages={page} --export-type="svg" --export-filename={svg.absolute()} "{pdf.absolute()}"',
        wd,
        fail_ok=True,
    )


def pdf_to_svg(
    pdf: Path, n_pages: int, prefix: str, poppler: bool, wd: Path, n_cores: int = 1
) -> None:
    def convert(idx: int) -> None:
        svg = wd / f"{prefix}{idx:02d}.svg"
        single_pdf_to_svg(pdf, idx + 1, svg, poppler, wd)

    Parallel(n_jobs=n_cores)(delayed(convert)(page) for page in range(n_pages))


def strip_svg_background(
    input_svg: Path, dest_svg: Path, poppler: bool, from_pptx: bool, wd: Path
) -> None:
    tree = ET.parse(input_svg)
    root = tree.getroot()
    if not poppler:
        # If poppler wasn't used to generate the SVG, then it should only have one group
        # We have to delete 2 paths within that group that trace the SVG background
        group = root.find("{http://www.w3.org/2000/svg}g")
        assert group
        # There should only be one group with id g1
        assert group.attrib["id"] == "g1"
        # There should be 2 paths that we need to delete
        # make sure they are indeed what we're looking for and save their id's
        for j in [0, 1]:
            assert "fill:#ffffff" in group[j].attrib["style"]
        path_ids = [group[j].attrib["id"] for j in [0, 1]]
        things_to_delete = ",".join(path_ids)
    else:
        if from_pptx:
            # If poppler was used to generate the SVG, then it will have a group for each glyph, in this case
            # identify the group with the smallest id - it will contain the 2 paths that trace the background
            groups = sorted(
                [
                    int(x.attrib["id"][1:])
                    for x in root.findall("{http://www.w3.org/2000/svg}g")
                ]
            )
            things_to_delete = f"g{groups[0]}"
        else:
            # Poppler was used to import the PDF, but the PDF came directly from Google Slides (not from processing the pptx)
            # In this case, the background is a single rect - delete just that one
            rect = root.findall("{http://www.w3.org/2000/svg}rect")
            assert len(rect) == 1
            assert rect[0].attrib["fill"] == "rgb(100%, 100%, 100%)"
            things_to_delete = rect[0].attrib["id"]

    run_cmd(
        f'inkscape --actions "select-by-id:{things_to_delete}; delete-selection; select-all; fit-canvas-to-selection; \
            export-filename: {dest_svg.absolute()}; export-plain-svg; export-do;" {input_svg.absolute()}',
        wd,
    )
