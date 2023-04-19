# Papers

- All figures are consolidated in the `figs` folder in `publications`

## Setup

- Run `git submodule update --init --recursive .` (to fetch the `acmart` submodule)
- Go to `templates/acmart` and edit the `Makefile` to replace `pdflatex-dev` with `pdflatex` (same thing with `xelatex-dev` and `lualatex-dev`)
- Run `make acmart.cls` to build `acmart.cls`
