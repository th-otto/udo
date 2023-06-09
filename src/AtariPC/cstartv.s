****************
* extended cstart routine:
* - setting up argc and argv
* - setting up environment
* - shrink memory
* - and start main
*
* parameters are NOT wildcard expanded
* ARGV environment parameter is searched for instead
*
                GLOBL   exit
                GLOBL   __exit
                GLOBL   _BasPag
                GLOBL	_base
                GLOBL   _app
                GLOBL   errno
                GLOBL   _AtExitVec,_FilSysVec
                GLOBL   _RedirTab
                GLOBL	_stksize
                GLOBL   _StkLim
                GLOBL   _PgmSize
                GLOBL	environ
                GLOBL	_init_environ
                GLOBL	__env_argv
                GLOBL	_argc
                GLOBL	_argv
                
                GLOBL   __text
                GLOBL   __data
                GLOBL   __bss
                
                XREF    main
                XREF    _fpuinit
                XREF    _StkSize
                XREF    _FreeAll
				XREF	_StdErrF

* Base page structure

                OFFSET  0

TpaStart:       ds.l    1
TpaEnd:         ds.l    1
TextSegStart:   ds.l    1
TextSegSize:    ds.l    1
DataSegStart:   ds.l    1
DataSegSize:    ds.l    1
BssSegStart:    ds.l    1
BssSegSize:     ds.l    1
DtaPtr:         ds.l    1
PntPrcPtr:      ds.l    1
Reserved0:      ds.l    1
EnvStrPtr:      ds.l    1
Reserved1:      ds.b    7
CurDrv:         ds.b    1
Reserved2:      ds.l    18
CmdLine:        ds.b    128
BasePageSize:   ds      0


DEBUG			equ		0
PSTACKSIZE      equ     0

				XREF	print_env

				MACRO	DBG_OUT	string
				IFNE	DEBUG
				LOCAL	txt
				data
txt:			dc.b	string
				dc.b	13,10,0
				text
                movem.l	d0-a6,-(a7)
				move.l	#txt,-(a7)
				move.w	#Cconws,-(a7)
				trap	#1
				lea		6(a7),a7
                movem.l	(a7)+,d0-a6
                ENDC
				ENDM
				
                TEXT

Cconws			equ		$09
Fsetdta         equ     $1a
Fgetdta         equ     $2f
Fseek			equ		$42
Fforce			equ		$46
Mshrink         equ     $4a
Pterm           equ     $4c
Fsfirst         equ     $4e
Fsnext          equ     $4f

__text:
Start:          bra     Start0

                dc.l    _RedirTab
_stksize:       dc.l    _StkSize                * Stack size entry

EmpStr:         dc.b    0,0

                IFNE    PSTACKSIZE
                dc.b    'PROF'
                ENDC
                
Start0:         move.l  a0,a3
                move.l  a3,d0
                bne     acc
                move.l  4(a7),a3
                moveq.l #1,d0
                bra     app
acc:            moveq.l #0,d0
app:            move.l  a3,_BasPag
                move.w  d0,_app
                movea.l TextSegSize(a3),a0
                adda.l  DataSegSize(a3),a0
                adda.l  BssSegSize(a3),a0
                adda.w  #BasePageSize,a0
                move.l  a0,_PgmSize

                move.l  a3,d0
                add.l   a0,d0
                and.b   #$FC,d0
                movea.l d0,a7

* check application flag

*        TST.W   _app
*        BEQ     Start8  * No environment and no arguments

                sub.l   _stksize,d0
                add.l	#4,d0
                and.b   #$FC,d0
                movea.l d0,a1
                movea.l a1,a4
                move.l  a1,environ
                move.l  a1,_init_environ
                
                ifne	DEBUG
                movem.l	d0-a6,-(a7)
                move.l	a3,a0
                jsr		print_env
                movem.l	(a7)+,d0-a6
                endc
                
                movea.l EnvStrPtr(a3),a2
                move.l  a2,(a1)+
Start1:         tst.b   (a2)+
                bne     Start1
                move.l  a2,(a1)+
                tst.b   (a2)+
                bne     Start1
                clr.l   -4(a1)
                movea.l a1,a2

                move.l  #EmpStr,(a1)+   ;   argv[0] = ""
                lea     CmdLine(a3),a0
                move.b  (a0)+,d1
                ext.w   d1
                cmp.w	#127,d1
                beq		do_argv
scan_cmd:
                moveq   #1,d3
                clr.b   0(a0,d1)
Start2:         move.b  (a0)+,d1
                beq     Start99
                cmpi.b  #' '+1,d1
                bmi     Start2
                addq.l  #1,d3
                subq.l  #1,a0
                cmpi.b  #'"',d1
                bne     Start4
                addq.l  #1,a0
                move.l  a0,(a1)+
Start3:         move.b  (a0)+,d1
                beq     Start99
                cmp.b   #'"',d1
                bne     Start3
                clr.b   -1(a0)
                bra     Start2
Start4:         move.l  a0,(a1)+
Start6:         move.b  (a0)+,d1
                beq     Start7
                cmp.b   #' '+1,d1
                bpl     Start6
Start7:         clr.b   -1(a0)
                bra     Start2
Start99:        clr.l   (a1)+
				

do_argv:
                move.l	a4,-(a7)	; push envp
                move.l  a2,-(a7)	; push argv
                move.w  d3,-(a7)	; push argc
				move.w	d1,-(a7)
				
                move.l  a1,_StkLim
                move.l  _PgmSize,-(a7)
                move.l  a3,-(a7)
                move.w  #0,-(a7)
                move.w  #Mshrink,-(a7)
                trap    #1
                lea     12(a7),a7

                jsr     _fpuinit
                
                move.w	(a7)+,d1
                cmp.w	#127,d1
				bne		no_argv
				DBG_OUT	"argv indicator found"
				
				lea		0(a7),a0
				lea		2(a7),a1
				move.l	environ,a2
				bsr		argv
				tst.b	d2
				bne		no_argv
				DBG_OUT	"no ARGV found, using command line"
				moveq	#126,d1
                lea     CmdLine+1(a3),a0
                move.w	(a7)+,d3
                move.l	(a7)+,a2
                move.l	a2,a1
                move.l	#EmpStr,(a1)+
				bra		scan_cmd
				
no_argv:
				move.l	#_StdErrF,a0
				move.w	#2,16(a0)	; fileno(stderr) = 2
				tst.b	d1
				bne		nostderr	; environ STDERR found -> shell should handle it
				DBG_OUT	"no STDERR env, checking redirection"
				
				move.w	#1,-(a7)	; offset = Fseek(0l, 2, SEEK_CUR)
				move.w	#2,-(a7)
				clr.l	-(a7)
				move.w	#Fseek,-(a7)
				trap	#1
				move.l	d0,d3
				
				move.w	#0,-(a7)	; Fseek(1l, 2, SEEK_SET)
				move.w	#2,-(a7)
				move.l	#1,-(a7)
				move.w	#Fseek,-(a7)
				trap	#1
				exg		d0,d3
				
				move.w	#0,-(a7)	; Fseek(offset, 2, SEEK_SET)
				move.w	#2,-(a7)
				move.l	d0,-(a7)
				move.w	#Fseek,-(a7)
				trap	#1
				lea		30(a7),a7
				
				subq.l	#1,d3
				beq		nostderr	; not a tty -> don't change
				
				DBG_OUT	"redirecting handle 2"
				
				move.w	#-1,-(a7)
				move.w	#2,-(a7)
				move.w	#Fforce,-(a7)
				trap	#1
				addq.l	#6,a7
				
nostderr:		

                IFNE    PSTACKSIZE
Setexc          equ     5

                move.l	a7,a0
                lea     8(a0),a0
                move.l  a0,_StkTop
                move.l  a0,_StkBot
                pea     catchtrap(pc)
                move.w  #32,-(a7)       ; trap #0
                move.w  #Setexc,-(a7)
                trap    #13
                addq.l  #8,a7
                move.l  d0,old_trap
				ENDC

				move.w	(a7),d0		; restore argc
				move.l	2(a7),a0	; restore argv
                movea.l a4,a1		; restore envp
				move.w	d0,_argc
				move.l	a0,_argv

				jsr     main


exit:           move.w  d0,-(a7)
                move.l  _AtExitVec,d0
                beq     __exit
                movea.l d0,a0
                jsr     (a0)
__exit:
				IFNE	PSTACKSIZE
				XREF    ltoa
				move.l	_StkTop,d0
				move.l  _StkBot,d1
				sub.l   d1,d0
				moveq.l	#10,d1
				move.l  #stackmsg1,a0
				jsr     ltoa
			    pea     stackmsg
			    move.w	#Cconws,-(a7)
				trap	#1
				lea		6(a7),a7
			    pea     stackmsg2
			    move.w	#Cconws,-(a7)
				trap	#1
				lea		6(a7),a7

                move.l  old_trap,-(a7)
                move.w  #32,-(a7)
                move.w  #Setexc,-(a7)
                trap    #13
                addq.l  #8,a7
				ENDC
				
				move.l  _FilSysVec,d0
                beq     Exit1
                movea.l d0,a0
                jsr     (a0)
Exit1:          jsr     _FreeAll
                move.w  #Pterm,-(a7)
                trap    #1



*
* passed: (a0) = &argc
*         (a1) = &argv
*         a2   = envp[]
*
* returns: d1 != 0 -> STDERR found
* returns: d2 != 0 -> ARGV found
*
argv:			movem.l	a3-a4,-(a7)
				sf		d1
				sf		d2
argv1:			move.l	(a2)+,a3
				move.l	a3,d0
				beq		xenv
				cmp.b	#'A',(a3)
				beq		argv2
				cmp.b	#'S',(a3)
				bne		argv1
				cmp.b	#'T',1(a3)
				bne		argv1
				cmp.b	#'D',2(a3)
				bne		argv1
				cmp.b	#'E',3(a3)
				bne		argv1
				cmp.b	#'R',4(a3)
				bne		argv1
				cmp.b	#'R',5(a3)
				bne		argv1
				cmp.b	#'=',6(a3)
				bne		argv1
				st		d1
				bra		argv1
argv2:			cmp.b	#'R',1(a3)
				bne		argv1
				cmp.b	#'G',2(a3)
				bne		argv1
				cmp.b	#'V',3(a3)
				bne		argv1
				cmp.b	#'A',(a3)
				bne		argv1
				cmp.b	#'=',4(a3)
				bne		argv1
				st		d2
				clr.l	-4(a2)		; terminate env[] array here
				clr.b	(a3)		; remove ARGV from env
				lea		6(a3),a3
				move.l	a3,a4
				move.l	a3,__env_argv
scanslash:		tst.b	(a3)
				beq		endslash
				cmp.b	#$5c,(a3)+
				bne		scanslash
				; move.l	a3,a4
				bra		scanslash
endslash:		move.l	a4,a3
lowerit:		move.b	(a4)+,d0
				beq		lowerend
				cmp.b	#'A',d0
				bcs		lowerit
				cmp.b	#'Z'+1,d0
				bcc		lowerit
				add.b	#'a'-'A',d0
				move.b	d0,-1(a4)
				bra		lowerit
lowerend:		move.l	(a1),a4
				clr.w	(a0)
nxarg:			move.l	a3,(a4)+
				add.w	#1,(a0)
nxar1:			tst.b	(a3)+
				bne		nxar1
				tst.b	(a3)
				bne		nxarg
				clr.l	(a4)
xenv:			movem.l	(a7)+,a3-a4
				rts
				

                IFNE    PSTACKSIZE
                regoff  equ 12
                
catchtrap:      btst    #5,(a7)
                bne     catch4
                movem.l a0-a1/d1,-(a7)
                move.l  usp,a0
                move.l  _StkBot,d1
                cmp.l   a0,d1
                bcs     catch1
                move.l  a0,_StkBot
catch1:         move.l  regoff+2(a7),a1
                move.w  0(a1),d1
                cmp.w   #$4e75,d1             ; rts
                beq     catch2
                ; simulate LINK opcode
                addq.l  #2,a1
                move.l  a1,regoff+2(a7)
                move.l  a6,-(a0)
                move.l  a0,a6
                add.w   d1,a0
                bra     catch3
catch2:         ; simulate UNLK opcode
                move.l  a6,a0
                move.l  (a0)+,a6
catch3:         move.l  a0,usp
                movem.l (a7)+,a0-a1/d1
                rte

catch4:         move.l	a0,-(a7)
				move.l	6(a7),a0
				cmp.w	#$4e75,(a0)
				beq		catch5
				move.w	#$4e56,-2(a0)
				bra		catch6
catch5:		    move.w	#$4e5e,-2(a0)
catch6:	        subq.l  #2,a0
                move.l  a0,6(a7)
                move.l	(a7)+,a0
                pflusha
				rte

                ENDC
                				
                DATA
                
__data:
errno:          dc.l    0
_AtExitVec:     dc.l    0
_FilSysVec:     dc.l    0


                BSS

__bss:
_base:
_BasPag:        ds.l    1
_app:           ds.w    1
_StkLim:        ds.l    1
_PgmSize:       ds.l    1
_RedirTab:      ds.b    24
environ:        ds.l    1
_init_environ:  ds.l    1
__env_argv:		ds.l	1
_argc:			ds.w	1
_argv:			ds.l	1

                IFNE    PSTACKSIZE
old_trap:       ds.l    1
_StkTop:        ds.l    1
_StkBot:        ds.l    1
                
                DATA
stackmsg:       dc.b    'maximum stack size used: '
stackmsg1:      dc.b    '          ',0
stackmsg2:      dc.b    13,10,0
                ENDC
