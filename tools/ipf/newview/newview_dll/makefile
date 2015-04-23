# NewView.dll
# For Watcom C/C++ 10.6 and higher
# Use wmake DEBUG=1 to get debug info

OBJ_FILES=&
  newview.obj

# debug all: link debug info in
# remaining options set in helpmgr.def
!ifdef DEBUG
MODE_LINKFLAGS=debug all
!endif

# Link step: .obj -> .dll
newview.dll: newview.def $(OBJ_FILES)
  wlink &
    name newview &
    $(MODE_LINKFLAGS) &
    @newview.def &
    file newview.obj
  copy newview.dll ..\build\newview\newview.dll

# Compile step: .c -> .obj

# /b2=os2: compile for os/2
# /s:  remove stack checks (crashes)
# /wx: all warnings
# /zq: quiet
# /od: Disable optimisation
# /d2: full debug info
# /zld: don't include autodependency info
# /onatx /oh todo

!ifdef DEBUG
MODE_CFLAGS=/od /d2 /dDEBUG /hd
!else
MODE_CFLAGS=/onatx /oh
!endif

CFLAGS=/bt=os2 /s /wx /zq $(MODE_CFLAGS)

# Makefile rule for compiling C files
.c.obj:
  wcc386 $(CFLAGS) $*.c

newview.obj: newview.c
