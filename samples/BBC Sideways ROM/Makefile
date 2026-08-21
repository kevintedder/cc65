#
# cc65 makefile for the BBC Sideways ROM specific modules
#

#.SUFFIXES: .o .s .c
MAKEFLAGS += -rR

#--------------------------------------------------------------------------
TARGET	= bbcswr

# Assume CC65_HOME is 2 levels up from here Eg. CC65\samples\<current folder>
CC65_HOME	= ..\..

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

BINARY	=	swr.rom

LIBRARY	=	$(CC65_LIB)\bbcswr.lib

ROM_SEED_OBJ =	$(CC65_LIBWRK)\bbcswr\crt0.o
ROM_SEED_SRC =	$(CC65_LIBSRC)\bbcswr\crt0.s

SERVICES	=	swr.o \
				swr_cmds.o \
				service_no_op.o \
				service_claim_absolute_ws.o \
				service_claim_private_ws.o \
				service_auto_boot.o \
				service_unknown_command.o \
				service_unknown_interrupt.o \
				service_break.o \
				service_unknown_osbyte.o \
				service_unknown_osword.o \
				service_help.o \
				service_claim_static_ws.o \
				service_nmi_release.o \
				service_nmi_claim.o \
				service_initilise_rom_fs.o \
				service_rom_fs_get_byte.o \
				service_vector_claim.o \
				service_spool_closure.o \
				service_font_explosion.o \
				service_filesystem_init.o \
				service_tube_post_init.o \
				service_tube_main_init.o

ifeq ($(OS), Windows_NT)
#	Windows OS
	DELETE	= del
else
#	Linux OS
	DELETE	= rm
endif

#--------------------------------------------------------------------------
# Rules

all:	$(ROM_SEED_OBJ)   $(BINARY)   $(BINARY).asm 

#	Rebuild the ROM seed file (~\CC65\LIBSRC\BBCSWR\CRT0.o) if it or the 
#	ROM header file (.\SWR.INC) have changed 
$(ROM_SEED_OBJ):  $(ROM_SEED_SRC)  .\swr.inc  $(SERVICES)
	$(CA65) $(ASFLAGS) -o $(ROM_SEED_OBJ)  $<
	$(AR65) a $(CC65_LIB)\bbcswr.lib  $(ROM_SEED_OBJ)


%.asm:	$(BINARY)
	$(DA65) $(DAFLAGS) -o $^.asm $<


$(BINARY):	$(SERVICES)  $(ROM_SEED)
	$(LD65) $(LDFLAGS) -o $@  $^ $(LIBRARY) 


.PRECIOUS: %.o
%.o:	%.s
	$(CA65) $(ASFLAGS) -o $@ $^


.PRECIOUS: %.s
%.s:	%.c
	$(CC65) $(CFLAGS) -o $@ $^


clean:
	@$(DELETE) $(BINARY) *.o *.s *.map *.asm


cleanlib:
	@$(DELETE) $(CC65_HOME)\libwrk\$(TARGET)\*
	@$(DELETE) $(LIBRARY)
