	;; 
	;; HOH.asm
	;;
	;; Main Head Over Heels source file
	;;
	;; Glues together all the other assembly files, binaries, etc.
	;; 

#target ROM
#code HOH, 0, $FFFF
	defs $4000, $00

#insert "screen.scr"

#include "room_data.asm"

	;; Hack, should be removed.
#include "equs.asm"

MAGIC_OFFSET:	EQU 360 	; The offset high data is moved down by...
	
ViewBuff:	EQU $B800

	;; The buffer into which we draw the columns doors stand on
ColBuf:		EQU $F944
ColBufLen:	EQU $94

DoorwayBuf:	EQU $F9D8

#include "mainloop.asm"
        
C72A0:	XOR		A
		JR		L72A9
C72A3:	LD		A,$FF
		LD		HL,L7305
		PUSH	HL
L72A9:	LD		HL,L7355
		LD		DE,L72EB
		JR		L72BC
L72B1:	XOR		A
		LD		HL,L7B78
		PUSH	HL
		LD		HL,L734B
		LD		DE,L72F3
L72BC:	PUSH	DE
		LD		(L7348+1),HL
		CALL	C7314
		LD		(L72F0),HL
		AND		A
		LD		HL,LFB28
		JR		NZ,L72CD
		EX		DE,HL
L72CD:	EX		AF,AF'
		CALL	C7321
		INC		B
		NOP
		DEC		SP
		LD		(HL),B
		CALL	C7321
		DEC		E
		NOP
		LD		(HL),A
		XOR		A
		CALL	C7321
		ADD		HL,DE
		NOP
		AND		D
		AND		D
		CALL	C7321
		RET		P
		INC		BC
		LD		B,B
		CP		D
		RET
L72EB:	CALL	C7321
		LD		(DE),A
		NOP			
L72F0:		RET		NZ 		; Self-modifying code
		AND		D
		RET
L72F3:	PUSH	DE
		CALL	GetCharObj
		EX		DE,HL
		LD		BC,L0012
		PUSH	BC
		LDIR
		CALL	C7314
		POP		BC
		POP		DE
		LDIR
L7305:		LD		HL,(LAF92) 	; NB: Referenced as data.
		LD		(ObjDest),HL
		LD		HL,ObjectLists + 4
		LD		BC,L0008
		JP		FillZero
	
C7314:		LD		HL,Character
		BIT		0,(HL) 		; Heels?
		LD		HL,HeelsObj	; No Heels case
		RET		Z
		LD		HL,HeadObj 	; Have Heels case
		RET

C7321:	POP		IX
		LD		C,(IX+$00)
		INC		IX
		LD		B,(IX+$00)
		INC		IX
		EX		AF,AF'
		AND		A
		JR		Z,L733B
		LD		E,(IX+$00)
		INC		IX
		LD		D,(IX+$00)
		JR		L7343
L733B:	LD		L,(IX+$00)
		INC		IX
		LD		H,(IX+$00)
L7343:	INC		IX
		EX		AF,AF'
		PUSH	IX
L7348:	JP		L7355	; Self-modifying code
L734B:	LD		A,(DE)
		LDI
		DEC		HL
		LD		(HL),A
		INC		HL
		JP		PE,L734B
		RET
L7355:	LDIR
		RET

;; Given a fetched 3-bit value in A... returns 0 in A. I assume there
;; was support for multiple door sprites, that got nixed at some
;; point.
ToDoorId:       XOR     A
                RET

	;; Installs the interrupt hook
IrqInstall:	DI
		IM	2
		LD	A,$39		; Page full of FFhs.
		LD	I,A
		LD	A,$18
		LD	(LFFFF),A 	; JR 0xFFF4
		LD	A,$C3		; JP ...
		LD	($FFF4),A
		LD	HL,IrqHandler 	; to IrqHandler
		LD	(LFFF5),HL
		CALL	ShuffleMem
		EI
		RET

	;; The main interrupt hook - calls IrqFn and decrements FrameCounter (if non-zero).
IrqHandler:	PUSH	AF
		PUSH	BC
		PUSH	HL
		PUSH	DE
		PUSH	IX
		PUSH	IY
		CALL	IrqFn
		POP	IY
		POP	IX
		POP	DE
		POP	HL
		POP	BC
		LD	A,(FrameCounter)
		AND	A
		JR	Z,SkipWriteFrame
		DEC	A
		LD	(FrameCounter),A
SkipWriteFrame:	POP	AF
		EI
		RET

;; Draws the screen in black. Presumably hides the drawing process.
;;
;; Draws screen in black with an X extent from 32 to 192,
;; Y extent from 40 to 255 (?!).
DrawBlacked:	LD	A,$08
		CALL	SetAttribs 	; Set all black attributes
		LD	HL,$4048	; X extent
		LD	DE,$4857 	; Y extent
DBL_1:		PUSH	HL
		PUSH	DE
		CALL	CheckYAndDraw
		POP	DE
		POP	HL
		LD	H,L
		LD	A,L
		ADD	A,$14   ; First window is 8 wide, subsequent are 20.
		LD	L,A
		CP	$C1     ; Loop across the visible core of the screen.
		JR	C,DBL_1
		LD	HL,$4048
		LD	D,E
		LD	A,E
		ADD	A,$2A   ; First window is 15, subsequent are 42.
		LD	E,A     ; Loop all the way to row 255!
		JR	NC,DBL_1
		RET

#include "attr_scheme.asm"
	
CHAR_ARR1:	EQU $21
CHAR_ARR2:	EQU $22
CHAR_ARR3:	EQU $23
CHAR_ARR4:	EQU $24
CHAR_LIGHTNING:	EQU $25
CHAR_SPRING:	EQU $26
CHAR_SHIELD:	EQU $27
	
	;; Look up character code (- 0x20 already) to a pointer to the character in DE.
CharCodeToAddr:	CP	$08
		JR	C,CC2A 		; Space ! " # $ % & '
		SUB	$07
		CP	$13
		JR	C,CC2A		; / 0-9
		SUB	$07 		; Alphabetical characters.
CC2A:		ADD	A,A
		ADD	A,A
		LD	L,A
		LD	H,$00
		ADD	HL,HL
		LD	DE,IMG_CHARS - 360
		ADD	HL,DE
		EX	DE,HL
		RET

#include "controls.asm"

#include "columns.asm"
        
#include "room.asm"

InitStuff:	CALL	IrqInstall
		JP	InitRevTbl

InitNewGame:	XOR	A
		LD	(WorldMask),A
		LD	(LB218),A
		LD	(Continues),A
		LD	A,$18
		LD	(LA2C8),A
		LD	A,$1F
		LD	(LA2DA),A
		CALL	InitNewGame1
		CALL	Reinitialise
		DEFW	StatusReinit
		CALL	ResetSpecials
		LD	HL,L8940
		LD	(RoomId),HL
		LD	A,$01
		CALL	C7B43
		LD	HL,L8A40
		LD	(RoomId),HL
		XOR	A
		LD	(LB218),A
		RET

C7B43:		LD	(Character),A
		PUSH	AF
		LD	(LFB28),A
		CALL	C7BBF
		XOR	A
		LD	(LA297),A
		CALL	CharThing15
		JR	L7B59		; Tail call

L7B56:		CALL	CharThing
L7B59:		LD	A,(SavedObjListIdx)
		AND	A
		JR	NZ,L7B56
		POP	AF
		XOR	$03
		LD	(Character),A
		CALL	CharThing3
		JP	C72A0		; Tail call

InitContinue:	CALL	Reinitialise
		DEFW	StatusReinit
		LD	A,$08
		CALL	UpdateAttribs	; Blacked-out attributes
		JP	DoContinue	; Tail call

L7B78:		CALL	C774D
		CALL	Reinitialise
		DEFW	ReinitThing
		CALL	SetCharThing
		CALL	C7C1A
		CALL	DrawBlacked
		XOR	A
		LD	(LA295),A
		JR	RevealScreen	; Tail call

#include "stuff.asm"

#include "menus.asm"

;; Takes a sprite code in B and a height in A, and applies truncation
;; of the third column A * 2 + from the top of the column. This
;; performs removal of the bits of the door hidden by the walls.
;; If the door is raised, more of the frame is visible, so A is
;; the height of the door.
OccludeDoorway:
        ;; Copy the sprite (and mask) indexed by L to DoorwayBuf
		PUSH		AF
		LD		A,L
		LD		H,$00
		LD		(SpriteCode),A
		CALL		Sprite3x56
		EX		DE,HL
		LD		DE,DoorwayBuf
		PUSH		DE
		LD		BC, 56 * 3 * 2
		LDIR
		POP		HL
		POP		AF
	;; A = Min(A * 2 + 8, 0x38)
		ADD		A,A
		ADD		A,$08
		CP		$39
		JR		C,ODW
		LD		A,$38
	;; A *= 3
ODW:		LD		B,A
		ADD		A,A
		ADD		A,B
	;; DE = Top of sprite + A
	;; HL = Top of mask + A
		LD		E,A
		LD		D,$00
		ADD		HL,DE
		EX		DE,HL
		LD		HL, 56 * 3
		ADD		HL,DE
	;; B = $39 - A
		LD		A,B
		NEG
		ADD		A,$39
		LD		B,A
	;; C = ~$03
		LD		C,$FC
		JR		ODW3
	;; This loop then cuts off a wedge from the right-hand side,
	;; presumably to give a nice trunction of the image?
ODW2:		LD		A,(DE)
		AND		C
		LD		(DE),A
		INC		DE
		INC		DE
		INC		DE
		LD		A,C
		CPL
		OR		(HL)
		LD		(HL),A
		INC		HL
		INC		HL
		INC		HL
		AND		A
		RL		C
		AND		A
		RL		C
ODW3:		DJNZ	ODW2
	;; Clear the flipped flag for this copy.
		XOR		A
		LD		(DoorwayFlipped),A
		RET

#include "objects.asm"

#include "walls.asm"

#include "specials.asm"

L8ADC:	DEFB $00,$00
L8ADE:	DEFB $00
L8ADF:	DEFB $00,$00,$00

NUM_ROOMS:      EQU 301
RoomMask:       DEFS NUM_ROOMS, $00

;; Clear donut count and then count number of inventory items we have
EmptyDonuts:    LD      HL,Inventory
                RES     2,(HL)
ED1:            EXX
                LD      BC,L0001
                JR      CountBits

WorldCount:     LD      HL,WorldMask ; FIXME: Possibly actually crowns...
                JR      ED1

RoomCount:      LD      HL,RoomMask
                EXX
                LD      BC,301
        ;; NB: Fall through

;; Counts #bits set in BC bytes starting at HL', returning them in DE.
;; Count is given in BCD.
CountBits:      EXX
                LD      DE,L0000
                EXX
        ;; Outer loop
CB1:            EXX
                LD      C,(HL)
        ;; Run inner loop 8 times?
                SCF
                RL      C
CB2:
        ;; BCD-normalise E
                LD      A,E
                ADC     A,$00
                DAA
                LD      E,A
        ;; BCD-normalise D
                LD      A,D
                ADC     A,$00
                DAA
                LD      D,A
        ;; And loop...
                SLA     C
                JR      NZ,CB2
        ;; So, I think we just added bit population of (HL') into DE'.
                INC     HL
                EXX
                DEC     BC
                LD      A,B
                OR      C
                JR      NZ,CB1
        ;; And do the same for the rest of the BC entries...
                EXX
                RET

InitNewGame1:	LD	HL,RoomMask
		LD	BC,NUM_ROOMS
		JP	FillZero

        ;; Gets the score and puts it in HL
GetScore:	CALL	InVictoryRoom 		; Zero set if end reached.
		PUSH	AF
		CALL	RoomCount
		POP	AF
		LD	HL,L0000
		JR	NZ,GS_1
		LD	HL,$0501
		LD	A,(LA295) 	; TODO: Non-zero gets you points.
		AND	A
		JR	Z,GS_1
		LD	HL,$1002
GS_1:		LD	BC,16
		CALL	MulAccBCD
        ;; 500 points per inventory item.
		PUSH	HL
		CALL	EmptyDonuts ; Alternatively, score inventory minus donuts?
		POP	HL
		LD	BC,500
		CALL	MulAccBCD
        ;; Add score for each world - 636 per world.
		PUSH	HL
		CALL	WorldCount
		POP	HL
		LD	BC,636
        ;; NB: Fall through.

        ;; HL += DE * BC. HL and DE are in BCD. BC is not.
MulAccBCD:      LD      A,E
                ADD     A,L
                DAA
                LD      L,A
                LD      A,H
                ADC     A,D
                DAA
                LD      H,A
                DEC     BC
                LD      A,B
                OR      C
                JR      NZ,MulAccBCD
                RET

;; Given a direction bitmask in A, return a direction code.
LookupDir:      AND     $0F
                ADD     A,DirTable & $FF
                LD      L,A
                ADC     A,DirTable >> 8
                SUB     L
                LD      H,A
                LD      A,(HL)
                RET

;; Input into this look-up table is the 4-bit bitmask:
;; Left Right Down Up.
;;
;; Bits are low if direction is pressed.
;;
;; Combinations are mapped to the following directions:
;;
;; $05 $04 $03
;; $06 $FF $02
;; $07 $00 $01
;;
DirTable:       DEFB $FF,$00,$04,$FF,$06,$07,$05,$06
                DEFB $02,$01,$03,$02,$FF,$00,$04,$FF

;; A has a direction, returns Y delta in C, X delta in B, and
;; third entry is the DirTable inverse mapping.
DirDeltas:      LD              L,A
                ADD             A,A
                ADD             A,L
                ADD             A,DirTable2 & $FF
                LD              L,A
                ADC             A,DirTable2 >> 8
                SUB             L
                LD              H,A
                LD              C,(HL)
                INC             HL
                LD              B,(HL)
                INC             HL
                LD              A,(HL)
                RET

        ;; First byte is Y delta, second X, third is reverse lookup?
DirTable2:      DEFB $FF,$00,$0D        ; ~F2
                DEFB $FF,$FF,$09        ; ~F6
                DEFB $00,$FF,$0B        ; ~F4
                DEFB $01,$FF,$0A        ; ~F5
                DEFB $01,$00,$0E        ; ~F1
                DEFB $01,$01,$06        ; ~F9
                DEFB $00,$01,$07        ; ~F8
                DEFB $FF,$01,$05        ; ~FA

UpdateCurrPos:  LD	HL,(CurrObject)
        ;; Fall through

        ;; Takes direction in A.
UpdatePos:      PUSH    HL
                CALL    DirDeltas
        ;; Store the bottom 4 bits of A (dir bitmap) in Object + $0B
                LD      DE,$0B
                POP     HL
                ADD     HL,DE
                XOR     (HL)
                AND     $0F
                XOR     (HL)
                LD      (HL),A
        ;; Update U coordinate with Y delta.
                LD      DE,-$06
                ADD     HL,DE
                LD      A,(HL)
                ADD     A,C
                LD      (HL),A
        ;; Update V coordinate with X delta.
                INC     HL
                LD      A,(HL)
                ADD     A,B
                LD      (HL),A
                RET

C8CF0:	INC		(HL)
		LD		A,(HL)
		ADD		A,L
		LD		E,A
		ADC		A,H
		SUB		E
		LD		D,A
		LD		A,(DE)
		AND		A
		RET		NZ
		LD		(HL),$01
		INC		HL
		LD		A,(HL)
		RET
L8CFF:	LD		A,(HL)
		INC		(HL)
		ADD		A,A
		ADD		A,L
		LD		E,A
		ADC		A,H
		SUB		E
		LD		D,A
		INC		DE
		LD		A,(DE)
		AND		A
		JR		Z,L8D11
		EX		DE,HL
		LD		E,A
		INC		HL
		LD		D,(HL)
		RET
L8D11:	LD		(HL),$01
		INC		HL
		LD		E,(HL)
		INC		HL
		LD		D,(HL)
		RET

        ;; Looks suspiciously like a crazy PRNG?
Random:		LD		HL,(L8D49)
		LD		D,L
		ADD		HL,HL
		ADC		HL,HL
		LD		C,H
		LD		HL,(L8D47)
		LD		B,H
		RL		B
		LD		E,H
		RL		E
		RL		D
		ADD		HL,BC
		LD		(L8D47),HL
		LD		HL,(L8D49)
		ADC		HL,DE
		RES		7,H
		LD		(L8D49),HL
		JP		M,L8D43
		LD		HL,L8D47
L8D3F:		INC		(HL)
		INC		HL
		JR		Z,L8D3F
L8D43:		LD		HL,(L8D47)
		RET

L8D47:	DEFB $4A,$6F
L8D49:	DEFB $6E,$21

	;; Pointer to object in HL
RemoveObject:	PUSH	HL
		PUSH	HL
		PUSH	IY
		PUSH	HL
		POP	IY
		CALL	Unlink
		POP	IY
		POP	HL
		CALL	C8D6F
		POP	IX
		SET	7,(IX+$04)
	;; Transfer top bit of Phase to IX+$0A
		LD	A,(Phase)
		LD	C,(IX+$0A)
		XOR	C
		AND	$80
		XOR	C
		LD	(IX+$0A),A
		RET

C8D6F:	PUSH	IY
		INC		HL
		INC		HL
		CALL	GetObjExtents2
		EX		DE,HL
		LD		H,B
		LD		L,C
		CALL	CheckAndDraw
		POP		IY
		RET
	
InsertObject:	PUSH	HL
		PUSH	HL
		PUSH	IY
		PUSH	HL
		POP	IY
		CALL	EnlistAux
		POP	IY
		POP	HL
		CALL	C8D6F
		POP	IX
		RES	7,(IX+$04)
		LD	(IX+$0B),$FF
		LD	(IX+$0C),$FF
		RET
	
#include "sprite_stuff.asm"
	
#include "obj_fns.asm"
	
L9376:	DEFB $FD,$F9,$FB,$FA,$FE,$F6,$F7,$F5

SetFacingDirEx: LD      C,(IY+$10)      ; Read direction code
                BIT     1,C             ; Heading 'down'?
                RES     4,(IY+$04)      ; Set bit 4 of flags, if so.
                JR      NZ,SetFacingDir
                SET     4,(IY+$04)
        ;; NB: Fall through
SetFacingDir:   LD      A,(IY+$0F)      ; Load animation code.
                AND     A
                RET     Z               ; Return if not animated
                BIT     2,C             ; Heading right?
        ;; TODO: All seems a bit complicated for what I think it does.
                LD      C,A
                JR      Z,SFD1          ; Then jump to that case.
                BIT     3,C
                RET     NZ
                LD      A,$08
                JR      SFD2
SFD1:           BIT     3,C             ; Ret if sprite currently faces forward.
                RET     Z
                XOR     A               ; ...
SFD2:           XOR     C
                AND     $0F
                XOR     C
                LD      (IY+$0F),A
                RET

L93AA:	DEFB $00,$00,$00,$00,$00,$00

	;; The phase mechanism allows an object to not get processed
	;; for one frame.
DoObjects:	LD	A,(Phase)
		XOR	$80
		LD	(Phase),A 		; Toggle top bit of Phase
		CALL	CharThing
	;; Loop over main object list...
		LD	HL,(ObjectLists + 2)
		JR	DO_3
DO_1:		PUSH	HL
		LD	A,(HL)
		INC	HL
		LD	H,(HL)
		LD	L,A
		EX	(SP),HL			; Next item on top of stack, curr item in HL
		EX	DE,HL
		LD	HL,L000A
		ADD	HL,DE
	;; Check position +10
		LD	A,(Phase)
		XOR	(HL)
		CP	$80			; Skip if top bit doesn't match Phase
		JR	C,DO_2
		LD	A,(HL)
		XOR	$80
		LD	(HL),A			; Flip top bit - will now mismatch Phase
		AND	$7F
		CALL	NZ,CallObjFn 		; And if any other bits set, call CallObjFn
DO_2:		POP	HL
DO_3:		LD	A,H			; loop until null pointer.
		OR	L
		JR	NZ,DO_1
		RET

	;; Room origin, in double-pixel coordinates, for attrib-drawing
RoomOrigin:	DEFW $0000
	
Attrib0:	DEFB $00
Attrib3:	DEFB $43
Attrib4:	DEFB $45
Attrib5:	DEFB $46

#include "blit_screen.asm"

#include "screen_bits.asm"

#include "controls2.asm"

#include "sound.asm"

#include "blit_mask.asm"

#include "background.asm"

#include "blit_rot.asm"

#include "scene.asm"

	;; Fetch bit-packed data.
	;; Expects number of bits in B.
	
	;; End marker is the set bit rotated in from carry: The
	;; current byte is all read when only that bit remains.
FetchData:	LD	DE,CurrData
		LD	A,(DE)
		LD	HL,(DataPtr)
		LD	C,A
		XOR	A
FD_1:		RL	C
		JR	Z,FD_3
FD_2:		RLA
		DJNZ	FD_1
		EX	DE,HL
		LD	(HL),C
		RET
	;; Next character case: Load/initially rotate the new character, and jump back.
FD_3:		INC	HL
		LD	(DataPtr),HL
		LD	C,(HL)
		SCF
		RL	C
		JP	FD_2

CallBothWalls:	LD	HL,(DoorLocs)
        ;; Take the smaller of H and L.
		LD	A,L
		CP	H
		JR	C,CBW_1
		LD	A,H
        ;; Take it away from C0, to convert to a height above ground...
        ;; So make it the lower of the two.
CBW_1:		NEG
		ADD	A,$C0
        ;; Lower (increase Z coord) door height if it's a value less than A.
		LD	HL,DoorHeight
		CP	(HL)
		JR	C,CBW_2
		LD	(HL),A
        ;; Get door height into A and tail call BothWalls
CBW_2:		LD	A,(HL)
		JP	BothWalls	; NB: Tail call.

FillZero:	LD	E,$00
	;; HL = Dest, BC = Size, E = value
FillValue:	LD	(HL),E
		INC	HL
		DEC	BC
		LD	A,B
		OR	C
		JR	NZ,FillValue
		RET

StatusReinit:	DEFB $09	; Number of bytes to reinit with
	
		DEFB $00	; Inventory reset
		DEFB $00	; Speed reset
		DEFB $00	; Springs reset
		DEFB $00	; Heels invuln reset
		DEFB $00	; Head invuln reset
		DEFB $08	; Heels lives reset
		DEFB $08	; Head lives reset
		DEFB $00	; Donuts reset
		DEFB $00	; FIXME
	
Inventory:	DEFB $00	; Bit 0 purse, bit 1 hooter, bit 2 donuts FIXME
Speed:		DEFB $00	; Speed
		DEFB $00	; Springs
Invuln:		DEFB $00	; Heels invuln
		DEFB $00	; Head invuln
Lives:		DEFB $04	; Heels lives
		DEFB $04	; Head lives
Donuts:		DEFB $00	; Donuts
LA293:		DEFB $00
Character:	DEFB $03	; $3 = Both, $2 = Head, $1 = Heels
LA295:	DEFB $01
LA296:	DEFB $00
LA297:	DEFB $00
InvulnModulo:	DEFB $03
SpeedModulo:	DEFB $02
	
ReinitThing:	DEFB $03	; Three bytes to reinit with
	
		DEFB $00
		DEFB $00
		DEFB $FF
	
LA29E:		DEFB $00
LA29F:		DEFB $00
LA2A0:		DEFB $FF

TickTock:	DEFB $02        ; Phase for moving
LA2A2:	DEFB $00
EntryPosn:	DEFB $00,$00,$00 ; Where we entered the room (for when we die).
LA2A6:	DEFB $03
Carrying:	DEFW $0000	 ; Pointer to carried object.
	
FiredObj:	DEFB $00,$00,$00,$00,$20
		DEFB $28,$0B,$C0
		DEFB $24,$08
		DEFB $12
		DEFB $FF,$FF,$00,$00
		DEFB $08,$00,$00
	
LA2BB:	DEFB $0F
SavedObjListIdx:	DEFB $00
OtherSoundId:	DEFB $00
SoundId:	DEFB $00	 ; Id of sound, +1 (0 = no sound)
Movement:	DEFB $FF
	
HeelsObj:	DEFB $00
LA2C1:	DEFB $00,$00,$00,$08
LA2C5:	DEFB $28,$0B,$C0
LA2C8:	DEFB $18,$21,$00,$FF,$FF
LA2CD:	DEFB $00,$00,$00,$00
LA2D1:	DEFB $00
	
HeadObj:	DEFB $00,$00,$00,$00,$08
LA2D7:	DEFB $28,$0B,$C0
LA2DA:	DEFB $1F,$25,$00,$FF,$FF
LA2DF:	DEFB $00,$00
LA2E1:	DEFB $00,$00,$00
	
LA2E4:	DEFB $00,$18,$19,$18,$1A,$00
LA2EA:	DEFB $00,$1B,$1C,$1B,$1D,$00
LA2F0:	DEFB $00
LA2F1:	DEFB $1E,$1F,$1E,$20,$00
LA2F6:	DEFB $00,$21,$22,$21,$23,$00
LA2FC:	DEFB $00,$24,$A4,$A5,$25
LA301:	DEFB $A5,$A6,$26,$26,$A6,$A6,$26,$26,$00
LA30A:	DEFB $00,$26,$A6,$26,$A6,$A5,$25
LA311:	DEFB $24,$A5,$00
        
LA314:		DEFB $00
LA315:		DEFB $40

        ;; Start on 5th row of SPR_HEAD2
HEAD_OFFSET:    EQU (7 * 48 + 4) * 3 + 1

WiggleEyebrows:
        ;; Toggle top bit of LA314.
                LD      HL,LA314 ; TODO
                LD      A,$80
                XOR     (HL)
                LD      (HL),A
        ;; Check bit 0 of LC043 for source choice.
                LD      A,(LC043) ; TODO
                BIT     0,A
        ;; Set up destination
                LD      HL,IMG_3x24 - MAGIC_OFFSET + HEAD_OFFSET
                LD      DE,XORs + 12 ; Reset means second image
                JR      Z,WE_1
                DEC     HL
                LD      DE,XORs ; Set means first image, dest 1 byte less.
        ;; Run XORify twice, at HL, and HL+0x48 (the other part of SPR_HEAD2).
WE_1:           PUSH    DE
                PUSH    HL
                CALL    XORify
                LD      DE,L0048
                POP     HL
                ADD     HL,DE
                POP     DE
        ;; NB: Fall through

;; Source DE, dest HL, xor 2 bytes of 3 in, 6 times.
;; Used to XOR over 2 of three columns of a 3x24 sprite.
XORify:         LD      C,$06
        ;; C times, repeat the loop below, then HL++.
XOR_1:          LD      B,$02
        ;; XOR (DE++) over (HL++), B times.
XOR_2:          LD      A,(DE)
                XOR     (HL)
                LD      (HL),A
                INC     DE
                INC     HL
                DJNZ    XOR_2
                INC     HL
                DEC     C
                JR      NZ,XOR_1
                RET

        ;; Two images, of bits to flip to wiggle eyebrows, one facing
        ;; left, one right.
XORs:
#insert "img_2x6.bin"

#include "character.asm"

#include "contact.asm"

LAD4C:	DEFW $8A40,$7150,$8940,$0480,$BA70,$1300,$4100,$2980
	DEFW $A100,$2600,$8100,$E980,$8400,$B100,$8500,$EF20
	DEFW $A400,$00F0,$A500,$88D0,$BCD0,$DED0,$2DB0,$8BD0
	DEFW $1190,$E1C0,$00B0,$E2C0,$10B0,$C100,$8BF0,$00F0
	DEFW $9730,$EF20,$1D00,$A800,$BA70,$4E00,$8800,$1B30
	DEFW $4C00,$3930,$8B30,$8D30

;; Width of sprite in bytes.
SpriteWidth:    DEFB $04
;; Current sprite we're drawing.
SpriteCode:     DEFB $00

RevTable:       EQU $B900

;; Initialise a look-up table of byte reverses.
InitRevTbl:     LD      HL,RevTable
RevLoop_1:      LD      C,L
                LD      A,$01
                AND     A
RevLoop_2:      RRA
                RL      C
                JR      NZ,RevLoop_2
                LD      (HL),A
                INC     L
                JR      NZ,RevLoop_1
                RET

;; Generates the X and Y extents, and sets the sprite code and sprite
;; width.
;;
;; Parameters: Sprite code is passed in in A.
;;             X coordinate in C, Y coordinate in B
;; Returns: X extent in BC, Y extent in HL
GetSprExtents:  LD      (SpriteCode),A
                AND     $7F
                CP      $10
                JR      C,Case3x56      ; Codes < $10 are 3x56
                LD      DE,L0606
                LD      H,$12
                CP      $54
                JR      C,SSW1
                LD      DE,L0808        ; Codes >= $54 are 4x28
                LD      H,$14
SSW1:           CP      $18
                JR      NC,SSW2
                LD      A,(SpriteFlags) ; 3x24 or 4x28
                AND     $02
                LD      D,$04
                LD      H,$0C
                JR      Z,SSW2
                LD      D,$00
                LD      H,$10
        ;; All cases but 3x56 join up here:
        ;; D is Y extent down, H is Y extent up
        ;; E is half-width (in double pixels)
        ;; 4x28: D = 8, E = 8, H = 20
        ;; 3x24: D = 6, E = 6, H = 18
        ;; 3x32: D = 4, E = 6, H = 12 if flags & 2
        ;; 3x32: D = 0, E = 6, H = 16 otherwise
SSW2:           LD      A,B
                ADD     A,D
                LD      L,A             ; L = B + D
                SUB     D
                SUB     H
                LD      H,A             ; H = B - H
                LD      A,C
                ADD     A,E
                LD      C,A             ; C = C + E
                SUB     E
                SUB     E
                LD      B,A             ; B = C - 2*E
                LD      A,E
                AND     A
                RRA                     ; And save width in bytes to SpriteWidth
                LD      (SpriteWidth),A
                RET
Case3x56:       LD      HL,(CurrObject2+1)
                INC     HL
                INC     HL
                BIT     5,(HL)          ; Check flag bit 0x20 for later
                EX      AF,AF'
                LD      A,(HL)
                SUB     $10
                CP      $20
                LD      L,$04
                JR      NC,C356_1
                LD      L,$08
C356_1:         LD      A,B             ; L = (Flag - $10) >= $20 ? 8 : 4
                ADD     A,L
                LD      L,A             ; L = B + L
                SUB     $38
                LD      H,A             ; H = L - 56
                EX      AF,AF'
                LD      A,C
                LD      B,$08
                JR      NZ,C356_2
                LD      B,$04
C356_2:         ADD     A,B             ; B = (Flag & 0x20) ? 8 : 4
                LD      C,A             ; C = C + B
                SUB     $0C
                LD      B,A             ; B = C - 12
                LD      A,$03           ; Always 3 bytes wide.
                LD      (SpriteWidth),A
                RET

#include "get_sprite.asm"
	
DoorwayFlipped:	DEFB $00
LAF5B:	DEFB $1B		; Reinitialisation size

	DEFB $00
	DEFW LBA40
	DEFW ObjectLists + 0
	DEFW ObjectLists + 2
	DEFW $0000
	DEFW $0000
	DEFW $0000,$0000
	DEFW $0000,$0000
	DEFW $0000,$0000
	DEFW $0000,$0000

        ;; The index into ObjectLists.
ObjListIdx:     DEFB $00
        ;; Current pointer for where we write objects into
ObjDest:        DEFW LBA40
        ;; 'A' list item pointers are offset +2 from 'B' list pointers.
ObjListAPtr:    DEFW ObjectLists
ObjListBPtr:    DEFW ObjectLists + 2
        ;; Each list consists of a pair of pointers to linked lists of
        ;; objects (ListA and ListB). They're opposite directions in a
	;; doubly-linked list, and each side has a head node, it seems.
ObjectLists:    DEFW $0000,$0000 ; 0 - Usual list
                DEFW $0000,$0000 ; 1 - Next room in V direction
                DEFW $0000,$0000 ; 2 - Next room in U direction
                DEFW $0000,$0000 ; 3 - Far
                DEFW $0000,$0000 ; 4 - Near

LAF92:	DEFW LBA40
SortObj:	DEFW $0000

        ;; Given an index in A, set the object list index and pointers.
SetObjList:     LD      (ObjListIdx),A
                ADD     A,A
                ADD     A,A
                ADD     A,ObjectLists & $ff
                LD      L,A
                ADC     A,ObjectLists >> 8
                SUB     L
                LD      H,A
        ;; ObjListAPtr = ObjectLists + (ObjListIdx) * 4
                LD      (ObjListAPtr),HL
                INC     HL
                INC     HL
        ;; ObjListBPtr = ObjectLists + (ObjListIdx) * 4 + 2
                LD      (ObjListBPtr),HL
                RET

;; DE contains an 'A' object pointer. Assumes the other half of the object
;; is in the next slot (+0x12). Syncs the object state.
SyncDoubleObject:
        ;; Copy 5 bytes, from the pointer location onwards:
        ;; Next pointer, flags, U & V coordinates.
                LD      HL,$0012
                ADD     HL,DE
                PUSH    HL
                EX      DE,HL
                LD      BC,$0005
                LDIR
        ;; Copy across Z coordinate, sutracting 6.
                LD      A,(HL)
                SUB     $06
                LD      (DE),A
        ;; If bit 5 of byte 9 is set on first object, we're done.
                INC     DE
                INC     HL
                INC     HL
                BIT     5,(HL)
                JR      NZ,SDO_2
        ;; Otherwise, copy the sprite over (byte 8).
                DEC     HL
                LDI
SDO_2:          POP     HL
                RET

#include "procobj.asm"

#include "depthcmp.asm"

LB217:		DEFB $00
LB218:		DEFB $00
LB219:		DEFB $00
Dying:		DEFB $00                ; Mask of the characters who are dying
Direction:	DEFB $00

        ;; HL contains an object, A contains a direction
Move:		PUSH	AF
		CALL	GetUVZExtentsE
		EXX
		POP	AF
		LD	(Direction),A
	;; NB: Fall through

        ;; Takes value in A etc. plus extra return value.
DoMove:		CALL	DoMoveAux
		LD	A,(Direction)
		RET

	;; Takes value in A, indexes into table, writes variable, makes call...
DoMoveAux:	LD	DE,PostMove
        ;; Pop this on the stack to be called upon return.
		PUSH	DE
		LD	C,A
		ADD	A,A
		ADD	A,A
		ADD	A,C		; Multiply by 5
		ADD	A,MoveTbl & $FF
		LD	L,A
		ADC	A,MoveTbl >> 8
		SUB	L
		LD	H,A		; Generate index into table
		LD	A,(HL)
		LD	(LB217),A 	; Load first value here
		INC	HL
		LD	E,(HL)
		INC	HL
		LD	D,(HL)		; Next two in DE
		INC	HL
		LD	A,(HL)
		INC	HL
		LD	H,(HL)
		LD	L,A		; Next two in HL
		PUSH	DE
		EXX			; Save regs, and...
		RET			; tail call DE.

PostMove:    EXX
                        RET             Z
                        PUSH    HL
                        POP             IX
                        BIT             2,C
                        JR              NZ,LB269
                        LD              HL,ObjectLists ; TODO: Another object list traversal
LB257:    LD              A,(HL)
                        INC             HL
                        LD              H,(HL)
                        LD              L,A
                        OR              H
                        JR              Z,LB282
                        PUSH    HL
                        CALL    DoCopy
                        POP             HL
                        JR              C,LB2A0
                        JR              NZ,LB257
                        JR              LB282
LB269:    LD              HL,LAF80
LB26C:    LD              A,(HL)
                        INC             HL
                        LD              H,(HL)
                        LD              L,A
                        OR              H
                        JR              Z,LB27C
                        PUSH    HL
                        CALL    DoCopy
                        POP             HL
                        JR              C,LB2A2
                        JR              NZ,LB26C
LB27C:    CALL	GetCharObj
                        LD              E,L
                        JR              LB288
LB282:    CALL    GetCharObj
                        LD              E,L
                        INC             HL
                        INC             HL
LB288:    BIT             0,(IY+$09)
                        JR              Z,LB292
                        LD              A,YL
                        CP              E
                        RET             Z

LB292:    LD              A,(SavedObjListIdx)
                        AND             A
                        RET             Z
                        CALL    DoCopy
                        RET             NC
                        CALL    GetCharObj
                        INC             HL
                        INC             HL
LB2A0:    DEC             HL
                        DEC             HL
LB2A2:    PUSH    HL
                        POP             IX
                        LD              A,(LB217)
                        BIT             1,(IX+$09)
                        JR              Z,LB2B6
                        AND             A,(IX-$06)
                        LD              (IX-$06),A
                        JR              LB2BC
LB2B6:    AND             A,(IX+$0C)
                        LD              (IX+$0C),A
LB2BC:    XOR             A
                        SUB             $01
        ;; NB: Fall through

LB2BF:		PUSH	AF
		PUSH	IX
		PUSH	IY
		CALL	CB2CD
		POP	IY
		POP	IX
		POP	AF
		RET

        ;; IX and IY are both objects?
        ;; Something is in A.
CB2CD:		BIT	0,(IY+$09)
		JR	NZ,LB2DF 		; Bit 0 set on IY? Proceed.
		BIT	0,(IX+$09)
		JR	Z,LB34F 		; Bit 0 not set on IX? LB34F instead.
        ;; Swap IY and IX.
		PUSH	IY
		EX	(SP),IX
		POP	IY
        ;; At this point, bit 0 set on IY.
LB2DF:		LD	C,(IY+$09) 		; IY's sprite flags in C.
		LD	B,(IY+$04)		; IY's flags in B.
		BIT	5,(IX+$04)              ; Bit 5 not set in IX's flags?
		RET	Z			; Then return.
		BIT	6,(IX+$04)		; Bit 6 set?
		JR	NZ,CollectSpecial       ; CollectSpecial instead, then.
        ;; Return if A is non-zero and bit 4 of IX is set.
		AND	A
		JR	Z,DeadlyContact
		BIT	4,(IX+$09)
		RET	NZ
        ;; NB: Fall through.

;; TODO: Current theory...
;; IY holds character sprite. We've hit a deadly floor or object.
;; C is character's sprite flags (offset 9)
;; B is character's other flags (offset 4)
DeadlyContact:
        ;; If we're double-height (i.e. joined), set bottom two bits
	;; of B and jump.
		BIT	3,B
		LD	B,$03
		JR	NZ,DCO_1
		DEC	B
        ;; Otherwise, if bit 2 of C is set (we're Head), set to 2.
		BIT	2,C
		JR	NZ,DCO_1
        ;; Otherwise (we're Heels), set to 1.
		DEC	B
DCO_1:
        ;; Now clear bits based on invulnerability...
        ;; If Heels is invuln, reset bit 0.
        	XOR	A
		LD	HL,Invuln
		CP	(HL)
		JR	Z,DCO_2
		RES	0,B
DCO_2:		INC	HL
        ;; If Head is invuln, reset bit 1.
		CP	(HL)
		JR	Z,DCO_3
		RES	1,B
        ;; No bits set = invulnerable, so return.
DCO_3:		LD	A,B
		AND	A
		RET	Z
        ;; Update Dying - the mask of which characters should die.
		LD	HL,Dying
		OR	(HL)
		LD	(HL),A
        ;; Another check.
		DEC	HL
		LD	A,(HL)
		AND	A
		RET	NZ
        ;; Return if emperor
		LD	A,(WorldMask)
		CP	$1F
		RET	Z
        ;; Update a thing...
		LD	(HL),$0C
        ;; And do invulnerability if LB218 is non-zero.
		LD	A,(LB218)
		AND	A
		CALL	NZ,BoostInvuln2
		LD	B,$C6
		JP	PlaySound 	; Tail call.

;; Make the special object disappear and call the associated function.
CollectSpecial:
        ;; Set flags etc. for fading
                LD      (IX+$0F),$08
                LD      (IX+$04),$80
        ;; Switch to fade function
                LD      A,(IX+$0A)
                AND     $80
                OR      OBJFN_FADE
                LD      (IX+$0A),A
        ;; Clear special collectable item status.
                RES     6,(IX+$09)
        ;; Extract the item id for the call to GetSpecial.
                LD      A,(IX+$11)
                JP      GetSpecial      ; Tail call

LB34F:		BIT		3,(IY+$09)
		JR		NZ,LB35E
		BIT		3,(IX+$09)
		RET		Z
		PUSH	IY
		POP		IX
LB35E:	BIT		1,(IX+$09)
		JR		Z,LB369
		LD		DE,LFFEE
		ADD		IX,DE
LB369:	BIT		7,(IX+$09)
		RET		Z
		SET		6,(IX+$09)
		LD		(IX+$0B),$FF
		RET

#include "movement.asm"

#include "print_char.asm"

	;; Called immediately after installing interrupt handler.
ShuffleMem:	; Zero end of top page
		LD	HL,LFFFE
		XOR	A
		LD	(HL),A
		; Switch to bank 1, write top of page
		LD	BC,L7FFD
		LD	D,$10
		LD	E,$11
		OUT	(C),E
		LD	(HL),$FF
		; Switch back, see if original overwritten...
		OUT	(C),D
		CP	(HL)
		JR	NZ,Have48K
		; Ok, we're 128K...
		; Zero screen attributes, so no-one can see we're using it as temp space...
		LD	B,$03
		LD	HL,L5800
ShuffleMem_1:	LD	(HL),$00
		INC	L
		JR	NZ,ShuffleMem_1
		INC	H
		DJNZ	ShuffleMem_1
		; Stash data in display memory
		LD	BC,L091B
		LD	DE,L4000
		LD	HL,LB884
		LDIR
		; Switch to bank 1
		LD	A,$11
		LD	BC,L7FFD
		OUT	(C),A
		; Reinitialise IRQ handler there.
		LD	A,$18
		LD	(LFFFF),A
		LD	A,$C3
		LD	($FFF4),A
		LD	HL,IrqHandler
		LD	(LFFF5),HL
		; FIXME: Another memory chunk copy.
		LD	BC,L0043
		LD	DE,AltPlaySound
		LD	HL,LB824
		LDIR
		; FIXME: Repoint interrupt vector.
		DEC	DE
		LD	E,$00
		INC	D
		LD	A,D
		LD	I,A
		LD	A,$FF
ShuffleMem_2:	LD	(DE),A
		INC	E
		JR	NZ,ShuffleMem_2
		INC	D
		LD	(DE),A
		; Unstash from display memory
		LD	BC,L091B
		LD	DE,LC000
		LD	HL,L4000
		LDIR
		; Switch to bank 0.
		LD	BC,L7FFD
		LD	A,$10
		OUT	(C),A
Have48K:	; Move the data end of things down by 360 bytes...
		LD	HL,PanelFlips
		LD	DE,PanelFlips - MAGIC_OFFSET
		LD	BC,L390C ; Up to 0xFAAC
		LDIR
		RET

#include "data_trailer.asm"

#end
