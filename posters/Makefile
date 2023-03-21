all: posters/tutorial/tutorial.html posters/sic-asplos23/sic-asplos23.html

templates/mit/mit.css: templates/mit/mit.scss base/base.scss
	sass --load-path=. $< $@

templates/slice/slice.css: templates/slice/slice.scss base/base.scss
	sass --load-path=. $< $@

posters/tutorial/tutorial.html: posters/tutorial/tutorial.jinja2 base/base.jinja2 templates/mit/mit.jinja2 templates/mit/mit.css
	ln -fs ../../templates/mit/mit.css posters/tutorial/index.css
	ln -fs ../../figs posters/tutorial/figs
	./render $< $@

posters/sic-asplos23/sic-asplos23.html: posters/sic-asplos23/sic-asplos23.jinja2 base/base.jinja2 templates/slice/slice.jinja2 templates/slice/slice.css
	ln -fs ../../templates/slice/slice.css posters/sic-asplos23/index.css
	ln -fs ../../figs posters/sic-asplos23/figs
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
