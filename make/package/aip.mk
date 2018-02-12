#
# Remarks:
# The package/aip module provides support for building an AdvancedInstaller Windows Executable
#
# NOTE: AIC cannot deal with forward slashes in directory path, hence the 'subst'
# NOTE: as we are using msys on windows, add /NewProject;/Execute;/Build to the
#       MSYS_ARG_CONV_EXCL list in the project makefile and/or environment.
#
# The builder expects a $(PACKAGE).aip file present to which it will add all files
# in $(archdir) and set version, product name and files to be packaged.

AIC ?= AdvancedInstaller.com

package: $(PACKAGE_DIR)/$(PACKAGE).exe


# building an exe file, the local makefile needs to give all files to be packaged as
# prerequisites. Currently, this is assumed a flat structure in APPDIR. In addition,
# the first prerequisite must be the .aip file.
# TODO: add support for directory structure.
$(PACKAGE_DIR)/%.exe: %.aip
	$(ECHO_TARGET)
	$(file > $<.in,;aic)
	$(file >>$<.in,SetProperty ProductName=$(PRODUCT_NAME))
	$(file >>$<.in,SetProperty Manufacturer=$(MANUFACTURER))
	$(file >>$<.in,SetVersion $(VERSION))
	$(file >>$<.in,$(PRODUCT_ICON:%=SetIcon -icon %))
	$(file >>$<.in,SetPackageName $(PACKAGE))
	$(file >>$<.in,SetOutputLocation -buildname DefaultBuild -path $(shell cygpath -aw $(PACKAGE_DIR)))
	$(foreach f,$(filter-out $<,$^),$(file >>$<.in,AddFile APPDIR $(subst /,\,$f)))
	$(file >>$<.in,Build)
	$(AIC) /Execute $(subst /,\,$<) $(subst /,\,$<.in)
	@$(RM) $<.in


clean: clean-aip
distclean: distclean-aip

clean-aip:
	$(RM) $(PACKAGE_DIR)/$(PACKAGE).exe

distclean-aip: clean-aip
	$(RM) -r $(PACKAGE_DIR) $(PACKAGE)-cache
