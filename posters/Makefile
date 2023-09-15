base_jinja := base/base.jinja2
base_sass := base/base.scss
RENDER := ../scripts/render

posters =

define poster
posters/$1/index.css: posters/$1/index.scss templates/$2/$2.scss $(base_sass)
	sass --load-path=. $$< $$@

posters/$1/index.html: posters/$1/index.jinja2 templates/$2/$2.jinja2 $(base_jinja)
	$(RENDER) --output $$@ $$<

$1: posters/$1/index.css posters/$1/index.html

posters += $1
endef

# Add posters here:
# $(call poster,<poster name>,<template name>)
$(eval $(call poster,tutorial,mit))
$(eval $(call poster,2022-bwrc_fall-simcommand,bwrc))
$(eval $(call poster,2022-oscar-simcommand,slice))
$(eval $(call poster,2023-slice_winter-cov_model,slice))
$(eval $(call poster,2023-slice_winter-verif_projects,slice))
$(eval $(call poster,2023-asplos-sic,slice))
$(eval $(call poster,2023-slice_summer-fuzzing,slice))
$(eval $(call poster,2023-slice_summer-recipes,slice))
$(eval $(call poster,2023-slice_summer-simcommand_chiseltest,slice))
$(eval $(call poster,2023-slice_summer-rtl2graph,slice))
$(eval $(call poster,2023-slice_summer-distpcsr,slice))

all: $(posters) posters/index.html

define write
echo $(1) >> $(2);
endef

posters/index.html: $(addsuffix /index.html,$(addprefix posters/,$(posters)))
	echo "<!DOCTYPE html>" > $@
	echo '<html lang="en">' >> $@
	echo '  <head>' >> $@
	echo '    <title>Poster Index</title>' >> $@
	echo '  </head>' >> $@
	echo '  <body>' >> $@
	echo '    <ul>' >> $@
	$(foreach p,$(posters),$(call write,"      <li><a href=\"./$(p)/index.html\">$(p)</li>",$@))
	echo '    </ul>' >> $@
	echo '  </body>' >> $@
	echo '</html>' >> $@

define del
rm -f $(1);
endef

clean:
	$(foreach p,$(posters),$(call del,posters/$(p)/index.css))
	$(foreach p,$(posters),$(call del,posters/$(p)/index.css.map))
	$(foreach p,$(posters),$(call del,posters/$(p)/index.html))
	rm -f posters/index.html

.PHONY: all $(posters) clean
