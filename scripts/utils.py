import subprocess
from pathlib import Path
import sys
import xml.etree.ElementTree as ET

def run_cmd(cmd: str, cwd: Path) -> subprocess.CompletedProcess:
    print(f"running {cmd}")
    result = subprocess.run(cmd, shell=True, stdout=sys.stdout, stderr=subprocess.STDOUT, cwd=cwd)
    assert result.returncode == 0, f"{cmd} failed with returncode {result.returncode}"
    return result

def run_cmd_capture(cmd: str, cwd: Path) -> str:
    print(f"running {cmd}")
    result = subprocess.run(cmd, shell=True, capture_output=True, cwd=cwd)
    stdout = result.stdout.decode('UTF-8').strip()
    assert result.returncode == 0, f"{cmd} failed with returncode {result.returncode} and stdout {stdout}"
    return stdout

def pdf_to_svg(pdf: Path, poppler: bool, wd: Path) -> None:
    svg = pdf.with_suffix(".svg")
    extra_arg = "" if not poppler else "--pdf-poppler"
    run_cmd(f"inkscape {extra_arg} --export-page=1 --export-type=\"svg\" --export-filename={svg.absolute()} {pdf.absolute()}", wd)

def strip_svg_background(input_svg: Path, dest_svg: Path, poppler: bool, wd: Path) -> None:
    tree = ET.parse(input_svg)
    root = tree.getroot()
    if not poppler:
        # If poppler wasn't used to generate the SVG, then it should only have one group
        # We have to delete 2 paths within that group that trace the SVG background
        group = root.find('{http://www.w3.org/2000/svg}g')
        assert group
        # There should only be one group with id g1
        assert group.attrib['id'] == 'g1'
        # There should be 2 paths that we need to delete
        # make sure they are indeed what we're looking for and save their id's
        for j in [0,1]:
            assert 'fill:#ffffff' in group[j].attrib['style']
        path_ids = [group[j].attrib['id'] for j in [0,1]]
        things_to_delete = ','.join(path_ids)
    else:
        # If poppler was used to generate the SVG, then it will have a group for each glyph, in this case
        # identify the group with the smallest id - it will contain the 2 paths that trace the background
        groups = sorted([int(x.attrib['id'][1:]) for x in root.findall('{http://www.w3.org/2000/svg}g')])
        things_to_delete = f"g{groups[0]}"

    run_cmd(f'inkscape --actions "select-by-id:{things_to_delete}; delete-selection; select-all; fit-canvas-to-selection; \
            export-filename: {dest_svg.absolute()}; export-plain-svg; export-do;" {input_svg.absolute()}', wd)
