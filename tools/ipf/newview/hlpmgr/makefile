# ---------------------------------------------
# New Help Manager for use with NewView
# For Watcom C/C++ 10.6 and higher
# Use wmake DEBUG=1 to get debug info

# Hlpmgr2.dll can be used for testing without
# needing a reboot.
# ---------------------------------------------

all: hlpmgr2.dll helpmgr.dll

OBJ_FILES=&
  helpmgr.obj &
  helpinstance.obj &
  helptables.obj &
  viewer.obj &
  log.obj &
  sharedmemory.obj &
  utility.obj &
  ddf.obj &
  misc.obj &
  globalfilelist.obj

#  far16fun.obj

# debug all: link debug info in
# remaining options set in helpmgr.def
!ifdef DEBUG
MODE_LINKFLAGS=debug all
!endif

clean : .SYMBOLIC
        -del .\*.obj
        -del .\*.err


test.exe:  test.obj
  wlink $(MODE_LINKFLAGS) file test.obj file log.obj system os2v2 name test.exe import SetHelpDatabase helpmgr.37 import IOLoadAllTOC helpmgr.28

# Link step: .obj -> .dll
hlpmgr2.dll: helpmgr.def $(OBJ_FILES)
  wlink &
    name hlpmgr2 &
    $(MODE_LINKFLAGS) &
    @helpmgr.def &
    file helpmgr.obj &
    file helpinstance.obj &
    file helptables.obj &
    file viewer.obj &
    file log.obj &
    file sharedmemory.obj &
    file utility.obj &
    file ddf.obj &
    file misc.obj &
    file globalfilelist.obj

#    file far16fun.obj

helpmgr.dll: helpmgr.def $(OBJ_FILES)
  wlink &
    name helpmgr &
    $(MODE_LINKFLAGS) &
    @helpmgr.def &
    file helpmgr.obj &
    file helpinstance.obj &
    file helptables.obj &
    file viewer.obj &
    file log.obj &
    file sharedmemory.obj &
    file utility.obj &
    file ddf.obj &
    file misc.obj &
    file globalfilelist.obj

#    file far16fun.obj

# Compile step: .c -> .obj

# /b2=os2: compile for os/2
# /s:  remove stack checks (crashes)
# /wx: all warnings
# /zq: quiet
# /od: Disable optimisation
# /d2: full debug info
# /zld: don't include autodependency info

!ifdef DEBUG
MODE_CFLAGS=/od /d2 /dDEBUG /hd
!endif

CFLAGS=/bt=os2 /s /wx /zq $(MODE_CFLAGS)

# Makefile rule for compiling C files
.c.obj:
  wcc386 $(CFLAGS) $*.c

helpmgr.obj: helpmgr.c viewer.h log.h messages.h helptables.h sharedmemory.h helpinstance.h utility.h

helpinstance.obj: helpinstance.c helpinstance.h viewer.h utility.h log.h HelpTables.h SharedMemory.h

helptables.obj: helptables.c helptables.h

viewer.obj: viewer.c viewer.h log.h

log.obj: log.c log.h

sharedmemory.obj: sharedmemory.h sharedmemory.c

utility.obj: utility.c utility.h log.h

ddf.obj: ddf.c utility.h log.h

misc.obj: misc.c utility.h log.h

globalfilelist.obj: globalfilelist.c globalfilelist.h
