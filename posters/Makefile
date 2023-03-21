all: posters/tutorial/tutorial.html

css := base/base.css

templates/mit/mit.css: templates/mit/mit.scss base/base.scss
	sass --load-path=. $< $@

posters/tutorial/tutorial.html: posters/tutorial/tutorial.jinja2 base/base.jinja2 templates/mit/mit.jinja2 templates/mit/mit.css
	ln -fs ../../templates/mit/mit.css posters/tutorial/index.css
	ln -fs ../../figs posters/tutorial/figs
	./render $< $@

clean:
	rm -f base/base.css*
	rm -f templates/mit/mit.css
	rm -f templates/mit/mit.css.map
	rm -f templates/slice/slice.css
	rm -f templates/slice/slice.css.map
	rm -f posters/tutorial/tutorial.html
	rm -f posters/tutorial/index.css
	rm -f posters/tutorial/figs

.PHONY: css all
