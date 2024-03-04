base_jinja = base/base.jinja2

# sass compilation and hot reload is taken care of by vite
# themes_scss = $(wildcard themes/*.scss)
# themes_css = $(patsubst %.scss,%.css,$(themes_scss))
#
# %.css: %.scss
# 	sass --load-path=. $^ > $@
#
# themes: $(themes_css)

talks =

define talk
$1.html: talks/$1.jinja2 $(base_jinja) $2
	../scripts/render --output $$@ $$<

$1: ./$1.html

talks += $1
endef

# Add talks here:
# $(call talk,<talk name>)
$(eval $(call talk,demo))
$(eval $(call talk,2023-plarch_edsl))
$(eval $(call talk,2023-plarch_mixed_hdl_and_hdl_design))
$(eval $(call talk,2023_10-cs294-multi_level_sim_proposal))
$(eval $(call talk,2023_12-athlete_review-tidalsim_and_verif_apps))
$(eval $(call talk,2023_12-cs294_tidalsim_final_talk))
$(eval $(call talk,2024_01-quals-tidalsim,$(wildcard talks/quals/*.jinja2)))
$(eval $(call talk,2024_01-slice_winter-tidalsim))
$(eval $(call talk,2024_01-athlete-tidalsim))
$(eval $(call talk,2024_02-uarch_event_tracing))
$(eval $(call talk,2024_02-athlete-tidalsim_update))
$(eval $(call talk,2024_03-athlete_internal-tidalsim_apps))

talks_output = $(addsuffix .html,$(talks))

all: $(talks_output) index.html

define write
echo $(1) >> $(2);
endef

index.html: $(talks_output)
	echo "<!DOCTYPE html>" > $@
	echo '<html lang="en">' >> $@
	echo '  <head>' >> $@
	echo '    <title>Talk Index</title>' >> $@
	echo '  </head>' >> $@
	echo '  <body>' >> $@
	echo '    <ul>' >> $@
	$(foreach t,$(talks),$(call write,"      <li><a href=\"./$(t).html\">$(t)</li>",$@))
	echo '    </ul>' >> $@
	echo '  </body>' >> $@
	echo '</html>' >> $@

define del
rm -f $(1);
endef

clean:
	$(foreach t,$(talks),$(call del,$(t).html))
	rm -f index.html

.PHONY: all clean
