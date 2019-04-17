#
# STM32.MK --Macros and definitions for ARM/STM32 architectures
#
CC = /c/Keil/ARM/ARMCC/bin/armcc.exe
CXX = /c/Keil/ARM/ARMCC/bin/armcc.exe
AR = /c/Keil/ARM/ARMCC/bin/armar.exe
LD = /c/Keil/ARM/ARMCC/bin/armlink.exe
ARFLAGS = -x$(AR)

ARMCC_FLAGS = --cpu=Cortex-M3 --diag-style=ide \
    --diag_remark=450,667 -g -O0 -Ospace \
    --signed_chars --no_rtti --no_exceptions \
    --diag_error=warning \
    --list --asm --interleave \
    --asm_dir=$(archdir) --list_dir=$(archdir) \
    -I/c/Keil/ARM/RV31/INC

ARCH.CXXFLAGS = -c --cpp $(ARMCC_FLAGS)
ARCH.CFLAGS = -c $(ARMCC_FLAGS)

ARMCC_DEFS = -DARCH_ARM -DCPU_STM32 -DOS_RTX \
  -D__RTX -D_INTERNAL_USR_HEAP -DRAM_RESIDENT_BOOTLOADER \
  -DCPPUTEST_STD_CPP_LIB_DISABLED \
  -DCPPUTEST_MEM_LEAK_DETECTION_DISABLED \
  -DRDL_SYSTEM_WDT_ENABLED -DHAL_SYSTEM_WDT_ENABLED
ARCH.C_DEFS = $(ARMCC_DEFS)
ARCH.C++_DEFS = $(ARMCC_DEFS)
