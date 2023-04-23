# HTML/CSS Posters

This repo is based on [cpitclaudel/academic-poster-template](https://github.com/cpitclaudel/academic-poster-template).
My modifications include:

- Splitting posters into a base template (`base/base.{jinja2,scss}`), a style template (e.g. `templates/slice/slice.{jinja2,scss}`), and a top-level poster (e.g. `posters/tutorial/index.{jinja2,scss}`).
- Using `sass` instead of `less` for CSS preprocessing.
- A cleaner `Makefile` and build flow.
- Support for `livereload`, so you can edit a poster's style/content and the browser will automatically refresh with your changes.
- Support for command line generation of PDFs from your HTML posters.

## Setup

### Dependencies

- **sass**: `pacman -S dart-sass` (ArchLinux), [static binaries available here](https://github.com/sass/dart-sass/releases)
- **pip dependencies**: `pip install jinja2 livereload playwright watchdog`
- **playwright browser**: `playwright install chromium`

## Quickstart

A poster consists of a jinja2 template file (`posters/tutorial/index.jinja2`) and a scss file (`posters/tutorial/index.scss`).
To get started, verify that you can build the all posters in this repo with `make all`.
To serve the posters, run `./scripts/serve` and browse to `localhost:5500/tutorial`.
