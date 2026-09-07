#
# cc65 makefile for the BBC Sideways ROM specific modules
#

.SUFFIXES: .o .s .c
MAKEFLAGS += -rR

#--------------------------------------------------------------------------
TARGET	= bbc

USER_HOME	= $(HOME)
# Assume CC65_HOME is 2 levels up from here Eg. CC65\samples\<current folder>
CC65_HOME	= $(USER_HOME)\cc65

#	CC65 Folders
CC65_INC	= $(CC65_HOME)\asminc
CC65_BIN	= $(CC65_HOME)\bin
CC65_INC	= $(CC65_HOME)\include
CC65_LIB	= $(CC65_HOME)\lib
CC65_LIBSRC	= $(CC65_HOME)\libsrc
CC65_LIBWRK	= $(CC65_HOME)\libwrk

#	CC65 Binaries
AR65		= $(CC65_BIN)\ar65
CA65		= $(CC65_BIN)\ca65
CC65		= $(CC65_BIN)\cc65
#CL65		= $(CC65_BIN)\cl65
DA65		= $(CC65_BIN)\da65
LD65		= $(CC65_BIN)\ld65

#--------------------------------------------------------------------------
# flags

CWARN	= -W unused-label,unused-param,unused-var

ASFLAGS		?= -g --include-dir .
CFLAGS		?= -Osir -T -t $(TARGET) $(CWARN)
#CL_FLAGS	?= -Osir -T -g  $(TARGET) $(CWARN) -m $@.map  -l $@.lst -Ln $@.lab -vm
DAFLAGS		?= --comments 4 -S 0x8000
LDFLAGS		?= -m $@.map -vm -t $(TARGET)

BINARY	=	hello

LIBRARY	=	$(CC65_LIB)\$(TARGET).lib

BEEBMEM_LIB = C:\Users\kevin\Documents\BeebEm

SEED_OBJ =	$(CC65_LIBWRK)\$(TARGET)\crt0.o
SEED_SRC =	$(CC65_LIBSRC)\$(TARGET)\crt0.s

MODULES	=	hello.c


ifeq ($(OS), Windows_NT)
#	Windows OS
	DELETE	= del
	COPY	= copy
else
#	Linux OS
	DELETE	= rm
	COPY	= cp
endif


.PHONY: all, clean, cleanlib

#--------------------------------------------------------------------------
# Rules

all:	$(BINARY)   
#$(BINARY).asm 

#  $(CC65_LIB)\$(TARGET).lib   $(CC65_INC)\$(TARGET)\%.inc
$(BINARY):	$(BINARY).o  $(CC65_LIB)\$(TARGET).lib
	$(LD65) $(LDFLAGS) -o $@  $(SEED_OBJ) $^ $(LIBRARY) 
	$(COPY) $(BINARY) $(BEEBMEM_LIB)\$(BINARY)

%.asm:	$(BINARY)
	$(DA65) $(DAFLAGS) -o $^.asm $<


.PRECIOUS: %.o
%.o:	%.s
	$(CA65) $(ASFLAGS) -o $@ $^


.PRECIOUS: %.s
%.s:	%.c
	$(CC65) $(CFLAGS) -o $@ $^


clean:
	@$(DELETE) $(BINARY) *.o *.s *.map *.asm
	@$(DELETE) /Q $(CC65_HOME)\libwrk\$(TARGET)\*
	@$(DELETE) $(LIBRARY)
