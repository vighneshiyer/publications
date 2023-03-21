all: posters/tutorial/tutorial.html

css := base/base.css

base/base.css: base/base.scss
	sass $^ $@

posters/tutorial/tutorial.html: posters/tutorial/tutorial.jinja2 base/base.jinja2 templates/mit/mit.jinja2 base/base.css
	ln -fs ../../base posters/tutorial/base
	ln -fs ../../figs posters/tutorial/figs
	./render $< $@

clean:
	rm -f base/base.css*
	rm -f posters/tutorial/tutorial.html
	rm -f posters/tutorial/base
	rm -f posters/tutorial/figs

.PHONY: css all
