# HTML Talks Using reveal.js

## Dependencies

- Install `npm`. Run `npm install`
- Install `jinja2` (pip: `pip install Jinja2`, Arch: `pacman -S python-jinja`
- Install `joblib` (pip: `pip install joblib`, Arch: `pacman -S python-joblib`)

## Developing a Talk

- Run `make all`
- Run `npm run dev` to launch a HTTP server
- Go to the URL, click on the talk, and edit the `.jinja2` source file (changes will be injected into the webpage as they are made)
