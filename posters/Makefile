all := posters/tutorial

css := base/base.css

base/base.css: base/base.scss
	npm run sass $^ $@

posters/tutorial/tutorial.html: posters/tutorial/tutorial.jinja2 posters/tutorial/tutorial.css
	./render $^ $@

posters/tutorial/tutorial.css: base/base.css
	ln -s $^ $@

.PHONY: css
