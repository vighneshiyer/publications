base_jinja := base/base.jinja2
base_sass := base/base.scss
RENDER := scripts/render

posters =

define poster
posters/$1/index.css: posters/$1/index.scss templates/$2/$2.scss $(base_sass)
	sass --load-path=. $$< $$@

posters/$1/index.html: posters/$1/index.jinja2 templates/$2/$2.jinja2 $(base_jinja)
	$(RENDER) $$< $$@

$1: posters/$1/index.css posters/$1/index.html

posters += $1
endef

# Add posters here:
# $(call poster,<poster name>,<template name>)
$(eval $(call poster,tutorial,mit))
$(eval $(call poster,sic-asplos23,slice))
$(eval $(call poster,simcommand-oscar22,slice))

all: $(posters)

define del
rm -f $(1);
endef

clean:
	$(foreach p,$(posters),$(call del,posters/$(p)/index.css))
	$(foreach p,$(posters),$(call del,posters/$(p)/index.css.map))
	$(foreach p,$(posters),$(call del,posters/$(p)/index.html))

.PHONY: all $(posters) clean
