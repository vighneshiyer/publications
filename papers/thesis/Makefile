main = $(notdir $(shell pwd))
include ../../figs/Makefrag

references = $(shell find ../references/*.bib -type f -not -path '*/references.bib')
references_all = ../references/references.bib

$(main).pdf:
	latexmk
	# Use latexmk -pvc to watch and autocompile

$(references_all): $(references)
	cat $^ > $@

clean:
	rm -rf *.pdf *.aux *.out *.log _minted* *.bbl *.blg comment.cut *.bcf *.glo *.idx *.ilg *.ind *.lof *.lol *.lot *.mw *.nlo *.run.xml *.toc *.xdy latexmkrc.f*

.PHONY: clean
