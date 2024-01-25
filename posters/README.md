# HTML/CSS Posters

This repo is based on [cpitclaudel/academic-poster-template](https://github.com/cpitclaudel/academic-poster-template).
My modifications include:

- Splitting posters into a base template (`base/base.{jinja2,scss}`), a style template (e.g. `templates/slice/slice.{jinja2,scss}`), and the poster content + special styles (e.g. `posters/tutorial/index.{jinja2,scss}`).
- Using `sass` instead of `less` for CSS preprocessing.
- A cleaner `Makefile` and build flow.
- Support for `livereload`, so you can edit a poster's style/content and the browser will automatically refresh with your changes.
- A CLI utility to render a HTML poster to a PDF for printing.

## Setup

Install the following dependencies into your environment:

- sass CSS preprocessor
    - Homebrew: `brew install sass/sass/sass`
    - Arch Linux: `pacman -S dart-sass`
    - Linux: Download a [static binary](https://github.com/sass/dart-sass/releases) and add it to your `$PATH`
- Python dependencies
    - `python -m venv venv`
    - `source venv/bin/activate`
    - `pip install jinja2 livereload playwright watchdog`
    - `playwright install chromium`
- Check that this repo is functional
    - `make all`: Render all the posters to .html files and compile the .scss files
    - `./scripts/serve`: Launch a webserver to serve the posters
    - Navigate to `http://localhost:5500` in your browser and click on `tutorial`

## Creating and Editing a Poster

### Organization

A poster consists of a jinja2 file (`index.jinja2`) and a SCSS file (`index.scss`) in a poster folder (`posters/tutorial`).

The poster jinja2 file (`index.jinja2`) references a HTML style template (`{% extends "templates/mit/mit.jinja2" %}`).
The style template in turn references the base template (`base/base.jinja2`).

The poster SCSS file (`index.scss`) references a SCSS style template (`@use 'templates/mit/mit.scss';`).
The style template in turn references the base SCSS template (`base/base.scss`).

Inside a poster folder (`posters/tutorial`) there is a symlink to the `figs` folder at the root of the `publications` repo.
This allows us to reference the same figures for posters, talks, and papers.

When `make all` is run, the `.jinja2` and `.scss` files are compiled to `.html` and `.css` files in the poster folder.

### Creating a New Poster

- Copy an existing poster folder: `cp -r posters/2024-slice_winter-tidalsim posters/new_poster`
- Add it to the Makefile: `vim Makefile`, add `$(eval $(call poster,new_poster,slice))` (use the correct template so the correct dependencies are used)

### Editing

- Run `./scripts/serve` to launch the webserver
- Browse to `http://localhost:5500/new_poster/index.html`
- Edit the `index.jinja2` file
    - If you save the file, the poster is recompiled and the browser is refreshed automatically
    - This automatic refresh works for changes made to `.jinja2` and `.scss` files, but not for changes made to the Makefile or `figs`
    - You can forcibly rebuild all posters with `make -B all` and manually refresh the browser if needed (very rare)

## Rendering a Poster to PDF

After running `./scripts/serve`:

```
./scripts/pdf --url http://localhost:5500/tutorial --outputFile poster.pdf --width "40in" --height "30in" --scale 125
```

Play with the `--scale` number (usually around 120-150) until the poster looks right and doesn't overflow.
