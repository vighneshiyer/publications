base_jinja = base/base.jinja2
themes_scss = $(wildcard themes/*.scss)
themes_css = $(patsubst %.scss,%.css,$(themes_scss))

%.css: %.scss
	sass --load-path=. $^ > $@

themes: $(themes_css)

talks =

define talk
$1.html: talks/$1.jinja2 $(base_jinja)
	../scripts/render --output $$@ $$<

$1: ./$1.html

talks += $1
endef

# Add talks here:
# $(call talk,<talk name>,<template name>)
$(eval $(call talk,demo,base))
$(eval $(call talk,2023-plarch_edsl,base))
$(eval $(call talk,2023-plarch_plarch_mixed_hdl_and_hdl_design,base))

# all: $(talks) talks/index.html
# 
# define write
# echo $(1) >> $(2);
# endef
# 
# talks/index.html: $(addsuffix /index.html,$(addprefix talks/,$(talks)))
# 	echo "<!DOCTYPE html>" > $@
# 	echo '<html lang="en">' >> $@
# 	echo '  <head>' >> $@
# 	echo '    <title>Talk Index</title>' >> $@
# 	echo '  </head>' >> $@
# 	echo '  <body>' >> $@
# 	echo '    <ul>' >> $@
# 	$(foreach p,$(posters),$(call write,"      <li><a href=\"./$(p)/index.html\">$(p)</li>",$@))
# 	echo '    </ul>' >> $@
# 	echo '  </body>' >> $@
# 	echo '</html>' >> $@
# 
# define del
# rm -f $(1);
# endef
# 
# clean:
# 	$(foreach p,$(posters),$(call del,posters/$(p)/index.css))
# 	$(foreach p,$(posters),$(call del,posters/$(p)/index.css.map))
# 	$(foreach p,$(posters),$(call del,posters/$(p)/index.html))
# 	rm -f posters/index.html

.PHONY: all $(posters) clean themes
