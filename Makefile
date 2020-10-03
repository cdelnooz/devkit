#
# Makefile --Build rules for makeshift, a make-based build system.
#
# Contents:
# makeshift.mk:         --Fail if makeshift is not available.
# makeshift-version.mk: --Install a file recording the makeshift version.
#
language = markdown
PACKAGE = makeshift
package-type = rpm deb

DEB_ARCH = all
RPM_ARCH = noarch

MK_SRC = _VERSION.mk makeshift-version.mk

include makeshift.mk make/version.mk make/package.mk

$(DESTDIR_ROOT):
	$(ECHO_TARGET)
	$(MAKE) install DESTDIR=$$(pwd)/$@ prefix=$(prefix) usr=$(usr) opt=$(opt)

SPECS/makeshift.spec: Makefile

#
# makeshift.mk: --Fail if makeshift is not available.
#
$(includedir)/makeshift.mk:
	@echo "You need to do a self-hosted install:"
	@echo "    sh install.sh [make-arg.s...]"
	@false

#
# makeshift-version.mk: --Install a file recording the makeshift version.
#
install:	$(includedir)/makeshift-version.mk

$(includedir)/makeshift-version.mk: makeshift-version.mk
	$(INSTALL_DATA) $? $@

makeshift-version.mk: _VERSION _BUILD
	date "+# DO NOT EDIT.  This file was generated by $$USER. %c" >$@
	echo "export MAKESHIFT_VERSION=$$(cat _VERSION)" >$@
	echo "export MAKESHIFT_BUILD=$$(cat _BUILD)" >>$@

uninstall:	uninstall-local
uninstall-local:
	$(ECHO_TARGET)
	$(RM) $(includedir)/makeshift-version.mk
	-$(RMDIR) -p $(includedir) 2>/dev/null

distclean:	clean-this
clean-this:
	$(RM) makeshift-version.mk
