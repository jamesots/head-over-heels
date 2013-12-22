#target ROM
#code 0, $10000
	defs $4000, $00

#include "screen.asm"
	
#include "data_header.asm"
	
	;; Main entry point
Entry:		LD	SP,$FFF4
		CALL	InitStuff
		CALL	InitStick
		JR	Main

L703B:		DEFB $00,$00,$00,$EF,$FF,$00,$00,$00
FrameCounter:	DEFB $01
L7044:		DEFB $FB,$FB
L7046:		CALL	$7D92

Main:		LD	SP,$FFF4
		CALL	$7C96
		JR	NC,Main_1
		CALL	$7B0E
		JR	Main_2
Main_1:		CALL	$964F
		CALL	$7B6B
Main_2:		CALL	$8DC2
		LD	A,$40
		LD	($8F18),A
MainB:		XOR	A
		LD	($703D),A
		CALL	$7B91
MainLoop:	CALL	WaitFrame
		CALL	$713F
		CALL	$7095
		CALL	$93B0
		CALL	$70FD
		CALL	$71A3
		LD	HL,$A2BE
		LD	A,(HL)
		SUB	$01
		LD	(HL),$00
		LD	B,A
		CALL	NC,PlaySound
		JR	MainLoop

	
L708B:	LD		HL,($703B)
		LD		BC,$8D30
		XOR		A
		SBC		HL,BC
		RET
L7095:	CALL	$708B
		RET		NZ
		LD		($7041),A
		DEC		A
		LD		($703F),A
		LD		HL,$8F18
		DEC		(HL)
		LD		A,(HL)
		INC		A
		JP		Z,$7046
		LD		B,$C1
		CP		$30
		PUSH	AF
		CALL	Z,PlaySound
		POP		AF
		AND		$01
		LD		A,$C9
		CALL	Z,$B682
		RET
L70BA:	LD		HL,$703C
		LD		A,($B218)
		DEC		A
		CP		$06
		JR		Z,$70EC
		JR		NC,$70E6
		CP		$04
		JR		C,$70CF
		ADD		A,A
		XOR		$02
		DEC		HL
L70CF:	LD		C,$01
		BIT		1,A
		JR		NZ,$70D7
		LD		C,$FF
L70D7:	RRA
		JR		C,$70E1
		RLD
		ADD		A,C
		RRD
		JR		$70E6
L70E1:	RRD
		ADD		A,C
		RLD
L70E6:	LD		SP,$FFF4
		JP		MainB
L70EC:	CALL	$AD26
		JR		$70E6
	
WaitFrame:	LD		A,(FrameCounter)
		AND		A
		JR		NZ,WaitFrame
		LD		A,$04
		LD		(FrameCounter),A
		RET

L70FD:	CALL	$9643
		RET		NZ
		LD		B,$C0
		CALL	PlaySound
		CALL	GetInputWait
		LD		A,$AC
		CALL	$B682
L710E:	CALL	$75D1
		JR		C,$710E
		DEC		C
		JP		Z,$7046
		CALL	GetInputWait
		CALL	$7BB3
		LD		HL,$4C50
L7120:	PUSH	HL
		LD		DE,$6088
		CALL	$A0A8
		POP		HL
		LD		A,L
		LD		H,A
		ADD		A,$14
		LD		L,A
		CP		$B5
		JR		C,$7120
		RET
L7132:	LD		HL,$7169
		AND		A
		JR		Z,$713B
		LD		HL,$7176
L713B:	LD		($715F),HL
		RET
L713F:	CALL	InputThing
		BIT		7,A
		LD		HL,$7040
		CALL	$718F
		BIT		5,A
		CALL	$718E
		BIT		6,A
		CALL	$718E
		LD		C,A
		RRA
		CALL	$8C90
		CP		$FF
		JR		Z,$7189
		RRA
		JP		C,$7176
		LD		A,C
		LD		($703E),A
		LD		($703F),A
		RET
L7169:	LD		A,($703E)
		XOR		C
		CPL
		XOR		C
		AND		$FE
		XOR		C
		LD		($703F),A
		RET
L7176:	LD		A,($703E)
		XOR		C
		AND		$FE
		XOR		C
		LD		B,A
		OR		C
		CP		B
		JR		Z,$7185
		LD		A,B
		XOR		$FE
L7185:	LD		($703F),A
		RET
L7189:	LD		A,C
		LD		($703F),A
		RET
L718E:	INC		HL
L718F:	RES		0,(HL)
		JR		Z,$7196
		RES		1,(HL)
		RET
L7196:	BIT		1,(HL)
		RET		NZ
		SET		1,(HL)
		SET		0,(HL)
		RET
L719E:	LD		B,$C4
		JP		PlaySound
L71A3:	LD		A,($7041)
		RRA
		RET		NC
		LD		A,($A2BC)
		LD		HL,$B219
		OR		(HL)
		LD		HL,($A296)
		OR		H
		OR		L
		JR		NZ,$719E
		LD		HL,($A290)
		CP		H
		JR		Z,$719E
		CP		L
		JR		Z,$719E
L71BF:	CALL	$7297
		LD		BC,($A2BB)
		JR		NC,$71C9
		LD		(HL),C
L71C9:	INC		HL
		RRA
		JR		NC,$71CE
		LD		(HL),C
L71CE:	LD		HL,$7041
		LD		IY,$A2C0
		LD		A,E
		CP		$03
		JR		Z,$7229
		LD		A,($A295)
		AND		A
		JR		Z,$7229
		LD		A,(IY+$05)
		INC		A
		SUB		(IY+$17)
		CP		$03
		JR		NC,$7229
		LD		C,A
		LD		A,(IY+$06)
		INC		A
		SUB		(IY+$18)
		CP		$03
		JR		NC,$7229
		LD		B,A
		LD		A,(IY+$07)
		SUB		$06
		CP		A,(IY+$19)
		JR		NZ,$7229
		LD		E,$FF
		RR		B
		JR		C,$720E
		RR		B
		CCF
		CALL	$724D
L720E:	RR		C
		JR		C,$7219
		RR		C
		CALL	$724D
		JR		$721D
L7219:	RLC		E
		RLC		E
L721D:	LD		A,$03
		INC		E
		JR		Z,$7234
		DEC		E
		LD		(IY+$1E),E
		RES		1,(HL)
		RET
L7229:	LD		A,$04
		XOR		(HL)
		LD		(HL),A
		AND		$04
		LD		A,$02
		JR		Z,$7234
		DEC		A
L7234:	LD		($A294),A
		CALL	$725C
		CALL	$7297
		JR		C,$7240
		INC		HL
L7240:	LD		A,(HL)
		LD		($A2BB),A
		LD		A,($A295)
		AND		A
		JP		NZ,$8E1D
		JR		$72B1
L724D:	PUSH	AF
		RL		E
		POP		AF
		CCF
		RL		E
		RET
L7255:	LD		IY,$A2C0
		LD		A,($A294)
L725C:	LD		(IY+$0A),$00
		RES		3,(IY+$04)
		BIT		0,A
		JR		NZ,$726C
		LD		(IY+$0A),$01
L726C:	LD		(IY+$1C),$00
		RES		3,(IY+$16)
		BIT		1,A
		JR		NZ,$727C
		LD		(IY+$1C),$01
L727C:	RES		1,(IY+$1B)
		CP		$03
		RET		NZ
		SET		3,(IY+$04)
		SET		1,(IY+$1B)
		RET
L728C:	LD		HL,($703B)
		LD		DE,($FB28)
		AND		A
		SBC		HL,DE
		RET
L7297:	LD		A,($A294)
		LD		HL,$7044
		LD		E,A
		RRA
		RET
L72A0:	XOR		A
		JR		$72A9
L72A3:	LD		A,$FF
		LD		HL,$7305
		PUSH	HL
L72A9:	LD		HL,$7355
		LD		DE,$72EB
		JR		$72BC
L72B1:	XOR		A
		LD		HL,$7B78
		PUSH	HL
		LD		HL,$734B
		LD		DE,$72F3
L72BC:	PUSH	DE
		LD		($7349),HL
		CALL	$7314
		LD		($72F0),HL
		AND		A
		LD		HL,$FB28
		JR		NZ,$72CD
		EX		DE,HL
L72CD:	EX		AF,AF'
		CALL	$7321
		INC		B
		NOP
		DEC		SP
		LD		(HL),B
		CALL	$7321
		DEC		E
		NOP
		LD		(HL),A
		XOR		A
		CALL	$7321
		ADD		HL,DE
		NOP
		AND		D
		AND		D
		CALL	$7321
		RET		P
		INC		BC
		LD		B,B
		CP		D
		RET
L72EB:	CALL	$7321
		LD		(DE),A
		NOP
		RET		NZ
		AND		D
		RET
L72F3:	PUSH	DE
		CALL	$A94B
		EX		DE,HL
		LD		BC,$0012
		PUSH	BC
		LDIR
		CALL	$7314
		POP		BC
		POP		DE
		LDIR
		LD		HL,($AF92)
		LD		($AF78),HL
		LD		HL,$AF82
		LD		BC,$0008
		JP		FillZero
L7314:	LD		HL,$A294
		BIT		0,(HL)
		LD		HL,$A2C0
		RET		Z
		LD		HL,$A2D2
		RET
L7321:	POP		IX
		LD		C,(IX+$00)
		INC		IX
		LD		B,(IX+$00)
		INC		IX
		EX		AF,AF'
		AND		A
		JR		Z,$733B
		LD		E,(IX+$00)
		INC		IX
		LD		D,(IX+$00)
		JR		$7343
L733B:	LD		L,(IX+$00)
		INC		IX
		LD		H,(IX+$00)
L7343:	INC		IX
		EX		AF,AF'
		PUSH	IX
		JP		$7355
L734B:	LD		A,(DE)
		LDI
		DEC		HL
		LD		(HL),A
		INC		HL
		JP		PE,$734B
		RET
L7355:	LDIR
		RET
L7358:	XOR		A
		RET

	;; Installs the interrupt hook
IrqInstall:	DI
		IM	2
		LD	A,$39		; Page full of FFhs.
		LD	I,A
		LD	A,$18
		LD	($FFFF),A 	; JR 0xFFF4
		LD	A,$C3		; JP ...
		LD	($FFF4),A
		LD	HL,IrqHandler 	; to IrqHandler
		LD	($FFF5),HL
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
	
L7395:		LD	A,$08
		CALL	SetAttribs 	; Set all black attributes
		LD	HL,$4048
		LD	DE,$4857
L73A0:		PUSH	HL
		PUSH	DE
		CALL	$A098
		POP	DE
		POP	HL
		LD	H,L
		LD	A,L
		ADD	A,$14
		LD	L,A
		CP	$C1
		JR	C,$73A0
		LD	HL,$4048
		LD	D,E
		LD	A,E
		ADD	A,$2A
		LD	E,A
		JR	NC,$73A0
		RET

	;; Paper colour
BK:		EQU	0
BL:		EQU	1
RD:		EQU	2
MG:		EQU	3
GR:		EQU	4
CY:		EQU	5
YL:		EQU	6
WH:		EQU	7
	;; Modifiers (otherwise, will be dark with black ink)
BR:		EQU	$40	; Bright
BLI:		EQU	$10	; Blue ink
WHI:		EQU	$38	; White ink

	;; The various colour schemes available.
AttribTable:	DEFB    YL,    CY, BR+CY,  BR+MG,  BR+GR,     WH ; 0
		DEFB    WH, BR+GR,    CY,  BR+MG,  BR+GR,     YL ; 1
		DEFB    CY,    MG,    WH,  BR+GR,  BR+YL,  BR+WH ; 2
		DEFB BR+MG,    GR,    CY,  BR+CY,  BR+YL,  BR+WH ; 3
		DEFB BR+GR,    CY,    YL,  BR+MG,  BR+CY,  BR+WH ; 4
		DEFB BR+CY, BR+MG,    WH,  BR+GR,  BR+YL,  BR+WH ; 5
		DEFB BR+WH, BR+CY,    YL,  BR+MG,  BR+CY,  BR+YL ; 6
		DEFB BR+YL, BR+GR,    WH,  BR+MG,  BR+GR,  BR+CY ; 7
		DEFB    BK,    BK,    BK,     BK,     BK,     BK ; 8
		DEFB   WHI,    BK,    BK, WHI+BL, WHI+RD, WHI+GR ; 9
		DEFB   BLI,    BK,    BK, BLI+CY, BLI+YL, BLI+WH ; 10
	
UpdateAttribs:	CALL	SetAttribs
		JP	ApplyAttribs	; Tail call

	;; The border attribute etc. is saved for the sound routine to modify.
LastOut:	DEFB $00

SetAttribs:	LD	C,A
		ADD	A,A
		ADD	A,C
		ADD	A,A
		LD	C,A		; x6
		LD	B,$00
		LD	HL,AttribTable
		ADD	HL,BC
		LD	A,(HL)		; Index into table
		LD	(Attrib0),A
		RRA
		RRA
		RRA
		OUT	($FE),A		; Output paper colour as border.
		LD	(LastOut),A
		LD	A,(HL)
		INC	HL
		LD	E,(HL)
		INC	HL
		LD	D,(HL)
		LD	(Attrib1),DE 	; Writes out Attrib2 at the same time
		LD	DE,Attrib3
		INC	HL
		LDI			; Write out Attrib3
		LDI			; Write out Attrib4
		LDI			; Write out Attrib5
	;; Fill the whole screen with Attrib0.
		LD	C,A
		LD	HL,$5800
AttribLoop:	LD	(HL),C
		INC	HL
		LD	A,H
		CP	$5B
		JR	C,AttribLoop
		RET

Attrib1:	DEFB $00
Attrib2:	DEFB $00
	
L743C:	CP		$08
		JR		C,$7448
		SUB		$07
		CP		$13
		JR		C,$7448
		SUB		$07
L7448:	ADD		A,A
		ADD		A,A
		LD		L,A
		LD		H,$00
		ADD		HL,HL
		LD		DE,$F790
		ADD		HL,DE
		EX		DE,HL
		RET
L7454:	DEFB $FF,$45,$4E,$54,$45,$52,$FF,$83,$53,$53,$48,$FF,$B0,$09,$00,$07
L7464:	DEFB $09,$82,$86,$E3,$A3,$FF,$20,$4A,$4F,$59,$53,$54,$49,$43,$4B,$FF
L7474:	DEFB $87,$53,$2F,$87,$E3,$FF,$4B,$45,$4D,$50,$53,$54,$4F,$4E,$E3,$FF
L7484:	DEFB $46,$55,$4C,$4C,$45,$52,$E3,$FF,$81,$4A,$4F,$59,$FF,$E7,$46,$FF
L7494:	DEFB $E7,$55,$FF,$E7,$44,$FF,$E7,$52,$FF,$E7,$4C,$FF,$83,$53,$50,$43
L74A4:	DEFB $FF,$8D,$5A,$58,$43,$56,$41,$53,$44,$46,$47,$51,$57,$45,$52,$54
L74B4:	DEFB $31,$32,$33,$34,$35,$30,$39,$38,$37,$36,$50,$4F,$49,$55,$59,$8C
L74C4:	DEFB $4C,$4B,$4A,$48,$ED,$E1,$4D,$4E,$42,$E8,$E9,$EA,$EB,$EC,$FF,$FF
L74D4:	DEFB $FF,$FF,$FF,$FF,$E0,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$E1,$FF,$FF
L74E4:	DEFB $FF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF,$F7
L74F4:	DEFB $FB,$FD,$FE,$FF,$FF,$FF,$FD,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
L7504:	DEFB $FF,$FF,$FF,$F0,$FF,$FF,$FF,$FF,$FF,$FF,$E0,$FE,$FF,$FF,$EF,$F7
L7514:	DEFB $FB,$FD,$FE,$FF,$FF,$FF

	;; FIXME: Suspect this is the stick-select screen
SelectStick:	LD	A,$E2
		CALL	$B682
		LD	IX,StickType
		CALL	$7E2E
SelSt_1:	CALL	$7E11
		JR	C,SelSt_1
		RET
	
StickType:	DEFB $00
L752D:		DEFB $03,$04,$08,$E4
	
InitStick:	LD	B,$04
IS_1:		IN	A,($1F)			; Kempston port
		AND	$1F
		CP	$1F
		JR	NC,IS_2
		DJNZ	IS_1
IS_2:		SBC	A,A
		AND	$01
		LD	(StickType),A
		CALL	SelectStick
		LD	A,(StickType)
		SUB	$01
		RET	C			; StickType = 0: Keyboard, return
		LD	HL,Kempston
		JR	Z,IS_3			; StickType = 1: Kempston
		LD	HL,Fuller		; StickType = 2: Fuller
IS_3:		LD	(InputThingJoy+1),HL	; Install joystick hooks
		LD	(StickCall+1),HL
		XOR	A
		LD	(GI_Noppable),A		; NOP the RET to fall through
		LD	A,$CD
		LD	(InputThing),A 		; Make it into a 'CALL', so that it returns.
		RET

	;;  Joystick handler for Kempston
Kempston:	IN	A,($1F)
		LD	B,A
		RRCA
		RRA
		RL	C
		RLCA
		RL	C
		RRA
		RRA
		RL	C
		RRA
		RL	C
		RRA
		RL	C
		LD	A,C
		CPL
		OR	$E0
		RET

	;;  Joystick handler for Fuller
Fuller:		IN	A,($7F)
		LD	C,A
		RLCA
		XOR	C
		AND	$F7
		XOR	C
		RL	C
		RL	C
		XOR	C
		AND	$EF
		XOR	C
		OR	$E0
		RET

	;; FIXME: Work out precisely what this is doing...
GetInput:	LD		HL,$BF20
		LD		BC,$FEFE
GI_1:		IN		A,(C)
		OR		$E0
		INC		A
		JR		NZ,GI_2
		INC		HL
		RLC		B
		JR		C,GI_1
		INC		A
GI_Noppable:	RET				; May get overwritten for fall-through.
StickCall:	CALL		Kempston
		INC		A
		JR		NZ,GI_2
		DEC		A
		RET
GI_2:		DEC		A
		LD		BC,$FF7F
GI_3:		RLC		C
		INC		B
		RRA
		JR		C,GI_3
		LD		A,L
		SUB		$20
		LD		E,A
		ADD		A,A
		ADD		A,A
		ADD		A,E
		ADD		A,B
		LD		B,A
		XOR		A
		RET
	
L75C1:		LD		A,B
		ADD		A,$A5
		LD		L,A
		ADC		A,$74
		SUB		L
		LD		H,A
		LD		A,(HL)
		RET

	;;  Like GetInput, but blocking.
GetInputWait:	CALL	GetInput
		JR	Z,GetInputWait
		RET

L75D1:		CALL	GetInput
		SCF
		RET	NZ
		LD	A,B
		LD	C,$00
		CP	$1E
		RET	Z
		INC	C
		AND	A
		RET	Z
		CP	$24
		RET	Z
		INC	C
		XOR	A
		RET

L75E5:	LD		DE,$74D2
		LD		L,A
		LD		H,$00
		ADD		HL,DE
		RET
L75ED:	CALL	$75E5
		LD		C,$00
L75F2:	LD		A,(HL)
		LD		B,$FF
L75F5:	CP		$FF
		JR		Z,$760F
L75F9:	INC		B
		SCF
		RRA
		JR		C,$75F9
		PUSH	HL
		PUSH	AF
		LD		A,C
		ADD		A,B
		PUSH	BC
		LD		B,A
		CALL	$75C1
		CALL	$7683
		POP		BC
		POP		AF
		POP		HL
		JR		$75F5
L760F:	LD		DE,$0008
		ADD		HL,DE
		LD		A,C
		ADD		A,$05
		LD		C,A
		CP		$2D
		JR		C,$75F2
		RET
L761C:	CALL	$75E5
		PUSH	HL
		CALL	GetInputWait
		LD		HL,$BF20
		LD		E,$FF
		LD		BC,$0009
		CALL	FillValue
L762E:	CALL	GetInput
		JR		NZ,$762E
		LD		A,B
		CP		$1E
		JR		Z,$765B
L7638:	LD		A,C
		AND		(HL)
		CP		(HL)
		LD		(HL),A
		JR		Z,$762E
		CALL	$75C1
		CALL	$7683
		LD		HL,($B67E)
		PUSH	HL
		LD		A,$A5
		CALL	$B682
		CALL	GetInputWait
		POP		HL
		LD		($B67E),HL
		LD		A,$C0
		SUB		L
		CP		$14
		JR		NC,$762E
L765B:	EXX
		LD		HL,$BF20
		LD		A,$FF
		LD		B,$09
L7663:	CP		(HL)
		INC		HL
		JR		NZ,$766E
		DJNZ	$7663
		EXX
		LD		A,$1E
		JR		$7638
L766E:	POP		HL
		LD		BC,$0008
		LD		A,$09
		LD		DE,$BF20
L7677:	EX		AF,AF'
		LD		A,(DE)
		LD		(HL),A
		INC		DE
		ADD		HL,BC
		EX		AF,AF'
		DEC		A
		JR		NZ,$7677
		JP		GetInputWait
L7683:	PUSH	AF
		LD		A,$82
		CALL	$B682
		POP		AF
		JP		$B682
L768D:	DEFB $00
L768E:	PUSH	DE
		PUSH	BC
		PUSH	HL
		LD		A,($768D)
		CALL	$769E
		POP		HL
		POP		BC
		POP		DE
		RET
L769B:	LD		($768D),A
L769E:	PUSH	AF
		LD		HL,$F944
		LD		BC,$0094
		CALL	FillZero
		XOR		A
		LD		($9EE1),A
		DEC		A
		LD		($9D83),A
		POP		AF
		AND		A
		RET		Z
		LD		DE,$F9D7
		PUSH	AF
		CALL	$76D5
L76BA:	POP		AF
		SUB		$06
		JR		Z,$76C5
		PUSH	AF
		CALL	$76CD
		JR		$76BA
L76C5:	LD		HL,$F91B
		LD		BC,$0024
		JR		$76DB
L76CD:	LD		HL,$F933
		LD		BC,$0018
		JR		$76DB
L76D5:	LD		HL,$F943
		LD		BC,$0010
L76DB:	LDDR
		RET
L76DE:	DEFB $E0,$76,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L76EE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$00,$00,$00
L76FE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$27,$26,$17,$15,$05,$04,$36
L770E:	DEFB $34,$00,$00
FloorCode:	DEFB $00
	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L771E:	DEFB $00,$00,$00,$00,$00,$00,$08,$08,$48,$48,$08,$10,$48,$40,$08,$18
L772E:	DEFB $48,$38,$08,$20,$48,$30,$10,$08,$40,$48,$18,$08,$38,$48,$20,$08
L773E:	DEFB $30,$48,$10,$10,$40,$40,$00,$00,$00,$00,$00,$00,$00,$00,$C0
L774D:	LD		A,$FF
		LD		($7713),A
L7752:	LD		IY,$7718
		LD		HL,$40C0
		LD		($A052),HL
		LD		HL,$00FF
		LD		($A054),HL
		LD		HL,$C0C0
		LD		($7748),HL
		LD		($774A),HL
		LD		HL,$0000
		LD		BC,($703B)
		CALL	$780E
		XOR		A
		LD		($7713),A
		LD		($774C),A
		LD		HL,($AF78)
		LD		($AF92),HL
		LD		A,($7710)
		LD		($770F),A
		LD		DE,$7744
		LD		HL,$7748
		LD		BC,$0004
		LDIR
		LD		HL,$BA00
		LD		BC,$0040
		CALL	FillZero
		CALL	$A260
		CALL	$7A2E
		LD		A,$00
		RLA
		LD		($7712),A
		CALL	$84CB
		LD		HL,($7716)
		PUSH	HL
		LD		A,L
		AND		$08
		JR		Z,$77D0
		LD		A,$01
		CALL	$AF96
		LD		BC,($703B)
		LD		A,B
		INC		A
		XOR		B
		AND		$0F
		XOR		B
		LD		B,A
		LD		A,($771B)
		LD		H,A
		LD		L,$00
		CALL	$780E
		CALL	$A260
L77D0:	LD		IY,$7720
		POP		HL
		PUSH	HL
		LD		A,L
		AND		$04
		JR		Z,$77F8
		LD		A,$02
		CALL	$AF96
		LD		BC,($703B)
		LD		A,B
		ADD		A,$10
		XOR		B
		AND		$F0
		XOR		B
		LD		B,A
		LD		A,($771A)
		LD		L,A
		LD		H,$00
		CALL	$780E
		CALL	$A260
L77F8:	LD		A,($774C)
		LD		HL,($7705)
		PUSH	AF
		CALL	$81DC
		POP		AF
		CALL	$769B
		POP		HL
		LD		($7716),HL
		XOR		A
		JP		$AF96
L780E:	LD		($76E0),HL
		XOR		A
		LD		($76E2),A
		PUSH	BC
		CALL	$7A45
		LD		B,$03
		CALL	$A242
		LD		($7710),A
		ADD		A,A
		ADD		A,A
		ADD		A,$24
		LD		L,A
		ADC		A,$77
		SUB		L
		LD		H,A
		LD		B,$02
		LD		IX,$76E0
L7830:	LD		C,(HL)
		LD		A,(IX+$00)
		AND		A
		JR		Z,$7842
		SUB		C
		LD		E,A
		RRA
		RRA
		RRA
		AND		$1F
		LD		(IX+$00),A
		LD		A,E
L7842:	ADD		A,C
		LD		(IY+$00),A
		INC		HL
		INC		IX
		INC		IY
		DJNZ	$7830
		LD		B,$02
L784F:	LD		A,(IX-$02)
		ADD		A,A
		ADD		A,A
		ADD		A,A
		ADD		A,(HL)
		LD		(IY+$00),A
		INC		IY
		INC		IX
		INC		HL
		DJNZ	$784F
		LD		B,$03
		CALL	$A242
		LD		($7714),A
		LD		B,$03
		CALL	$A242
		LD		($7715),A
		CALL	$7934
		LD		B,$03
		CALL	$A242
		LD	(FloorCode),A
		CALL	SetFloorAddr
L787E:	CALL	$78D4
		JR		NC,$787E
		POP		BC
		JP		$8778
L7887:	BIT		2,A
		JR		Z,$788D
		OR		$F8
L788D:	ADD		A,(HL)
		RET
L788F:	EX		AF,AF'
		CALL	$7AF3
		LD		HL,($76DE)
		PUSH	AF
		LD		A,B
		CALL	$7887
		LD		B,A
		INC		HL
		LD		A,C
		CALL	$7887
		LD		C,A
		INC		HL
		POP		AF
		SUB		$07
		ADD		A,(HL)
		INC		HL
		LD		($76DE),HL
		LD		(HL),B
		INC		HL
		LD		(HL),C
		INC		HL
		LD		(HL),A
		LD		A,($7703)
		LD		HL,($7701)
		PUSH	AF
		PUSH	HL
		CALL	$7A1C
		LD		($7701),HL
L78BE:	CALL	$78D4
		JR		NC,$78BE
		LD		HL,($76DE)
		DEC		HL
		DEC		HL
		DEC		HL
		LD		($76DE),HL
		POP		HL
		POP		AF
		LD		($7701),HL
		LD		($7703),A
L78D4:	LD		B,$08
		CALL	$A242
		CP		$FF
		SCF
		RET		Z
		CP		$C0
		JR		NC,$788F
		PUSH	IY
		LD		IY,$76EE
		CALL	$8232
		POP		IY
		LD		B,$02
		CALL	$A242
		BIT		1,A
		JR		NZ,$78F9
		LD		A,$01
		JR		$7903
L78F9:	PUSH	AF
		LD		B,$01
		CALL	$A242
		POP		BC
		RLCA
		RLCA
		OR		B
L7903:	LD		($7700),A
L7906:	CALL	$7A8D
		CALL	$7AC1
		LD		A,($7700)
		RRA
		JR		NC,$791D
		LD		A,($7704)
		INC		A
		AND		A
		RET		Z
		CALL	$7922
		JR		$7906
L791D:	CALL	$7922
		AND		A
		RET
L7922:	LD		HL,$76EE
		LD		BC,$0012
		PUSH	IY
		LD		A,($7713)
		AND		A
		CALL	Z,$AFC6
		POP		IY
		RET
L7934:	LD		B,$03
		CALL	$A242
		CALL	$7358
		ADD		A,A
		LD		L,A
		LD		H,A
		INC		H
		LD		($7705),HL
		LD		IX,$7707
		LD		HL,$7748
		EXX
		LD		A,(IY-$01)
		ADD		A,$04
		CALL	$79B1
		LD		HL,$7749
		EXX
		LD		A,(IY-$02)
		ADD		A,$04
		CALL	$79A5
		LD		HL,$774A
		EXX
		LD		A,(IY-$03)
		SUB		$04
		CALL	$79B1
		LD		HL,$774B
		EXX
		LD		A,(IY-$04)
		SUB		$04
		JP		$79A5
L7977:	LD		B,$03
		CALL	$A242
		LD		HL,$7716
		SUB		$02
		JR		C,$799A
		RL		(HL)
		INC		HL
		SCF
		RL		(HL)
		SUB		$07
		NEG
		LD		C,A
		ADD		A,A
		ADD		A,C
		ADD		A,A
		ADD		A,$96
		LD		($76F5),A
		SCF
		EXX
		LD		(HL),A
		RET
L799A:	CP		$FF
		CCF
		RL		(HL)
		AND		A
		INC		HL
		RL		(HL)
		AND		A
		RET
L79A5:	LD		($76F3),A
		LD		HL,$76F4
		LD		A,($76E1)
		JP		$79BA
L79B1:	LD		($76F4),A
		LD		HL,$76F3
		LD		A,($76E0)
L79BA:	ADD		A,A
		ADD		A,A
		ADD		A,A
		PUSH	AF
		ADD		A,$24
		LD		(HL),A
		PUSH	HL
		CALL	$7977
		JR		NC,$7A15
		LD		A,(IX+$00)
		LD		($76F2),A
		INC		IX
		LD		A,($7705)
		LD		($76F6),A
		CALL	$79EB
		LD		A,(IX+$00)
		LD		($76F2),A
		INC		IX
		LD		A,($7706)
		LD		($76F6),A
		POP		HL
		POP		AF
		ADD		A,$2C
		LD		(HL),A
L79EB:	CALL	$7922
		LD		A,($76F2)
		LD		C,A
		AND		$30
		RET		PO
		AND		$10
		OR		$01
		LD		($76F2),A
		LD		A,($76F5)
		CP		$C0
		RET		Z
		PUSH	AF
		ADD		A,$06
		LD		($76F5),A
		LD		A,$54
		LD		($76F6),A
		CALL	$7922
		POP		AF
		LD		($76F5),A
		RET
L7A15:	POP		HL
		POP		AF
		INC		IX
		INC		IX
		RET
L7A1C:	LD		A,$80
		LD		($7703),A
		LD		HL,$5B00
		EX		AF,AF'
		LD		D,$00
L7A27:	LD		E,(HL)
		INC		HL
		CP		(HL)
		RET		Z
		ADD		HL,DE
		JR		$7A27
L7A2E:	LD		BC,($703B)
		LD		A,C
		DEC		A
		AND		$F0
		LD		C,A
		CALL	$7A4E
		RET		C
		INC		DE
		INC		DE
		INC		DE
		LD		A,(DE)
		OR		$F1
		INC		A
		RET		Z
		SCF
		RET
L7A45:	CALL	$7A4E
		EXX
		LD		A,C
		OR		(HL)
		LD		(HL),A
		EXX
		RET
L7A4E:	LD		D,$00
		LD		HL,$5C71
		CALL	$7A5C
		RET		NC
		LD		HL,$6B16
		JR		$7A63
L7A5C:	EXX
		LD		HL,$8AE2
		LD		C,$01
		EXX
L7A63:	LD		E,(HL)
		INC		E
		DEC		E
		SCF
		RET		Z
		INC		HL
		LD		A,B
		CP		(HL)
		JR		Z,$7A77
L7A6D:	ADD		HL,DE
		EXX
		RLC		C
		JR		NC,$7A74
		INC		HL
L7A74:	EXX
		JR		$7A63
L7A77:	INC		HL
		DEC		E
		LD		A,(HL)
		AND		$F0
		CP		C
		JR		NZ,$7A6D
		DEC		HL
		LD		($7701),HL
		LD		A,$80
		LD		($7703),A
		LD		B,$04
		JP		$A242
L7A8D:	LD		A,($7700)
		RRA
		RRA
		JR		C,$7A99
		LD		B,$01
		CALL	$A242
L7A99:	AND		$01
		RLCA
		RLCA
		RLCA
		RLCA
		AND		$10
		LD		C,A
		LD		A,($76ED)
		XOR		C
		LD		($76F2),A
		LD		BC,($76EC)
		BIT		4,A
		JR		Z,$7ABC
		BIT		1,A
		JR		Z,$7ABA
		XOR		$01
		LD		($76F2),A
L7ABA:	DEC		C
		DEC		C
L7ABC:	LD		A,C
		LD		($76FE),A
		RET
L7AC1:	CALL	$7AF3
L7AC4:	EX		AF,AF'
		LD		HL,($76DE)
		LD		DE,$76F3
L7ACB:	LD		A,B
		CALL	$7AEB
		LD		(DE),A
		LD		A,C
		CALL	$7AEB
		INC		DE
		LD		(DE),A
		EX		AF,AF'
		PUSH	AF
		ADD		A,(HL)
		LD		L,A
		ADD		A,A
		ADD		A,L
		ADD		A,A
		ADD		A,$96
		INC		DE
		LD		(DE),A
		POP		AF
		CPL
		AND		C
		AND		B
		OR		$F8
		LD		($7704),A
		RET
L7AEB:	ADD		A,(HL)
		INC		HL
		RLCA
		RLCA
		RLCA
		ADD		A,$0C
		RET
L7AF3:	LD		B,$03
		CALL	$A242
		PUSH	AF
		LD		B,$03
		CALL	$A242
		PUSH	AF
		LD		B,$03
		CALL	$A242
		POP		HL
		POP		BC
		LD		C,H
		RET
	
InitStuff:	CALL	IrqInstall
		JP	InitRevTbl
	
L7B0E:	XOR		A
		LD		($866B),A
		LD		($B218),A
		LD		($8A15),A
		LD		A,$18
		LD		($A2C8),A
		LD		A,$1F
		LD		($A2DA),A
		CALL	$8C47
		CALL	$7C76
		ADD		A,C
		AND		D
		CALL	$87D1
		LD		HL,$8940
		LD		($703B),HL
		LD		A,$01
		CALL	$7B43
		LD		HL,$8A40
		LD		($703B),HL
		XOR		A
		LD		($B218),A
		RET
L7B43:	LD		($A294),A
		PUSH	AF
		LD		($FB28),A
		CALL	$7BBF
		XOR		A
		LD		($A297),A
		CALL	$A958
		JR		$7B59
L7B56:	CALL	$A361
L7B59:	LD		A,($A2BC)
		AND		A
		JR		NZ,$7B56
		POP		AF
		XOR		$03
		LD		($A294),A
		CALL	$A58B
		JP		$72A0
L7B6B:	CALL	$7C76
		ADD		A,C
		AND		D
		LD		A,$08
		CALL	UpdateAttribs
		JP		$8906
L7B78:	CALL	$774D
		CALL	$7C76
		SBC		A,D
		AND		D
		CALL	$7255
		CALL	$7C1A
		CALL	$7395
		XOR		A
		LD		($A295),A
		JR		$7BB3
L7B8F:	DEFB $00,$00
L7B91:	CALL	$7BBF
		LD		A,($7CF8)
		AND		A
		JR		NZ,$7BAD
		LD		A,($7715)
		CP		$07
		JR		NZ,$7BA4
		LD		A,($7B90)
L7BA4:	LD		($7B90),A
		OR		$40
		LD		B,A
		CALL	PlaySound
L7BAD:	CALL	$7395
		CALL	$A958
L7BB3:	LD		A,($7714)
		CALL	UpdateAttribs
		CALL	$89D2
		JP		$8E1D
L7BBF:	CALL	$7C76
		LD		E,E
		XOR		A
		CALL	$7C76
		SBC		A,D
		AND		D
		LD		A,($A294)
		CP		$03
		JR		NZ,$7BDC
		LD		HL,$FB28
		SET		0,(HL)
		CALL	$7752
		LD		A,$01
		JR		$7C14
L7BDC:	CALL	$728C
		JR		NZ,$7C10
		CALL	$72A3
		CALL	$774D
		LD		HL,$A2C0
		CALL	$B104
		EXX
		LD		HL,$A2D2
		CALL	$B104
		CALL	$ACD6
		JR		NC,$7C0C
		LD		A,($A294)
		RRA
		JR		C,$7C00
		EXX
L7C00:	LD		A,B
		ADD		A,$05
		EXX
		CP		B
		JR		C,$7C0C
		LD		A,$FF
		LD		($7B8F),A
L7C0C:	LD		A,$01
		JR		$7C14
L7C10:	CALL	$7752
		XOR		A
L7C14:	LD		($A295),A
		JP		$7C1A
L7C1A:	LD		HL,($7718)
		LD		A,($7717)
		PUSH	AF
		BIT		1,A
		JR		Z,$7C29
		DEC		H
		DEC		H
		DEC		H
		DEC		H
L7C29:	RRA
		LD		A,L
		JR		NC,$7C30
		SUB		$04
		LD		L,A
L7C30:	SUB		H
		ADD		A,$80
		LD		($9C8C),A
		LD		C,A
		LD		A,$FC
		SUB		H
		SUB		L
		LD		B,A
		NEG
		LD		E,A
		ADD		A,C
		LD		($9CA0),A
		LD		A,C
		NEG
		ADD		A,E
		LD		($9C98),A
		CALL	$9D45
		POP		AF
		RRA
		PUSH	AF
		CALL	NC,$7C6B
		POP		AF
		RRA
		RET		C
		LD		HL,$BA3E
L7C59:	LD		A,(HL)
		AND		A
		JR		NZ,$7C61
		DEC		HL
		DEC		HL
		JR		$7C59
L7C61:	INC		HL
		LD		A,(HL)
		OR		$FA
		INC		A
		RET		NZ
		LD		(HL),A
		DEC		HL
		LD		(HL),A
		RET
L7C6B:	LD		HL,$BA00
L7C6E:	LD		A,(HL)
		AND		A
		JR		NZ,$7C61
		INC		HL
		INC		HL
		JR		$7C6E
L7C76:	POP		HL
		LD		E,(HL)
		INC		HL
		LD		D,(HL)
		INC		HL
		PUSH	HL
		EX		DE,HL
		LD		C,(HL)
		LD		B,$00
		INC		HL
		LD		D,H
		LD		E,L
		ADD		HL,BC
		EX		DE,HL
		LDIR
		RET
L7C88:	DEFB $00,$00,$1E,$60,$60,$98,$8C,$60,$2F,$60,$48,$AF,$8C,$48
L7C96:	LD		A,$99
		CALL	$B682
		LD		IX,$7CD4
		LD		(IX+$00),$00
		CALL	$7CCC
		CALL	$7E2E
L7CA9:	CALL	$8D18
		CALL	$7E11
		JR		C,$7CA9
		LD		A,(IX+$00)
		CP		$01
		JP		C,$7D68
		JR		NZ,$7CC0
		CALL	$7CFD
		JR		$7C96
L7CC0:	CP		$03
		LD		HL,$7C96
		PUSH	HL
		JP		Z,$7D4C
		JP		$7CD9
L7CCC:	LD		E,$03
		LD		HL,$7C8A
		JP		$8E30
L7CD4:	DEFB $00,$04,$05,$89,$9A
L7CD9:	LD		A,$A9
		CALL	$B682
		LD		IX,$7CF8
		CALL	$7E2E
L7CE5:	CALL	$7E11
		JR		C,$7CE5
		LD		A,($7CF8)
		CP		$02
		LD		HL,$964E
		SET		7,(HL)
		RET		NZ
		RES		7,(HL)
		RET
L7CF8:	DEFB $00,$03,$07,$08,$96
L7CFD:	LD		A,$A6
		CALL	$B682
		LD		IX,$7D47
		CALL	$7E2E
		LD		B,$08
L7D0B:	PUSH	BC
		LD		A,B
		DEC		A
		CALL	$7DF0
		POP		BC
		PUSH	BC
		LD		A,B
		DEC		A
		CALL	$75ED
		POP		BC
		DJNZ	$7D0B
L7D1B:	CALL	$7E06
		JR		C,$7D1B
		RET		NZ
		LD		A,$A8
		CALL	$B682
		LD		A,(IX+$00)
		ADD		A,(IX+$04)
		CALL	$B682
		LD		A,$02
		CALL	$B682
		LD		A,(IX+$00)
		CALL	$7DF0
		LD		A,(IX+$00)
		CALL	$761C
		LD		A,$A7
		CALL	$B682
		JR		$7D1B
L7D47:	DEFB $00,$08,$00,$85,$8E
L7D4C:	LD		A,$AA
		CALL	$B682
		LD		IX,$7D63
		CALL	$7E2E
L7D58:	CALL	$7E11
		JR		C,$7D58
		LD		A,(IX+$00)
		JP		$7132
L7D63:	DEFB $01,$02,$05,$09,$9E
L7D68:	LD		A,($8A15)
		CP		$01
		RET		C
		LD		A,$AB
		CALL	$B682
		LD		IX,$7D8D
		LD		(IX+$00),$00
		CALL	$7E2E
L7D7E:	CALL	$7E11
		JR		C,$7D7E
		LD		A,(IX+$00)
		CP		$02
		JP		Z,$7C96
		RRA
		RET
L7D8D:	DEFB $00,$03,$09,$09,$A0
	
L7D92:		CALL	$964F
		CALL	ScreenWipe
		LD		A,$BA
		CALL	$B682
		CALL	$7CCC
		CALL	$8C50
		PUSH	HL
		LD		A,($866B)
		OR		$E0
		INC		A
		LD		A,$C4
		JR		Z,$7DBB
		LD		A,H
		ADD		A,$10
		JR		NC,$7DB4
		LD		A,H
L7DB4:	RLCA
		RLCA
		RLCA
		AND		$07
		ADD		A,$BF
L7DBB:	CALL	$B682
		LD		A,$BB
		CALL	$B682
		CALL	$8C1F
		CALL	$B773
		LD		A,$BC
		CALL	$B682
		POP		DE
		CALL	$B773
		LD		A,$BD
		CALL	$B682
		CALL	$8C1A
		LD		A,E
		CALL	$B784
		LD		A,$BE
		CALL	$B682
L7DE3:	CALL	$964F
		CALL	$75D1
		JR		C,$7DE3
		LD		B,$C0
		JP		PlaySound
L7DF0:	ADD		A,A
		ADD		A,(IX+$03)
		AND		$7F
		LD		B,A
		LD		C,$0B
		PUSH	BC
		CALL	$B73C
		LD		A,$02
		CALL	$B682
		POP		BC
		JP		$B73C
L7E06:	CALL	$75D1
		RET		C
		LD		A,C
		CP		$01
		JR		NZ,$7E16
		AND		A
		RET
	
L7E11:	CALL	$75D1
		RET		C
		LD		A,C
L7E16:		AND		A
		RET		Z
		LD		A,(IX+$00)
		INC		A
		CP		A,(IX+$01)
		JR		C,$7E22
		XOR		A
L7E22:	LD	(IX+$00),A
		PUSH	IX
		LD	B,$88
		CALL	PlaySound
		POP	IX
L7E2E:		LD	B,(IX+$03)
		RES	7,B
		LD	C,(IX+$02)
		LD	($7C88),BC
		CALL	$B73C
		LD	B,(IX+$01)
		LD	C,(IX+$00)
		INC	C
L7E44:		LD	A,$AF
		DEC	C
		PUSH	BC
		JR	NZ,$7E60
		BIT	7,(IX+$03)
		JR	NZ,$7E59
		LD	A,$04
		CALL	$B682
		LD	A,$AE
		JR	$7E60
L7E59:		LD		A,$03
		CALL	$B682
		LD		A,$AE
L7E60:	CALL	$B682
		LD		A,(IX+$01)
		POP		BC
		PUSH	BC
		SUB		B
		ADD		A,(IX+$04)
		CALL	$B682
		POP		HL
		PUSH	HL
		LD		BC,($7C88)
		LD		A,L
		AND		A
		JR		NZ,$7E80
		BIT		7,(IX+$03)
		JR		NZ,$7E80
		INC		B
L7E80:	INC		B
		PUSH	BC
		CALL	$B73C
		LD		A,$03
		CALL	$B682
		BIT		7,(IX+$03)
		JR		NZ,$7E95
		LD		A,$02
		CALL	$B682
L7E95:	POP		BC
		INC		B
		LD		($7C88),BC
		CALL	$B73C
		POP		BC
		DJNZ	$7E44
		SCF
		RET
L7EA3:	DEFB $FF
	DEFM "PLAY"
        DEFB $FF,$05,$01,$FF,$05,$02,$FF,$05,$03,$FF
	DEFM " THE ", $FF
	DEFM "GAME", $FF
	DEFM "SELECT", $FF
	DEFM "KEY", $FF
	DEFM "ANY ", $87,$FF
	DEFM "SENSITIVITY", $FF,$82
	DEFM "PRESS ", $FF,$82
	DEFM " TO ", $FF,$83,$E0,$FF,$83
	DEFM "SHIFT", $FF
	DEFM "LEFT", $FF
	DEFM "RIGHT", $FF
	DEFM "DOWN", $FF
	DEFM "UP", $FF
	DEFM "JUMP",$FF
	DEFM "CARRY", $FF
	DEFM "FIRE", $FF
	DEFM "SWOP", $FF
	DEFM "LOTS OF IT", $FF
	DEFM "NOT SO MUCH", $FF
	DEFM "PARDON",$FF
	DEFM $00,$C5,$A3,$FF,$80,$84,$85,$FF,$86,$84,$87,$53,$FF
	DEFM "ADJUST", $84, "SOUND", $FF
	DEFM "CONTROL ", $89,$FF
	DEFM "HIGH ",$89,$FF
	DEFM "LOW ", $89,$FF
	DEFM "OLD ",$85,$FF
	DEFM "NEW ",$85,$FF
	DEFM "MAIN MENU", $FF,$B9,$02,$15,$8A
	DEFB $83,$88,$8B, "MOVE CURSOR",$06,$01
	DEFB $17,$20,$8A,$8C,$8B,$86," OPTION", $02,$FF,$06
	DEFB $05,$03,$8A,$8D,$8B,$C8,$02,$FF,$06,$05,$03,$8A,$8C,$8B,$C8,$02
	DEFB $FF,$B0,$08,$00,$81,$9B,$A7,$FF,$A3,$06,$05,$03,$8A,$81,$8D,$8B
	DEFB $C8,$02,$FF,$06,$05,$03,$02,$06,$01,$15,$02,$06,$01,$17,$8A,$83
	DEFB $87,$53,$82," REQUIRED FOR ",$83,$FF
	DEFM $B0,$08,$00,$82,$9C,$A3,$06,$06,$03,$05,$00
	DEFM "MUSIC BY GUY STEVENS",$FF
	DEFM $B0,$06,$00,$82,$9D,$A3,$FF,$B0,$09,$00,$82,$9A,$A3
	DEFB $FF,$04,$82,$06,$03,$03,$8A,$83,$8D,$8B,$C8,$20,$85,$06,$04,$06
	DEFB $8A,$83,$88,$8B,"RESTART",$FF,"   ",$FF
	DEFB $83,$21,$22,$AD,$FF,$03,$81,$23,$24,$AD,$FF,$00,$07,$09,$04,$06
	DEFB $FF,$B9,$05,$14,$FF,$B9,$19,$14,$FF,$B9,$19,$17,$FF,$B9,$05,$17
	DEFB $FF,$04,$06,$12,$16,$FF,$04,$06,$0C,$16,$FF,$B9,$01,$11,$FF,$03
	DEFB $82,$06,$1A,$13,$26,$06,$1A,$16,$82,$27,$06,$06,$13,$82,$25,$06
	DEFB $06,$16,$82,$27,$FF,$03,$06,$FF,$C5,$06,$0A,$08,$82,$04,$05,$00
	DEFB $FF,$B9,$06,$11,$81,"EXPLORED ",$FF," ROOMS"
	DEFB $06,$09,$0E,$82,"SCORE ",$FF
	DEFB "0",$06,$05,$14,$83,"LIBERATED ",$FF
	DEFB " PLANETS",$FF,"  DUMMY"
	DEFB $FF,"  NOVICE",$FF,"   SPY    ",$FF,"MASTER SPY",$FF
	DEFB "   HERO",$FF," EMPEROR"
	DEFB $FF,$07,$0A,$04,$06,$08,$00,$82,"HEAD      HEELS",$B9,$0C,$01,$05,$00
	DEFM " OVER ",$06,$01,$00," JON",$06,$01,$02,"RITMAN"
	DEFB $06,$19,$00,"BERNIE",$06,$18,$02,"DRUMMOND"
	DEFB $FF,$00,$07,$06,$06,$05,$00,$04,$83,$84
	DEFB $C7," EMPIRE",$03,$06,$03,$09,$81,"EGYPTUS"
	DEFB $06,$15,$17,"BOOK WORLD"
	DEFB $06,$03,$17,"SAFARI",$06,$14,$09,"PENITENTIARY"
	DEFB $06,$0B,$10,$C7,$FF,"BLACKTOOTH"
	DEFB $FF,"FINISH",$FF
	DEFB $B6,$05,$00,"FREEDOM ",$FF,$00,$07,$06,$B9
	DEFB $00,$0A,$82,$84,"PEOPLE SALUTE YOUR HEROISM",$06,$08
	DEFB $0C,"AND PROCLAIM YOU",$04,$06,$0B,$10,$05,$00,$C4,$FF
L81DC:	PUSH	AF
		LD		A,L
		LD		H,$00
		LD		(SpriteCode),A
		CALL	Sprite3x56
		EX		DE,HL
		LD		DE,$F9D8
		PUSH	DE
		LD		BC,$0150
		LDIR
		POP		HL
		POP		AF
		ADD		A,A
		ADD		A,$08
		CP		$39
		JR		C,$81FB
		LD		A,$38
L81FB:	LD		B,A
		ADD		A,A
		ADD		A,B
		LD		E,A
		LD		D,$00
		ADD		HL,DE
		EX		DE,HL
		LD		HL,$00A8
		ADD		HL,DE
		LD		A,B
		NEG
		ADD		A,$39
		LD		B,A
		LD		C,$FC
		JR		$8224
L8211:	LD		A,(DE)
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
L8224:	DJNZ	$8211
		XOR		A
		LD		($AF5A),A
		RET
L822B:	DEFB $00,$00,$FF,$00,$3D,$8E,$3D
L8232:	LD		(IY+$09),$00
		LD		L,A
		LD		E,A
		LD		D,$00
		LD		H,D
		ADD		HL,HL
		ADD		HL,DE
		LD		DE,$8406
		ADD		HL,DE
		LD		B,(HL)
		INC		HL
		LD		A,(HL)
		AND		$3F
		LD		(IY+$0A),A
		LD		A,(HL)
		INC		HL
		RLCA
		RLCA
		AND		$03
		JR		Z,$8264
		ADD		A,$2E
		LD		E,A
		ADC		A,$82
		SUB		E
		LD		D,A
		LD		A,(DE)
		SET		5,(IY+$09)
		BIT		2,(HL)
		JR		Z,$8264
		LD		C,B
		LD		B,A
		LD		A,C
L8264:	LD		($822E),A
		LD		A,B
		CALL	$828B
		LD		A,(HL)
		OR		$9F
		INC		A
		LD		A,(HL)
		JR		NZ,$8278
		SET		7,(IY+$09)
		AND		$BF
L8278:	AND		$FB
		CP		$80
		RES		7,A
		LD		(IY-$01),A
		LD		(IY-$02),$02
		RET		C
		SET		4,(IY+$09)
		RET
L828B:	LD		(IY+$0F),$00
		LD		(IY+$08),A
		CP		$80
		RET		C
		ADD		A,A
		ADD		A,A
		ADD		A,A
		LD		(IY+$0F),A
		PUSH	HL
		CALL	$82E8
		POP		HL
		RET
L82A1:	LD		($822B),DE
		PUSH	DE
		POP		IY
		DEC		A
		ADD		A,A
		ADD		A,$BC
		LD		L,A
		ADC		A,$83
		SUB		L
		LD		H,A
		LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		XOR		A
		LD		($8ED8),A
		LD		A,(IY+$0B)
		LD		($822D),A
		LD		(IY+$0B),$FF
		BIT		6,(IY+$09)
		RET		NZ
		JP		(HL)
L82C9:	BIT		5,(IY+$09)
		JR		Z,$82E8
		CALL	$82E8
		EX		AF,AF'
		LD		C,(IY+$10)
		LD		DE,$0012
		PUSH	IY
		ADD		IY,DE
		CALL	$938D
		CALL	$82E8
		POP		IY
		RET		C
		EX		AF,AF'
		RET
L82E8:	LD		C,(IY+$0F)
		LD		A,C
		AND		$F8
		CP		$08
		CCF
		RET		NC
		RRCA
		RRCA
		SUB		$02
		ADD		A,$30
		LD		L,A
		ADC		A,$83
		SUB		L
		LD		H,A
		LD		A,C
		INC		A
		AND		$07
		LD		B,A
		ADD		A,(HL)
		LD		E,A
		INC		HL
		ADC		A,(HL)
		SUB		E
		LD		D,A
		LD		A,(DE)
		AND		A
		JR		NZ,$8313
		LD		B,$00
		LD		A,(HL)
		DEC		HL
		LD		L,(HL)
		LD		H,A
		LD		A,(HL)
L8313:	LD		(IY+$08),A
		LD		A,B
		XOR		C
		AND		$07
		XOR		C
		LD		(IY+$0F),A
		AND		$F0
		CP		$80
		LD		C,$02
		JR		Z,$832A
		CP		$90
		LD		C,$01
L832A:	LD		A,C
		CALL	Z,$A92C
		SCF
		RET
L8330:	DEFB $6E,$83,$73,$83,$75,$83,$77,$83,$77,$83,$7C,$83,$7C,$83,$81,$83
L8340:	DEFB $81,$83,$84,$83,$84,$83,$8A,$83,$8F,$83,$94,$83,$94,$83,$9B,$83
L8350:	DEFB $9D,$83,$9F,$83,$9F,$83,$A4,$83,$A4,$83,$A7,$83,$A9,$83,$AB,$83
L8360:	DEFB $AD,$83,$AF,$83,$B1,$83,$B3,$83,$B5,$83,$B7,$83,$B7,$83,$A4,$24
L8370:	DEFB $25,$26,$00,$10,$00,$11,$00,$24,$25,$25,$24,$00,$2D,$2D,$2E,$2E
L8380:	DEFB $00,$57,$D7,$00,$2B,$2B,$2C,$2B,$2C,$00,$32,$32,$33,$33,$00,$34
L8390:	DEFB $34,$35,$35,$00,$26,$25,$26,$A6,$A5,$A6,$00,$36,$00,$37,$00,$38
L83A0:	DEFB $39,$B9,$B8,$00,$3A,$BA,$00,$3B,$00,$3C,$00,$3E,$00,$3F,$00,$40
L83B0:	DEFB $00,$41,$00,$42,$00,$43,$00,$44,$45,$C5,$C4,$00,$CC,$90,$36,$90
L83C0:	DEFB $3A,$90,$3E,$90,$42,$90,$E3,$90,$E8,$90,$ED,$90,$01,$91,$76,$8F
L83D0:	DEFB $F2,$90,$F7,$90,$FC,$90,$C6,$8F,$06,$91,$72,$91,$70,$90,$21,$90
L83E0:	DEFB $2B,$90,$56,$90,$DD,$90,$D7,$90,$1E,$90,$53,$90,$66,$8F,$BF,$90
L83F0:	DEFB $08,$8F,$88,$90,$EB,$8E,$DB,$8E,$4C,$90,$4E,$8F,$26,$92,$82,$90
L8400:	DEFB $2F,$8F,$19,$8F,$0B,$91,$88,$1B,$01,$2B,$1C,$40,$31,$00,$02,$4A
L8410:	DEFB $01,$40,$9E,$17,$00,$5D,$00,$01,$56,$02,$11,$56,$03,$11,$56,$04
L8420:	DEFB $01,$56,$05,$01,$46,$01,$40,$4B,$01,$40,$90,$8F,$6C,$4C,$0A,$00
L8430:	DEFB $58,$00,$21,$5E,$00,$21,$30,$0E,$00,$94,$09,$60,$96,$4F,$6C,$9A
L8440:	DEFB $DD,$0C,$49,$1E,$00,$5A,$01,$01,$5F,$00,$01,$5F,$14,$01,$48,$00
L8450:	DEFB $00,$92,$0B,$60,$31,$18,$02,$82,$06,$68,$84,$CC,$6C,$47,$0A,$20
L8460:	DEFB $5C,$1F,$01,$55,$15,$01,$96,$CD,$6C,$5B,$00,$21,$5D,$14,$01,$59
L8470:	DEFB $14,$01,$59,$00,$01,$3D,$20,$60,$92,$21,$60,$9E,$12,$00,$55,$01
L8480:	DEFB $01,$5F,$13,$01,$8C,$07,$60,$5A,$16,$01,$5D,$08,$01,$55,$23,$01
L8490:	DEFB $9C,$CD,$6C,$42,$00,$20,$47,$0A,$00,$2D,$00,$20,$56,$14,$01,$5D
L84A0:	DEFB $0A,$01,$5D,$01,$01,$98,$4F,$6C,$98,$CD,$6C,$82,$08,$68,$36,$00
L84B0:	DEFB $20,$37,$00,$20,$1E,$00,$00,$18,$00,$00,$4C,$24,$00,$4C,$A5,$2C
L84C0:	DEFB $84,$21,$60
PanelBase:	DEFB $00,$00
	DEFB $00,$00,$00,$00,$00,$00
L84CB:	CALL	$8603
		LD		A,C
		SUB		$06
		LD		C,A
		ADD		A,B
		RRA
		LD		($84C7),A
		LD		A,B
		NEG
		ADD		A,C
		RRA
		LD		($84C8),A
		LD		A,B
		LD		($84C9),A
		RET
L84E4:	LD		($84CA),A
		CALL	$8506
		LD		A,($7716)
		AND		$04
		RET		NZ
		LD		B,$04
		EXX
		LD		A,$80
		LD		($8592),A
		CALL	$8603
		LD		DE,$0002
		LD		A,(IY-$01)
		SUB		(IY-$03)
		JR		$8521
L8506:	LD		A,($7716)
		AND		$08
		RET		NZ
		LD		B,$08
		EXX
		XOR		A
		LD		($8592),A
		CALL	$8603
		DEC		L
		DEC		L
		LD		DE,$FFFE
		LD		A,(IY-$02)
		SUB		(IY-$04)
L8521:	RRA
		RRA
		RRA
		RRA
		AND		$0F
		PUSH	HL
		POP		IX
		EXX
		LD		C,A
		LD		A,($7717)
		AND		B
		CP		$01
		EX		AF,AF'
		LD		A,($7715)
		LD		B,A
		ADD		A,$38
		LD		L,A
		ADC		A,$C0
		SUB		L
		LD		H,A
		LD		($84C5),HL
		LD		A,B
		ADD		A,A
		LD		B,A
		ADD		A,A
		ADD		A,A
		ADD		A,$2A
		LD		L,A
		ADC		A,$86
		SUB		L
		LD		H,A
		LD		($7701),HL
		LD		A,$80
		LD		($7703),A
		LD		A,$1B
		ADD		A,B
		LD		L,A
		ADC		A,$86
		SUB		L
		LD		H,A
		LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		LD		(PanelBase),HL
		LD		A,$FF
		EX		AF,AF'
		LD		A,C
		PUSH	AF
		SUB		$04
		LD		B,$01
		JR		Z,$857B
		LD		B,$0F
		INC		A
		JR		Z,$857B
		LD		B,$19
		INC		A
		JR		Z,$857B
		LD		B,$1F
L857B:	POP		AF
		JR		C,$8584
		LD		A,C
		ADD		A,A
		ADD		A,B
		LD		B,A
		LD		A,C
		EX		AF,AF'
L8584:	CALL	$85FB
		DJNZ	$8584
		LD		B,C
		SLA		B
L858C:	EX		AF,AF'
		DEC		A
		JR		Z,$85C2
		EX		AF,AF'
		OR		$00
		LD		(IX+$01),A
		EXX
		LD		A,C
		ADD		A,$08
		LD		(IX+$00),C
		LD		C,A
		ADD		IX,DE
		EXX
		CALL	$85FB
L85A4:	DJNZ	$858C
		EXX
		PUSH	IX
		POP		HL
		LD		A,L
		CP		$40
		RET		NC
		LD		A,(IX+$00)
		AND		A
		RET		NZ
		LD		A,($8592)
		OR		$05
		LD		(IX+$01),A
		LD		A,C
		SUB		$10
		LD		(IX+$00),A
		RET
L85C2:	EXX
		LD		A,($84CA)
		AND		A
		LD		A,C
		JR		Z,$85CD
		ADD		A,$10
		LD		C,A
L85CD:	SUB		$10
		LD		(IX+$00),A
		LD		A,($8592)
		OR		$04
		LD		(IX+$01),A
		ADD		IX,DE
		LD		(IX+$01),A
		LD		A,C
		SUB		$08
		LD		(IX+$00),A
		ADD		A,$18
		LD		C,A
		LD		A,($84CA)
		AND		A
		JR		Z,$85F2
		LD		A,C
		SUB		$10
		LD		C,A
L85F2:	ADD		IX,DE
		LD		A,$FF
		EX		AF,AF'
		EXX
		DEC		B
		JR		$85A4
L85FB:	PUSH	BC
		LD		B,$02
		CALL	$A242
		POP		BC
		RET
L8603:	LD		A,(IY-$02)
		LD		D,A
		LD		E,(IY-$01)
		SUB		E
		ADD		A,$80
		LD		B,A
		RRA
		RRA
		AND		$3E
		LD		L,A
		LD		H,$BA
		LD		A,$07
		SUB		E
		SUB		D
		LD		C,A
		RET
L861B:	DEFB $50,$C0,$A0,$C1,$F0,$C2,$D0,$C3,$B0,$C4,$70,$C6,$50,$C7,$A0,$C8
L862B:	DEFB $46,$91,$65,$94,$A1,$69,$69,$AA,$49,$24,$51,$49,$12,$44,$92,$A4
L863B:	DEFB $04,$10,$10,$41,$04,$00,$44,$00,$04,$10,$10,$41,$04,$00,$10,$00
L864B:	DEFB $4E,$31,$B4,$E7,$4E,$42,$E4,$99,$45,$51,$50,$51,$54,$55,$55,$55
L865B:	DEFB $64,$19,$65,$11,$A4,$41,$28,$55,$00,$00,$00,$00,$00,$00,$00,$00
L866B:	DEFB $00,$70,$14,$00,$72,$60,$30,$01,$40,$B0,$2E,$09,$34,$B0,$00,$1A
L867B:	DEFB $00,$F0,$9A,$0B,$70,$40,$A7,$1C,$44,$30,$37,$7D,$37,$70,$15,$68
L868B:	DEFB $34,$60,$89,$48,$47,$60,$C5,$68,$76,$80,$1B,$68,$76,$D0,$BC,$28
L869B:	DEFB $35,$D0,$1C,$28,$71,$F0,$87,$38,$74,$20,$FB,$28,$71,$60,$31,$48
L86AB:	DEFB $05,$C0,$E2,$38,$54,$20,$69,$68,$07,$60,$52,$62,$77,$60,$47,$72
L86BB:	DEFB $27,$C0,$E3,$42,$07,$F0,$63,$12,$70,$20,$AA,$22,$05,$30,$6C,$22
L86CB:	DEFB $46,$60,$47,$73,$57,$80,$FA,$63,$67,$F0,$70,$13,$60,$10,$7B,$73
L86DB:	DEFB $31,$60,$64,$74,$70,$80,$1A,$44,$45,$F0,$46,$74,$74,$60,$C5,$66
L86EB:	DEFB $74,$70,$98,$76,$00,$00,$32,$76,$50,$80,$29,$76,$40,$A0,$E0,$16
L86FB:	DEFB $40,$A0,$0F,$66,$47,$B0,$03,$26,$44,$F0,$83,$36,$17,$40,$8A,$06
L870B:	DEFB $06,$20,$99,$76,$14,$60,$C5,$65,$75,$60,$77,$75,$44,$00,$36,$75
L871B:	DEFB $66,$A0,$FE,$75,$22,$F0,$42,$65,$61,$20,$AE,$75,$04,$30,$8D,$7E
L872B:	DEFB $47,$30,$8D,$6E,$17,$30,$8D,$7E,$07,$30,$8D,$6E,$37,$30,$8D,$3E
L873B:	DEFB $27,$27,$28,$29,$2A,$2A,$2A,$2A,$00,$86,$2F,$2F,$2F,$2F,$2F,$2F
L874B:	LD		BC,($703B)
L874F:	LD		HL,$866C
		LD		E,$34
L8754:	LD		A,C
		CP		(HL)
		INC		HL
		JR		NZ,$875C
		LD		A,B
		CP		(HL)
		RET		Z
L875C:	INC		HL
		INC		HL
		INC		HL
		DEC		E
		JR		NZ,$8754
		DEC		E
		RET
L8764:	INC		HL
		XOR		A
		RLD
		LD		E,A
		RLD
		LD		D,A
		RLD
		INC		HL
		RLD
		LD		B,A
		RLD
		LD		C,A
		RLD
		RET
L8778:	PUSH	BC
		LD		HL,$8728
		LD		A,($866B)
		CPL
		LD		B,$05
		LD		DE,$0004
L8785:	RR		(HL)
		RRA
		RL		(HL)
		ADD		HL,DE
		DJNZ	$8785
		POP		BC
		CALL	$874F
L8791:	RET		NZ
		PUSH	HL
		PUSH	DE
		PUSH	BC
		PUSH	IY
		CALL	$8764
		LD		IY,$76EE
		LD		A,D
		CP		$0E
		LD		A,$60
		JR		NZ,$87A6
		XOR		A
L87A6:	LD		(IY+$04),A
		LD		(IY+$11),D
		LD		(IY+$0A),$1A
		LD		A,D
		ADD		A,$3C
		LD		L,A
		ADC		A,$87
		SUB		L
		LD		H,A
		LD		A,(HL)
		PUSH	BC
		PUSH	DE
		CALL	$828B
		POP		DE
		POP		BC
		POP		IY
		LD		A,E
		CALL	$7AC4
		CALL	$7922
		POP		BC
		POP		DE
		POP		HL
		CALL	$875C
		JR		$8791
L87D1:	LD		HL,$866C
		LD		DE,$0004
		LD		B,$34
L87D9:	RES		0,(HL)
		ADD		HL,DE
		DJNZ	$87D9
		RET
L87DF:	LD		D,A
		CALL	$874B
L87E3:	RET		NZ
		INC		HL
		LD		A,(HL)
		DEC		HL
		AND		$0F
		CP		D
		JR		Z,$87F1
		CALL	$875C
		JR		$87E3
L87F1:	DEC		HL
		SET		0,(HL)
		ADD		A,A
		ADD		A,$0A
		LD		L,A
		ADC		A,$88
		SUB		L
		LD		H,A
		LD		E,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,E
		LD		IX,$8805
		JP		(HL)
		LD		B,$C5
		JP		PlaySound
L880A:	LD		H,$88
		LD		H,$88
		DEC		(HL)
		ADC		A,B
		LD		B,H
		ADC		A,B
		LD		C,L
		ADC		A,B
		LD		E,C
		ADC		A,B
		LD		E,L
		ADC		A,B
		NOP
		NOP
		AND		(HL)
		ADC		A,B
		SUB		L
		ADC		A,B
		SUB		L
		ADC		A,B
		SUB		L
		ADC		A,B
		SUB		L
		ADC		A,B
		SUB		L
		ADC		A,B
		LD		A,D
L8827:	LD		HL,$A28B
		CALL	$89BA
		CALL	$8E1D
		LD		B,$C2
		JP		PlaySound
L8835:	LD		A,($A294)
		AND		$02
		RET		Z
		LD		A,$06
		CALL	$8873
		LD		A,$02
		JR		$8827
L8844:	LD		A,($A294)
		AND		$02
		RET		Z
		XOR		A
		JR		$8873
L884D:	LD		A,($A294)
		AND		$01
		RET		Z
		JR		$8873
L8855:	LD		IX,$8763
		LD		C,$02
		JR		$885F
L885D:	LD		C,$04
L885F:	LD		A,($A294)
		CP		$03
		JR		Z,$886C
		RRA
		AND		$01
		ADD		A,C
		JR		$8873
L886C:	LD		A,C
		PUSH	AF
		CALL	$8878
		POP		AF
		INC		A
L8873:	PUSH	AF
		CALL	$9DF4
		POP		AF
L8878:	CALL	$89F9
		CALL	$89E7
L887E:	PUSH	AF
		PUSH	BC
		AND		A
		LD		A,$81
		JR		Z,$8887
		LD		A,$83
L8887:	CALL	$B682
		POP		BC
		LD		A,C
		ADD		A,$B1
		CALL	$B682
		POP		AF
		JP		$B77F
L8895:	LD		A,D
		SUB		$09
		LD		HL,$866B
		CALL	$89BA
		LD		B,$C1
		CALL	PlaySound
		JP		$8D9E
L88A6:	LD		B,$C2
		CALL	PlaySound
		CALL	$89AB
		LD		IX,$866C
		LD		DE,$0004
		LD		B,$06
L88B7:	LD		(HL),$80
L88B9:	LD		A,(IX+$00)
		ADD		IX,DE
		RRA
		RR		(HL)
		JR		NC,$88B9
		INC		HL
		DJNZ	$88B7
		EX		DE,HL
		LD		HL,$8A15
		INC		(HL)
		LD		HL,$A294
		LD		A,(HL)
		LDI
		LD		HL,$A290
		LDI
		LDI
		CP		$03
		JR		Z,$88EF
		LD		HL,$A2A6
		CP		(HL)
		JR		NZ,$88EF
		LD		HL,$FB49
		LD		BC,$0004
		LDIR
		LD		HL,$FB28
		JR		$88FA
L88EF:	LD		HL,$A2A2
		LD		BC,$0004
		LDIR
		LD		HL,$703B
L88FA:	LDI
		LDI
		LD		HL,$703B
		LDI
		LDI
		RET
L8906:	LD		HL,$8A15
		DEC		(HL)
		CALL	$89AB
		LD		A,(HL)
		AND		$03
		LD		($A28B),A
		LD		A,(HL)
		RRA
		RRA
		AND		$1F
		LD		($866B),A
		PUSH	HL
		POP		IX
		LD		HL,$866C
		LD		DE,$0004
		LD		B,$2F
		RR		(HL)
		JR		$8934
L892A:	RR		(HL)
		SRL		(IX+$00)
		JR		NZ,$8939
		INC		IX
L8934:	SCF
		RR		(IX+$00)
L8939:	RL		(HL)
		ADD		HL,DE
		DJNZ	$892A
		PUSH	IX
		POP		HL
		INC		HL
		LD		DE,$A294
		LD		A,(HL)
		LDI
		LD		DE,$A290
		LDI
		LDI
		LD		DE,$B218
		LDI
		BIT		0,A
		LD		DE,$A2C5
		JR		Z,$895E
		LD		DE,$A2D7
L895E:	LD		BC,$0003
		LDIR
		LD		DE,$703B
		LDI
		LDI
		CP		$03
		JR		Z,$8984
		LD		BC,($A290)
		DEC		B
		JP		M,$8984
		DEC		C
		JP		M,$8984
		XOR		$03
		LD		($FB28),A
		PUSH	HL
		CALL	$7B43
		POP		HL
L8984:	LD		DE,$703B
		LDI
		LDI
		LD		BC,($703B)
		SET		0,C
		CALL	$874F
		CALL	$8764
		LD		A,E
		EX		AF,AF'
		LD		DE,$8ADF
		LD		HL,$8ADC
		CALL	$7ACB
		LD		A,$08
		LD		($B218),A
		LD		($A297),A
		RET
L89AB:	LD		A,($8A15)
		LD		B,A
		INC		B
		LD		HL,$8A04
		LD		DE,$0012
L89B6:	ADD		HL,DE
		DJNZ	$89B6
		RET
L89BA:	LD		B,A
		INC		B
		LD		A,$80
L89BE:	RLCA
		DJNZ	$89BE
		OR		(HL)
		LD		(HL),A
		RET
L89C4:	CALL	$89F9
		CALL	$89EF
		RET		Z
		LD		A,(HL)
		CALL	$887E
		OR		$FF
		RET
L89D2:	LD		A,$B8
		CALL	$B682
		LD		A,$07
L89D9:	PUSH	AF
		DEC		A
		CALL	$89F9
		LD		A,(HL)
		CALL	$887E
		POP		AF
		DEC		A
		JR		NZ,$89D9
		RET
L89E7:	ADD		A,(HL)
		DAA
		LD		(HL),A
		RET		NC
		LD		A,$99
		LD		(HL),A
		RET
L89EF:	LD		A,(HL)
		AND		A
		RET		Z
		SUB		$01
		DAA
		LD		(HL),A
		OR		$FF
		RET
L89F9:	LD		C,A
		LD		B,$00
		LD		HL,$8A0E
		ADD		HL,BC
		LD		A,($B218)
		AND		A
		LD		A,(HL)
		JR		Z,$8A09
		LD		A,$03
L8A09:	LD		HL,$A28C
		ADD		HL,BC
		RET
L8A0E:	DEFB $99,$10,$99,$99,$02,$02,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A1E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A2E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A3E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A4E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A5E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A6E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A7E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A8E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8A9E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8AAE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8ABE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8ACE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8ADE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8AEE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8AFE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B0E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B1E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B2E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B3E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B4E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B5E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B6E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B7E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B8E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8B9E:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8BAE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8BBE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8BCE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8BDE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8BEE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8BFE:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
L8C0E:	DEFB $00
L8C0F:	LD		HL,$A28B
		RES		2,(HL)
L8C14:	EXX
		LD		BC,$0001
		JR		$8C26
L8C1A:	LD		HL,$866B
		JR		$8C14
L8C1F:	LD		HL,$8AE2
		EXX
		LD		BC,$012D
L8C26:	EXX
		LD		DE,$0000
		EXX
L8C2B:	EXX
		LD		C,(HL)
		SCF
		RL		C
L8C30:	LD		A,E
		ADC		A,$00
		DAA
		LD		E,A
		LD		A,D
		ADC		A,$00
		DAA
		LD		D,A
		SLA		C
		JR		NZ,$8C30
		INC		HL
		EXX
		DEC		BC
		LD		A,B
		OR		C
		JR		NZ,$8C2B
		EXX
		RET
L8C47:	LD		HL,$8AE2
		LD		BC,$012D
		JP		FillZero
L8C50:	CALL	$708B
		PUSH	AF
		CALL	$8C1F
		POP		AF
		LD		HL,$0000
		JR		NZ,$8C69
		LD		HL,$0501
		LD		A,($A295)
		AND		A
		JR		Z,$8C69
		LD		HL,$1002
L8C69:	LD		BC,$0010
		CALL	$8C82
		PUSH	HL
		CALL	$8C0F
		POP		HL
		LD		BC,$01F4
		CALL	$8C82
		PUSH	HL
		CALL	$8C1A
		POP		HL
		LD		BC,$027C
L8C82:	LD		A,E
		ADD		A,L
		DAA
		LD		L,A
		LD		A,H
		ADC		A,D
		DAA
		LD		H,A
		DEC		BC
		LD		A,B
		OR		C
		JR		NZ,$8C82
		RET
L8C90:	AND		$0F
		ADD		A,$9B
		LD		L,A
		ADC		A,$8C
		SUB		L
		LD		H,A
		LD		A,(HL)
		RET
L8C9B:	DEFB $FF,$00,$04,$FF,$06,$07,$05,$06,$02,$01,$03,$02,$FF,$00,$04,$FF
L8CAB:	LD		L,A
		ADD		A,A
		ADD		A,L
		ADD		A,$BB
		LD		L,A
		ADC		A,$8C
		SUB		L
		LD		H,A
		LD		C,(HL)
		INC		HL
		LD		B,(HL)
		INC		HL
		LD		A,(HL)
		RET
L8CBB:	DEFB $FF,$00,$0D,$FF,$FF,$09,$00,$FF,$0B,$01,$FF,$0A,$01,$00,$0E,$01
L8CCB:	DEFB $01,$06,$00,$01,$07,$FF,$01,$05
L8CD3:	LD		HL,($822B)
L8CD6:	PUSH	HL
		CALL	$8CAB
		LD		DE,$000B
		POP		HL
		ADD		HL,DE
		XOR		(HL)
		AND		$0F
		XOR		(HL)
		LD		(HL),A
		LD		DE,$FFFA
		ADD		HL,DE
		LD		A,(HL)
		ADD		A,C
		LD		(HL),A
		INC		HL
		LD		A,(HL)
		ADD		A,B
		LD		(HL),A
		RET
L8CF0:	INC		(HL)
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
		JR		Z,$8D11
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
L8D18:	LD		HL,($8D49)
		LD		D,L
		ADD		HL,HL
		ADC		HL,HL
		LD		C,H
		LD		HL,($8D47)
		LD		B,H
		RL		B
		LD		E,H
		RL		E
		RL		D
		ADD		HL,BC
		LD		($8D47),HL
		LD		HL,($8D49)
		ADC		HL,DE
		RES		7,H
		LD		($8D49),HL
		JP		M,$8D43
		LD		HL,$8D47
L8D3F:	INC		(HL)
		INC		HL
		JR		Z,$8D3F
L8D43:	LD		HL,($8D47)
		RET
L8D47:	DEFB $4A,$6F,$6E,$21
L8D4B:	PUSH	HL
		PUSH	HL
		PUSH	IY
		PUSH	HL
		POP		IY
		CALL	$B0C6
		POP		IY
		POP		HL
		CALL	$8D6F
		POP		IX
		SET		7,(IX+$04)
		LD		A,($703D)
		LD		C,(IX+$0A)
		XOR		C
		AND		$80
		XOR		C
		LD		(IX+$0A),A
		RET
L8D6F:	PUSH	IY
		INC		HL
		INC		HL
		CALL	$A1D8
		EX		DE,HL
		LD		H,B
		LD		L,C
		CALL	$A0A8
		POP		IY
		RET
L8D7F:	PUSH	HL
		PUSH	HL
		PUSH	IY
		PUSH	HL
		POP		IY
		CALL	$B03B
		POP		IY
		POP		HL
		CALL	$8D6F
		POP		IX
		RES		7,(IX+$04)
		LD		(IX+$0B),$FF
		LD		(IX+$0C),$FF
		RET
L8D9E:	LD		A,($866B)
		CP		$1F
		JR		NZ,$8DB9
		LD		A,$CA
		CALL	$B682
		CALL	$964F
		LD		DE,$040F
		LD		HL,$7C8A
		CALL	$8E32
		CALL	$8DDF
L8DB9:	CALL	$8DC2
		CALL	$7395
		JP		$7BB3
L8DC2:	LD		A,$C6
		CALL	$B682
		CALL	$964F
		LD		HL,$8DFF
		LD		DE,$05FF
		CALL	$8E32
		LD		HL,$8E0E
		LD		DE,($866B)
		LD		D,$05
		CALL	$8E32
L8DDF:	CALL	GetInputWait
		CALL	$8DED
		CALL	ScreenWipe
		LD		B,$C1
		JP		PlaySound
L8DED:	LD		HL,$A800
L8DF0:	PUSH	HL
		CALL	$964F
		CALL	$75D1
		POP		HL
		RET		NC
		DEC		HL
		LD		A,H
		OR		L
		JR		NZ,$8DF0
		RET
L8DFF:	DEFB $4C,$54,$78,$4C,$A4,$78,$4C,$54,$E8,$4C,$A4,$E8,$4C,$7C,$B0,$2F
L8E0F:	DEFB $54,$60,$2F,$A4,$60,$2F,$54,$D0,$2F,$A4,$D0,$2F,$7C,$98
L8E1D:	CALL	$AA49
		LD		HL,$8E4E
		LD		DE,($A28B)
		LD		D,$03
		CALL	$8E32
		LD		DE,($A294)
L8E30:	LD		D,$02
L8E32:	LD		A,(HL)
		INC		HL
		LD		C,(HL)
		INC		HL
		LD		B,(HL)
		INC		HL
		PUSH	HL
		RR		E
		PUSH	DE
		JR		NC,$8E47
		CALL	$8E74
L8E41:	POP		DE
		POP		HL
		DEC		D
		JR		NZ,$8E32
		RET
L8E47:	LD		D,$01
		CALL	$8E5F
		JR		$8E41
L8E4E:	DEFB $27,$B0,$F0,$28,$44,$F0,$29,$44,$D8,$98,$94,$F0,$1E,$60,$F0

	;; FIXME: Very spritey
L8E5D:		LD	D,$03
L8E5F:		LD	(SpriteCode),A
		LD	A,B
		SUB	$48
		LD	B,A
		PUSH	DE
		PUSH	BC
		CALL	GetSpriteAddr
		LD	HL,$180C
		POP	BC
		POP	AF
		AND	A
		JP	$9542
L8E74:		LD	L,$00
		DEC	L
		INC	L
		JR	Z,$8E5D
		LD	(SpriteCode),A
		CALL	$8E9B
		CALL	$8ECF
		CALL	GetSpriteAddr
		LD	BC,$B800
		EXX
		LD	B,$18
		CALL	Blit3of3
		JP	$93E8

L8E92:		CALL	$8E9B
		CALL	$8ECF
		JP	$93E8
L8E9B:		LD	H,C
		LD	A,H
		ADD	A,$0C
		LD	L,A
		LD	($A052),HL
		LD	A,B
		ADD	A,$18
		LD	C,A
		LD	($A054),BC
		RET


L8EAC:		LD	(SpriteCode),A
		CALL	$8E9B
		LD	A,B
		ADD	A,$20
		LD	($A054),A
		CALL	$8ECF
		LD	A,$02
		LD	($A05C),A
		CALL	GetSpriteAddr
		LD	BC,$B800
		EXX
		LD	B,$20
		CALL	Blit3of3
		JP	$93E8

L8ECF:		LD	HL,$B800
		LD	BC,$0100
		JP	FillZero 	; Tail call

L8ED8:	DEFB $00,$FF,$FF
L8EDB:	LD		A,(IY+$0C)
		LD		(IY+$0C),$FF
		OR		$F0
		CP		$FF
		RET		Z
		LD		($8EDA),A
		RET
L8EEB:	CALL	$9319
		LD		HL,$8EDA
		LD		A,(HL)
		LD		(HL),$FF
		PUSH	AF
		CALL	$8C90
		INC		A
		SUB		$01
		CALL	NC,$921B
		POP		AF
		CALL	$92DF
		CALL	$92CF
		JP		$92B7
L8F08:	BIT		5,(IY+$0C)
		RET		NZ
		CALL	$92CF
		CALL	$92B7
		LD		B,$47
		JP		PlaySound
L8F18:	LD		H,B
		LD		HL,$8F18
		LD		A,(HL)
		AND		A
		RET		NZ
		LD		(HL),$60
		LD		(IY+$0B),$F7
		LD		(IY+$0A),$19
		LD		A,$05
		JP		$A92C
L8F2E:	NOP
		LD		HL,$8F2E
		LD		(HL),$FF
		PUSH	HL
		CALL	$8F3C
		POP		HL
		LD		(HL),$00
		RET
L8F3C:	LD		A,($822D)
		INC		A
		JR		NZ,$8F82
		LD		A,(IY+$0C)
		AND		$20
		RET		NZ
		LD		BC,($A2BB)
		JR		$8F61
L8F4E:	LD		A,($822D)
		INC		A
		JR		NZ,$8F82
		CALL	$9269
		OR		$F3
		CP		C
		JR		Z,$8F61
		LD		A,C
		OR		$FC
		CP		C
		RET		NZ
L8F61:	LD		(IY+$0C),C
		JR		$8F82
L8F66:	CALL	$92D2
		CALL	$8F97
		JR		C,$8F71
		CALL	$8F97
L8F71:	JP		C,$905D
		JR		$8F88
L8F76:	LD		A,($822D)
		INC		A
		JR		NZ,$8F82
		LD		A,(IY+$0C)
		INC		A
		JR		Z,$8F8B
L8F82:	CALL	$9319
		CALL	$8F97
L8F88:	JP		$92B7
L8F8B:	PUSH	IY
		CALL	$90CC
		POP		IY
		LD		(IY+$0B),$FF
		RET
L8F97:	LD		A,($822D)
		AND		A,(IY+$0C)
		CALL	$8C90
		CP		$FF
		SCF
		RET		Z
		CALL	$8FC0
		RET		C
		PUSH	AF
		CALL	$92A6
		POP		AF
		PUSH	AF
		CALL	$8CD3
		POP		AF
		LD		HL,($8F2E)
		INC		L
		RET		Z
		CALL	$8FC0
		RET		C
		CALL	$8CD3
		AND		A
		RET
L8FC0:	LD		HL,($822B)
		JP		$B21C
L8FC6:	LD		A,(IY+$0C)
		OR		$C0
		INC		A
		JR		NZ,$8FD2
		LD		(IY+$11),A
		RET
L8FD2:	LD		A,(IY+$11)
		AND		A
		JR		Z,$8FDD
		LD		(IY+$0C),$FF
		RET
L8FDD:	DEC		(IY+$11)
		CALL	$9314
		LD		HL,$AF80
L8FE6:	LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		OR		H
		JR		Z,$8FF7
		PUSH	HL
		PUSH	HL
		POP		IX
		CALL	$9005
		POP		HL
		JR		$8FE6
L8FF7:	CALL	$92D6
		LD		A,(IY+$04)
		XOR		$10
		LD		(IY+$04),A
		JP		$92B7
L9005:	LD		A,(IX+$0A)
		AND		$7F
		CP		$0E
		RET		Z
		CP		$11
		RET		Z
		LD		A,(IX+$09)
		LD		C,A
		AND		$09
		RET		NZ
		LD		A,C
		XOR		$40
		LD		(IX+$09),A
		RET
L901E:	LD		A,$90
		LD		BC,$523E
		LD		(IY+$11),A
		LD		(IY+$0A),$10
		RET
L902B:	BIT		5,(IY+$0C)
		RET		NZ
		CALL	$931F
		JP		$92B7
L9036:	LD		A,$FE
		JR		$9044
L903A:	LD		A,$FD
		JR		$9044
L903E:	LD		A,$F7
		JR		$9044
L9042:	LD		A,$FB
L9044:	LD		(IY+$0B),A
		LD		(IY+$0A),$00
		RET
L904C:	LD		A,($A294)
		AND		$02
		JR		$905C
L9053:	LD		A,$C0
		LD		BC,$CF3E
		OR		A,(IY+$0C)
		INC		A
L905C:	RET		Z
L905D:	LD		A,$05
		CALL	$A92C
		LD		A,(IY+$0A)
		AND		$80
		OR		$11
		LD		(IY+$0A),A
		LD		(IY+$0F),$08
		LD		(IY+$04),$80
		CALL	$92A6
		CALL	$92D2
		LD		A,(IY+$0F)
		AND		$07
		JP		NZ,$92B7
		LD		HL,($822B)
		JP		$8D4B
L9088:	LD		B,(IY+$08)
		BIT		5,(IY+$0C)
		SET		5,(IY+$0C)
		LD		A,$2C
		JR		Z,$90B3
		LD		A,(IY+$0F)
		AND		A
		JR		NZ,$90AD
		LD		A,$2C
		CP		B
		JR		NZ,$90CC
		LD		(IY+$0F),$50
		LD		A,$04
		CALL	$A92C
		JR		$90C6
L90AD:	AND		$07
		JR		NZ,$90C6
		LD		A,$2B
L90B3:	LD		(IY+$08),A
		LD		(IY+$0F),$00
		CP		B
		JR		Z,$90CC
		JR		$90C6
L90BF:	LD		A,(IY+$0F)
		AND		$F0
		JR		Z,$90CC
L90C6:	CALL	$92A6
		CALL	$92D2
L90CC:	CALL	$9319
		LD		A,$FF
		CALL	$92DF
		JP		$92B7
L90D7:		LD		HL,$921F
		JP		$911B
L90DD:		LD		HL,$920D
		JP		$911B
L90E3:		LD		HL,$921F
		JR		$9121
L90E8:		LD		HL,$920D
		JR		$9121
L90ED:		LD		HL,$9214
		JR		$9121
L90F2:		LD		HL,$9200
		JR		$9121
L90F7:		LD		HL,$9200
		JR		$9155
L90FC:		LD		HL,$91E4
		JR		$9155
L9101:		LD		HL,$91F1
		JR		$9155
L9106:		LD		HL,$9245
		JR		$9141

L910B:	LD		A,($866B)
		OR		$F0
		INC		A
		LD		HL,$925D
		JR		Z,$9119
		LD		HL,$9264
L9119:	JR		$9141
L911B:	PUSH	HL
		CALL	$92CF
		JR		$912C
L9121:	PUSH	HL
L9122:	CALL	$92CF
		CALL	$9319
		LD		A,$FF
		JR		C,$912F
L912C:	CALL	$936A
L912F:	CALL	$92DF
		POP		HL
		LD		A,($8ED9)
		INC		A
		JP		Z,$92B7
		CALL	$9140
		JP		$92B7
L9140:	JP		(HL)
L9141:	PUSH	HL
		CALL	$9319
		POP		HL
		CALL	$9140
L9149:	CALL	$92CF
		CALL	$936A
		CALL	$92DF
		JP		$92B7
L9155:	PUSH	HL
		CALL	$8D18
		LD		A,L
		AND		$0F
		JR		NZ,$9122
		CALL	$9319
		POP		HL
		CALL	$9140
		CALL	$92CF
		CALL	$936A
		CALL	$92DF
		JP		$92B7
L9171:	NOP
		LD		A,$01
		CALL	$A92C
		CALL	$92CF
		LD		A,(IY+$11)
		LD		B,A
		BIT		3,A
		JR		Z,$91BE
		RRA
		RRA
		AND		$3C
		LD		C,A
		RRCA
		ADD		A,C
		NEG
		ADD		A,$C0
		CP		A,(IY+$07)
		JR		NC,$91A8
		LD		HL,($822B)
		CALL	$AC41
		RES		4,(IY+$0B)
		JR		NC,$91A0
		JR		Z,$91E1
L91A0:	CALL	$92A6
		DEC		(IY+$07)
		JR		$91E1
L91A8:	LD		HL,$9171
		LD		A,(HL)
		AND		A
		JR		NZ,$91B1
		LD		(HL),$02
L91B1:	DEC		(HL)
		JR		NZ,$91E1
		LD		A,B
		XOR		$08
		LD		(IY+$11),A
		AND		$08
		JR		$91E1
L91BE:	AND		$07
		ADD		A,A
		LD		C,A
		ADD		A,A
		ADD		A,C
		NEG
		ADD		A,$BF
		CP		A,(IY+$07)
		JR		C,$91A8
		LD		HL,($822B)
		CALL	$AB06
		JR		NC,$91D7
		JR		Z,$91E1
L91D7:	CALL	$92A6
		RES		5,(IY+$0B)
		INC		(IY+$07)
L91E1:	JP		$92B7
L91E4:	CALL	$8D18
		LD		A,L
		AND		$06
		CP		A,(IY+$10)
		JR		Z,$91E4
		JR		$921B
L91F1:	CALL	$8D18
		LD		A,L
		AND		$06
		OR		$01
		CP		A,(IY+$10)
		JR		Z,$91F1
		JR		$921B
L9200:	CALL	$8D18
		LD		A,L
		AND		$07
		CP		A,(IY+$10)
		JR		Z,$9200
		JR		$921B
L920D:	LD		A,(IY+$10)
		SUB		$02
		JR		$9219
L9214:	LD		A,(IY+$10)
		ADD		A,$02
L9219:	AND		$07
L921B:	LD		(IY+$10),A
		RET
L921F:	LD		A,(IY+$10)
		ADD		A,$04
		JR		$9219
L9226:	CALL	$9319
		CALL	$9269
		LD		A,$18
		CP		D
		JR		C,$923F
		CP		E
		JP		C,$923F
		LD		A,C
		CALL	$8C90
		LD		(IY+$10),A
		JP		$9149
L923F:	CALL	$92CF
		JP		$92B7
L9245:	CALL	$9269
		LD		A,D
		CP		E
		LD		B,$F3
		JR		C,$9251
		LD		A,E
		LD		B,$FC
L9251:	AND		A
		LD		A,B
		JR		NZ,$9257
		XOR		$0F
L9257:	OR		C
L9258:	CALL	$8C90
		JR		$921B
L925D:	CALL	$9269
		XOR		$0F
		JR		$9258
L9264:	CALL	$9269
		JR		$9258
L9269:	CALL	$A94B
		LD		DE,$0005
		ADD		HL,DE
		LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		LD		C,$FF
		LD		A,H
		SUB		(IY+$06)
		LD		D,A
		JR		Z,$928A
		JR		NC,$9283
		NEG
		LD		D,A
		SCF
L9283:	PUSH	AF
		RL		C
		POP		AF
		CCF
		RL		C
L928A:	LD		A,(IY+$05)
		SUB		L
		LD		E,A
		JR		Z,$92A0
		JR		NC,$9297
		NEG
		LD		E,A
		SCF
L9297:	PUSH	AF
		RL		C
		POP		AF
		CCF
		RL		C
		LD		A,C
		RET
L92A0:	RLC		C
		RLC		C
		LD		A,C
		RET
L92A6:	LD		A,($8ED8)
		BIT		0,A
		RET		NZ
		OR		$01
		LD		($8ED8),A
		LD		HL,($822B)
		JP		$A05D
L92B7:	LD		(IY+$0C),$FF
		LD		A,($8ED8)
		AND		A
		RET		Z
		CALL	$92A6
		LD		HL,($822B)
		CALL	$B0BE
		LD		HL,($822B)
		JP		$A0A5
L92CF:	CALL	$937E
L92D2:	CALL	$82C9
		RET		NC
L92D6:	LD		A,($8ED8)
		OR		$02
		LD		($8ED8),A
		RET
L92DF:	AND		A,(IY+$0C)
		CP		$FF
		LD		($8ED9),A
		RET		Z
		CALL	$8C90
		CP		$FF
		LD		($8ED9),A
		RET		Z
		PUSH	AF
		LD		($8ED9),A
		CALL	$8FC0
		POP		BC
		CCF
		JP		NC,$930F
		PUSH	AF
		CP		B
		JR		NZ,$9306
		LD		A,$FF
		LD		($8ED9),A
L9306:	CALL	$92A6
		POP		AF
		CALL	$8CD3
		SCF
		RET
L930F:	LD		A,($822D)
		INC		A
		RET		Z
L9314:	LD		A,$06
		JP		$A92C
L9319:	BIT		4,(IY+$0C)
		JR		Z,$9354
L931F:	LD		HL,($822B)
		CALL	$AB06
		JR		NC,$933D
		CCF
		JR		NZ,$9331
		BIT		4,(IY+$0C)
		RET		NZ
		JR		$9354
L9331:	BIT		4,(IY+$0C)
		SCF
		JR		NZ,$933D
		RES		4,(IY+$0B)
		RET
L933D:	PUSH	AF
		CALL	$92A6
		RES		5,(IY+$0B)
		INC		(IY+$07)
		LD		A,$03
		CALL	$A92C
		POP		AF
		RET		C
		INC		(IY+$07)
		SCF
		RET
L9354:	LD		HL,($822B)
		CALL	$AC41
		RES		4,(IY+$0B)
		JR		NC,$9362
		CCF
		RET		Z
L9362:	CALL	$92A6
		DEC		(IY+$07)
		SCF
		RET
L936A:	LD		A,(IY+$10)
		ADD		A,$76
		LD		L,A
		ADC		A,$93
		SUB		L
		LD		H,A
		LD		A,(HL)
		RET
L9376:	DEFB $FD,$F9,$FB,$FA,$FE,$F6,$F7,$F5
L937E:	LD		C,(IY+$10)
		BIT		1,C
		RES		4,(IY+$04)
		JR		NZ,$938D
		SET		4,(IY+$04)
L938D:	LD		A,(IY+$0F)
		AND		A
		RET		Z
		BIT		2,C
		LD		C,A
		JR		Z,$939E
		BIT		3,C
		RET		NZ
		LD		A,$08
		JR		$93A2
L939E:	BIT		3,C
		RET		Z
		XOR		A
L93A2:	XOR		C
		AND		$0F
		XOR		C
		LD		(IY+$0F),A
		RET
L93AA:	DEFB $00,$00,$00,$00,$00,$00
L93B0:	LD		A,($703D)
		XOR		$80
		LD		($703D),A
		CALL	$A361
		LD		HL,($AF80)
		JR		$93DD
L93C0:	PUSH	HL
		LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		EX		(SP),HL
		EX		DE,HL
		LD		HL,$000A
		ADD		HL,DE
		LD		A,($703D)
		XOR		(HL)
		CP		$80
		JR		C,$93DC
		LD		A,(HL)
		XOR		$80
		LD		(HL),A
		AND		$7F
		CALL	NZ,$82A1
L93DC:	POP		HL
L93DD:	LD		A,H
		OR		L
		JR		NZ,$93C0
		RET
L93E2:	DEFB $00,$00
	
Attrib0:	DEFB $00
Attrib3:	DEFB $43
Attrib4:	DEFB $45
Attrib5:	DEFB $46

L93E8:	LD		HL,($A052)
		LD		A,H
		SUB		$40
		ADD		A,A
		LD		C,A
		LD		A,L
		SUB		H
		RRA
		RRA
		AND		$07
		DEC		A
		ADD		A,A
		LD		E,A
		LD		D,$00
		LD		HL,$9418
		ADD		HL,DE
		LD		E,(HL)
		INC		HL
		LD		D,(HL)
		PUSH	DE
		LD		HL,($A054)
		LD		A,L
		SUB		H
		EX		AF,AF'
		LD		A,H
		SUB		$48
		LD		B,A
		CALL	$94EF
		EX		AF,AF'
		LD		B,A
		LD		C,$FF
		LD		HL,$B800
		RET
L9418:	INC		H
		SUB		H
		LD		B,D
		SUB		H
		LD		H,D
		SUB		H
		ADD		A,H
		SUB		H
		XOR		B
		SUB		H
		RES		2,H

#include "blit_screen.asm"

	;; FIXME: Returns stuff in DE, takes stuff in BC
L94EF:		LD	A,B
		AND	A
		RRA
		SCF
		RRA		; /4, +0x80 ?
		AND	A
		RRA
		XOR	B
		AND	$F8	; Clear bottom 3 bits
		XOR	B
		LD	D,A
		LD	A,C
		RLCA
		RLCA
		RLCA
		XOR	B
		AND	$C7
		XOR	B
		RLCA
		RLCA
		LD	E,A
		RET
	
	;; Screen-wipe loop
ScreenWipe:	LD	E,$04
SW_0:		LD	HL,$4000
		LD	BC,$1800
		PUSH	AF
		; This loop smears to the right...
SW_1:		POP	AF
		LD	A,(HL)
		RRA
		PUSH	AF
		AND	(HL)
		LD	(HL),A
		; (Delay loop)
		LD	D,$0C
SW_2:		DEC	D
		JR	NZ,SW_2
		INC	HL
		DEC	BC
		LD	A,B
		OR	C
		JR	NZ,SW_1
		; This loop smears to the left...
		LD	BC,$1800
SW_3:		DEC	HL
		POP	AF
		LD	A,(HL)
		RLA
		PUSH	AF
		AND	(HL)
		LD	(HL),A
		; (Delay loop)
		LD	D,$0C
SW_4:		DEC	D
		JR	NZ,SW_4
		DEC	BC
		LD	A,B
		OR	C
		JR	NZ,SW_3
		POP	AF
		DEC	E
		; And loop until fully wiped...
		JR	NZ,SW_0
		LD	HL,$4000
		LD	BC,$1800
		JP	FillZero 	; Tail call

L9542:		PUSH	AF
		PUSH	BC
		PUSH	DE
		XOR		A
		LD		($940B),A
		LD		D,B
		LD		A,B
		ADD		A,H
		LD		E,A
		LD		($A054),DE
		LD		A,C
		LD		B,C
		ADD		A,L
		LD		C,A
		LD		($A052),BC
		LD		A,L
		RRCA
		RRCA
		AND		$07
		LD		L,A
		POP		DE
		PUSH	HL
		LD		C,A
		LD		A,H
		LD		HL,$B800
L9566:	EX		AF,AF'
		LD		B,C
L9568:	LD		A,(DE)
		LD		(HL),A
		INC		L
		INC		DE
		DJNZ	$9568
		LD		A,$06
		SUB		C
		ADD		A,L
		LD		L,A
		EX		AF,AF'
		DEC		A
		JR		NZ,$9566
		CALL	$93E8
		POP		HL
		POP		BC
		LD		A,C
		SUB		$40
		ADD		A,A
		LD		C,A
		CALL	$94EF
		CALL	GetAttrOrigin
		LD		A,H
		RRA
		RRA
		RRA
		AND		$1F
		LD		H,A
		POP		AF
		ADD		A,$E4
		LD		C,A
		ADC		A,$93
		SUB		C
		LD		B,A
		LD	A,(BC)
		EX		DE,HL
L9598:	LD		B,E
		LD		C,L
L959A:	LD		(HL),A
		INC		L
		DJNZ	$959A
		LD		L,C
		LD		BC,$0020
		ADD		HL,BC
		DEC		D
		JR		NZ,$9598
		LD		A,$48
		LD		($940B),A
		RET

	;; Divide by 8, take bottom 2 bits, tack on $58 (top byte of attribute table address)
GetAttrOrigin:	LD	A,D
		RRA
		RRA
		RRA
		AND	$03
		OR	$58
		LD	D,A
		RET
	
ApplyAttribs:	LD	BC,($93E2)
		LD	A,C
		SUB	$40
		ADD	A,A
		LD	C,A
		LD	A,B
		SUB	$3D
		LD	B,A
		CALL	$94EF
		LD	L,D
		CALL	GetAttrOrigin
		EX	DE,HL

		PUSH	HL
	;; Write out Attrib2 over HL, in a diagonal line up the right, 2:1 gradient.
		LD	A,L
		AND	$1F
		NEG
		ADD	A,$20
		LD	B,A
		LD	A,(Attrib2)
		LD	C,A
		CALL	ApplyAttribs1

		POP	HL
	;; Write out Attrib1 over HL, in a diagonal line up the left, 2:1 gradient.
		LD	A,L
		DEC	L
		AND	$1F
		LD	B,A 	; Initialise count with X coordinate from address.

		LD	A,(Attrib1)
		LD	C,A

		BIT	2,E
		JR	Z,AA_2		; Do we start with up and left, or left?
AA_1:		LD	(HL),C
		DEC	B
		RET	Z
	;; Left one 
		DEC	L
AA_2:		LD	(HL),C
	;; Up one line
		LD	A,L
		SUB	$20
		LD	L,A
		JR	NC,AA_3
		DEC	H
AA_3:		LD	(HL),C
	;; Left one
		DEC	L
		DJNZ	AA_1
		RET

ApplyAttribs1:	BIT	2,E
		JR	Z,AA1_2		; Do we start with up and right or up?
AA1_1:		LD	(HL),C
		DEC	B
		RET	Z
	;; Right one
		INC	L
AA1_2:		LD	(HL),C
	;; Up one line
		LD	A,L
		SUB	$20
		LD	L,A
		JR	NC,AA1_3
		DEC	H
AA1_3:		LD	(HL),C
	;; Right one
		INC	L
		DJNZ	AA1_1
		RET
	
InputThing:	JP	InputThingKbd	; If joystick used, this is rewritten as 'CALL'.
		RLCA
		RLCA
		RLCA
		EX 	AF,AF'
InputThingJoy:	CALL 	Kempston	; Rewritten with the appropriate joystick call.
		LD 	B,0
		LD 	E,A
		JR 	IT_2	
InputThingKbd:	LD	B,$FE
		LD	A,$FF
		LD	HL,$74D2
IT_1:		EX	AF,AF'
		LD	C,$FE
		IN	E,(C)
IT_2:		LD	C,$08
IT_3:		LD	A,(HL)
		OR	E
		OR	$E0
		CP	$FF
		CCF
		RL	D
		INC	HL
		DEC	C
		JR	NZ,IT_3
		EX	AF,AF'
		AND	D
		RLC	B
		JR	C,IT_1
		RRCA
		RRCA
		RRCA
		RET

L9643:		LD	A,$BF
		IN	A,($FE)
		AND	$10
		RET

L964A:	DEFB $00
L964B:	DEFB $FF
L964C:	DEFB $00
L964D:	DEFB $00
L964E:	DEFB $80
	
L964F:		LD	A,($964B)
		CP	$00
		RET	Z
		LD	B,$C3
		JP	PlaySound
	
IrqFn:		JP	IrqFnCore

	;; Ratio between elements are twelth root of two - definitions for notes in a scale.
ScaleTable:	DEFW 1316,1241,1171,1105,1042,983,927,875,825,778,734,692

	;; FIXME: Called from everywhere.
PlaySound:	LD	A,($964E)
		RLA
		RET	NC
		LD	HL,$964B
		LD	A,(HL)
		CP	B
		RET	Z
		LD	A,B
		AND	$3F
		CP	$3F
		JR	NZ,PS_2
		INC	B
		JR	Z,PS_1
		LD	A,(HL)
		AND	A
		RET	Z
		LD	A,B
		DEC	A
		XOR	(HL)
		AND	$C0
		RET	NZ
PS_1:		LD	A,$FF
		LD	(HL),A
		RET
PS_2:		LD	C,A
		LD	A,B
		LD	D,$00
		DEC	HL
		LD	(HL),A
		RLCA
		RLCA
		AND	$03
		LD	B,A
		CP	$03
		JR	NZ,PS_3
		XOR	A
		LD	(HL),A
		LD	HL,$98E5
		JR	PS_6
PS_3:		LD	A,($964B)
		AND	A
		RET	Z
		LD	A,B
		CP	$02
		JR	Z,PS_5
		CP	$01
		LD	A,$F9
		JR	Z,PS_4
		LD	A,$FC
PS_4:		ADD	A,C
		RET	NC
		LD	C,A
PS_5:		LD	HL,SoundTable
		LD	E,B
		SLA	E
		ADD	HL,DE
		LD	E,(HL)
		INC	HL
		LD	H,(HL)
		LD	L,E
PS_6:		LD	E,C
		SLA	E
		ADD	HL,DE
		LD	E,(HL)
		INC	HL
		LD	D,(HL)
		LD	A,(DE)
		AND	$07
		LD	C,A
		AND	$04
		JR	NZ,PS_8
		LD	A,C
		AND	$02
		LD	B,$0A
		JR	NZ,PS_7
		LD	B,$92
		RR	C
		JR	C,PS_7
		LD	B,$02
	;; Scribble over locations the interrupt handler cares about.
	;; So, disable interrupts.
PS_7:		DI
		LD	HL,$964A
		LD	A,(HL)
		INC	HL
		LD	(HL),A
		LD	HL,SndCtrl
		LD	(HL),B 		; Write SndCtrl
		INC	HL
		INC	HL
		LD	(HL),E		; Write ScorePtr
		INC	HL
		LD	(HL),D
		XOR	A
		INC	HL
		LD	(HL),A		; Clear ScoreIdx
		EI
		RET
PS_8:		EX	DE,HL
		LD	B,(HL)
		INC	HL
		LD	E,(HL)
		INC	HL
		LD	D,(HL)
		LD	A,B
		AND	$02
		JR	Z,PS_9
		LD	A,($964B)
		AND	A
		JR	Z,PS_9
		LD	A,$FF
		LD	($964B),A
PS_9:		XOR	A
		LD	($98B7),A
		CALL	DoSound
		LD	A,$FF
		LD	($98B7),A
		RET

	;;  Core interrupt handler.
IrqFnCore:	LD	IY,SndCtrl
		LD	A,($964B)
		INC	A
		RET	Z
		LD	IX,(ScorePtr)
		LD	DE,(ScoreIdx)
		LD	D,$00
		ADD	IX,DE	   ; Generate current score pointer, put in IX.
		BIT	1,(IY+$00) ; SndCtrl
		JR	NZ,IFC_2
		LD	A,(NoteLen)
		AND	A
		JP	NZ,OtherSoundThing
		RES	4,(IY+$00) ; SndCtrl - turn on glissando
		CALL	GetScoreByte
		LD	D,A
		INC	A
		JR	NZ,IFC_4
		CALL	GetScoreByte
		CP	D
		JR	NZ,IFC_1
		LD	($964B),A
		RET
IFC_1:		AND	A
		JR	NZ,IFC_2
		LD	(ScoreIdx),A
		LD	IX,(ScorePtr)
IFC_2:		LD	D,(IX+$00)
		CALL	UnpackD
		LD	(IY+$05),D ; Something
		LD	B,$08
		LD	A,E
		AND	$02
		JR	NZ,IFC_3
		LD	B,$80
		RRC	E
		JR	C,IFC_3
		LD	B,$00
IFC_3:		LD	A,(SndCtrl)
		AND	$02
		OR	B
		LD	E,A
		AND	$02
		RLA
		RLA
		RLA
		OR	E
		LD	(SndCtrl),A
		CALL	GetScoreByte
		LD	D,A
IFC_4:		LD	A,(SndCtrl)
		AND	$F9
		LD	(SndCtrl),A 	; Turn off 0x2 and 0x4
		CALL	UnpackD
		LD	C,D
		LD	D,$00
		LD	HL,IrqArray
		ADD	HL,DE
		LD	A,(HL)
		LD	(NoteLen),A
		LD	A,C
		AND	A
		JR	NZ,IrqBits	; Tail call
		SET	2,(IY+$00)	; SndCtrl
		RET

GetScoreByte:	INC	IX		; Contains ScorePtr + ScoreIdx
		INC	(IY+$04)	; ScoreIdx
		LD	A,(IX+$00)
		RET

	;; More interrupt-related stuff...
IrqBits:	ADD	A,(IY+$05) 	; Something
	;; Divide A by 12, result plus one in C, remainder in A.
		LD	B,12
		LD	H,0
		LD	C,H
IB_0:		INC	C
		SUB	B
		JR	NC,IB_0
		ADD	A,B
	;; Look up the basic delay constant in the scale table.
		LD	L,A
		ADD	HL,HL
		LD	DE,ScaleTable
		ADD	HL,DE
		LD	E,(HL)
		INC	HL
		LD	D,(HL)
		INC	HL	; (Seems unnecessary??)
	;; Generate the octave constant in A.
		LD	B,C
		LD	A,$02
IB_1:		RLCA
		DJNZ	IB_1
		BIT	4,(IY+$00) 	; SndCtrl - get glissando bit
		JR	NZ,IB_2
	;; Glissando case: Double the constant and add 8. Don't ask me.
		RLCA			; Glissando case...
		ADD	A,$08
	;; Otherwise, don't.
IB_2:		LD	(SoundLenConst),A
	;; Now shift the delay constant (in DE), according to the octave we're in.
		LD	B,C
IB_3:		SRL	D
		RR	E
		DJNZ	IB_3
	;; Now some octave-specific cases:
		LD	A,C
		DEC	A
		JR	Z,IB_5	; Go to IB_5 if bottom octave/octave 1 (encoded as 0).
		LD	B,$09
		LD	A,$04
		SUB	C
		JR	C,IB_4	; Go to IB_4 if octave > 4
		RLA
		NEG
		ADD	A,B
		LD	B,A
IB_4:		LD	A,E
		SUB	B
		LD	E,A
		JR	NC,IB_5
		DEC	D
	;; Check for glissando
IB_5:		LD	A,(SndCtrl)
		AND	$90
		CP	$80
		JR	NZ,IB_8
	;; Glissando case
		LD	(SoundDelayTarget),DE
		LD	HL,(SoundDelayConst)
		EX	DE,HL
		XOR	A
		SBC	HL,DE		; Now contains difference between current and target.
		LD	A,(NoteLen)
	;; Count significant bits in A.
		LD	B,$08
IB_6:		RLA
		DEC	B
		JR	NC,IB_6
	;; Divide through by that.
IB_7:		SRA	H
		RR	L
		DJNZ	IB_7
	;; And that gives us our delta to finish in the appropriate timeframe.
		LD	(SoundDelayDelta),HL
		RES	4,(IY+$00) 	; SndCtrl - enable glissando.
		JR	DoCurrSound	; Tail call
	;; Non-glissando case
IB_8:		LD	(SoundDelayConst),DE
	;; NB: Fall through

DoCurrSound:	LD	B,(IY+$0A)	; SoundLenConst
		LD	DE,(SoundDelayConst)
		LD	A,($98B7)
		INC	A
		RET	NZ
	;; Fall through!

	;; Writes out B edges with a delay constant of DE.
DoSound:	LD	A,E
	;; Bottom two bits control the overwrite of the jump to DS_1 -
	;; back jump to the OUT, or one of the INC HLs. 
		AND	$03
		NEG
		ADD	A,$F0
		LD	(DS_3+1),A
	;; Divide DE by 4.
		SRL	D
		RR	E
		SRL	D
		RR	E
	;; Load up previously written value...
		LD	A,(LastOut)
	;; Jump target area... these are simply delay ops.
		INC	HL
		INC	HL
		INC	HL
	;; Write/toggle the sound bit.
DS_1:		OUT	($FE),A
		XOR	$30
	;; Delay loop.
		LD	C,A
		PUSH	DE
DS_2:		DEC	DE
		LD	A,D
		OR	E
		JP	NZ,DS_2
		POP	DE
		LD	A,C
	;; And loop.			
DS_3:		DJNZ	DS_1		; Target of self-modifying code!
		RET

OtherSoundThing:LD	A,(SndCtrl)
		LD	B,A
		DEC	(IY+$01)	; NoteLen
		JR	NZ,OST_1
		AND	$80
		RET	Z		; Do nothing if NoteLen is zero, and top
					; bit of SndCtrl is reset.
		LD	A,B
OST_1:		AND	$0C
		RET	NZ		; Return if 0x8 or 0x4 bit set in SndCtrl
		LD	A,B
		AND	$90
		CP	$80
		JR	NZ,DoCurrSound  ; Skip if IrqFlag & 0x90 != 0x80
		LD	HL,(SoundDelayConst) ; Add SoundDelayDelta to SoundDelayConst
		LD	DE,(SoundDelayDelta)
		ADD	HL,DE
		LD	E,L
		LD	D,H
		LD	BC,(SoundDelayTarget)	; Check if we've hit the limit of the glissando.
		XOR	A
		SBC	HL,BC
		RRA
		XOR	A,(IY+$0B)	; SoundDelayDelta high byte - this bit is for signed check.
		RLA
		JR	C,OST_2
		SET	4,(IY+$00)	; Set 0x10 bit of SndCtrl - turn off glissando.
		LD	DE,(SoundDelayTarget) ; And use the target frequency
OST_2:		LD	(SoundDelayConst),DE
		JR	DoCurrSound 	; Tail call

UnpackD:	LD	BC,$0307
		LD	A,D
		AND	C
		LD	E,A		; Mask bottom 3 bits into E.
		LD	A,C
		CPL
		AND	D
		LD	D,A		; Mask top 5 bits of D.
UnpackD_1:	RRC	D
		DJNZ	UnpackD_1
		RET			; And rotate into bottom position.

IrqArray:	DEFB $01,$02,$04,$06,$08,$0C,$10,$20,$FF

SndCtrl:	DEFB $00
NoteLen:	DEFB $00
ScorePtr:	DEFW $0000
ScoreIdx:	DEFB $00
Something:	DEFB $00
SoundDelayTarget:	DEFW $0000
SoundDelayConst:	DEFW $0000
SoundLenConst:	DEFB $00
SoundDelayDelta:	DEFW $0000
SoundTable:	DEFW $98E1,$98DD,$98CB,$9909,$9914
		DEFW $991F,$9932,$993D,$994A,$994D,$9950,$9958,$996A
		DEFW $995B,$9903,$9906,$9954,$9972,$9983,$99DD,$999E
		DEFW $99A9,$98F7,$99CD,$99D5

L99F7:	DEFB $10,$95,$6A,$62,$6A,$7D,$6D,$04
L98FF:	DEFB $8D,$96,$FF,$FF,$16,$90,$00,$14,$00,$02,$82,$31,$52,$41,$2A,$31
L990F:	DEFB $1A,$29,$42,$FF,$00,$82,$31,$51,$41,$29,$31,$19,$29,$41,$FF,$00
L991F:	DEFB $22,$F3,$EB,$E3,$DB,$EB,$E3,$DB,$D3,$E3,$DB,$D3,$CB,$DB,$D3,$CB
L992F:	DEFB $C3,$FF,$00,$22,$BB,$A3,$8B,$73,$5B,$43,$2B,$23,$FF,$00,$22,$13
L993F:	DEFB $33,$53,$73,$93,$B3,$D3,$DB,$E3,$EE,$FF,$00,$64,$80,$00,$46,$A0
L994F:	DEFB $00,$31,$DA,$65,$F4,$01,$01,$FF,$FF,$46,$D0,$00,$01,$51,$BB,$FF
L995F:	DEFB $08,$04,$30,$04,$28,$04,$20,$04,$18,$FF,$FF,$41,$10,$5C,$5C,$43
L996F:	DEFB $07,$FF,$FF,$61,$0C,$36,$FF,$60,$35,$35,$35,$45,$35,$45,$FF,$61
L997F:	DEFB $56,$56,$FF,$FF,$30,$B2,$BA,$CC,$34,$34,$6A,$5A,$52,$6A,$92,$8A
L998F:	DEFB $94,$C2,$CA,$DC,$44,$44,$A2,$92,$8A,$92,$8A,$7A,$6E,$FF,$FF,$11
L999F:	DEFB $30,$52,$01,$19,$3A,$01,$09,$22,$FF,$FF,$20,$45,$FF,$80,$7B,$73
L99AF:	DEFB $7B,$6B,$FF,$20,$2D,$FF,$80,$63,$5B,$63,$53,$FF,$20,$0D,$FF,$80
L99BF:	DEFB $43,$3B,$43,$33,$FF,$20,$1D,$FF,$80,$53,$4B,$53,$FF,$FF,$41,$09
L99CF:	DEFB $3E,$5E,$CE,$F6,$FF,$FF,$41,$F0,$A6,$5E,$3E,$0E,$FF,$FF,$02,$52
L99DF:	DEFB $32,$54,$6A,$52,$6C,$82,$6A,$7A,$92,$FF,$61,$F6,$00,$FF,$2A,$52
L99EF:	DEFB $32,$54,$6A,$52,$6C,$82,$6A,$7A,$92,$FF,$89,$32,$0A,$32,$32,$00
L99FF:	DEFB $FF,$3A,$52,$32,$54,$6A,$52,$6C,$82,$6A,$7A,$92,$FF,$99,$F6,$FF
L9A0F:	DEFB $62,$F2,$EA,$DA,$CA,$BA,$B2,$A2,$92,$8A,$7A,$6A,$FF,$61,$50,$53
L9A1F:	DEFB $34,$34,$FF,$00,$FF,$FF

#include "blit.asm"
	
L9BBE:	LD		HL,($A052)
		LD		A,H
		RRA
		RRA
		LD		C,A
		AND		$3E
		EXX
		LD		L,A
		LD		H,$BA
		EXX
		LD		A,L
		SUB		H
		RRA
		RRA
		AND		$07
		SUB		$02
		LD		DE,$B800
		RR		C
		JR		NC,$9BF0
		LD		IY,$9DF8
		LD		IX,$9EA9
		LD		HL,$9E73
		CALL	$9C16
		CP		$FF
		RET		Z
		SUB		$01
		JR		$9C01
L9BF0:	LD		IY,$9E07
		LD		IX,$9EBB
		LD		HL,$9E46
		CALL	$9C16
		INC		E
		SUB		$02
L9C01:	JR		NC,$9BF0
		INC		A
		RET		NZ
		LD		IY,$9DF8
		LD		IX,$9EAD
		LD		HL,$9E80
		LD		($9CD2),HL
		EXX
		JR		$9C28
L9C16:	LD		($9CD2),HL
		PUSH	DE
		PUSH	AF
		EXX
		PUSH	HL
		CALL	$9C28
		POP		HL
		INC		L
		INC		L
		EXX
		POP		AF
		POP		DE
		INC		E
		RET
L9C28:	LD		DE,($A054)
		LD		A,E
		SUB		D
		LD		E,A
		LD		A,(HL)
		AND		A
		JR		Z,$9C7F
		LD		A,D
		SUB		(HL)
		LD		D,A
		JR		NC,$9C82
		INC		HL
		LD		C,$38
		BIT		2,(HL)
		JR		Z,$9C41
		LD		C,$4A
L9C41:	ADD		A,C
		JR		NC,$9C4F
		ADD		A,A
		CALL	$9D77
		EXX
		LD		A,D
		NEG
		JP		$9C6B
L9C4F:	NEG
		CP		E
		JR		NC,$9C7F
		LD		B,A
		NEG
		ADD		A,E
		LD		E,A
		LD		A,B
		CALL	$9DF6
		LD		A,(HL)
		EXX
		CALL	$9DBF
		EXX
		LD		A,$38
		BIT		2,(HL)
		JR		Z,$9C6B
		LD		A,$4A
L9C6B:	CP		E
		JR		NC,$9C7C
		LD		B,A
		NEG
		ADD		A,E
		EX		AF,AF'
		LD		A,B
		CALL	$9DF4
		EX		AF,AF'
		LD		D,$00
		JR		$9C84
L9C7C:	LD		A,E
		JP		(IX)
L9C7F:	LD		A,E
		JP		(IY)
L9C82:	LD		A,E
		INC		HL
L9C84:	LD		B,A
		DEC		HL
		LD		A,L
		ADD		A,A
		ADD		A,A
		ADD		A,$04
		CP		$00
		JR		C,$9C9B
		LD		E,$00
		JR		NZ,$9C95
		LD		E,$05
L9C95:	SUB		$04
		ADD		A,$00
		JR		$9CA3
L9C9B:	ADD		A,$04
		NEG
		ADD		A,$00
		LD		E,$08
L9CA3:	NEG
		ADD		A,$0B
		LD		C,A
		LD		A,E
		LD		($9CF6),A
		LD		A,(HL)
		ADD		A,D
		INC		HL
		SUB		C
		JR		NC,$9CCA
		ADD		A,$0B
		JR		NC,$9CCD
		LD		E,A
		SUB		$0B
		ADD		A,B
		JR		C,$9CBF
		LD		A,B
		JR		$9CEC
L9CBF:	PUSH	AF
		SUB		B
		NEG
L9CC3:	CALL	$9CEC
		POP		AF
		RET		Z
		JP		(IY)
L9CCA:	LD		A,B
		JP		(IY)
L9CCD:	ADD		A,B
		JR		C,$9CD4
		LD		A,B
L9CD1:	JP		$0000
L9CD4:	PUSH	AF
		SUB		B
		NEG
		CALL	$9CD1
		POP		AF
		RET		Z
		SUB		$0B
		LD		E,$00
		JR		NC,$9CE7
		ADD		A,$0B
		JR		$9CEC
L9CE7:	PUSH	AF
		LD		A,$0B
		JR		$9CC3
L9CEC:	PUSH	DE
		EXX
		POP		HL
		LD		H,$00
		ADD		HL,HL
		LD		BC,$9D03
		JR		$9CFF
L9CF7:	LD		BC,$9D19
		JR		$9CFF
L9CFC:	LD		BC,$9D2F
L9CFF:	ADD		HL,BC
		EXX
		JP		(IX)
		LD		B,B
		NOP
		LD		(HL),B
		NOP
		LD		(HL),H
		NOP
		LD		(HL),A
		NOP
		SCF
		LD		B,B
		RLCA
		LD		(HL),B
		INC		BC
		LD		(HL),H
		NOP
		LD		(HL),A
		NOP
		SCF
		NOP
		RLCA
		NOP
		INC		BC
		NOP
		LD		BC,$0D00
		NOP
		DEC		A
		NOP
		LD		A,L
		LD		BC,$0D7C
		LD		(HL),B
		DEC		A
		LD		B,B
		LD		A,L
		NOP
		LD		A,H
		NOP
		LD		(HL),B
		NOP
		LD		B,B
		NOP
		LD		B,B
		LD		BC,$0D70
		LD		(HL),H
		DEC		A
		LD		(HL),A
		LD		A,L
		SCF
		LD		A,H
		RLCA
		LD		(HL),B
		INC		BC
		LD		B,B
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
L9D45:	LD		HL,(FloorAddr)
		LD		($93E2),BC
		LD		BC,$000A
		ADD		HL,BC
		LD		C,$10
		LD		A,($7717)
		RRA
		PUSH	HL
		JR		NC,$9D5B
		ADD		HL,BC
		EX		(SP),HL
L9D5B:	ADD		HL,BC
		RRA
		JR		NC,$9D62
		AND		A
		SBC		HL,BC
L9D62:	LD		DE,$9D19
		CALL	$9D6D
		POP		HL
		INC		HL
		LD		DE,$9D04
L9D6D:	LD		A,$04
L9D6F:	LDI
		INC		HL
		INC		DE
		DEC		A
		JR		NZ,$9D6F
		RET
L9D77:	PUSH	AF
		LD		A,(HL)
		EXX
		CALL	$9DBF
		POP		AF
		ADD		A,L
		LD		L,A
		RET		NC
		INC		H
		RET
L9D83:	DEFB $00
L9D84:	LD		A,($9D83)
		AND		A
		LD		HL,$F944
		RET		Z
		PUSH	HL
		PUSH	BC
		PUSH	DE
		LD		BC,$0094
		CALL	FillZero
		POP		DE
		POP		BC
		POP		HL
		XOR		A
		LD		($9D83),A
		RET
L9D9D:	BIT		0,A
		JR		NZ,$9D84
		LD		L,A
		LD		A,($9D83)
		AND		A
		CALL	Z,$768E
		LD		A,($9EE1)
		XOR		L
		RLA
		LD		HL,$F944
		RET		NC
		LD		A,($9EE1)
		XOR		$80
		LD		($9EE1),A
		LD		B,$4A
		JP		FlipSprite 	; Tail call

L9DBF:		BIT	2,A
		JR	NZ,$9D9D
		PUSH	AF
		CALL	$9DD1
		EX	AF,AF'
		POP	AF
		CALL	GetPanelAddr
		EX	AF,AF'
		RET	NC
		JP	FlipPanel 	; Tail call

	
L9DD1:	LD		C,A
		LD		HL,($84C5)
		AND		$03
		LD		B,A
		INC		B
		LD		A,$01
L9DDB:	RRCA
		DJNZ	$9DDB
		LD		B,A
		AND		(HL)
		JR		NZ,$9DEA
		RL		C
		RET		NC
		LD		A,B
		OR		(HL)
		LD		(HL),A
		SCF
		RET
L9DEA:	RL		C
		CCF
		RET		NC
		LD		A,B
		CPL
		AND		(HL)
		LD		(HL),A
		SCF
		RET
L9DF4:	JP		(IX)
L9DF6:	JP		(IY)
		EXX
		LD		B,A
		EX		DE,HL
		LD		E,$00
L9DFD:	LD		(HL),E
		LD		A,L
		ADD		A,$06
		LD		L,A
		DJNZ	$9DFD
		EX		DE,HL
		EXX
		RET
L9E07:	EXX
		LD		B,A
		EX		DE,HL
		LD		E,$00
L9E0C:	LD		(HL),E
		INC		L
		LD		(HL),E
		LD		A,L
		ADD		A,$05
		LD		L,A
		DJNZ	$9E0C
		EX		DE,HL
		EXX
		RET

	;; Set FloorAddr to the floor sprite indexed in A.
SetFloorAddr:	LD	C,A
		ADD	A,A
		ADD	A,C
		ADD	A,A
		ADD	A,A
		ADD	A,A
		LD	L,A
		LD	H,$00
		ADD	HL,HL		; x $30 (floor tile size)
		LD	DE,$F610
		ADD	HL,DE	 	; Add to floor tile base.
		LD	(FloorAddr),HL
		RET

	;; Address of the sprite used to draw the floor.
FloorAddr:	DEFW $F670

GetFloorAddr:	PUSH	AF
		EXX
		LD	A,(HL)
		OR	$FA	
		INC	A	; If bottom two bits are set...
		EXX
		JR	Z,GFA_1	; jump.
		LD	A,C
		LD	BC,(FloorAddr)
		ADD	A,C	; Add old C to FloorAddr and return in BC.
		LD	C,A
		ADC	A,B
		SUB	C
		LD	B,A
		POP	AF
		RET
GFA_1:		LD	BC,$F760
		POP	AF
		RET

L9E46:	LD		B,A
		LD		A,D
		BIT		7,(HL)
		EXX
		LD		C,$00
		JR		Z,$9E51
		LD		C,$10
L9E51:		CALL	GetFloorAddr
		AND		$0F
		ADD		A,A
		LD		H,$00
		LD		L,A
		EXX
L9E5B:	EXX
		PUSH	HL
		ADD		HL,BC
		LD		A,(HL)
		LD		(DE),A
		INC		HL
		INC		E
		LD		A,(HL)
		LD		(DE),A
		LD		A,E
		ADD		A,$05
		LD		E,A
		POP		HL
		LD		A,L
		ADD		A,$02
		AND		$1F
		LD		L,A
		EXX
		DJNZ	$9E5B
		RET
L9E73:	LD		B,A
		LD		A,D
		BIT		7,(HL)
		EXX
		LD		C,$01
		JR		Z,$9E8B
		LD		C,$11
		JR		$9E8B
L9E80:	LD		B,A
		LD		A,D
		BIT		7,(HL)
		EXX
		LD		C,$00
		JR		Z,$9E8B
		LD		C,$10
L9E8B:		CALL	GetFloorAddr
		AND		$0F
		ADD		A,A
		LD		H,$00
		LD		L,A
		EXX
L9E95:	EXX
		PUSH	HL
		ADD		HL,BC
		LD		A,(HL)
		LD		(DE),A
		LD		A,E
		ADD		A,$06
		LD		E,A
		POP		HL
		LD		A,L
		ADD		A,$02
		AND		$1F
		LD		L,A
		EXX
		DJNZ	$9E95
		RET
L9EA9:	EXX
		INC		HL
		JR		$9EAE
L9EAD:	EXX
L9EAE:	LD		B,A
L9EAF:	LD		A,(HL)
		LD		(DE),A
		INC		HL
		INC		HL
		LD		A,E
		ADD		A,$06
		LD		E,A
		DJNZ	$9EAF
		EXX
		RET
L9EBB:	EXX
		LD		B,A
L9EBD:	LD		A,(HL)
		LD		(DE),A
		INC		HL
		INC		E
		LD		A,(HL)
		LD		(DE),A
		INC		HL
		LD		A,E
		ADD		A,$05
		LD		E,A
		DJNZ	$9EBD
		EXX
		RET

	;; Flip a 56-byte-high wall panel
FlipPanel:	LD		B,$38
	;; Reverse a two-byte-wide image. Height in B, pointer to data in HL.
FlipSprite:	PUSH	DE
		LD	D,$B9
		PUSH	HL
FS_1:		INC	HL
		LD	E,(HL)
		LD	A,(DE)
		DEC	HL
		LD	E,(HL)
		LD	(HL),A
		INC	HL
		LD	A,(DE)
		LD	(HL),A
		INC	HL
		DJNZ	FS_1
		POP	HL
		POP	DE
		RET

L9EE1:	DEFB $00

	;; Return the panel address in HL, given panel index in A.
GetPanelAddr:	AND	$03	; Limit to 0-3
		ADD	A,A
		ADD	A,A
		LD	C,A 	; 4x
		ADD	A,A
		ADD	A,A
		ADD	A,A	; 32x
		SUB	C	; 28x
		ADD	A,A	; 56x
		LD	L,A
		LD	H,$00	; 112x
		ADD	HL,HL
		LD	BC,(PanelBase)
		ADD	HL,BC	; Add on to contents of PanelBase and return.
		RET
	
L9EF6:	DEC		A
		ADD		A,A
		EXX
		LD		C,A
		LD		B,$00
		LD		A,($ADA4)
		INC		A
		LD		($ADA4),A
		CP		$05
		LD		HL,$9F3A
		JR		NZ,$9F0D
		LD		HL,$9F40
L9F0D:	ADD		HL,BC
		LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		LD		($9F25),HL
		LD		($9F30),HL
		EXX
		EX		AF,AF'
		PUSH	AF
		LD		A,($A057)
		PUSH	DE
		LD		DE,$BF20
		LD		B,$00
		CALL	$0000
		EX		DE,HL
		POP		HL
		PUSH	DE
		LD		A,($A057)
		LD		B,$FF
		CALL	$0000
		LD		HL,$BF20
		POP		DE
		POP		AF
		INC		A
		EX		AF,AF'
		RET
L9F3A:	DEFB $46,$9F,$98,$9F,$6F,$9F,$BB,$9F,$2B,$A0,$F3,$9F
L9F46:	PUSH	DE
L9F47:	EX		AF,AF'
		LD		E,B
		LD		A,(HL)
		INC		HL
		LD		C,(HL)
		INC		HL
		LD		D,(HL)
		INC		HL
		RRC		E
		RRA
		RR		C
		RR		D
		RR		E
		RRA
		RR		C
		RR		D
		RR		E
		EX		(SP),HL
		LD		(HL),A
		INC		HL
		LD		(HL),C
		INC		HL
		LD		(HL),D
		INC		HL
		LD		(HL),E
		INC		HL
		EX		(SP),HL
		EX		AF,AF'
		DEC		A
		JR		NZ,$9F47
		POP		HL
		RET
L9F6F:	PUSH	DE
L9F70:	EX		AF,AF'
		LD		E,B
		LD		A,(HL)
		INC		HL
		LD		C,(HL)
		INC		HL
		LD		D,(HL)
		INC		HL
		RLC		E
		RL		D
		RL		C
		RLA
		RL		E
		RL		D
		RL		C
		RLA
		RL		E
		EX		(SP),HL
		LD		(HL),E
		INC		HL
		LD		(HL),A
		INC		HL
		LD		(HL),C
		INC		HL
		LD		(HL),D
		INC		HL
		EX		(SP),HL
		EX		AF,AF'
		DEC		A
		JR		NZ,$9F70
		POP		HL
		RET
L9F98:	LD		C,B
		LD		B,A
		LD		A,C
		PUSH	BC
		LD		C,$FF
		PUSH	DE
L9F9F:	LDI
		LDI
		LDI
		LD		(DE),A
		INC		DE
		DJNZ	$9F9F
		POP		HL
		POP		BC
		LD		A,C
L9FAC:	RRD
		INC		HL
		RRD
		INC		HL
		RRD
		INC		HL
		RRD
		INC		HL
		DJNZ	$9FAC
		RET
L9FBB:	PUSH	DE
		LD		C,$1E
		LD		($9FC3),BC
L9FC2:	EX		AF,AF'
		LD		E,$00
		LD		A,(HL)
		INC		HL
		LD		B,(HL)
		INC		HL
		LD		C,(HL)
		INC		HL
		LD		D,(HL)
		INC		HL
		RRC		E
		RRA
		RR		B
		RR		C
		RR		D
		RR		E
		RRA
		RR		B
		RR		C
		RR		D
		RR		E
		EX		(SP),HL
		LD		(HL),A
		INC		HL
		LD		(HL),B
		INC		HL
		LD		(HL),C
		INC		HL
		LD		(HL),D
		INC		HL
		LD		(HL),E
		INC		HL
		EX		(SP),HL
		EX		AF,AF'
		DEC		A
		JR		NZ,$9FC2
		POP		HL
		RET
L9FF3:	PUSH	DE
		LD		C,$1E
		LD		($9FFB),BC
L9FFA:	EX		AF,AF'
		LD		E,$00
		LD		A,(HL)
		INC		HL
		LD		B,(HL)
		INC		HL
		LD		C,(HL)
		INC		HL
		LD		D,(HL)
		INC		HL
		RLC		E
		RL		D
		RL		C
		RL		B
		RLA
		RL		E
		RL		D
		RL		C
		RL		B
		RLA
		RL		E
		EX		(SP),HL
		LD		(HL),E
		INC		HL
		LD		(HL),A
		INC		HL
		LD		(HL),B
		INC		HL
		LD		(HL),C
		INC		HL
		LD		(HL),D
		INC		HL
		EX		(SP),HL
		EX		AF,AF'
		DEC		A
		JR		NZ,$9FFA
		POP		HL
		RET
LA02B:	LD		C,B
		LD		B,A
		LD		A,C
		PUSH	BC
		LD		C,$FF
		PUSH	DE
LA032:	LDI
		LDI
		LDI
		LDI
		LD		(DE),A
		INC		DE
		DJNZ	$A032
		POP		HL
		POP		BC
LA040:	RRD
		INC		HL
		RRD
		INC		HL
		RRD
		INC		HL
		RRD
		INC		HL
		RRD
		INC		HL
		DJNZ	$A040
		RET
LA052:	DEFB $66,$60,$70,$50,$00,$00,$00,$00,$00,$00,$00
LA05D:	INC		HL
		INC		HL
		CALL	$A1D8
		LD		($A058),BC
		LD		($A05A),HL
		RET

	
LA06A:		INC		HL
		INC		HL
		CALL		$A1D8
		LD		DE,($A05A)
		LD		A,H
		CP		D
		JR		NC,$A078
		LD		D,H
LA078:		LD		A,E
		CP		L
		JR		NC,$A07D
		LD		E,L
LA07D:		LD		HL,($A058)
		LD		A,B
		CP		H
		JR		NC,$A085
		LD		H,B
LA085:		LD		A,L
		CP		C
		RET		NC
		LD		L,C
		RET


LA08A:		LD		A,L
		ADD		A,$03
		AND		$FC
		LD		L,A
		LD		A,H
		AND		$FC
		LD		H,A
		LD		($A052),HL
		RET


LA098:		CALL	$A08A
		JR	$A0AF

LA09D:		LD	A,$48
		CP	E
		RET	NC
		LD	D,$48
		JR	$A0B6

LA0A5:		CALL	$A06A
LA0A8:		CALL	$A08A
		LD	A,E
		CP	$F1
		RET	NC
LA0AF:		LD	A,D
		CP	E
		RET	NC
		CP	$48
		JR	C,$A09D

	;; TODO: This function is seriously epic...
LA0B6:		LD		($A054),DE
		CALL	$9BBE
		LD		A,($7716)
		AND		$0C
		JR		Z,$A109
		LD		E,A
		AND		$08
		JR		Z,$A0EC
		LD		BC,($A052)
		LD		HL,$84C9
		LD		A,B
		CP		(HL)
		JR		NC,$A0EC
		LD		A,($A055)
		ADD		A,B
		RRA
		LD		D,A
		LD		A,($84C7)
		CP		D
		JR		C,$A0EC
		LD		HL,$AF82
		PUSH		DE
		CALL		$A11E
		POP		DE
		BIT		2,E
		JR		Z,$A109
LA0EC:		LD		BC,($A052)
		LD		A,($84C9)
		CP		C
		JR		NC,$A109
		LD		A,($A055)
		SUB		C
		CCF
		RRA
		LD		D,A
		LD		A,($84C8)
		CP		D
		JR		C,$A109
		LD		HL,$AF86
		CALL	$A11E
LA109:		LD		HL,$AF8A
		CALL	$A11E
		LD		HL,$AF7E
		CALL	$A11E
		LD		HL,$AF8E
		CALL	$A11E
		JP		$93E8
LA11E:		LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		OR		H
		RET		Z
		LD		($A12B),HL
		CALL	$A12F
		LD		HL,$0000
		JR		$A11E
LA12F:		CALL	$A1BD
		RET		NC
		LD		($A057),A
		LD		A,H
		ADD		A,A
		ADD		A,H
		ADD		A,A
		EXX
		SRL		H
		SRL		H
		ADD		A,H
		LD		E,A
		LD		D,$B8
		PUSH	DE
		PUSH	HL
		EXX
		LD		A,L
		NEG
		LD		B,A
		LD		A,($ADA4)
		AND		$04
		LD		A,B
		JR		NZ,$A156
		ADD		A,A
		ADD		A,B
		JR		$A158
LA156:		ADD		A,A
		ADD		A,A
LA158:		PUSH	AF
		CALL	GetSpriteAddr
		POP		BC
		LD		C,B
		LD		B,$00
		ADD		HL,BC
		EX		DE,HL
		ADD		HL,BC
		LD		A,($A056)
		AND		$03
		CALL	NZ,$9EF6
		POP		BC
		LD		A,C
		NEG
		ADD		A,$03
		RRCA
		RRCA
		AND		$07
		LD		C,A
		LD		B,$00
		ADD		HL,BC
		EX		DE,HL
		ADD		HL,BC
		POP		BC
		EXX
		LD		A,($ADA4)
		SUB		$03
		ADD		A,A
		LD		E,A
		LD		D,$00
		LD		HL,$A19F
		ADD		HL,DE
		LD		E,(HL)
		INC		HL
		LD		D,(HL)
		EX		AF,AF'
		DEC		A
		RRA
		AND		$0E
		LD		L,A
		LD		H,$00
		ADD		HL,DE
		LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		LD		A,($A057)
		LD		B,A
		JP		(HL)
		AND		L
		AND		C
		XOR		E
		AND		C
		OR		E
		AND		C
		DEC		H
		SBC		A,D
		LD		A,($569A)
		SBC		A,D
		LD		A,C
		SBC		A,D
		SUB		B
		SBC		A,D
		XOR		(HL)
		SBC		A,D
		OUT		($9A),A
		CP		$9A
		RLA
		SBC		A,E
		SCF
		SBC		A,E
		LD		E,(HL)
		SBC		A,E
		ADC		A,E
		SBC		A,E
LA1BD:		CALL	$A1F0
		LD		A,B
		LD		($A056),A
		PUSH	HL
		LD		DE,($A052)
		CALL	$A20C
		EXX
		POP		BC
		RET		NC
		EX		AF,AF'
		LD		DE,($A054)
		CALL	$A20C
		RET


	
LA1D8:	INC		HL
		INC		HL
		LD		A,(HL)
		BIT		3,A
		JR		Z,$A1F3
		CALL	$A1F3
		LD		A,($A05C)
		BIT		5,A
		LD		A,$F0
		JR		Z,$A1ED
		LD		A,$F4
LA1ED:	ADD		A,H
		LD		H,A
		RET
LA1F0:	INC		HL
		INC		HL
		LD		A,(HL)
LA1F3:	BIT		4,A
		LD		A,$00
		JR		Z,$A1FB
		LD		A,$80
LA1FB:	EX		AF,AF'
		INC		HL
		CALL	$A231
		INC		HL
		INC		HL
		LD		A,(HL)
		LD		($A05C),A
		DEC		HL
		EX		AF,AF'
		XOR		(HL)
		JP		$ADB7
LA20C:	LD		A,D
		SUB		C
		RET		NC
		LD		A,B
		SUB		E
		RET		NC
		NEG
		LD		L,A
		LD		A,B
		SUB		D
		JR		C,$A224
		LD		H,A
		LD		A,C
		SUB		B
		LD		C,L
		LD		L,$00
		CP		C
		RET		C
		LD		A,C
		SCF
		RET
LA224:	LD		L,A
		LD		A,C
		SUB		D
		LD		C,A
		LD		A,E
		SUB		D
		CP		C
		LD		H,$00
		RET		C
		LD		A,C
		SCF
		RET
LA231:	LD		A,(HL)
		LD		D,A
		INC		HL
		LD		E,(HL)
		SUB		E
		ADD		A,$80
		LD		C,A
		INC		HL
		LD		A,(HL)
		ADD		A,A
		SUB		E
		SUB		D
		ADD		A,$7F
		LD		B,A
		RET

LA242:		LD	DE,$7703
		LD	A,(DE)
		LD	HL,($7701)
		LD	C,A
		XOR	A
LA24B:		RL	C
		JR	Z,$A255
LA24F:		RLA
		DJNZ	$A24B
		EX	DE,HL
		LD	(HL),C
		RET
LA255:		INC	HL
		LD	($7701),HL
		LD	C,(HL)
		SCF
		RL	C
		JP	$A24F

LA260:	LD		HL,($7748)
		LD		A,L
		CP		H
		JR		C,$A268
		LD		A,H
LA268:	NEG
		ADD		A,$C0
		LD		HL,$774C
		CP		(HL)
		JR		C,$A273
		LD		(HL),A
LA273:	LD		A,(HL)
		JP		$84E4

FillZero:	LD	E,$00
	;; HL = Dest, BC = Size, E = value
FillValue:	LD	(HL),E
		INC	HL
		DEC	BC
		LD	A,B
		OR	C
		JR	NZ,FillValue
		RET

LA281:	DEFB $09,$00,$00,$00,$00,$00,$08,$08,$00,$00,$00,$00,$00,$00,$00,$04
LA291:	DEFB $04,$00,$00,$03,$01,$00,$00,$03,$02,$03,$00,$00,$FF,$00,$00,$FF
LA2A1:	DEFB $02,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$20,$28,$0B,$C0
LA2B1:	DEFB $24,$08,$12,$FF,$FF,$00,$00,$08,$00,$00,$0F,$00,$00,$00,$FF,$00
LA2C1:	DEFB $00,$00,$00,$08,$28,$0B,$C0,$18,$21,$00,$FF,$FF,$00,$00,$00,$00
LA2D1:	DEFB $00,$00,$00,$00,$00,$08,$28,$0B,$C0,$1F,$25,$00,$FF,$FF,$00,$00
LA2E1:	DEFB $00,$00,$00,$00,$18,$19,$18,$1A,$00,$00,$1B,$1C,$1B,$1D,$00,$00
LA2F1:	DEFB $1E,$1F,$1E,$20,$00,$00,$21,$22,$21,$23,$00,$00,$24,$A4,$A5,$25
LA301:	DEFB $A5,$A6,$26,$26,$A6,$A6,$26,$26,$00,$00,$26,$A6,$26,$A6,$A5,$25
LA311:	DEFB $24,$A5,$00,$00,$40
LA316:	LD		HL,$A314
		LD		A,$80
		XOR		(HL)
		LD		(HL),A
		LD		A,($C043)
		BIT		0,A
		LD		HL,$D12D
		LD		DE,$A355
		JR		Z,$A32E
		DEC		HL
		LD		DE,$A349
LA32E:	PUSH	DE
		PUSH	HL
		CALL	$A339
		LD		DE,$0048
		POP		HL
		ADD		HL,DE
		POP		DE
LA339:	LD		C,$06
LA33B:	LD		B,$02
LA33D:	LD		A,(DE)
		XOR		(HL)
		LD		(HL),A
		INC		DE
		INC		HL
		DJNZ	$A33D
		INC		HL
		DEC		C
		JR		NZ,$A33B
		RET
LA349:	DEFB $00,$C0,$01,$D8,$00,$1C,$00,$84,$00,$10,$00,$20,$03,$00,$1B,$80
LA359:	DEFB $38,$00,$21,$00,$08,$00,$04,$00
LA361:	LD		A,($A314)
		RLA
		CALL	C,$A316
		LD		HL,$B219
		LD		A,(HL)
		AND		A
		JR		Z,$A37E
		EXX
		LD		HL,$A294
		LD		A,($B21A)
		AND		(HL)
		EXX
		JP		NZ,$A4B8
		CALL	$A4B8
LA37E:	LD		HL,$A296
		LD		A,(HL)
		AND		A
		JP		NZ,$A4A9
		INC		HL
		OR		(HL)
		JP		NZ,$A4A2
		LD		HL,$A298
		DEC		(HL)
		JR		NZ,$A3A8
		LD		(HL),$03
		LD		HL,($A294)
		LD		A,H
		ADD		A,A
		OR		H
		OR		L
		RRA
		PUSH	AF
		LD		A,$02
		CALL	C,$89C4
		POP		AF
		RRA
		LD		A,$03
		CALL	C,$89C4
LA3A8:	LD		A,$FF
		LD		($A2BF),A
		LD		A,($B218)
		AND		A
		JR		Z,$A3C6
		LD		A,($A2BC)
		AND		A
		JR		Z,$A3C3
		LD		A,($A2BB)
		SCF
		RLA
		LD		($703F),A
		JR		$A3C6
LA3C3:	LD		($B218),A
LA3C6:	CALL	$A597
LA3C9:	CALL	$A94B
		PUSH	HL
		POP		IY
		LD		A,(IY+$07)
		CP		$84
		JR		NC,$A3E5
		XOR		A
		LD		($A29F),A
		LD		A,($7712)
		AND		A
		JR		NZ,$A3E5
		LD		A,$06
		LD		($B218),A
LA3E5:	LD		A,($7042)
		RRA
		JR		NC,$A451
		LD		A,($A294)
		OR		$FD
		INC		A
		LD		HL,$A2BC
		OR		(HL)
		JR		NZ,$A44E
		LD		A,($A28B)
		OR		$F9
		INC		A
		JR		NZ,$A44E
		LD		A,($A2B8)
		CP		$08
		JR		NZ,$A44E
		LD		HL,$A2D7
		LD		DE,$A2AE
		LD		BC,$0003
		LDIR
		LD		HL,$A2A9
		PUSH	HL
		POP		IY
		LD		A,($703D)
		OR		$19
		LD		($A2B3),A
		LD		(IY+$04),$00
		LD		A,($A2BB)
		LD		($A2B4),A
		LD		(IY+$0C),$FF
		LD		(IY+$0F),$20
		CALL	$B03B
		LD		A,$06
		CALL	$89C4
		LD		B,$48
		CALL	PlaySound
		LD		A,($A292)
		AND		A
		JR		NZ,$A451
		LD		HL,$A28B
		RES		2,(HL)
		CALL	$8E1D
		JR		$A451
LA44E:	CALL	$719E
LA451:	LD		HL,$B218
		LD		A,(HL)
		AND		$7F
		RET		Z
		LD		A,($B219)
		AND		A
		JR		Z,$A461
		LD		(HL),$00
		RET
LA461:	LD		A,($A295)
		AND		A
		JR		Z,$A499
		CALL	$A94B
		PUSH	HL
		POP		IY
		CALL	$B0C6
		LD		A,($A294)
		CP		$03
		JR		Z,$A499
		LD		HL,$A2A6
		CP		(HL)
		JR		Z,$A482
		XOR		$03
		LD		(HL),A
		JR		$A48D
LA482:	LD		HL,$FB49
		LD		DE,$A2A2
		LD		BC,$0005
		LDIR
LA48D:	LD		HL,$0000
		LD		($A2CD),HL
		LD		($A2DF),HL
		CALL	$72A0
LA499:	LD		HL,$0000
		LD		($A2A7),HL
		JP		$70BA
LA4A2:	DEC		(HL)
		LD		HL,($A294)
		JP		$A543
LA4A9:	DEC		(HL)
		LD		HL,($A294)
		JP		NZ,$A54C
		LD		A,$07
		LD		($B218),A
		JP		$A3C9
LA4B8:	DEC		(HL)
		JP		NZ,$A549
		LD		HL,$0000
		LD		($A2A7),HL
		LD		HL,$A290
		LD		BC,($B21A)
		LD		B,$02
		LD		D,$FF
LA4CD:	RR		C
		JR		NC,$A4DA
		LD		A,(HL)
		SUB		$01
		DAA
		LD		(HL),A
		JR		NZ,$A4DA
		LD		D,$00
LA4DA:	INC		HL
		DJNZ	$A4CD
		DEC		HL
		LD		A,(HL)
		DEC		HL
		OR		(HL)
		JP		Z,$7046
		LD		A,D
		AND		A
		JR		NZ,$A521
		LD		HL,$A290
		LD		A,($A295)
		AND		A
		JR		Z,$A50F
		LD		A,($A2A6)
		CP		$03
		JR		NZ,$A504
		LD		A,(HL)
		AND		A
		LD		A,$01
		JR		NZ,$A4FF
		INC		A
LA4FF:	LD		($A2A6),A
		JR		$A521
LA504:	RRA
		JR		C,$A508
		INC		HL
LA508:	LD		A,(HL)
		AND		A
		JR		NZ,$A51E
		LD		($A295),A
LA50F:	CALL	$71BF
		LD		HL,$0000
		LD		($B219),HL
LA518:	LD		HL,$FB28
		SET		0,(HL)
		RET
LA51E:	CALL	$A518
LA521:	LD		A,($A2A6)
		LD		($A294),A
		CALL	$A58B
		CALL	$A94B
		LD		DE,$0005
		ADD		HL,DE
		EX		DE,HL
		LD		HL,$A2A3
		LD		BC,$0003
		LDIR
		LD		A,($A2A2)
		LD		($B218),A
		JP		$70E6
LA543:	PUSH	HL
		LD		HL,$A30A
		JR		$A550
LA549:	LD		HL,($B21A)
LA54C:	PUSH	HL
		LD		HL,$A2FC
LA550:	LD		IY,$A2C0
		CALL	$8CF0
		POP		HL
		PUSH	HL
		BIT		1,L
		JR		Z,$A572
		PUSH	AF
		LD		($A2DA),A
		RES		3,(IY+$16)
		LD		HL,$A2D2
		CALL	$A05D
		LD		HL,$A2D2
		CALL	$A0A5
		POP		AF
LA572:	POP		HL
		RR		L
		RET		NC
		XOR		$80
		LD		($A2C8),A
		RES		3,(IY+$04)
		LD		HL,$A2C0
		CALL	$A05D
		LD		HL,$A2C0
		JP		$A0A5
LA58B:	AND		$01
		RLCA
		RLCA
		LD		HL,$7041
		RES		2,(HL)
		OR		(HL)
		LD		(HL),A
		RET
LA597:	CALL	$A94B
		PUSH	HL
		POP		IY
		LD		A,$3F
		LD		($A2BD),A
		LD		A,($A2BC)
		CALL	$AF96
		CALL	$A94B
		CALL	$A05D
		LD		HL,$A29F
		LD		A,(HL)
		AND		A
		JR		Z,$A608
		LD		A,($A2BC)
		AND		A
		JR		Z,$A5BF
		LD		(HL),$00
		JR		$A608
LA5BF:	DEC		(HL)
		CALL	$A94B
		CALL	$AC41
		JR		C,$A5D2
		DEC		(IY+$07)
		LD		A,$84
		CALL	$A931
		JR		$A5E3
LA5D2:	EX		AF,AF'
		LD		A,$88
		BIT		4,(IY+$0B)
		SET		4,(IY+$0B)
		CALL	Z,$A931
		EX		AF,AF'
		JR		Z,$A5EE
LA5E3:	RES		4,(IY+$0B)
		SET		5,(IY+$0B)
		DEC		(IY+$07)
LA5EE:	LD		A,($A294)
		AND		$02
		JR		NZ,$A5FB
LA5F5:	LD		A,($A2BB)
		JP		$A669
LA5FB:	LD		A,($703F)
		RRA
		CALL	$8C90
		INC		A
		JP		NZ,$A665
		JR		$A5F5
LA608:	SET		4,(IY+$0B)
		SET		5,(IY+$0C)
		CALL	$A94B
		LD		A,($B218)
		AND		A
		JR		NZ,$A622
		CALL	$AA74
		JP		NC,$A724
		JP		NZ,$A712
LA622:	LD		A,($B218)
		RLA
		JR		NC,$A62C
		LD		(IY+$0C),$FF
LA62C:	LD		A,$86
		BIT		5,(IY+$0B)
		SET		5,(IY+$0B)
		CALL	Z,$A931
		BIT		4,(IY+$0C)
		SET		4,(IY+$0C)
		JR		NZ,$A65B
		CALL	$A94B
		CALL	$AC41
		JR		NC,$A654
		JR		NZ,$A654
		LD		A,$88
		CALL	$A931
		JR		$A65B
LA654:	DEC		(IY+$07)
		RES		4,(IY+$0B)
LA65B:	XOR		A
		LD		($A29E),A
		CALL	$A89A
		CALL	$A820
LA665:	LD		A,($703F)
		RRA
LA669:	CALL	$A788
		CALL	$A774
		EX		AF,AF'
		LD		A,($A2A0)
		INC		A
		JR		NZ,$A69C
		XOR		A
		LD		HL,$A294
		BIT		0,(HL)
		JR		Z,$A684
		LD		($A2E4),A
		LD		($A2EA),A
LA684:	BIT		1,(HL)
		JR		Z,$A68E
		LD		($A2F0),A
		LD		($A2F6),A
LA68E:	EX		AF,AF'
		LD		BC,$1B21
		JR		C,$A6CC
		CALL	$A700
		LD		BC,$181F
		JR		$A6CC
LA69C:	EX		AF,AF'
		LD		HL,$A2E4
		LD		DE,$A2F0
		JR		NC,$A6AB
		LD		HL,$A2EA
		LD		DE,$A2F6
LA6AB:	PUSH	DE
		LD		A,($A294)
		RRA
		JR		NC,$A6B8
		CALL	$8CF0
		LD		($A2C8),A
LA6B8:	POP		HL
		LD		A,($A294)
		AND		$02
		JR		Z,$A6C6
		CALL	$8CF0
		LD		($A2DA),A
LA6C6:	SET		5,(IY+$0B)
		JR		$A6E4
LA6CC:	SET		5,(IY+$0B)
LA6D0:	LD		A,($A294)
		RRA
		JR		NC,$A6D9
		LD		(IY+$08),B
LA6D9:	LD		A,($A294)
		AND		$02
		JR		Z,$A6E4
		LD		A,C
		LD		($A2DA),A
LA6E4:	LD		A,($A2BF)
		LD		(IY+$0C),A
		CALL	$A94B
		CALL	$B0BE
		CALL	$AA42
		XOR		A
		CALL	$AF96
		CALL	$A94B
		CALL	$A0A5
		JP		$A938
LA700:	LD		HL,$A315
		DEC		(HL)
		LD		A,$03
		SUB		(HL)
		RET		C
		JR		Z,$A70F
		CP		$03
		RET		NZ
		LD		(HL),$40
LA70F:	JP		$A316
LA712:	LD		HL,$A29E
		LD		A,(HL)
		AND		A
		LD		(HL),$FF
		JR		Z,$A729
		CALL	$A89A
		CALL	$A820
		XOR		A
		JR		$A729
LA724:	XOR		A
		LD		($A29E),A
		INC		A
LA729:	LD		C,A
		CALL	$A81A
		RES		5,(IY+$0B)
		LD		A,($A294)
		AND		$02
		JR		NZ,$A73E
		DEC		C
		JR		NZ,$A756
		INC		(IY+$07)
LA73E:	INC		(IY+$07)
		AND		A
		JR		NZ,$A759
		LD		A,$82
		CALL	$A931
		LD		HL,$A293
		LD		A,(HL)
		AND		A
		JR		Z,$A765
		DEC		(HL)
		LD		A,($A2BB)
		JR		$A762
LA756:	INC		(IY+$07)
LA759:	LD		A,$83
		CALL	$A931
		LD		A,($703F)
		RRA
LA762:	CALL	$A788
LA765:	CALL	$A774
		LD		BC,$1B21
		JP		C,$A6D0
		LD		BC,$184D
		JP		$A6D0
LA774:	LD		A,($A2BB)
		CALL	$8C90
		RRA
		RES		4,(IY+$04)
		RRA
		JR		C,$A786
		SET		4,(IY+$04)
LA786:	RRA
		RET
LA788:	OR		$F0
		CP		$FF
		LD		($A2A0),A
		JR		Z,$A7A3
		EX		AF,AF'
		XOR		A
		LD		($A2A0),A
		LD		A,$80
		CALL	$A931
		EX		AF,AF'
		LD		HL,$A2BB
		CP		(HL)
		LD		(HL),A
		JR		Z,$A7A8
LA7A3:	CALL	$A81A
		LD		A,$FF
LA7A8:	PUSH	AF
		AND		A,(IY+$0C)
		CALL	$8C90
		CP		$FF
		JR		Z,$A7C6
		CALL	$A94B
		CALL	$B21C
		JR		NC,$A7D0
		LD		A,(IY+$0B)
		OR		$F0
		INC		A
		LD		A,$88
		CALL	NZ,$A931
LA7C6:	POP		AF
		LD		A,(IY+$0B)
		OR		$0F
		LD		(IY+$0B),A
		RET
LA7D0:	CALL	$A94B
		CALL	$8CD6
		POP		BC
		LD		HL,$A2A1
		LD		A,(HL)
		AND		A
		JR		Z,$A7E0
		DEC		(HL)
		RET
LA7E0:	LD		HL,$A28C
		LD		A,($A294)
		AND		$01
		OR		(HL)
		RET		Z
		LD		HL,$A299
		DEC		(HL)
		PUSH	BC
		JR		NZ,$A7FE
		LD		(HL),$02
		LD		A,($A294)
		RRA
		JR		C,$A7FE
		LD		A,$00
		CALL	$89C4
LA7FE:	LD		A,$81
		CALL	$A931
		POP		AF
		CALL	$8C90
		CP		$FF
		RET		Z
		CALL	$A94B
		PUSH	HL
		CALL	$B21C
		POP		HL
		JP		NC,$8CD6
		LD		A,$88
		JP		$A931
LA81A:	LD		A,$02
		LD		($A2A1),A
		RET
LA820:	LD		A,($A294)
		LD		B,A
		DEC		A
		JR		NZ,$A82B
		XOR		A
		LD		($A293),A
LA82B:	LD		A,($A2BC)
		AND		A
		RET		NZ
		LD		A,($703F)
		RRA
		RET		C
		LD		C,$00
		LD		L,(IY+$0D)
		LD		H,(IY+$0E)
		LD		A,H
		OR		L
		JR		Z,$A863
		PUSH	HL
		POP		IX
		BIT		0,(IX+$09)
		JR		Z,$A851
		LD		A,(IX+$0B)
		OR		$CF
		INC		A
		RET		NZ
LA851:	LD		A,(IX+$08)
		AND		$7F
		CP		$57
		JR		Z,$A88F
		CP		$2B
		JR		Z,$A862
		CP		$2C
		JR		NZ,$A863
LA862:	INC		C
LA863:	LD		A,($A294)
		AND		$02
		JR		NZ,$A873
		PUSH	BC
		LD		A,$01
		CALL	$89C4
		POP		BC
		JR		Z,$A874
LA873:	INC		C
LA874:	LD		A,C
		ADD		A,A
		ADD		A,A
		ADD		A,$04
		CP		$0C
		JR		NZ,$A87F
		LD		A,$0A
LA87F:	LD		($A29F),A
		LD		A,$85
		DEC		B
		JR		NZ,$A88C
		LD		HL,$A293
		LD		(HL),$07
LA88C:	JP		$A931
LA88F:	LD		HL,$080C
		LD		($A296),HL
		LD		B,$C7
		JP		PlaySound
LA89A:	LD		A,($7040)
		RRA
		RET		NC
		LD		A,($A28B)
		RRA
LA8A3:	JP		NC,$719E
		LD		A,($A294)
		AND		$01
		JR		Z,$A8A3
		LD		A,$87
		CALL	$A931
		LD		A,($A2A8)
		AND		A
		JR		NZ,$A8D3
		CALL	$A94B
		CALL	$AC12
		JR		NC,$A8A3
		LD		A,(IX+$08)
		PUSH	HL
		LD		($A2A7),HL
		LD		BC,$D8B0
		PUSH	AF
		CALL	$8E74
		POP		AF
		POP		HL
		JP		$8D4B
LA8D3:	LD		A,($A2BC)
		AND		A
		JP		NZ,$719E
		LD		C,(IY+$07)
		LD		B,$03
LA8DF:	CALL	$A94B
		PUSH	BC
		CALL	$AC41
		POP		BC
		JR		C,$A926
		DEC		(IY+$07)
		DEC		(IY+$07)
		DJNZ	$A8DF
		LD		HL,($A2A7)
		PUSH	HL
		LD		DE,$0007
		ADD		HL,DE
		PUSH	HL
		CALL	$A94B
		LD		DE,$0006
		ADD		HL,DE
		EX		DE,HL
		POP		HL
		LD		(HL),C
		EX		DE,HL
		DEC		DE
		LDD
		LDD
		POP		HL
		CALL	$8D7F
		LD		HL,$0000
		LD		($A2A7),HL
		LD		BC,$D8B0
		CALL	$8E92
		CALL	$A94B
		CALL	$AA74
		CALL	$A94B
		JP		$A05D
LA926:	LD		(IY+$07),C
		JP		$719E
LA92C:	LD		HL,$A2BE
		JR		$A934
LA931:	LD		HL,$A2BD
LA934:	CP		(HL)
		RET		C
		LD		(HL),A
		RET
LA938:	LD		A,($A2BD)
		OR		$80
		LD		B,A
		CP		$85
		JP		NC,PlaySound
		LD		A,($7CF8)
		AND		A
		RET		NZ
		JP		PlaySound
LA94B:	LD		HL,$A294
		BIT		0,(HL)
		LD		HL,$A2C0
		RET		NZ
		LD		HL,$A2D2
		RET
LA958:	XOR		A
		LD		($A2FC),A
		LD		($A296),A
		LD		($A30A),A
		LD		A,$08
		LD		($A2B8),A
		CALL	$7255
		LD		A,($A294)
		LD		($A2A6),A
		CALL	$A94B
		PUSH	HL
		PUSH	HL
		PUSH	HL
		POP		IY
		LD		A,($B218)
		LD		($A2A2),A
		PUSH	AF
		SUB		$01
		PUSH	AF
		CP		$04
		JR		NC,$A99D
		XOR		$01
		LD		E,A
		LD		D,$00
		LD		HL,$7744
		ADD		HL,DE
		LD		C,(HL)
		LD		HL,$AA6E
		ADD		HL,DE
		LD		A,($7716)
		AND		(HL)
		JR		NZ,$A99D
		LD		(IY+$07),C
LA99D:	CALL	$A94B
		LD		DE,$0005
		ADD		HL,DE
		EX		DE,HL
		POP		AF
		JR		C,$A9F2
		CP		$06
		JR		Z,$A9DA
		JR		NC,$A9ED
		CP		$04
		JR		NC,$A9C5
		LD		HL,$7718
		LD		C,$FD
		RRA
		JR		NC,$A9BC
		INC		DE
		INC		HL
LA9BC:	RRA
		JR		C,$A9FD
		LD		C,$03
		INC		HL
		INC		HL
		JR		$A9FD
LA9C5:	INC		DE
		INC		DE
		RRA
		LD		A,$84
		JR		NC,$A9D6
		LD		A,($7B8F)
		AND		A
		LD		A,$BA
		JR		Z,$A9D6
		LD		A,$B4
LA9D6:	LD		(DE),A
		POP		AF
		JR		$AA0C
LA9DA:	INC		DE
		INC		DE
		LD		A,($7B8F)
		AND		A
		JR		Z,$A9E6
		LD		A,(DE)
		SUB		$06
		LD		(DE),A
LA9E6:	LD		B,$C8
		CALL	PlaySound
		JR		$AA00
LA9ED:	LD		HL,$8ADF
		JR		$A9F5
LA9F2:	LD		HL,$AA64
LA9F5:	LDI
		LDI
		LDI
		JR		$AA00
LA9FD:	LD		A,(HL)
		ADD		A,C
		LD		(DE),A
LAA00:	POP		AF
		ADD		A,$67
		LD		L,A
		ADC		A,$AA
		SUB		L
		LD		H,A
		LD		A,(HL)
		LD		($A2BB),A
LAA0C:	LD		A,$80
		LD		($B218),A
		POP		HL
		LD		DE,$0005
		ADD		HL,DE
		LD		DE,$A2A3
		LD		BC,$0003
		LDIR
		LD		(IY+$0D),$00
		LD		(IY+$0E),$00
		LD		(IY+$0B),$FF
		LD		(IY+$0C),$FF
		POP		HL
		CALL	$B010
		CALL	$AA42
		XOR		A
		LD		($B219),A
		LD		($B21A),A
		LD		($7B8F),A
		JP		$AF96
LAA42:	LD		A,($AF77)
		LD		($A2BC),A
		RET
LAA49:	LD		A,($A294)
		LD		HL,$A295
		RRA
		OR		(HL)
		RRA
		RET		NC
		LD		HL,($A2A7)
		INC		H
		DEC		H
		RET		Z
		LD		DE,$0008
		ADD		HL,DE
		LD		A,(HL)
		LD		BC,$D8B0
		JP		$8E74
LAA64:	DEFB $28,$28,$C0,$FD,$FD,$FB,$FE,$F7,$FD,$FD,$08,$04,$02,$01,$00,$00
LAA74:	CALL	$AA7E
		LD		A,(IY+$07)
		SUB		C
		JP		$AB0B
LAA7E:	LD		C,$C0
		LD		A,($A2BC)
		AND		A
		RET		Z
		LD		IX,$7744
		LD		C,(IX+$00)
		LD		A,($771B)
		SUB		$03
		CP		A,(IY+$06)
		RET		C
		LD		C,(IX+$02)
		LD		A,($7719)
		ADD		A,$02
		CP		A,(IY+$06)
		RET		NC
		LD		C,(IX+$01)
		LD		A,($771A)
		SUB		$03
		CP		A,(IY+$05)
		RET		C
		LD		C,(IX+$03)
		RET
LAAB1:	CP		$FF
LAAB3:	SCF
		LD		(IY+$0D),A
		LD		(IY+$0E),A
		RET		NZ
		BIT		0,(IY+$09)
		JR		Z,$AAF9
		LD		A,($A2BC)
		AND		A
		JR		NZ,$AAF6
		LD		A,(FloorCode)
		CP		$06
		JR		Z,$AAED
		CP		$07
		JR		NZ,$AAF6
		CALL	$A94B
		PUSH	IY
		POP		DE
		AND		A
		SBC		HL,DE
		JR		Z,$AAE6
		LD		HL,$7041
		LD		A,(HL)
		OR		$03
		LD		(HL),A
		JR		$AAF6
LAAE6:	LD		A,$05
		LD		($B218),A
		AND		A
		RET
LAAED:	LD		C,(IY+$09)
		LD		B,(IY+$04)
		CALL	$B2F8
LAAF6:	XOR		A
		SCF
		RET
LAAF9:	LD		A,(FloorCode)
		CP		$07
		JR		NZ,$AAF6
		LD		(IY+$0A),$22
		JR		$AAF6
LAB06:	LD		A,(IY+$07)
		SUB		$C0
LAB0B:	LD		BC,$0000
		LD		($AA72),BC
		JR		Z,$AAB3
		INC		A
		JR		Z,$AAB1
		CALL	$B0F9
		LD		C,B
		INC		C
		EXX
		LD		A,(IY+$0E)
		AND		A
		JR		Z,$AB64
		LD		H,A
		LD		L,(IY+$0D)
		PUSH	HL
		POP		IX
		BIT		7,(IX+$04)
		JR		NZ,$AB64
		LD		A,(IX+$07)
		SUB		$06
		EXX
		CP		B
		EXX
		JR		NZ,$AB64
		CALL	$ACD3
		JR		NC,$AB64
LAB3F:	BIT		1,(IX+$09)
		JR		Z,$AB4E
		RES		5,(IX-$06)
		LD		A,(IX-$07)
		JR		$AB55
LAB4E:	RES		5,(IX+$0C)
		LD		A,(IX+$0B)
LAB55:	OR		$E0
		LD		C,A
		LD		A,(IY+$0C)
		AND		C
		LD		(IY+$0C),A
LAB5F:	XOR		A
		SCF
		JP		$B2BF
LAB64:	LD		HL,$AF80
LAB67:	LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		OR		H
		JR		Z,$ABA6
		PUSH	HL
		POP		IX
		BIT		7,(IX+$04)
		JR		NZ,$AB67
		LD		A,(IX+$07)
		SUB		$06
		EXX
		CP		B
		JR		NZ,$AB90
		EXX
		PUSH	HL
		CALL	$ACD3
		POP		HL
		JR		NC,$AB67
LAB88:	LD		(IY+$0D),L
		LD		(IY+$0E),H
		JR		$AB3F
LAB90:	CP		C
		EXX
		JR		NZ,$AB67
		LD		A,($AA73)
		AND		A
		JR		NZ,$AB67
		PUSH	HL
		CALL	$ACD3
		POP		HL
		JR		NC,$AB67
		LD		($AA72),HL
		JR		$AB67
LABA6:	LD		A,($A2BC)
		AND		A
		JR		Z,$ABE7
		CALL	$ACAF
		LD		A,($A294)
		CP		$03
		LD		A,$F4
		JR		Z,$ABBA
		LD		A,$FA
LABBA:	ADD		A,(IX+$07)
		EXX
		CP		B
		JR		NZ,$ABCB
		EXX
		PUSH	HL
		CALL	$ACD3
		POP		HL
		JR		NC,$ABE7
		JR		$AB88
LABCB:	CP		C
		EXX
		JR		NZ,$ABE7
		LD		A,($AA73)
		AND		A
		JR		NZ,$ABE7
		CALL	$ACAF
		CALL	$ACD3
		JR		NC,$ABE7
		LD		(IY+$0D),$00
		LD		(IY+$0E),$00
		JR		$AC0E
LABE7:	LD		HL,($AA72)
		LD		(IY+$0D),$00
		LD		(IY+$0E),$00
		LD		A,H
		AND		A
		RET		Z
		PUSH	HL
		POP		IX
		BIT		1,(IX+$09)
		JR		Z,$AC04
		BIT		4,(IX-$07)
		JR		$AC08
LAC04:	BIT		4,(IX+$0B)
LAC08:	JR		NZ,$AC0E
		RES		4,(IY+$0C)
LAC0E:	XOR		A
		SUB		$01
		RET
LAC12:	CALL	$B0F9
		LD		A,B
		ADD		A,$06
		LD		B,A
		INC		A
		LD		C,A
		EXX
		LD		HL,$AF80
LAC1F:	LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		OR		H
		RET		Z
		PUSH	HL
		POP		IX
		BIT		6,(IX+$04)
		JR		Z,$AC1F
		LD		A,(IX+$07)
		EXX
		CP		B
		JR		Z,$AC36
		CP		C
LAC36:	EXX
		JR		NZ,$AC1F
		PUSH	HL
		CALL	$ACD3
		POP		HL
		JR		NC,$AC1F
		RET
LAC41:	CALL	$B0F9
		LD		B,C
		DEC		B
		EXX
		XOR		A
		LD		($AA72),A
		LD		HL,$AF80
LAC4E:	LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		OR		H
		JR		Z,$AC97
		PUSH	HL
		POP		IX
		BIT		7,(IX+$04)
		JR		NZ,$AC4E
		LD		A,(IX+$07)
		EXX
		CP		C
		JR		NZ,$AC7F
		EXX
		PUSH	HL
		CALL	$ACD3
		POP		HL
		JR		NC,$AC4E
LAC6D:	LD		A,(IY+$0B)
		OR		$E0
		AND		$EF
		LD		C,A
		LD		A,(IX+$0C)
		AND		C
		LD		(IX+$0C),A
		JP		$AB5F
LAC7F:	CP		B
		EXX
		JR		NZ,$AC4E
		LD		A,($AA72)
		AND		A
		JR		NZ,$AC4E
		PUSH	HL
		CALL	$ACD3
		POP		HL
		JR		NC,$AC4E
		LD		A,$FF
		LD		($AA72),A
		JR		$AC4E
LAC97:	LD		A,($A2BC)
		AND		A
		JR		Z,$ACCC
		CALL	$ACAF
		LD		A,(IX+$07)
		EXX
		CP		C
		JR		NZ,$ACB6
		EXX
		CALL	$ACD3
		JR		NC,$ACCC
		JR		$AC6D
LACAF:	CALL	$A94B
		PUSH	HL
		POP		IX
		RET
LACB6:	CP		B
		EXX
		JR		NZ,$ACCC
		LD		A,($AA72)
		AND		A
		JR		NZ,$ACCC
		CALL	$ACAF
		CALL	$ACD3
		JR		NC,$ACCC
		LD		A,$FF
		JR		$ACCF
LACCC:	LD		A,($AA72)
LACCF:	AND		A
		RET		Z
		SCF
		RET
LACD3:	CALL	$ACE6
LACD6:	LD		A,E
		EXX
		CP		D
		LD		A,E
		EXX
		RET		NC
		CP		D
		RET		NC
		LD		A,L
		EXX
		CP		H
		LD		A,L
		EXX
		RET		NC
		CP		H
		RET
LACE6:	LD		A,(IX+$04)
		BIT		1,A
		JR		NZ,$AD03
		RRA
		LD		A,$03
		ADC		A,$00
		LD		C,A
		ADD		A,(IX+$05)
		LD		D,A
		SUB		C
		SUB		C
		LD		E,A
		LD		A,C
		ADD		A,(IX+$06)
		LD		H,A
		SUB		C
		SUB		C
		LD		L,A
		RET
LAD03:	RRA
		JR		C,$AD16
		LD		A,(IX+$05)
		ADD		A,$04
		LD		D,A
		SUB		$08
		LD		E,A
		LD		L,(IX+$06)
		LD		H,L
		INC		H
		DEC		L
		RET
LAD16:	LD		A,(IX+$06)
		ADD		A,$04
		LD		H,A
		SUB		$08
		LD		L,A
		LD		E,(IX+$05)
		LD		D,E
		INC		D
		DEC		E
		RET
LAD26:	LD		BC,($703B)
		LD		HL,$AD4C
		CALL	$AD35
		LD		($703B),DE
		RET
LAD35:	CALL	$AD42
		JR		Z,$AD42
		PUSH	DE
		CALL	$AD42
		POP		DE
		JR		NZ,$AD35
		RET
LAD42:	LD		A,C
		LD		E,(HL)
		INC		HL
		LD		D,(HL)
		INC		HL
		CP		E
		RET		NZ
		LD		A,B
		CP		D
		RET
LAD4C:	DEFB $40,$8A,$50,$71,$40,$89,$80,$04,$70,$BA,$00,$13,$00,$41,$80,$29
LAD5C:	DEFB $00,$A1,$00,$26,$00,$81,$80,$E9,$00,$84,$00,$B1,$00,$85,$20,$EF
LAD6C:	DEFB $00,$A4,$F0,$00,$00,$A5,$D0,$88,$D0,$BC,$D0,$DE,$B0,$2D,$D0,$8B
LAD7C:	DEFB $90,$11,$C0,$E1,$B0,$00,$C0,$E2,$B0,$10,$00,$C1,$F0,$8B,$F0,$00
LAD8C:	DEFB $30,$97,$20,$EF,$00,$1D,$00,$A8,$70,$BA,$00,$4E,$00,$88,$30,$1B
LAD9C:	DEFB $00,$4C,$30,$39,$30,$8B,$30,$8D,$04

	;; Current sprite we're drawing.
SpriteCode:	DEFB $00

	;; Initialise a look-up table of byte reverses.
InitRevTbl:	LD	HL,$B900
RevLoop_1:	LD	C,L
		LD	A,$01
		AND	A
RevLoop_2:	RRA
		RL	C
		JR	NZ,RevLoop_2
		LD	(HL),A
		INC	L
		JR	NZ,RevLoop_1
		RET

LADB7:		LD	(SpriteCode),A
		AND	$7F
		CP	$10
		JR	C,$ADF4
		LD	DE,$0606
		LD	H,$12
		CP	$54
		JR	C,$ADCE
		LD	DE,$0808
		LD	H,$14
LADCE:	CP		$18
		JR	NC,$ADE1
		LD	A,($A05C)
		AND	$02
		LD	D,$04
		LD	H,$0C
		JR	Z,$ADE1
		LD	D,$00
		LD	H,$10
LADE1:	LD		A,B
		ADD	A,D
		LD	L,A
		SUB	D
		SUB	H
		LD	H,A
		LD	A,C
		ADD	A,E
		LD	C,A
		SUB	E
		SUB	E
		LD	B,A
		LD	A,E
		AND	A
		RRA
		LD	($ADA4),A
		RET
LADF4:	LD		HL,($A12B)
		INC	HL
		INC	HL
		BIT	5,(HL)
		EX	AF,AF'
		LD	A,(HL)
		SUB	$10
		CP	$20
		LD	L,$04
		JR	NC,$AE07
		LD	L,$08
LAE07:	LD		A,B
		ADD	A,L
		LD	L,A
		SUB	$38
		LD	H,A
		EX	AF,AF'
		LD	A,C
		LD	B,$08
		JR	NZ,$AE15
		LD	B,$04
LAE15:	ADD		A,B
		LD	C,A
		SUB	$0C
		LD	B,A
		LD	A,$03
		LD	($ADA4),A
		RET

	;; Return height in B, image in DE, mask in HL.
GetSpriteAddr:	LD	A,(SpriteCode)
		AND	$7F
		CP	$54
		JP	NC,Sprite4x28
		CP	$18
		JR	NC,Sprite3x24
		CP	$10
		LD	H,$00
		JR	NC,Sprite3x32
	;; TODO: Somewhat mysterious below here...
		LD	L,A
		LD	DE,($A12B)
		INC	DE
		INC	DE
		LD	A,(DE)
		OR	$FC
		INC	A
		JR	NZ,Sprite3x56
		LD	A,(SpriteCode)
		LD	C,A
		RLA
		LD	A,($770F)
		JR	C,GSA_1		; Top bit set?
		CP	$06
		JR	GSA_2
GSA_1:		CP	$03
GSA_2:		JR	Z,Sprite3x56
		LD	A,($AF5A)
		XOR	C
		RLA
		LD	DE,$F9D8
		LD	HL,$FA80
		RET	NC
		LD	A,C
		LD	($AF5A),A
		LD	B,$70
		JR	FlipSprite3	; Tail call

	;; Deal with a 3 byte x sprite 56 pixels high.
Sprite3x56:	LD	A,L
		LD	E,A
		ADD	A,A 		; 2x
		ADD	A,A 		; 4x
		ADD	A,E 		; 5x
		ADD	A,A 		; 10x
		LD	L,A
		ADD	HL,HL 		; 20x
		ADD	HL,HL 		; 40x
		ADD	HL,HL 		; 80x
		LD	A,E
		ADD	A,H
		LD	H,A 		; 336x = 3x56x2x
		LD	DE,$C910
		ADD	HL,DE
		LD	DE,$00A8
		LD	B,$70
		JR	Sprite3Wide

	;; Deal with a 3 byte x 32 pixel high sprite.
Sprite3x32:	SUB	$10
		LD	L,A
		ADD	A,A		; 2x
		ADD	A,L		; 3x
		LD	L,A
		ADD	HL,HL		; 3x2x
		ADD	HL,HL		; 3x4x
		ADD	HL,HL		; 3x8x
		ADD	HL,HL		; 3x16x
		ADD	HL,HL		; 3x32x
		ADD	HL,HL		; 3x32x2x
		LD	DE,$CBB0
		ADD	HL,DE
		LD	DE,$0060
		LD	B,$40
		EX	DE,HL
		ADD	HL,DE
		EXX
		CALL	NeedsFlip
		EXX
		CALL	NC,FlipSprite3
		LD	A,($A05C)
		AND	$02
		RET	NZ
		LD	BC,$0030
		ADD	HL,BC
		EX	DE,HL
		ADD	HL,BC
		EX	DE,HL
		RET

	;; Deal with a 3 byte x 24 pixel high sprite
Sprite3x24:	SUB	$18
		LD	D,A
		LD	E,$00
		LD	H,E
		ADD	A,A 		; 2x
		ADD	A,A		; 4x
		LD	L,A
		ADD	HL,HL		; 8x
		ADD	HL,HL		; 16x
		SRL	D
		RR	E		; 128x
		ADD	HL,DE		; 144x = 3x24x2x
		LD	DE,$CD30
		ADD	HL,DE
		LD	DE,$0048
		LD	B,$30
Sprite3Wide:	EX	DE,HL
		ADD	HL,DE
		EXX
		CALL	NeedsFlip
		EXX
		RET	C		; NB: Fall-through.
	;; Flip a 3-character-wide sprite. Height in B, source in DE.
FlipSprite3:	PUSH	HL
		PUSH	DE
		EX	DE,HL
		LD	D,$B9
FS3_1:		LD	C,(HL)
		LD	(FS3_2+1),HL	; Self-modifying code!
		INC	HL
		LD	E,(HL)
		LD	A,(DE)
		LD	(HL),A
		INC	HL
		LD	E,(HL)
		LD	A,(DE)
FS3_2:		LD	($0000),A
		LD	E,C
		LD	A,(DE)
		LD	(HL),A
		INC	HL
		DJNZ	FS3_1
		POP	DE
		POP	HL
		RET

	;; Looks up a 4x28 sprite.
Sprite4x28:	SUB	$54
		LD	D,A
		RLCA			; 2x
		RLCA			; 4x
		LD	H,$00
		LD	L,A
		LD	E,H
		ADD	HL,HL		; 8x
		ADD	HL,HL		; 16x
		ADD	HL,HL		; 32x
		EX	DE,HL
		SBC	HL,DE		; 224x = 4x28x2x
		LD	DE,$EB90
		ADD	HL,DE
		LD	DE,$0070
		LD	B,$38		; 56 high (including image and mask)
		EX	DE,HL
		ADD	HL,DE
		EXX
		CALL	NeedsFlip
		EXX
		RET	C		; NB: Fall through
	;; Flip a 4-character-wide sprite. Height in B, source in DE.
FlipSprite4:	PUSH	HL
		PUSH	DE
		EX	DE,HL
		LD	D,$B9
FS4_1:		LD	C,(HL)
		LD	(FS4_2+1),HL	; Self-modifying code
		INC	HL
		LD	E,(HL)
		INC	HL
		LD	A,(DE)
		LD	E,(HL)
		LD	(HL),A
		DEC	HL
		LD	A,(DE)
		LD	(HL),A
		INC	HL
		INC	HL
		LD	E,(HL)
		LD	A,(DE)
FS4_2:		LD	($0000),A
		LD	E,C
		LD	A,(DE)
		LD	(HL),A
		INC	HL
		DJNZ	FS4_1
		POP	DE
		POP	HL
		RET

	;; Look up the sprite in the bitmap, returns with C set if the top bit of SpriteCode
	;; matches the bitmap, otherwise updates the bitmap (assumes that the caller will
	;; flip the sprite if we return NC). In effect, a simple cache.
NeedsFlip:	LD	A,(SpriteCode)
		LD	C,A
		AND	$07
		INC	A
		LD	B,A
		LD	A,$01
NF_1:		RRCA
		DJNZ	NF_1
		LD	B,A		; B now contains bitmask from low 3 bits of SpriteCode
		LD	A,C
		RRA
		RRA
		RRA
		AND	$0F		; A contains next 4 bits.
		LD	E,A
		LD	D,$00
		LD	HL,$C040
		ADD	HL,DE
		LD	A,B
		AND	(HL)		; Perform bit-mask look-up
		JR	Z,NF_2		; Bit set?
		RL	C		; Bit was non-zero
		RET	C
		LD	A,B
		CPL
		AND	(HL)
		LD	(HL),A		; If top bit of SpriteCode wasn't set, reset bit mask
		RET
NF_2:		RL	C		; Bit was zero
		CCF
		RET	C
		LD	A,B
		OR	(HL)
		LD	(HL),A		; If top bit of SpriteCode was set, set bit mask
		RET

LAF5A:	DEFB $00,$1B,$00,$40,$BA,$7E,$AF,$80,$AF,$00,$00,$00,$00,$00,$00,$00
LAF6A:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$BA
LAF7A:	DEFB $7E,$AF,$80,$AF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
LAF8A:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$40,$BA,$00,$00
LAF96:	LD		($AF77),A
		ADD		A,A
		ADD		A,A
		ADD		A,$7E
		LD		L,A
		ADC		A,$AF
		SUB		L
		LD		H,A
		LD		($AF7A),HL
		INC		HL
		INC		HL
		LD		($AF7C),HL
		RET
LAFAB:	LD		HL,$0012
		ADD		HL,DE
		PUSH	HL
		EX		DE,HL
		LD		BC,$0005
		LDIR
		LD		A,(HL)
		SUB		$06
		LD		(DE),A
		INC		DE
		INC		HL
		INC		HL
		BIT		5,(HL)
		JR		NZ,$AFC4
		DEC		HL
		LDI
LAFC4:	POP		HL
		RET
LAFC6:	PUSH	HL
		PUSH	BC
		INC		HL
		INC		HL
		CALL	$A1BD
		POP		BC
		POP		HL
		RET		NC
		LD		DE,($AF78)
		PUSH	DE
		LDIR
		LD		($AF78),DE
		POP		HL
		PUSH	HL
		POP		IY
		BIT		3,(IY+$04)
		JR		Z,$B010
		LD		BC,$0009
		PUSH	HL
		LDIR
		EX		DE,HL
		LD		A,(DE)
		OR		$02
		LD		(HL),A
		INC		HL
		LD		(HL),$00
		LD		DE,$0008
		ADD		HL,DE
		LD		($AF78),HL
		BIT		5,(IY+$09)
		JR		Z,$B00F
		PUSH	IY
		LD		DE,$0012
		ADD		IY,DE
		LD		A,($822E)
		CALL	$828B
		POP		IY
LB00F:	POP		HL
LB010:	LD		A,($AF77)
		DEC		A
		CP		$02
		JR		NC,$B03B
		INC		HL
		INC		HL
		BIT		3,(IY+$04)
		JR		Z,$B034
		PUSH	HL
		CALL	$B034
		POP		DE
		CALL	$AFAB
		PUSH	HL
		CALL	$B106
		EXX
		PUSH	IY
		POP		HL
		INC		HL
		INC		HL
		JR		$B085
LB034:	PUSH	HL
		CALL	$B106
		EXX
		JR		$B082
LB03B:	INC		HL
		INC		HL
		BIT		3,(IY+$04)
		JR		Z,$B057
		PUSH	HL
		CALL	$B057
		POP		DE
		CALL	$AFAB
		PUSH	HL
		CALL	$B106
		EXX
		PUSH	IY
		POP		HL
		INC		HL
		INC		HL
		JR		$B085
LB057:	PUSH	HL
		CALL	$B106
		LD		A,$03
		EX		AF,AF'
		LD		A,($771A)
		CP		D
		JR		C,$B07D
		LD		A,($771B)
		CP		H
		JR		C,$B07D
		LD		A,$04
		EX		AF,AF'
		LD		A,($7718)
		DEC		A
		CP		E
		JR		NC,$B07D
		LD		A,($7719)
		DEC		A
		CP		L
		JR		NC,$B07D
		XOR		A
		EX		AF,AF'
LB07D:	EXX
		EX		AF,AF'
		CALL	$AF96
LB082:	LD		HL,($AF7A)
LB085:	LD		($AF94),HL
LB088:	LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		OR		H
		JR		Z,$B09C
		PUSH	HL
		CALL	$B106
		CALL	$B17A
		POP		HL
		JR		NC,$B085
		AND		A
		JR		NZ,$B088
LB09C:	LD		HL,($AF94)
		POP		DE
		LD		A,(HL)
		LDI
		LD		C,A
		LD		A,(HL)
		LD		(DE),A
		DEC		DE
		LD		(HL),D
		DEC		HL
		LD		(HL),E
		LD		L,C
		LD		H,A
		OR		C
		JR		NZ,$B0B4
		LD		HL,($AF7C)
		INC		HL
		INC		HL
LB0B4:	DEC		HL
		DEC		DE
		LDD
		LD		A,(HL)
		LD		(DE),A
		LD		(HL),E
		INC		HL
		LD		(HL),D
		RET
LB0BE:	PUSH	HL
		CALL	$B0C6
		POP		HL
		JP		$B03B
LB0C6:	BIT		3,(IY+$04)
		JR		Z,$B0D5
		PUSH	HL
		CALL	$B0D5
		POP		DE
		LD		HL,$0012
		ADD		HL,DE
LB0D5:	LD		E,(HL)
		INC		HL
		LD		D,(HL)
		INC		HL
		PUSH	DE
		LD		A,D
		OR		E
		INC		DE
		INC		DE
		JR		NZ,$B0E4
		LD		DE,($AF7A)
LB0E4:	LD		A,(HL)
		LDI
		LD		C,A
		LD		A,(HL)
		LD		(DE),A
		LD		H,A
		LD		L,C
		OR		C
		DEC		HL
		JR		NZ,$B0F4
		LD		HL,($AF7C)
		INC		HL
LB0F4:	POP		DE
		LD		(HL),D
		DEC		HL
		LD		(HL),E
		RET
LB0F9:	CALL	$B104
		AND		$08
		RET		Z
		LD		A,C
		SUB		$06
		LD		C,A
		RET
LB104:	INC		HL
		INC		HL
LB106:	INC		HL
		INC		HL
		LD		A,(HL)
		INC		HL
		LD		C,A
		EX		AF,AF'
		LD		A,C
		BIT		2,A
		JR		NZ,$B153
		BIT		1,A
		JR		NZ,$B12F
		AND		$01
		ADD		A,$03
		LD		B,A
		ADD		A,A
		LD		C,A
		LD		A,(HL)
		ADD		A,B
		LD		D,A
		SUB		C
		LD		E,A
		INC		HL
		LD		A,(HL)
		INC		HL
		ADD		A,B
		LD		B,(HL)
		LD		H,A
		SUB		C
		LD		L,A
LB129:	LD		A,B
		SUB		$06
		LD		C,A
		EX		AF,AF'
		RET
LB12F:	RRA
		JR		C,$B143
		LD		A,(HL)
		ADD		A,$04
		LD		D,A
		SUB		$08
		LD		E,A
		INC		HL
		LD		A,(HL)
		INC		HL
		LD		B,(HL)
		LD		H,A
		LD		L,A
		INC		H
		DEC		L
		JR		$B129
LB143:	LD		D,(HL)
		LD		E,D
		INC		D
		DEC		E
		INC		HL
		LD		A,(HL)
		INC		HL
		ADD		A,$04
		LD		B,(HL)
		LD		H,A
		SUB		$08
		LD		L,A
		JR		$B129
LB153:	LD		A,(HL)
		RR		C
		JR		C,$B15E
		LD		E,A
		ADD		A,$04
		LD		D,A
		JR		$B162
LB15E:	LD		D,A
		SUB		$04
		LD		E,A
LB162:	INC		HL
		LD		A,(HL)
		INC		HL
		LD		B,(HL)
		RR		C
		JR		C,$B170
		LD		L,A
		ADD		A,$04
		LD		H,A
		JR		$B174
LB170:	LD		H,A
		SUB		$04
		LD		L,A
LB174:	LD		A,B
		SUB		$12
		LD		C,A
		EX		AF,AF'
		RET
LB17A:	LD		A,L
		EXX
		CP		H
		LD		A,L
		EXX
		JR		NC,$B184
		CP		H
		JR		C,$B1BB
LB184:	LD		A,E
		EXX
		CP		D
		LD		A,E
		EXX
		JR		NC,$B18E
		CP		D
		JR		C,$B1F2
LB18E:	LD		A,C
		EXX
		CP		B
		LD		A,C
		EXX
		JR		NC,$B198
		CP		B
		JR		C,$B1AF
LB198:	LD		A,L
		ADD		A,E
		ADD		A,C
		LD		L,A
		ADC		A,$00
		SUB		L
		LD		H,A
		EXX
		LD		A,L
		ADD		A,E
		ADD		A,C
		EXX
		LD		E,A
		ADC		A,$00
		SUB		E
		LD		D,A
		SBC		HL,DE
		LD		A,$FF
		RET
LB1AF:	LD		A,L
		ADD		A,E
		LD		L,A
		EXX
		LD		A,L
		ADD		A,E
		EXX
		CP		L
		CCF
		LD		A,$FF
		RET
LB1BB:	LD		A,E
		EXX
		CP		D
		LD		A,E
		EXX
		JR		NC,$B1C5
		CP		D
		JR		C,$B1EB
LB1C5:	LD		A,C
		EXX
		CP		B
		LD		A,C
		EXX
		JR		NC,$B1CF
		CP		B
		JR		C,$B1E4
LB1CF:	EXX
		ADD		A,E
		EXX
		LD		L,A
		ADC		A,$00
		SUB		L
		LD		H,A
		LD		A,C
		ADD		A,E
		LD		E,A
		ADC		A,$00
		SUB		E
		LD		D,A
		SBC		HL,DE
		CCF
		LD		A,$FF
		RET
LB1E4:	LD		A,E
		EXX
		CP		E
		EXX
		LD		A,$00
		RET
LB1EB:	LD		A,C
		EXX
		CP		C
		EXX
		LD		A,$00
		RET
LB1F2:	LD		A,C
		EXX
		CP		B
		LD		A,C
		EXX
		JR		NC,$B1FC
		CP		B
		JR		C,$B210
LB1FC:	EXX
		ADD		A,L
		EXX
		LD		E,A
		ADC		A,$00
		SUB		E
		LD		D,A
		LD		A,C
		ADD		A,L
		LD		L,A
		ADC		A,$00
		SUB		L
		LD		H,A
		SBC		HL,DE
		LD		A,$FF
		RET
LB210:	LD		A,L
		EXX
		CP		L
		EXX
		LD		A,$00
		RET
LB217:	DEFB $00,$00,$00,$00,$00
LB21C:	PUSH	AF
		CALL	$B0F9
		EXX
		POP		AF
		LD		($B21B),A
LB225:	CALL	$B22C
		LD		A,($B21B)
		RET
LB22C:	LD		DE,$B24B
		PUSH	DE
		LD		C,A
		ADD		A,A
		ADD		A,A
		ADD		A,C
		ADD		A,$77
		LD		L,A
		ADC		A,$B3
		SUB		L
		LD		H,A
		LD		A,(HL)
		LD		($B217),A
		INC		HL
		LD		E,(HL)
		INC		HL
		LD		D,(HL)
		INC		HL
		LD		A,(HL)
		INC		HL
		LD		H,(HL)
		LD		L,A
		PUSH	DE
		EXX
		RET
LB24B:	DEFB $D9,$C8,$E5,$DD,$E1,$CB,$51,$20,$15,$21,$7E,$AF,$7E,$23,$66,$6F
LB25B:	DEFB $B4,$28,$24,$E5,$CD,$F4,$9D,$E1,$38,$3B,$20,$F0,$18,$19,$21,$80
LB26B:	DEFB $AF,$7E,$23,$66,$6F,$B4,$28,$09,$E5,$CD,$F4,$9D,$E1,$38,$28,$20
LB27B:	DEFB $F0,$CD,$4B,$A9,$5D,$18,$06,$CD,$4B,$A9,$5D,$23,$23,$FD,$CB,$09
LB28B:	DEFB $46,$28,$04,$FD,$7D,$BB,$C8,$3A,$BC,$A2,$A7,$C8,$CD,$F4,$9D,$D0
LB29B:	DEFB $CD,$4B,$A9,$23,$23,$2B,$2B,$E5,$DD,$E1,$3A,$17,$B2,$DD,$CB,$09
LB2AB:	DEFB $4E,$28,$08,$DD,$A6,$FA,$DD,$77,$FA,$18,$06,$DD,$A6,$0C,$DD,$77
LB2BB:	DEFB $0C,$AF,$D6,$01
LB2BF:	PUSH	AF
		PUSH	IX
		PUSH	IY
		CALL	$B2CD
		POP		IY
		POP		IX
		POP		AF
		RET
LB2CD:	BIT		0,(IY+$09)
		JR		NZ,$B2DF
		BIT		0,(IX+$09)
		JR		Z,$B34F
		PUSH	IY
		EX		(SP),IX
		POP		IY
LB2DF:	LD		C,(IY+$09)
		LD		B,(IY+$04)
		BIT		5,(IX+$04)
		RET		Z
		BIT		6,(IX+$04)
		JR		NZ,$B333
		AND		A
		JR		Z,$B2F8
		BIT		4,(IX+$09)
		RET		NZ
LB2F8:	BIT		3,B
		LD		B,$03
		JR		NZ,$B304
		DEC		B
		BIT		2,C
		JR		NZ,$B304
		DEC		B
LB304:	XOR		A
		LD		HL,$A28E
		CP		(HL)
		JR		Z,$B30D
		RES		0,B
LB30D:	INC		HL
		CP		(HL)
		JR		Z,$B313
		RES		1,B
LB313:	LD		A,B
		AND		A
		RET		Z
		LD		HL,$B21A
		OR		(HL)
		LD		(HL),A
		DEC		HL
		LD		A,(HL)
		AND		A
		RET		NZ
		LD		A,($866B)
		CP		$1F
		RET		Z
		LD		(HL),$0C
		LD		A,($B218)
		AND		A
		CALL	NZ,$8855
		LD		B,$C6
		JP		PlaySound
LB333:	LD		(IX+$0F),$08
		LD		(IX+$04),$80
		LD		A,(IX+$0A)
		AND		$80
		OR		$11
		LD		(IX+$0A),A
		RES		6,(IX+$09)
		LD		A,(IX+$11)
		JP		$87DF
LB34F:	BIT		3,(IY+$09)
		JR		NZ,$B35E
		BIT		3,(IX+$09)
		RET		Z
		PUSH	IY
		POP		IX
LB35E:	BIT		1,(IX+$09)
		JR		Z,$B369
		LD		DE,$FFEE
		ADD		IX,DE
LB369:	BIT		7,(IX+$09)
		RET		Z
		SET		6,(IX+$09)
		LD		(IX+$0B),$FF
		RET
LB377:	DEFB $FD,$BE,$B4,$84,$B4,$FF,$9F,$B3,$00,$00,$FB,$15,$B5,$A2,$B4,$FF
LB387:	DEFB $C0,$B3,$00,$00,$FE,$65,$B5,$28,$B4,$FF,$E4,$B3,$00,$00,$F7,$AD
LB397:	DEFB $B5,$69,$B4,$FF,$07,$B4,$00,$00
LB39F:	EXX
		POP		HL
		POP		DE
		XOR		A
		CALL	$B225
		JR		C,$B3B6
		EXX
		DEC		D
		DEC		E
		EXX
		LD		A,$02
		CALL	$B225
		LD		A,$01
		RET		NC
		XOR		A
		RET
LB3B6:	LD		A,$02
		CALL	$B225
		RET		C
		AND		A
		LD		A,$02
		RET
LB3C0:	EXX
		POP		HL
		POP		DE
		LD		A,$04
		CALL	$B225
		JR		C,$B3DA
		EXX
		INC		D
		INC		E
		EXX
		LD		A,$02
		CALL	$B225
		LD		A,$03
		RET		NC
		LD		A,$04
		AND		A
		RET
LB3DA:	LD		A,$02
		CALL	$B225
		RET		C
		AND		A
		LD		A,$02
		RET
LB3E4:	EXX
		POP		HL
		POP		DE
		LD		A,$04
		CALL	$B225
		JR		C,$B3FE
		EXX
		INC		D
		INC		E
		EXX
		LD		A,$06
		CALL	$B225
		LD		A,$05
		RET		NC
		LD		A,$04
		AND		A
		RET
LB3FE:	LD		A,$06
		CALL	$B225
		RET		C
		LD		A,$06
		RET
LB407:	EXX
		POP		HL
		POP		DE
		XOR		A
		CALL	$B225
		JR		C,$B41E
		EXX
		DEC		D
		DEC		E
		EXX
		LD		A,$06
		CALL	$B225
		LD		A,$07
		RET		NC
		XOR		A
		RET
LB41E:	LD		A,$06
		CALL	$B225
		RET		C
		AND		A
		LD		A,$06
		RET
LB428:	INC		HL
		INC		HL
		CALL	$B650
		LD		A,(HL)
		SUB		C
		EXX
		CP		D
		EXX
		JR		C,$B465
		JR		NZ,$B453
		INC		HL
LB437:	LD		A,(HL)
		SUB		B
		EXX
		CP		H
		LD		A,L
		EXX
		JR		NC,$B465
		SUB		B
		CP		(HL)
		JR		NC,$B465
LB443:	INC		HL
		EXX
		LD		A,C
		EXX
		CP		(HL)
		JR		NC,$B465
		LD		A,(HL)
		SUB		E
		EXX
		CP		B
		EXX
		JR		NC,$B465
		SCF
		RET
LB453:	INC		HL
		LD		A,(HL)
		SUB		B
		EXX
		CP		H
		EXX
		JR		C,$B465
		INC		HL
		LD		A,(HL)
		SUB		E
		EXX
		CP		B
		EXX
		JR		C,$B465
		XOR		A
		RET
LB465:	LD		A,$FF
		AND		A
		RET
LB469:	INC		HL
		INC		HL
		CALL	$B650
		LD		A,(HL)
		SUB		C
		EXX
		CP		D
		LD		A,E
		EXX
		JR		NC,$B453
		SUB		C
		CP		(HL)
		JR		NC,$B465
		INC		HL
		LD		A,(HL)
		SUB		B
		EXX
		CP		H
		EXX
		JR		Z,$B443
		JR		$B465
LB484:	CALL	$B650
		EXX
		LD		A,E
		EXX
		SUB		C
		CP		(HL)
		JR		C,$B465
		INC		HL
		JR		Z,$B437
LB491:	EXX
		LD		A,L
		EXX
		SUB		B
		CP		(HL)
		JR		C,$B465
		INC		HL
		LD		A,(HL)
		ADD		A,E
		EXX
		CP		B
		EXX
		JR		NC,$B465
		XOR		A
		RET
LB4A2:	CALL	$B650
		EXX
		LD		A,E
		EXX
		SUB		C
		CP		(HL)
		INC		HL
		JR		NC,$B491
		DEC		HL
		LD		A,(HL)
		SUB		C
		EXX
		CP		D
		LD		A,L
		EXX
		JR		NC,$B465
		INC		HL
		SUB		B
		CP		(HL)
		JP		Z,$B443
		JR		$B465
LB4BE:	CALL	$B63D
		JR		Z,$B4F6
		CALL	$B5F5
		LD		A,$24
		JR		C,$B4F9
		BIT		0,(IX-$01)
		JR		Z,$B4E4
		LD		A,($7747)
		CALL	$B629
		JR		C,$B4F6
		CALL	$B619
		JR		C,$B4FD
		LD		A,($7718)
		SUB		$04
		JR		$B4ED
LB4E4:	BIT		0,(IX-$02)
		JR		Z,$B4F6
		LD		A,($7718)
LB4ED:	CP		E
		RET		NZ
		LD		A,$01
LB4F1:	LD		($B218),A
		SCF
		RET
LB4F6:	LD		A,($7718)
LB4F9:	CP		E
		RET		NZ
		SCF
		RET
LB4FD:	CALL	$B621
		JR		C,$B4F6
		CALL	$B4F6
LB505:	RET		NZ
		LD		A,L
		CP		$25
		LD		A,$F7
		JR		C,$B50F
		LD		A,$FB
LB50F:	LD		($A2BF),A
		XOR		A
		SCF
		RET
LB515:	CALL	$B63D
		JR		Z,$B54A
		CALL	$B5FF
		LD		A,$24
		JR		C,$B54D
		BIT		1,(IX-$01)
		JR		Z,$B53B
		LD		A,($7746)
		CALL	$B629
		JR		C,$B54A
		CALL	$B609
		JR		C,$B551
		LD		A,($7719)
		SUB		$04
		JR		$B544
LB53B:	BIT		1,(IX-$02)
		JR		Z,$B54A
		LD		A,($7719)
LB544:	CP		L
		RET		NZ
		LD		A,$02
		JR		$B4F1
LB54A:	LD		A,($7719)
LB54D:	CP		L
		RET		NZ
		SCF
		RET
LB551:	CALL	$B611
		JR		C,$B54A
		CALL	$B54A
LB559:	RET		NZ
		LD		A,E
		CP		$25
		LD		A,$FE
		JR		C,$B50F
		LD		A,$FD
		JR		$B50F
LB565:	CALL	$B63D
		JR		Z,$B59B
		CALL	$B5F5
		LD		A,$2C
		JR		C,$B59E
		BIT		2,(IX-$01)
		JR		Z,$B58B
		LD		A,($7745)
		CALL	$B629
		JR		C,$B59B
		CALL	$B619
		JR		C,$B5A2
		LD		A,($771A)
		ADD		A,$04
		JR		$B594
LB58B:	BIT		2,(IX-$02)
		JR		Z,$B59B
		LD		A,($771A)
LB594:	CP		D
		RET		NZ
		LD		A,$03
		JP		$B4F1
LB59B:	LD		A,($771A)
LB59E:	CP		D
		RET		NZ
		SCF
		RET
LB5A2:	CALL	$B621
		JR		C,$B59B
		CALL	$B59B
		JP		$B505
LB5AD:	CALL	$B63D
		JR		Z,$B5E3
		CALL	$B5FF
		LD		A,$2C
		JR		C,$B5E6
		BIT		3,(IX-$01)
		JR		Z,$B5D3
		LD		A,($7744)
		CALL	$B629
		JR		C,$B5E3
		CALL	$B609
		JR		C,$B5EA
		LD		A,($771B)
		ADD		A,$04
		JR		$B5DC
LB5D3:	BIT		3,(IX-$02)
		JR		Z,$B5E3
		LD		A,($771B)
LB5DC:	CP		H
		RET		NZ
		LD		A,$04
		JP		$B4F1
LB5E3:	LD		A,($771B)
LB5E6:	CP		H
		RET		NZ
		SCF
		RET
LB5EA:	CALL	$B611
		JR		C,$B5E3
		CALL	$B5E3
		JP		$B559
LB5F5:	LD		A,($771B)
		CP		H
		RET		C
		LD		A,L
		CP		A,(IX+$01)
		RET
LB5FF:	LD		A,($771A)
		CP		D
		RET		C
		LD		A,E
		CP		A,(IX+$00)
		RET
LB609:	LD		A,$2C
		CP		D
		RET		C
		LD		A,E
		CP		$24
		RET
LB611:	LD		A,$30
		CP		D
		RET		C
		LD		A,E
		CP		$20
		RET
LB619:	LD		A,$2C
		CP		H
		RET		C
		LD		A,L
		CP		$24
		RET
LB621:	LD		A,$30
		CP		H
		RET		C
		LD		A,L
		CP		$20
		RET
LB629:	SUB		B
		RET		C
		PUSH	AF
		LD		A,($A294)
		CP		$03
		JR		NZ,$B638
		POP		AF
		CP		$03
		CCF
		RET
LB638:	POP		AF
		CP		$09
		CCF
		RET
LB63D:	LD		IX,$7718
		BIT		0,(IY+$09)
		RET		Z
		LD		A,(IY+$0A)
		AND		$7F
		SUB		$01
		RET		C
		XOR		A
		RET
LB650:	INC		HL
		INC		HL
		LD		A,(HL)
		INC		HL
		LD		E,$06
		BIT		1,A
		JR		NZ,$B662
		RRA
		LD		A,$03
		ADC		A,$00
		LD		B,A
		LD		C,A
		RET
LB662:	RRA
		JR		C,$B669
		LD		BC,$0104
		RET
LB669:	LD		BC,$0401
		RET
LB66D:	DEFB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
LB67D:	DEFB $02,$40,$80,$00,$FF

	;; FIXME: Joystick selection screen?
LB682:	JP		$B685
LB685:	CP		$80
		JR		NC,$B6BA
		SUB		$20
		JR		C,$B6CB
		CALL	$743C
		LD		HL,$0804
		LD		A,($B680)
		AND		A
		CALL	NZ,$B75F
		LD		BC,($B67E)
		LD		A,C
		ADD		A,$04
		LD		($B67E),A
		LD		A,($B681)
		AND		A
		LD		A,($B67D)
		JR		NZ,$B6B7
		INC		A
		AND		$03
		SCF
		JR		NZ,$B6B4
		INC		A
LB6B4:	LD		($B67D),A
LB6B7:	JP		$9542
LB6BA:	AND		$7F
		CALL	$B74A
LB6BF:	LD		A,(HL)
		CP		$FF
		RET		Z
		INC		HL
		PUSH	HL
		CALL	$B682
		POP		HL
		JR		$B6BF
LB6CB:	ADD		A,$20
		CP		$05
		JR		NC,$B702
		AND		A
		JP		Z,ScreenWipe
		SUB		$02
		JR		C,$B6ED
		JR		Z,$B6E0
		DEC		A
		LD		($B680),A
		RET
LB6E0:	LD		A,($B67E)
		CP		$C0
		RET		NC
		LD		A,$20
		CALL	$B682
		JR		$B6E0
LB6ED:	LD		HL,($B67E)
		LD		A,($B680)
		AND		A
		LD		A,H
		JR		Z,$B6F9
		ADD		A,$08
LB6F9:	ADD		A,$08
		LD		H,A
		LD		L,$40
		LD		($B67E),HL
		RET
LB702:	LD		HL,$B71A
		JR		Z,$B711
		CP		$07
		LD		HL,$B715
		JR		Z,$B711
		LD		HL,$B728
LB711:	LD		($B683),HL
		RET
	
LB715:		CALL	SetAttribs
		JR		$B723
LB71A:	AND		A
		LD		($B681),A
		JR		Z,$B723
		LD		($B67D),A
LB723:	LD		HL,$B685
		JR		$B711
LB728:	LD		HL,$B734
		ADD		A,A
		ADD		A,A
		ADD		A,$40
		LD		($B67E),A
		JR		$B711
LB734:	ADD		A,A
		ADD		A,A
		ADD		A,A
		LD		($B67F),A
		JR		$B723
LB73C:	LD		($B747),BC
		LD		HL,$B746
		JP		$B6BF
LB746:	DEFB $06,$00,$00,$FF
LB74A:	LD		B,A
		LD		HL,$7EA3
		SUB		$60
		JR		C,$B756
		LD		HL,$7454
		LD		B,A
LB756:	INC		B
		LD		A,$FF
LB759:	LD		C,A
		CPIR
		DJNZ	$B759
		RET
LB75F:	LD		B,$08
		LD		HL,$B66D
LB764:	LD		A,(DE)
		LD		(HL),A
		INC		HL
		LD		(HL),A
		INC		HL
		INC		DE
		DJNZ	$B764
		LD		HL,$1004
		LD		DE,$B66D
		RET
LB773:	LD		BC,$00F8
		PUSH	DE
		LD		A,D
		CALL	$B787
		POP		DE
		LD		A,E
		JR		$B787
LB77F:	LD		BC,$FFFE
		JR		$B787
LB784:	LD		BC,$00FE
LB787:	PUSH	AF
		RRA
		RRA
		RRA
		RRA
		CALL	$B790
		POP		AF
LB790:	AND		$0F
		JR		NZ,$B79D
		RRC		C
		JR		C,$B79D
		RRC		B
		RET		NC
		LD		A,$F0
LB79D:	LD		C,$FF
		ADD		A,$30
		PUSH	BC
		CALL	$B682
		POP		BC
		SCF
		RET

	;; Called immediately after intalling interrupt handler.
ShuffleMem:	; Zero end of top page
		LD	HL,$FFFE
		XOR	A
		LD	(HL),A
		; Switch to bank 1, write top of page
		LD	BC,$7FFD
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
		LD	HL,$5800
ShuffleMem_1:	LD	(HL),$00
		INC	L
		JR	NZ,ShuffleMem_1
		INC	H
		DJNZ	ShuffleMem_1
		; Stash data in display memory
		LD	BC,$091B
		LD	DE,$4000
		LD	HL,$B884
		LDIR
		; Switch to bank 1
		LD	A,$11
		LD	BC,$7FFD
		OUT	(C),A
		; Reinitialise IRQ handler there.
		LD	A,$18
		LD	($FFFF),A
		LD	A,$C3
		LD	($FFF4),A
		LD	HL,IrqHandler
		LD	($FFF5),HL
		; FIXME: Another memory chunk copy.
		LD	BC,$0043
		LD	DE,$964F
		LD	HL,$B824
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
		LD	BC,$091B
		LD	DE,$C000
		LD	HL,$4000
		LDIR
		; Switch to bank 0.
		LD	BC,$7FFD
		LD	A,$10
		OUT	(C),A
Have48K:	; FIXME: Shuffle some more memory
		LD	HL,$C1A0
		LD	DE,$C038
		LD	BC,$390C
		LDIR
		RET
	
LB824:		LD	A,($964B)
		CP	$80
		RET	Z
		LD	B,$C3
		JP	PlaySound

#include "data_trailer.asm"
	
#end