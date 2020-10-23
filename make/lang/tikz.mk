#
# TIKZ.MK --Build rules for handling TeX documents with standalone
# Tikz diagrams
#
# Contents:
# clean:     --Clean generated files
# distclean: --Clean generated files & directories
# src:       --Update the definition of TIKZ_SRC.
# todo:      --Report unfinished work in TIKZ code.
#
.PHONY: $(recursive-targets:%=%-tikz)

ifdef autosrc
    LOCAL_TIKZ_SRC := $(wildcard *.tex)

    TIKZ_SRC ?= $(LOCAL_TIKZ_SRC)
endif


PDF2SVG ?= pdf2svg
TEX2PDF ?= lualatex

TIKZ_PDF = $(TIKZ_SRC:%.tex=$(gendir)/%.pdf)
TIKZ_SVG = $(TIKZ_PDF:%.pdf=%.svg)
TIKZ_AUX = $(TIKZ_PDF:%.pdf=%.aux)
TIKZ_LOG = $(TIKZ_PDF:%.pdf=%.log)

%.svg: %.pdf
	$(PDF2SVG) $^ $@


$(gendir)/%.pdf: %.tex | $(gendir)
	$(TEX2PDF) --output-directory=$(gendir) $^ > $(gendir)/$(TEX2PDF).log

#
# clean: --Clean TIKZ intermediate files.
#
clean:	clean-tikz
distclean:	clean-tikz
clean-tikz:
	$(ECHO_TARGET)
	$(Q)$(RM) $(TIKZ_PDF) $(TIKZ_SVG) $(TIKZ_AUX) $(TIKZ_LOG) \
	$(gendir)/$(TEX2PDF).log



build-tikz: $(TIKZ_PDF)

#
# src: --Update the definition of TIKZ_SRC.
#
src:	src-tikz
src-tikz:
	$(ECHO_TARGET)
	$(Q)$(MK-FILELIST) -f $(MAKEFILE) -qn TIKZ_SRC *.tex
#
# todo: --Report unfinished work in tikz code.
#
todo:	todo-tikz
todo-tikz:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(TIKZ_SRC) /dev/null ||:
