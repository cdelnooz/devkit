#
# RTX.MK --Settings for Keil/RTX
#
LIB_PREFIX =
LIB_SUFFIX = lib

include os/posix.mk

OS.C++_DEFS = -DOS_RTX -D__RTX

OS.C_DEFS = -DOS_RTX -D__RTX

CC = armcc
CXX = armcc
AR = armar
LD = armlink
RANLIB = $(AR) -s
