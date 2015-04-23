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


nv_i18n_dir = directory()

nv_build_dir = value('NV_BUILD', , 'OS2ENVIRONMENT')
nv_rc = SysMkDir(nv_build_dir)

nv_build_dir_components = nv_build_dir||'\components'
nv_rc = SysMkDir(nv_build_dir_components)

/* TODO dir cleanup */


say 'Building Aaron''s Components...'


'rcomp20 ControlsUtility.rc ' nv_build_dir_components
'rcomp20 DialogIcons.rc ' nv_build_dir_components
'rcomp20 FileImages.rc ' nv_build_dir_components

'spc20 components.spr'

