/* Rexx */

/* ------------------------------------------------------------------------- */
/* NewView - a new OS/2 Help Viewer                                          */
/*                                                                           */
/* Copyright 2003-2006 Aaron Lawrence (aaronl at consultant dot com)         */
/* Copyright 2006 Ronald Brill (rbri at rbri.org)                            */
/*                                                                           */
/* This software is released under the Gnu Public License                    */
/*                                                                           */
/*                                                                           */
/* 1.) Create all needed output directories                                  */
/* 2.) Build all the resource files for our customized sibyl                 */
/* 3.) Compile                                                               */
/* ------------------------------------------------------------------------- */


nv_build_dir = value('NV_BUILD', , 'OS2ENVIRONMENT')
nv_rc = SysMkDir(nv_build_dir)

nv_build_dir_sibyl = nv_build_dir||'\sibyl'
nv_rc = SysMkDir(nv_build_dir_sibyl)

nv_build_dir_sibyl_lib = nv_build_dir_sibyl||'\lib'
nv_rc = SysMkDir(nv_build_dir_sibyl_lib)

/* TODO dir cleanup */


'cd spcc'
'rcomp20 english.rc ' nv_build_dir_sibyl_lib
'rcomp20 buttons.rc ' nv_build_dir_sibyl_lib
'rcomp20 cursors.rc ' nv_build_dir_sibyl_lib
'rcomp20 dbctrls.rc ' nv_build_dir_sibyl_lib
'rcomp20 mmedia.rc ' nv_build_dir_sibyl_lib
'rcomp20 tabctrls.rc ' nv_build_dir_sibyl_lib
cd ..

'cd addon'
'rcomp20 CHECKLB.RC ' nv_build_dir_sibyl_lib
'rcomp20 COOLBAR.RC ' nv_build_dir_sibyl_lib
'rcomp20 DIROUTLN.RC ' nv_build_dir_sibyl_lib
'rcomp20 EDITLIST.RC ' nv_build_dir_sibyl_lib
'rcomp20 GLYPHBTN.RC ' nv_build_dir_sibyl_lib
'rcomp20 LED.RC ' nv_build_dir_sibyl_lib
'rcomp20 SEVEN.RC ' nv_build_dir_sibyl_lib
'rcomp20 SPIN.RC ' nv_build_dir_sibyl_lib
'cd ..'

/*
  Libdir is set to appexp so that Appexp.scu is found. Strange
    -t1  PM target
    -L   local symbols debug
    -D   Debug info
    -O0  Disable optimisation
    -$i+ Enable I/O exceptions
    -$W6 Disable warning "Parameter is declared but never used"
*/
'spc20.exe makeall.pas' nv_build_dir_sibyl_lib 'appexp rtl;spcc;addon;appexp; -B -t1 -L -D -O0 -$i+ -$W6-'

