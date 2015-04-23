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

nv_build_dir_lib = nv_build_dir||'\library'
nv_rc = SysMkDir(nv_build_dir_lib)

/* TODO dir cleanup */


/* create temp project file */
sprFile = 'acl_build.spr'

if STREAM(sprFile,'C','QUERY EXISTS') <> ""
then do
say sprFile 'exists, deleting'
'erase ' sprFile
end

call lineout sprFile, '[Directories]'
call lineout sprFile, ''
call lineout sprFile, 'OutDir='||nv_build_dir_lib
call lineout sprFile, 'LibDir='||nv_build_dir||'\sibyl\lib'
call lineout sprFile, ''
call lineout sprFile, '[Project Files]'
call lineout sprFile, ''
call lineout sprFile, 'Primary=.\ACLLibrary.pas'
call lineout sprFile

say sprFile 'created'

'spc20' sprFile

/* spc20 acllibrary.spr */

