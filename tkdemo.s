* Demo For Mouse Graphics Tool Kit

; This demo uses one macro for calling the toolkit.
; The Macro (XXX) takes two parameters and generates
; the following code:
;
;         jsr ToolMLI
;         dfb parameter1
;         dfb parameter2
;
;
; demo #1 for toolkit/graphics package
;

            org $800
            put equates
            dsk tkdemo
;
;
xxx     MAC         ; call toolmli
        jsr ToolMLI
        dfb ]1
        da  ]2
        EOM 

SystemFont equ $8800
SaveBuffer equ $A000
RingBell equ $FBDD
; MonitorEntry equ -151
MonitorEntry equ 65385
;
;
InDesktop equ 0
InMenu equ 1
InContent equ 2
InDrag equ 3
InGrow equ 4
InClose equ 5
InThumb equ 5
;
UseInterrupts equ 0 ; Yes
;
; set up the desk top
;
            lda #0
            sta Quit ; init quit
            xxx SetZP1;DoNotSave
            xxx StartDeskTop;TheDesk
            xxx InitMenu;CharList
            xxx SetMenu;TheMenu
;
            xxx ShowCursor;0
            jsr SetChecks ; Initialize the Window Test Menu
;
;
;
;
********************************************
*
* This is the start of the Main Loop
* The main loop is controlled by a flag
* called Quit.  As long as Quit is zero,
* the loop continues. When it is non-zero,
* control passes to the quitting routine.
*
********************************************
Demo_1 equ *
            lda Quit
            beq Demo_1_1
;
            jmp Killer
;
Demo_1_1 equ *
            xxx GetEvent;TheEvent ; Get the next event
;
            lda TheEvent ; Transfer control to appropriate part of program
;
            cmp #ButnDown
            bne Demo_3
            jsr HandleButton
            jmp Demo_1
;
Demo_3      cmp #KeyPress
            bne Demo_4
            jsr HandleKeypress
            jmp Demo_1
;
Demo_4      cmp #UpdateEvt
            bne Demo_5
            jsr HandleUpdate
            jmp Demo_1
;
Demo_5      jmp Demo_1 ; ignore all other events
;
;
ClearUpdates equ *
            xxx PeekEvent;TheEvent
            lda EvtType
            cmp #UpdateEvt
            bne Update_1
            xxx GetEvent;TheEvent
            jsr HandleUpdate
            jmp ClearUpdates
HandleUpdate equ *
            xxx BeginUpdate;UpdateID ; Returned in first event byte
            bne Update_1 ; if error skip it!
            lda UpdateID
            jsr DrawIt
            xxx EndUpdate;0
Update_1 rts
;
DrawItB equ *
            sta GWParms ; Get the port for the current window
            xxx GetWinPort;GWParms
            xxx SetPort;TempPort ; Set the port there
            lda GWParms ; Get back the window id
;
DrawIt equ * ; Refresh window whose id is passed in A-Reg
            cmp SmallWindow
            bne DrawIt_1
            jmp DrawWin1
DrawIt_1 cmp BigWindow
            bne DrawIt_2
            jmp DrawWin2
DrawIt_2 cmp CharsWindow
            bne DrawIt_3
            jmp DrawWin3
DrawIt_3 cmp TestWindow
            bne DrawIt_4
            jmp DrawWin4
DrawIt_4 cmp DialogWindow
            bne DrawIt_5
            jmp DrawWin5
DrawIt_5 rts ; Should never get here!
;
;
DrawWin1 equ *
            xxx SetPenMode;xSrcXOR
            xxx PaintPoly;xPolygon
            rts
DrawWin2 equ *
            xxx SetPenMode;xSrcCOPY
            xxx FramePoly;xPolygon
            xxx PaintRect;aRect
            rts
aRect       dw 10,30,70,50
DeltaX      equ 10
DeltaY      equ 10
K1          equ 6 ; put these temporary counters on zero page
K2          equ 7
DrawWin3    equ *
            ldx #3
DW3_1       lda OrigCharPoint,x
            sta CharPoint,x
            dex
            bpl DW3_1
            lda #0
            sta CurChar
            sta K1
            sta K2
DW3_2       xxx MoveTo;CharPoint
            xxx DrawText;TextData
            inc CurChar ; increment the current character
            clc ; calculate the new X position
            lda CharPoint
            adc #DeltaX
            sta CharPoint
            inc K1 ; increment the inner loop counter
            lda K1
            cmp #16 ; check to see if inner loop is done_
            bcc DW3_2
            lda OrigCharPoint ; reset x coordinate
            sta CharPoint
            lda OrigCharPoint+1
            sta CharPoint+1
            clc ; calculate a new Y coordinate
            lda CharPoint+2
            adc #DeltaY
            sta CharPoint+2
            lda #0 ; reset inner loop counter
            sta K1
            inc K2
            lda K2
            cmp #8
            bcc DW3_2
            rts
OrigCharPoint dw 10,13
CharPoint   dw 0,0
TextData    dw CurChar
            dfb 1
CurChar     dfb 0
DrawWin4    equ *
            lda #10
            sta W4FirstPoint
            sta W4FirstPoint+2
            xxx MoveTo;W4FirstPoint
;
            xxx DrawText;W4_L1
            lda TestWindow
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L2
            lda TestWindow+1
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L3
            lda TestWindow+2
            sta TempText
            sta K1
            lda TestWindow+3
            sta TempText+1
            sta K1+1
            ldy #0
            lda (K1),y
            sta TempText+2
            inc TempText
            bne *+5
            inc TempText+1
            xxx DrawText;TempText
            jsr NewLine
;
            xxx DrawText;W4_L4
            lda TestWindow+4
            jsr ByteOut
            jsr Comma
            lda TestWindow+5
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L5
            lda TestWindow+6
            jsr ByteOut
            jsr Comma
            lda TestWindow+7
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L6
            lda TestWindow+8
            jsr ByteOut
            jsr Comma
            lda TestWindow+9
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L7
            lda TestWindow+10
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L8
            lda TestWindow+11
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L9
            lda TestWindow+12
            ldx TestWindow+13
            jsr WordOut
            jsr Comma
            lda TestWindow+14
            ldx TestWindow+15
            jsr WordOut
            jsr NewLine
;
            xxx DrawText;W4_L10
            lda TestWindow+16
            ldx TestWindow+17
            jsr WordOut
            jsr Comma
            lda TestWindow+18
            ldx TestWindow+19
            jsr WordOut
            jsr NewLine
;
            xxx DrawText;W4_L11
            jsr NewLine
            lda #50
            jsr Tab
;
            xxx DrawText;W4_L12
            lda TestWindow+20
            ldx TestWindow+21
            jsr WordOut
            jsr Comma
            lda TestWindow+22
            ldx TestWindow+23
            jsr WordOut
            jsr NewLine
;
            xxx DrawText;W4_L13
            lda TestWindow+24
            ldx TestWindow+25
            jsr WordOut
            jsr Comma
            lda TestWindow+26
            ldx TestWindow+27
            jsr WordOut
            jsr NewLine
;
            xxx DrawText;W4_L14
            lda TestWindow+28
            ldx TestWindow+29
            jsr WordOut
            jsr Comma
            lda TestWindow+30
            ldx TestWindow+31
            jsr WordOut
            jsr Comma
            lda TestWindow+32
            ldx TestWindow+33
            jsr WordOut
            jsr Comma
            lda TestWindow+34
            ldx TestWindow+35
            jsr WordOut
            jsr NewLine
;
            xxx DrawText;W4_L15 ; Pattern
            lda #0
            sta K1
W4_1        ldx K1
            lda TestWindow+36,X
            jsr ByteOut
            jsr Comma
            inc K1
            lda K1
            cmp #8
            bcc W4_1
            ldx K1
            lda TestWindow+36,X
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L16
            lda TestWindow+46
            ldx TestWindow+47
            jsr WordOut
            jsr Comma
            lda TestWindow+48
            ldx TestWindow+49
            jsr WordOut
            jsr NewLine
;
            xxx DrawText;W4_L17
            lda TestWindow+50
            jsr ByteOut
            jsr Comma
            lda TestWindow+51
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L18
            lda TestWindow+52
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L19
            lda TestWindow+53
            jsr ByteOut
            jsr NewLine
;
            xxx DrawText;W4_L20
            lda TestWindow+54
            ldx TestWindow+55
            jsr WordOut
            jsr NewLine
            rts
WordOut equ *                   ; Displays the word in X,A as hex at current pen loc
                                ; High byte is in X, Low byte is in A_
            pha ; save low byte
            txa
            pha
            jsr Dollar
            pla
            jsr ByteOut2
            pla ; get it back and go thru Byte Out again_
            jmp ByteOut2
ByteOut equ * ; Displays the byte in a-reg as hex at
; current pen location_
            pha ; save it a momment
            jsr Dollar
            pla ; get it back
ByteOut2    jsr Bin2Hex
            stx BO2
            sty BO1
            xxx DrawText;BO
            rts
BO          dw BO1
            dfb 2
BO1         dfb 0
BO2         dfb 0
Comma       equ * ; Displays a comma at the current pen loc
            xxx DrawText;CommaParms
            rts
CommaParms  dw *+3
            dfb 1
            dfb ','
Dollar equ * ; Displays a dollar sign at the current pen loc
            xxx DrawText;DollarParms
            rts
DollarParms dw *+3
            dfb 1
            dfb '$'
NewLine equ * ; Increments W4FirstPoint and does a moveto
            clc
            lda W4FirstPoint+2
            adc #8
            sta W4FirstPoint+2
NewLine_1 xxx MoveTo;W4FirstPoint
            rts
Tab equ * ; Increments the X cooridinate of W4FirstPoint by A-reg
            clc
            adc W4FirstPoint
            sta W4FirstPoint
            jmp NewLine_1
TempText dw 0
            dfb 0
W4FirstPoint dw 10,0
W4_L1 dw *+3
            str 'Window ID: '
W4_L2 dw *+3
            str 'Option Byte: '
W4_L3 dw *+3
            str 'Window Title: '
W4_L4 dw *+3
            str 'Control Options (H,V): '
W4_L5 dw *+3
            str 'H Thumb Max & Pos: '
W4_L6 dw *+3
            str 'V Thumb Max & Pos: '
W4_L7 dw *+3
            str 'Window Status: '
W4_L8 dw *+3
            str 'Reserved: '
W4_L9 dw *+3
            str 'H & V Minimums: '
W4_L10 dw *+3
            str 'H & V Maximums: '
W4_L11 dw *+3
            str 'Window Graf Port--'
W4_L12 dw *+3
            str 'View Loc: '
W4_L13 dw *+3
            str 'Map Loc & Width: '
W4_L14 dw *+3
            str 'Clip Rect: '
W4_L15 dw *+3
            str 'Pattern: '
W4_L16 dw *+3
            str 'Pen Location: '
W4_L17 dw *+3
            str 'Pen Size: '
W4_L18 dw *+3
            str 'Pen Mode: '
W4_L19 dw *+3
            str 'TextBG: '
W4_L20 dw *+3
            str 'Font Address: '
;;
;; Bin2Hex translates the binary number in the A-Register to
;; two ascii digits in X & Y (high nibble in Y, low in X)
;;
Bin2Hex     equ *
            tax
            and #$F0
            lsr a
            lsr a
            lsr a
            lsr a
            jsr Nib2Ascii
            tay
            txa
            and #$0f
            jsr Nib2Ascii
            tax
            rts
Nib2Ascii equ *
            cmp #10
            bcc N2A_1
            clc
            adc #7
N2A_1       adc #'0'
            rts
;
;
;
NumLines    equ 8
StartingY   equ 15
DrawWin5    equ *
            lda #0
            sta K1
            lda #StartingY
            sta YStart
DW5_1 ldx K1
            lda StrTableLow,x
            sta W5TextPatch
            lda StrTableHi,x
            sta W5TextPatch+1
            xxx MoveTo;XStart
            jsr ToolMLI
            dfb DrawText
W5TextPatch dw $FFFF
            clc
            lda YStart
            adc #DeltaY
            sta YStart
            inc K1
            lda K1
            cmp #NumLines
            bcc DW5_1
            rts
XStart      dw 10
YStart      dw 0
StrTableLow db L1,L2,L3,L4,L5,L6,L7,L8
;StrTableHi  db <L1,<L2,<L3,<L4,<L5,<L6,<L7,<L8
StrTableHi  db >L1,>L2,>L3,>L4,>L5,>L6,>L7,>L8
L1 DW *+3
            str 'Mouse Graphics Tool Kit Demonstration'
L2 dw *+3
            str '   '
L3 dw *+3
            str 'This program demonstrates the use of the'
L4 dw *+3
            str 'Mouse Graphics Tool Kit.  Now you can do'
L5 dw *+3
            str 'things on an Apple // that you thought'
L6 dw *+3
            dfb 35
;     123456789012345678901234567890123
            asc 'were only possible on a Macintosh'
            dfb 16,17 ; the TM chars in the font.
L7 dw *+3
            str ' '
L8 dw *+3
            str 'Click in this window to continue.'
;
*
* Date for drawing windows
*
xSrcCOPY    dfb 4
xSrcXOR     dfb 2
xPolygon    dfb 3,0
            dw 10,10,100,100,40,100
*
* Data for Setting up the window port
*
GWParms     dfb 0 ; window id
            dw TempPort ; port i want to use
TempPort    ds PortLength,0

;
;
HandleKeypress equ *
            lda EvtKey ; Returned in event byte 1
            sta MenuCmd+2 ; Check to see if its a menu key_
            lda EvtMods ; Returned in event byte 2
            sta MenuCmd+3
            xxx MenuKey;MenuCmd
;
HandleMenu  equ * ; Takes result from menu commands and acts accordingly_
            lda MenuCmd
            bne *+3
            rts
;
            cmp #1 ; find out which menu
            bne Menu_1
            jsr h_menu_1
            jmp Menu_Done
;
Menu_1      cmp #2
            bne Menu_2
            jsr h_menu_2
            jmp Menu_Done
;
Menu_2      cmp #3
            bne Menu_3
            jsr h_menu_3
            jmp Menu_Done
;
Menu_3 cmp #4
            bne Menu_4
            jsr h_menu_4
            jmp Menu_Done
;
Menu_4      cmp #5
            bne Menu_5
            jsr h_menu_5
            jmp Menu_Done
;
Menu_5      cmp #6
            bne Menu_6
            jsr h_menu_6
            jmp Menu_Done
;
Menu_6      cmp #7
            bne Menu_7
            jsr h_menu_7
            jmp Menu_Done
;
Menu_7      jsr RingBell
;
Menu_Done equ *
            xxx HiLiteMenu;MenuCmd
            rts
;
h_menu_1    equ *
            xxx OpenWindow;DialogWindow
            lda DialogWindow
            jsr DrawItB
M1_1        xxx GetEvent;TheEvent
            lda EvtType
            cmp #KeyPress
            beq M1_2
            cmp #ButnDown
            bne M1_1
            xxx FindWindow;FWParms
            lda FindResult
            cmp #InContent
            bne M1_1
            lda WindowFound
            cmp DialogWindow
            bne M1_1
M1_2        xxx CloseWindow;WindowFound
            rts
;
h_menu_2    equ *
            lda MenuItem
            cmp #1
            bne M2_1
            lda #$40
            sta Quit
M2_1        cmp #2
            bne M2_2
            lda #$80
            sta Quit
M2_2        rts
;
h_menu_3    equ *
end_menu_3  rts
;
h_menu_4    equ *
            lda MenuItem
            cmp #4
            bcs m4_2 ; Its not one of the first three
;
            xxx FrontWindow;OnTop ; Need to know whats on top
            lda OnTop
            cmp MenuItem
            beq end_menu_3 ; a local rts
;
;
            jsr UncheckWindow
            xxx SelectWindow;MenuItem ; Try selecting it
            beq m4_1 ; It was open since no error occurred
            lda MenuItem
            asl a ; Multiply by 2
            tax
            lda WinfoTable,x
            sta wptr
            lda WinfoTable+1,x
            sta wptr+1
            jsr ToolMLI
            dfb OpenWindow
wptr        dw $FFFF ; Gets set above_
m4_1        lda MenuItem
            jsr CheckWindow
            jmp DrawItB ; Display its contents
;
m4_2        cmp #5
            bne m4_4
            xxx KeyBoardMouse;0 ; Signal that the next call to Drag or Grow is Fake
            xxx FrontWindow;OnTop ; Find what window is on top
            lda OnTop
            beq m4_3 ; if zero then there were none on desk
            sta DragParms
            xxx DragWindow;DragParms ; Drag It_
m4_3        rts
;
m4_4        cmp #6
            bne m4_6
            xxx KeyBoardMouse;0 ; Signal that the next call to Drag or Grow is Fake
            xxx FrontWindow;GrowParms ; Find what window is on top
            lda GrowParms
            beq m4_5 ; if zero then there were none on desk_
            xxx GrowWindow;GrowParms ; Grow it_
m4_5        rts
;
m4_6        cmp #7
            bne m4_7
            xxx FrontWindow;WindowFound ; Param used by DoClose
            lda WindowFound
            beq m4_7
            jmp DoClose_1
m4_7        rts
;
CheckWindow equ * ; preserves a-reg containing item number
            sta CheckParms+1
            xxx CheckItem;CheckParms
            lda CheckParms+1
            rts
CheckParms  dfb 4 ; Menu ID
            dfb 0 ; Item Number
            dfb 1 ; Check It (vs uncheck it)
;
UncheckWindow equ * ; preserves a-reg containing item number
            sta UncheckParms+1
            xxx CheckItem;UncheckParms
            lda UncheckParms+1
            rts
UncheckParms dfb 4 ; Menu ID
            dfb 0 ; Item Number
            dfb 0 ; Uncheck It (vs check it)
;
h_menu_5 equ *
            lda MenuItem
            bne m5_1
            rts
m5_1        cmp #1 ; Clear Menu
            bne m5_2
            jmp ClearMenu
m5_2        cmp #2 ; Disable Menu
            bne m5_3
            jmp DisMenu
m5_3        cmp #3 ; Enable Menu
            bne m5_4
            jmp EnMenu
m5_4        cmp #4 ; Disable Items
            bne m5_5
            jmp DisItems
m5_5        cmp #5 ; Enable Items
            bne m5_6
            jmp EnItems
m5_6        cmp #6 ; CheckItems
            bne m5_7
            jmp CkItems
m5_7        cmp #7 ; UncheckItems
            bne m5_8
            jmp UnckItems
m5_8        cmp #8 ; Change Marks
            bne m5_9
            jmp ChangeMarks
m5_9        cmp #9 ; Restore marks
            bne m5_10
            jmp RestoreMarks
m5_10       rts
;
ClearMenu   equ *
            jsr EnMenu
            jsr EnItems
            jsr RestoreMarks
            jmp UnckItems
;
DisMenu     equ *
            xxx DisableMenu;DisParms
            rts
DisParms    dfb 7,1
;
EnMenu      equ *
            xxx DisableMenu;EnParms
            rts
EnParms     dfb 7,0
;
DisItems    equ *
            ldx #1
            jmp DisEnItems
;
EnItems     equ *
            ldx #0
            jmp DisEnItems
;
DisEnItems  equ *
            lda #3
            jsr DisIt
            lda #5
            jsr DisIt
            lda #7
            jmp DisIt
;
DisIt       equ *
            stx DisItParms+2
            sta DisItParms+1
            xxx DisableItem;DisItParms
            ldx DisItParms+2
            rts
DisItParms  dfb 7,0,0
;
CkItems equ *
            ldx #1
            jmp CkUnckItems
;
UnckItems equ *
            ldx #0
            jmp CkUnckItems
;
CkUnckItems equ *
            lda #1
            jsr CkIt
            lda #4
            jsr CkIt
            lda #8
            jsr CkIt
            lda #9
            jmp CkIt
;
CkIt equ *
            stx CkItParms+2
            sta CkItParms+1
            xxx CheckItem;CkItParms
            ldx CkItParms+2
            rts
CkItParms   dfb 7,0,0
;
ChangeMarks equ *
            xxx SetMark;Mark8
            xxx SetMark;Mark9
            rts
Mark8       dfb 7,8,1,'#'
Mark9       dfb 7,9,1,'*'
RestoreMarks equ *
            xxx SetMark;Unmark8
            xxx SetMark;Unmark9
            rts
Unmark8     dfb 7,8,0,0
Unmark9     dfb 7,9,0,0
;
h_menu_6    equ *
            lda MenuItem
            cmp #1
            bne M6_2
M6_1        xxx OpenWindow;TestWindow
            lda TestWindow
            jmp DrawItB
M6_2    cmp #11
            bcc *+5
            jmp M6_11
            xxx CloseWindow;TestWindow
            jsr ClearUpdates
            lda MenuItem
            cmp #2
            bne M6_3
            lda TestWindow+1
            eor #%00000001 ; Dialog Box
            sta TestWindow+1
            jmp M6_1
M6_3        cmp #3
            bne M6_4
            lda TestWindow+1
            eor #%00000010 ; Go Away Box
            sta TestWindow+1
            jmp M6_12
M6_4        cmp #4
            bne M6_5
            lda TestWindow+4
            eor #%10000000 ; H Scroll Bar Present
            sta TestWindow+4
            jmp M6_12
M6_5        cmp #5
            bne M6_6
            lda TestWindow+5
            eor #%10000000 ; V Scroll Bar Present
            sta TestWindow+5
            jmp M6_12
M6_6        cmp #6
            bne M6_7
            lda TestWindow+4
            eor #%01000000 ; H Thumb Present
            sta TestWindow+4
            jmp M6_12
M6_7        cmp #7
            bne M6_8
            lda TestWindow+5
            eor #%01000000 ; V Thumb Present
            sta TestWindow+5
            jmp M6_12
M6_8        cmp #8
            bne M6_9
            lda TestWindow+4
            eor #%00000001 ; H Scroll Active
            sta TestWindow+4
            jmp M6_12
M6_9        cmp #9
            bne M6_10
            lda TestWindow+5
            eor #%00000001 ; V Scroll Active
            sta TestWindow+5
            jmp M6_12
M6_10       cmp #10
            bne M6_11
            lda TestWindow+1
            eor #%00000100 ; Grow Box Present
            sta TestWindow+1
            jmp M6_12
M6_11       rts
M6_12       jsr SetChecks
            jmp M6_1
SetChecks   equ *
            jsr ClearUm
            lda TestWindow+1
            and #%00000001 ; Dialog
            beq Set_1
            lda #2
            jsr Check1
Set_1       lda TestWindow+1
            and #%00000010 ; Go Away Box
            beq Set_2
            lda #3
            jsr Check1
Set_2       lda TestWindow+4
            and #%10000000 ; H-Scroll Present
            beq Set_3
            lda #4
            jsr Check1
Set_3       lda TestWindow+5
            and #%10000000 ; V-Scroll Present
            beq Set_4
            lda #5
            jsr Check1
Set_4       lda TestWindow+4
            and #%01000000 ; H-Thumb Present
            beq Set_5
            lda #6
            jsr Check1
Set_5       lda TestWindow+5
            and #%01000000 ; V-Thumb Present
            beq Set_6
            lda #7
            jsr Check1
Set_6       lda TestWindow+4
            and #%00000001 ; H-Scroll Active
            beq Set_7
            lda #8
            jsr Check1
Set_7       lda TestWindow+5
            and #%00000001 ; V-Scroll Active
            beq Set_8
            lda #9
            jsr Check1
Set_8       lda TestWindow+1
            and #%00000100 ; Grow Box Present
            beq Set_9
            lda #10
            jsr Check1
Set_9       rts
ClearUm equ *
            lda #2
            sta K1
ClearUm_1   lda K1
            sta ClearParms+1
            xxx CheckItem;ClearParms
            inc K1
            lda K1
            cmp #11
            bcc ClearUm_1
            rts
ClearParms dfb 6,0,0
Check1      equ *
            sta Check1Parms+1
            xxx CheckItem;Check1Parms
            rts
Check1Parms dfb 6,0,1
;
h_menu_7    equ *
            rts
;
HandleButton equ *
            xxx FindWindow;FWParms ; Takes the mouse pos which starts at byte 1 of TheEvent
            lda FindResult ; (TheEvent+5)
            bne HButton_1 ; Not just on the desktop
            rts ; just on the desktop
;
HButton_1   cmp #InMenu
            bne HButton_2
            xxx MenuSelect;MenuCmd
            jmp HandleMenu
;
HButton_2   cmp #InContent
            bne HButton_3
            jmp DoContent
;
HButton_3   cmp #InDrag
            bne HButton_4
            jmp DoDrag
;
HButton_4   cmp #InGrow
            bne HButton_5
            jmp DoGrow
;
HButton_5   cmp #InClose
            bne HButton_6
            jmp DoClose
;
HButton_6   rts ; should never get here!
;
DoContent   equ *
            xxx FrontWindow;OnTop
            lda OnTop
            cmp WindowFound ; second byte of find result (TheEvent+7)
            beq Content_1
            jsr UncheckWindow
            xxx SelectWindow;WindowFound ; Was not on top so select it
            lda WindowFound
            jsr CheckWindow
            jmp DrawItB
;
;
; This is where we do control stuff_
Content_1   lda WindowFound
            sta OnTop ; Get Ready for FindControl which trashes WindowFound
            xxx FindControl;FCParms
            lda FindResult
            sta TrackParms
            lda WhichPart
            cmp #InThumb ; vertical scroll bar, thumb
            bne Content_2
            xxx TrackThumb;TrackParms
;
            lda ThumbMoved
            beq Content_2
            lda ThumbResult
            sta ThumbPos
            xxx UpdateThumb;ThumbParms
Content_2   rts
;
DoDrag equ *
            xxx FrontWindow;OnTop
;
            lda OnTop
            cmp WindowFound ; second byte of find result (TheEvent+7)
            beq DoDrag_1
            jsr UncheckWindow
            xxx SelectWindow;WindowFound ; Was not on top so select it
            lda WindowFound
            jsr CheckWindow
DoDrag_1    lda WindowFound
            sta DragParms
            xxx DragWindow;DragParms
            lda ItMoved
            beq DoDrag_2 ; no it did not move
            jmp ClearUpdates
DoDrag_2    lda WindowFound
            cmp OnTop
            beq DoDrag_3
            jmp DrawItB
DoDrag_3    rts
;
DoGrow equ *
            lda WindowFound
            sta GrowParms
            xxx GrowWindow;GrowParms
            rts
;
DoClose equ *
            xxx TrackGoAway;TheStat
            lda TheStat
            beq DoClose_2
DoClose_1 xxx CloseWindow;WindowFound
            lda WindowFound
            jsr UncheckWindow
            xxx FrontWindow;OnTop
            lda OnTop
            beq DoClose_2
            jsr CheckWindow
DoClose_2 rts
*
*
*
*
;;
;; Killer is the routine that terminates the program_
;; It does all the necessary clean up for quitting
;; cleanly_
;;
Killer      equ *
            xxx CloseAll;0 ; Close all the windows ; 
            xxx StopDeskTop;0
            xxx SetSwitches;TextSwitch ; Turn off graphics/turn on text_
            xxx SetZP1;SaveZP ; Restore zero page
;
            bit Quit ; if High bit is set then do ProDOS quit
            bmi Killer_1 ; else just clear the screen and enter monitor_
            jsr $C300 ; Clear the text screen_
            jmp MonitorEntry
Killer_1    jsr $BF00
            dfb $65
            dw quit_params
            brk ; if we get here something is wrong!
*
quit_params dfb 4
            dw 0,0,0,0
TextSwitch  dfb 8
*
*
*
*
Quit        dfb 0 ; Global quit flag. High bit set => quit_
;
TheDesk     dfb $06,$EA ;machine ID
            dfb $0 ;ProDOS
            dfb $0
InterruptFlag dfb UseInterrupts ; no interupts
            dw SystemFont
            dw SaveBuffer
            dw 4000 ; save area size
;
; Menu Initialization Stuff
CharList    dfb 30 ; Solid Apple
            dfb 31 ; Open Apple
            dfb 29 ; Check Mark
            dfb 1 ; Control character
            dfb 127 ; Inactive character
;
;
WinfoTable dw 0,SmallWindow,BigWindow,CharsWindow
;
SmallWindow dfb 1,%00000110 ; Has GoAway and Grow boxes
            dw SmallStr
            dfb $80,$80 ;ctrl options
            dfb 3,0 ; H-ThumbMax and H-Thumb Pos
            dfb 3,0 ; V-ThumbMax and V-Thumb Pos
            dfb 0,0 ; Status Byte & Reserved
;
            dw 100,25
            dw 300,100
;
            dw 30,30 ;window port
            dw $2000,$80
            dw 0,0,125,50
            ds 8,$FF
            dfb $FF,0 ; and & or mask
            dw 0,0
            dfb 1,1
            dfb 0,$7F
            dw SystemFont
;
            dw 0 ;link to next window
;
;
BigWindow dfb 2,%00000110 ; Has GoAway and Grow Boxes
            dw BigStr
            dfb $80,$80 ; ctrl options
            dfb 3,0 ; H-ThumbMax and H-Thumb Pos
            dfb 3,0 ; V-ThumbMax and V-Thumb Pos
            dfb 0,0 ; Window Option Byte and Reserved
;
            dw 100,100
            dw 500,180
;
            dw 330,27 ;window port
            dw $2000,$80
            dw 0,0,240,130
            ds 8,$FF
            dfb $FF,0 ; and & or masks
            dw 0,0
            dfb 1,1
            dfb 0,$7F
            dw SystemFont
;
            dw 0 ;link to next window
;
;
CharsWindow dfb 3,%00000010 ; Has GoAway but no Grow Box
            dw CharsStr
            dfb 0,0 ; ctrl options
            dfb 0,0 ; H-ThumbMax and H-Thumb Pos
            dfb 0,0 ; V-ThumbMax and V-Thumb Pos
            dfb 0,0 ; Window Option Byte and Reserved
;
            dw 100,100
            dw 500,180
;
            dw 20,90 ;window port
            dw $2000,$80
            dw 0,0,180,90
            ds 8,$FF
            dfb $FF,0 ; and & or masks
            dw 0,0
            dfb 1,1
            dfb 0,$7F
            dw SystemFont
;
            dw 0 ;link to next window
;
;
TestWindow  dfb 4,%00000110 ; Has GoAway & Grow Boxes
            dw TestStr
            dfb $80,$80 ; Ctrl options
            dfb 3,0 ; H-ThumbMax and H-Thumb Pos
            dfb 3,0 ; V-ThumbMax and V-Thumb Pos
            dfb 0,0 ; Window Option Byte and Reserved
;
            dw 100,100
            dw 500,180
;
            dw 30,40 ;window port
            dw $2000,$80
            dw 0,0,240,130
            ds 8,$FF
            dfb $FF,0 ; And & Or masks
            dw 0,0
            dfb 1,1
            dfb 0,$7F
            dw SystemFont
;
            dw 0 ;link to next window
;
;
DialogWindow dfb 5,%00000001 ; Dialog Box
            dw 0
            dfb 0,0 ;ctrl options
            dfb 0,0 ; H-ThumbMax and H-Thumb Pos
            dfb 0,0 ; V-ThumbMax and V-Thumb Pos
            dfb 0,0 ; Window Option Byte and Reserved
;
            dw 100,100
            dw 500,180
;
            dw 150,30 ;window port
            dw $2000,$80
            dw 0,0,260,100
            ds 8,$FF
            dfb $FF,0 ; and & or masks
            dw 0,0
            dfb 1,1
            dfb 0,$7F
            dw SystemFont
;
            dw 0 ;link to next window
;
SmallStr    str 'Small Window'
BigStr      str 'Big Window'
CharsStr    str 'Font Display'
TestStr     str 'Test Window'
;
;
VScroll     dfb 1,1
HScroll     dfb 2,1
VCtrl       dfb 1,0,0,0
HCtrl       dfb 2,0,0,0
OnTop       dfb 0
;
************************************************************
*
* Many of the tool kit calls require that the mouse
* coordinates be passed back to the tool kit. Since
* the mouse coordinates are originally provided in
* the event parameters, using the same memory to pass
* parameters to the tool kit saves us the trouble of
* moving the information around_
*
* Below I equate many labels to the same memory. When
* I use them in the code I try to indicate (in a comment
* that they refer to this shared area)_
*
*
* The event parameter is five bytes long. The first byte
* is the event type.  The remaining bytes depend on the
* value of the first byte.
*
* For
*
************************************************************
TheEvent equ *
EvtType equ *
DragParms equ *
GrowParms equ *
ThumbParms equ *
TrackParms equ *
MouseX equ *+1
FWParms equ *+1
FCParms equ *+1
UpdateID equ *+1
ThumbPos equ *+1
EvtKey equ *+1
EvtMods equ *+2
MouseY equ *+3
WindowFound equ *+6
ItMoved equ *+5 ; Returned by DragWindow
FindResult equ *+5
ThumbResult equ *+5
WhichPart equ *+6
ThumbMoved equ *+6
            ds 5,0 ; 5 bytes for the event
            ds 2,0 ; 2 bytes for find results and tracking
;
;
MenuCmd dfb 0
MenuItem dfb 0
MenuChar dfb 0
MenuMods dfb 0
;
TheStat ds 1 ;room to return status
;
TheItem dfb 1,1,1 ; that is checked
;
FldrStr dfb 13
            asc 'System Folder'
;;
TheMenu     dfb 7,0
            dfb 1,0 ;Apple mblock
            dw AppleStr,AppleMenu
            ds 6,0
            dfb 2,0 ;File mblock
            dw FileStr,FileMenu
            ds 6,0
            dfb 3,0 ;Edit mblock
            dw EditStr,EditMenu
            ds 6,0
            dfb 4,0
            dw WindowStr,WindowMenu
            ds 6,0
            dfb 5,0
            dw MTStr,MTMenu
            ds 6,0
            dfb 6,0
            dw WTStr,WTMenu
            ds 6,0
            dfb 7,0
            dw DummyStr,DummyMenu
            ds 6,0
;
;
AppleMenu dfb 1
            ds 5,0
            dfb 0,0,0,0 ;About_ iblock
            dw AppleItem1
;
FileMenu dfb 2
            ds 5,0
            dfb 0,0,0,0 ; Monitor Entry
            dw FileItem1
            dfb 3,0,'Q','q' ; Quit
            dw FileItem2
;
EditMenu    dfb 7
            ds 5,0
            dfb 3,0 ;Undo
            asc 'Zz'
            dw EditItem1
            dfb 3,0 ;Cut
            asc 'Xx'
            dw EditItem2
            dfb 3,0 ;Copy
            asc 'Cc'
            dw EditItem3
            dfb 3,0 ;Paste
            asc 'Vv'
            dw EditItem4
            dfb 0,0,0,0 ;Clear
            dw EditItem5
            dfb 0,0,0,0 ;Select All
            dw EditItem6
            dfb 0,0,0,0 ;Show Clipboard
            dw EditItem7
;
WindowMenu dfb 7
            ds 5,0
            dfb 0,0,0,0
            dw WindowItem1
            dfb 0,0,0,0
            dw WindowItem2
            dfb 0,0,0,0
            dw WindowItem3
            dfb $40,0,0,0
            dw 0
            dfb 3,0,'D','d'
            dw WindowItem5
            dfb 3,0,'G','g'
            dw WindowItem6
            dfb 3,0,'H','h'
            dw WindowItem7
;
MTMenu dfb 9
            ds 5,0
            dfb 0,0,0,0
            dw MTItem1
            dfb 0,0,0,0
            dw MTItem2
            dfb 0,0,0,0
            dw MTItem3
            dfb 0,0,0,0
            dw MTItem4
            dfb 0,0,0,0
            dw MTItem5
            dfb 0,0,0,0
            dw MTItem6
            dfb 0,0,0,0
            dw MTItem7
            dfb 0,0,0,0
            dw MTItem8
            dfb 0,0,0,0
            dw MTItem9
;
WTMenu dfb 10
            ds 5,0
            dfb 0,0,0,0
            dw WTItem1
            dfb 0,0,0,0
            dw WTItem2
            dfb 0,0,0,0
            dw WTItem3
            dfb 0,0,0,0
            dw WTItem4
            dfb 0,0,0,0
            dw WTItem5
            dfb 0,0,0,0
            dw WTItem6
            dfb 0,0,0,0
            dw WTItem7
            dfb 0,0,0,0
            dw WTItem8
            dfb 0,0,0,0
            dw WTItem9
            dfb 0,0,0,0
            dw WTItem10
;
DummyMenu dfb 10
            ds 5,0
            dfb 0,0,0,0
            dw DumItem1
            dfb 0,0,0,0
            dw DumItem2
            dfb 0,0,0,0
            dw DumItem3
            dfb 0,0,0,0
            dw DumItem4
            dfb $40,0,0,0
            dw 0
            dfb 0,0,0,0
            dw DumItem6
            dfb 0,0,0,0
            dw DumItem7
            dfb 0,0,0,0
            dw DumItem8
            dfb 0,0,0,0
            dw DumItem9
            dfb 0,0,0,0
            dw DumItem10
;
;
AppleStr dfb 1,30 ;AppleChar
FileStr str 'File'
EditStr str 'Edit'
WindowStr str 'Windows'
MTStr str 'Menu Test'
WTStr str 'Window Test'
DummyStr str 'Dummy'
;
AppleItem1 str 'About this demo...'
;
FileItem1 str 'Enter Monitor'
FileItem2 str 'Quit'
;
EditItem1 str 'Undo'
EditItem2 str 'Cut'
EditItem3 str 'Copy'
EditItem4 str 'Paste'
EditItem5 str 'Clear'
EditItem6 str 'Select All'
EditItem7 str 'Show Clipboard'
;
WindowItem1 str 'Small Window'
WindowItem2 str 'Big Window'
WindowItem3 str 'Font Display'
WindowItem5 str 'Drag'
WindowItem6 str 'Grow'
WindowItem7 str 'Hide'
;
MTItem1 str 'Clear Menu'
MTItem2 str 'Disable Menu'
MTItem3 str 'Enable Menu'
MTItem4 str 'Disable Items'
MTItem5 str 'Enable Items'
MTItem6 str 'Check Items'
MTItem7 str 'Uncheck Items'
MTItem8 str 'Change Some Marks'
MTItem9 str 'Restore Some Marks'
;
;
WTItem1 str 'Open Test Window'
WTItem2 str 'Dialog'
WTItem3 str 'Go Away Present'
WTItem4 str 'H-Scroll Present'
WTItem5 str 'V-Scroll Present'
WTItem6 str 'H-Thumb Present'
WTItem7 str 'V-Thumb Present'
WTItem8 str 'H-Scroll Active'
WTItem9 str 'V-Scroll Active'
WTItem10 str 'Grow Box Present'
;
;
DumItem1 str 'Line 1'
DumItem2 str 'Line 2'
DumItem3 str 'Line 3'
DumItem4 str 'Line 4'
; 5 is filler
DumItem6 str 'Line 6'
DumItem7 str 'Line 7'
DumItem8 str 'Line 8'
DumItem9 str 'Line 9'
DumItem10 str 'Line 10'
;
;
DoNotSave dfb 0
SaveZP dfb $80
