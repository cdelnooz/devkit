#
# LINUX.MK	--Macros and definitions for (Debian) Linux.
#
# Remarks:
# The default Linux variant is (currently!?) Debian, and so this
# include file sets up some definitions to assist building Debian
# packages.
#
C_OS_DEFS	= -D__Linux__ -D_BSD_SOURCE -D_XOPEN_SOURCE
CXX_OS_DEFS	= -D__Linux__ -D_BSD_SOURCE -D_XOPEN_SOURCE

RANLIB		= ranlib
FAKEROOT	= fakeroot
GREP		= grep
INDENT          = indent

PKG_TYPE	= deb

SH_PATH		= /bin/sh
AWK_PATH	= /usr/bin/awk
SED_PATH	= /bin/sed
PERL_PATH	= /usr/bin/perl
PYTHON_PATH	= /usr/bin/python

