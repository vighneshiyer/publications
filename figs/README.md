# Figures

- The figures inside the various folders here are *static* figures, meaning they are standalone and don't come from another source
- The figures inside the `**dynamic**` folder are *dynamic* figures, meaning they come from a Google Slides presentation and are decomposed into a bunch of SVGs

- Remove all generated artifacts: `make -f Makefrag clean-figs`
- Pull dynamic PDFs from Google Drive using rclone (this only works on my computer, so these artifacts are checked into the repo): `make -f Makefrag pdfs`
    - If you wanted to edit a dynamic figure, edit it in Google Slides, then download the PDF and place it in `dynamic/`
    - e.g. for the tidalsim figures, place the PDF in `dynamic/tidalsim/tidalsim.pdf`
- Generate PDFs from SVGs and extract SVGs from dynamic PDFs: `make -f Makefrag figs`
