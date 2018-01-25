#
# CS.MK --Rules for building C# libraries and programs.
#
# Contents:
# build:   --Build all the c# sources that have changed.
# install: --install c# binaries and libraries.
# clean:   --Remove c# class files.
# src:     --Update the CS_SRC macro.
# tags:    --Build vi, emacs tags files.
# todo:    --Report "unfinished work" comments in CSC files.
#
#
.PHONY: $(recursive-targets:%=%-cs)

CS_SUFFIX ?= cs
LIB_SUFFIX ?= dll
EXE_SUFFIX ?= exe

CS_MAIN_RGX ?= '^[ \t]*static[ \t]*void[ \t]'

ifdef autosrc
    LOCAL_CS_SRC := $(shell find . -path ./obj -prune -o -type f -name '*.$(CS_SUFFIX)' -print)
    LOCAL_CS_MAIN := $(shell grep -l $(CS_MAIN_RGX) '*.$(CS_SUFFIX)') 
    CS_SRC ?= $(LOCAL_CS_SRC)
    CS_MAIN_SRC ?= $(LOCAL_CS_MAIN)
endif

# these rules assume that the C# code is organised as follows:
#  - the assembly or program name is the same as the directory name where the Makefile resides
#  - the cs source files are at the same level or in subdirectories (i.e. no submodules)
#  - if this builds an executable, the main file resides in the same directory as the Makefile
# when organised this way, these rules autodetect whether to build a library or executable and
# what name to give it. The name can be overridden in the local Makefile.
MODULE_NAME ?= $(shell basename $$(pwd))

ifdef CS_MAIN_SRC
    TARGET := $(MODULE_NAME).$(EXE_SUFFIX)
    TARGET.CS_FLAGS += -target:winexe
else
    TARGET := $(MODULE_NAME).$(LIB_SUFFIX)
    TARGET.CS_FLAGS += -target:library
endif

ifdef KEY_FILE
  TARGET.CS_FLAGS += -keyfile:$(KEY_FILE)
endif

CSC ?= $(CS_BINDIR)csc.exe

ALL_CS_FLAGS = $(VARIANT.CS_FLAGS) $(OS.CS_FLAGS) $(ARCH.CS_FLAGS) $(LOCAL.CS_FLAGS) \
    $(TARGET.CS_FLAGS) $(CS_FLAGS)


#
# build: --Build all the cs sources that have changed.
#
build:		build-cs
build-cs: $(archdir)/$(TARGET)

$(archdir)/$(TARGET): $(CS_SRC) | $(archdir)
	$(ECHO_TARGET)
	$(CSC) $(ALL_CS_FLAGS) $^ "-out:$@"

#
# install: --install cs binaries and libraries.
#
install-cs:	
	$(ECHO_TARGET)

uninstall-cs:
	$(ECHO_TARGET)

#
# clean: --Remove build outputs
#
distclean:	clean-cs
clean:	clean-cs
clean-cs:
	$(ECHO_TARGET)
	$(RM) $(archdir)/$(TARGET)

#
# src: --Update the CS_SRC macro.
#      exclude ./obj from the search path, Visual Studio sometimes generates files here.
#
src:	src-cs
src-cs:
	$(ECHO_TARGET)
	@mk-filelist -f $(MAKEFILE) -qn CS_SRC $$(find . -path ./obj -prune -o -type f -name '*.$(CS_SUFFIX)' -print)
	@mk-filelist -f $(MAKEFILE) -qn CS_MAIN_SRC $$(grep -l $(CS_MAIN_RGX) ''*.$(CS_SUFFIX)'')

#
# todo: --Report "unfinished work" comments in Java files.
#
todo:	todo-cs
todo-cs:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(CS_SRC) /dev/null || true
