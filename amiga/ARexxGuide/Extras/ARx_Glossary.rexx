/* ARx_Glossary.rexx v1.0 (8 Feb 1994)                         **
** Called by guide hyperlinks to launch glossary requesters    **
** The program ARx_GlossaryPort.rexx must also be in rexx:     */

if getclip('ARX_SHOWREQ') ~= 1 then do
		/* The clip prevents multiple calls to requester port    */
	call setclip('ARX_SHOWREQ', 1)
	arg LkUp
		/* Use a port to avoid re-reading compounds on each call */
	if show('P', 'ARX_REQPORT') then do
		address 'ARX_REQPORT' 'DISPLAY' LkUp address()
			/* Clear clip after requester port returns control    */
		call setclip('ARX_SHOWREQ', 0)
	end
	else	/* Set up the requester port.                         */
		address ARexx '"ARx_GlossaryPort.rexx '''LkUp''' '''address()'''"'

end
	/* This won't show anything on first click, but will get rid of bad **
	** value in the clip list.                                          */
else if ~show('P', 'ARX_REQPORT') then
	call setclip('ARX_SHOWREQ', 0)
