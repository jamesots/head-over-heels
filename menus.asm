	;; Menu-related stuff

MENU_CUR_ITEM:	EQU $00		; Currently-selected menu item index
	;; Top bit of NUM_ITEMS is set if you don't want the currently-selected
	;; line to be double-height
MENU_NUM_ITEMS:	EQU $01		; Number of items in the menu
MENU_INIT_X:	EQU $02		; Initial X coordinate of the menu items
MENU_INIT_Y:	EQU $03		; Initial Y coordinate of the menu items
MENU_STR_BASE:	EQU $04		; First string index of items in the menu

	;; FIXME: This alternate version uses something other than
	;; enter to step through.
MenuStepAlt:	CALL	GetMaybeEnter
		RET	C
		LD	A,C
		CP	$01
		JR	NZ,MenuStepCore
		AND	A
		RET

	;; A loop that's repeatedly called for menus.
MenuStep:	CALL	GetMaybeEnter
		RET	C
		LD	A,C
	;; NB: Fall through
	
MenuStepCore:	AND	A
		RET	Z
	;; Increment current item, looping back to top if necessary.
		LD	A,(IX+MENU_CUR_ITEM)
		INC	A
		CP	A,(IX+MENU_NUM_ITEMS)
		JR	C,MSC_1
		XOR	A
MSC_1:		LD	(IX+MENU_CUR_ITEM),A
	;; And play a nice little sound!
		PUSH	IX
		LD	B,$88
		CALL	PlaySound
		POP	IX
	;; NB: Fall through

	;; Draw the menu pointed to by IX.
DrawMenu:
	;; Set cursor and initialise variables for menu-drawing
		LD	B,(IX+MENU_INIT_Y)
		RES	7,B
		LD	C,(IX+MENU_INIT_X)
		LD	(MenuCursor),BC
		CALL	SetCursor
		LD	B,(IX+MENU_NUM_ITEMS)
		LD	C,(IX+MENU_CUR_ITEM)
		INC	C
	;; The main menu-item-drawing loop
DM_1:		LD	A,STR_ARROW_NONSEL 	; Arrow to use for non-selected items
		DEC	C
		PUSH	BC
		JR	NZ,DM_3
	;; This is the currently-selected item
		BIT	7,(IX+MENU_INIT_Y) 	; Is bit 7 of MENU_INIT_Y set?
		JR	NZ,DM_2
		LD	A,CTRL_DOUBLE 		; No - use double height
		CALL	PrintChar
		LD	A,STR_ARROW_SEL
		JR	DM_3
DM_2:		LD	A,CTRL_SINGLE 		; Yes - use single height
		CALL	PrintChar
		LD	A,STR_ARROW_SEL 	; Arrow to use for selected items
	;; Draw the arrow
DM_3:		CALL	PrintChar
	;; Calculate the string index to use, and print the string
		LD	A,(IX+MENU_NUM_ITEMS)
		POP	BC
		PUSH	BC
		SUB	B
		ADD	A,(IX+MENU_STR_BASE)
		CALL	PrintChar
	;; Update the cursor position
		POP	HL
		PUSH	HL
		LD	BC,(MenuCursor)
		LD	A,L			; Check if this is current item
		AND	A
		JR	NZ,DM_4
		BIT	7,(IX+MENU_INIT_Y) 	; Is current item and bit 7 of MENU_INIT_Y set?
		JR	NZ,DM_4
		INC	B			; No - advance 2 lines
DM_4:		INC	B			; Yes - just advance 1
		PUSH	BC
		CALL	SetCursor
	;; Make sure we're back to single-line
		LD	A,CTRL_SINGLE
		CALL	PrintChar
	;; And if bit 7 is not set, print out blanks to overwrite the changing parts.
		BIT	7,(IX+MENU_INIT_Y)
		JR	NZ,DM_5
		LD	A,CTRL_BLANKS
		CALL	PrintChar
	;; Finally, write out the cursor position. Again.
DM_5:		POP	BC
		INC	B
		LD	(MenuCursor),BC
		CALL	SetCursor
		POP	BC
		DJNZ	DM_1
		SCF
		RET
	
Strings:			; Strings table for indices < 0x60
STR_PLAY:		EQU $80
					DEFM DELIM, "PLAY"
CTRL_ATTR1:		EQU $81
        				DEFM DELIM,CTRL_ATTR,$01
CTRL_ATTR2:		EQU $82
					DEFM DELIM,CTRL_ATTR,$02
CTRL_ATTR3:		EQU $83
					DEFM DELIM,CTRL_ATTR,$03
STR_THE:		EQU $84
					DEFM DELIM," THE "
STR_GAME:		EQU $85
					DEFM DELIM,"GAME"
STR_SELECT:		EQU $86
					DEFM DELIM,"SELECT"
STR_KEY:		EQU $87
					DEFM DELIM,"KEY"
STR_ANY_KEY:		EQU $88
					DEFM DELIM,"ANY ",STR_KEY
STR_SENSITIVITY:	EQU $89
					DEFM DELIM,"SENSITIVITY"
STR_PRESS:		EQU $8A
					DEFM DELIM,CTRL_ATTR2,"PRESS "
STR_TO:			EQU $8B
					DEFM DELIM,CTRL_ATTR2," TO "
STR_ENTER2:		EQU $8C
					DEFM DELIM,CTRL_ATTR3,STR_ENTER
STR_SHIFT:		EQU $8D
					DEFM DELIM,CTRL_ATTR3,"SHIFT"
STR_LEFT:		EQU $8E
					DEFM DELIM,"LEFT"
STR_RIGHT:		EQU $8F
					DEFM DELIM,"RIGHT"
STR_DOWN:		EQU $90
					DEFM DELIM,"DOWN"
STR_UP:	 		EQU $91
					DEFM DELIM,"UP"
STR_JUMP:		EQU $92
					DEFM DELIM,"JUMP"
STR_CARRY:		EQU $93
					DEFM DELIM,"CARRY"
STR_FIRE:		EQU $94
					DEFM DELIM,"FIRE"
STR_SWOP:		EQU $95
					DEFM DELIM,"SWOP"
STR_LOTS:		EQU $96
					DEFM DELIM,"LOTS OF IT"
STR_NOTSO:		EQU $97
					DEFM DELIM,"NOT SO MUCH"
STR_PARDON:		EQU $98
					DEFM DELIM,"PARDON"
STR_GO_TITLE_SCREEN:	EQU $99
					DEFM DELIM,CTRL_SCREENWIPE
					DEFM STR_TITLE_SCREEN,STR_MENU_BLURB
STR_PLAY_THE_GAME:	EQU $9A
					DEFM DELIM,STR_PLAY,STR_THE,STR_GAME
STR_SELECT_THE_KEYS:	EQU $9B
					DEFM DELIM,STR_SELECT,STR_THE,STR_KEY,"S"
STR_ADJUST_THE_SOUND:	EQU $9C
					DEFM DELIM,"ADJUST",STR_THE,"SOUND"
STR_CONTROL_SENS:	EQU $9D
					DEFM DELIM,"CONTROL ",STR_SENSITIVITY
STR_HIGH_SENS:		EQU $9E
					DEFM DELIM,"HIGH ",STR_SENSITIVITY
STR_LOW_SENS:		EQU $9F
					DEFM DELIM,"LOW ",STR_SENSITIVITY
STR_OLD_GAME:		EQU $A0
					DEFM DELIM,"OLD ",STR_GAME
STR_NEW_GAME:		EQU $A1
					DEFM DELIM,"NEW ",STR_GAME
STR_MAIN_MENU:		EQU $A2
					DEFM DELIM,"MAIN MENU"
STR_MENU_BLURB:		EQU $A3
					DEFM DELIM,CTRL_SGLPOS,$02,$15
					DEFM STR_PRESS,CTRL_ATTR3,STR_ANY_KEY,STR_TO,"MOVE CURSOR"
					DEFM CTRL_CURPOS,$01,$17
					DEFM " ",STR_PRESS,STR_ENTER2,STR_TO,STR_SELECT," OPTION"
					DEFM CTRL_BLANKS
STR_SHIFT_TO_FINISH:	EQU $A4
					DEFM DELIM,CTRL_CURPOS,CTRL_ATTR,$03
					DEFM STR_PRESS,STR_SHIFT,STR_TO,STR_FINISH,CTRL_BLANKS
STR_ENTER_TO_FINISH:	EQU $A5
					DEFM DELIM,CTRL_CURPOS,CTRL_ATTR,$03
					DEFM STR_PRESS,STR_ENTER2,STR_TO,STR_FINISH,CTRL_BLANKS
STR_SELECT_THEN_SHIFT:	EQU $A6
					DEFM DELIM,CTRL_WIPE_SETPOS,$08,$00,CTRL_ATTR1
					DEFM STR_SELECT_THE_KEYS,STR_PRESS_SHFT_TO_FIN
STR_PRESS_SHFT_TO_FIN:	EQU $A7
					DEFM DELIM,STR_MENU_BLURB,CTRL_CURPOS,$05,$03
					DEFM STR_PRESS,CTRL_ATTR1,STR_SHIFT,STR_TO
					DEFM STR_FINISH,CTRL_BLANKS
STR_PRESS_KEYS_REQD:	EQU $A8
					DEFM DELIM,CTRL_CURPOS,CTRL_ATTR,$03,CTRL_BLANKS
					DEFM CTRL_CURPOS,$01,$15,CTRL_BLANKS
					DEFM CTRL_CURPOS,$01,$17
					DEFM STR_PRESS,CTRL_ATTR3,STR_KEY,"S"
					DEFM CTRL_ATTR2," REQUIRED FOR ",CTRL_ATTR3
STR_SOUND_MENU:		EQU $A9
					DEFM DELIM,CTRL_WIPE_SETPOS,$08,$00,CTRL_ATTR2
					DEFM STR_ADJUST_THE_SOUND
					DEFM STR_MENU_BLURB,CTRL_CURPOS,$06,$03,CTRL_ATTR,$00
					DEFM "MUSIC BY GUY STEVENS"
STR_SENSITIVITY_MENU:	EQU $AA
					DEFM DELIM,CTRL_WIPE_SETPOS,$06,$00,CTRL_ATTR2
					DEFM STR_CONTROL_SENS,STR_MENU_BLURB
STR_PLAY_GAME_MENU:	EQU $AB
					DEFM DELIM,CTRL_WIPE_SETPOS,$09,$00,CTRL_ATTR2
					DEFM STR_PLAY_THE_GAME,STR_MENU_BLURB
STR_FINISH_RESTART:	EQU $AC
					DEFM DELIM,CTRL_DOUBLE,CTRL_ATTR2
					DEFM CTRL_CURPOS,$03,$03
					DEFM STR_PRESS,CTRL_ATTR3,STR_SHIFT,STR_TO
					DEFM STR_FINISH," ",STR_GAME
					DEFM CTRL_CURPOS,$04,$06
					DEFM STR_PRESS,CTRL_ATTR3,STR_ANY_KEY,STR_TO,"RESTART"
STR_SPACES:		EQU $AD
					DEFM DELIM,"   "
STR_ARROW_SEL:		EQU $AE
					DEFM DELIM,CTRL_ATTR3,CHAR_ARR1,CHAR_ARR2,STR_SPACES
STR_ARROW_NONSEL:	EQU $AF
					DEFM DELIM,CTRL_SINGLE,CTRL_ATTR1
					DEFM CHAR_ARR3,CHAR_ARR4,STR_SPACES
CTRL_WIPE_SETPOS:	EQU $B0
					DEFM DELIM,CTRL_SCREENWIPE,CTRL_ATTRMODE,$09
					DEFM CTRL_DOUBLE,CTRL_CURPOS
CTRL_POS1:		EQU $B1
					DEFM DELIM,CTRL_SGLPOS,$05,$14
CTRL_POS2:		EQU $B2
					DEFM DELIM,CTRL_SGLPOS,$19,$14
CTRL_POS3:		EQU $B3
					DEFM DELIM,CTRL_SGLPOS,$19,$17
CTRL_POS4:		EQU $B4
					DEFM DELIM,CTRL_SGLPOS,$05,$17
CTRL_POS5:		EQU $B5
					DEFM DELIM,CTRL_DOUBLE,CTRL_CURPOS,$12,$16
CTRL_POS6:		EQU $B6
					DEFM DELIM,CTRL_DOUBLE,CTRL_CURPOS,$0C,$16
CTRL_POS7:		EQU $B7
					DEFM DELIM,CTRL_SGLPOS,$01,$11
STR_GAME_SYMBOLS:	EQU $B8
					DEFM DELIM,CTRL_SINGLE,CTRL_ATTR2
					DEFM CTRL_CURPOS,$1A,$13,CHAR_SPRING
					DEFM CTRL_CURPOS,$1A,$16,CTRL_ATTR2,CHAR_SHIELD
					DEFM CTRL_CURPOS,$06,$13,CTRL_ATTR2,CHAR_LIGHTNING
					DEFM CTRL_CURPOS,$06,$16,CTRL_ATTR2,CHAR_SHIELD
CTRL_SGLPOS:		EQU $B9
					DEFM DELIM,CTRL_SINGLE,CTRL_CURPOS
STR_TITLE_SCREEN_EXT:	EQU $BA
					DEFM DELIM,STR_TITLE_SCREEN
					DEFM CTRL_CURPOS,$0A,$08
					DEFM CTRL_ATTR2,CTRL_DOUBLE,CTRL_ATTR,$00
STR_EXPLORED:		EQU $BB
					DEFM DELIM,CTRL_SGLPOS,$06,$11,CTRL_ATTR1,"EXPLORED "
STR_ROOMS_SCORE:	EQU $BC
					DEFM DELIM," ROOMS"
					DEFM CTRL_CURPOS,$09,$0E
					DEFM CTRL_ATTR2,"SCORE "
STR_LIBERATED:		EQU $BD
					DEFM DELIM,"0"
					DEFM CTRL_CURPOS,$05,$14
					DEFM CTRL_ATTR3,"LIBERATED "
STR_PLANETS:		EQU $BE
					DEFM DELIM," PLANETS"
STR_DUMMY:		EQU $BF
					DEFM DELIM,"  DUMMY"
STR_NOVICE:		EQU $C0
					DEFM DELIM,"  NOVICE"
STR_SPY:		EQU $C1
					DEFM DELIM,"   SPY    "
STR_MASTER_SPY:		EQU $C2
					DEFM DELIM,"MASTER SPY"
STR_HERO:		EQU $C3
					DEFM DELIM,"   HERO"
STR_EMPEROR:		EQU $C4
					DEFM DELIM," EMPEROR"
STR_TITLE_SCREEN:	EQU $C5
					DEFM DELIM,CTRL_ATTRMODE,$0A,CTRL_DOUBLE
					DEFM CTRL_CURPOS,$08,$00
					DEFM CTRL_ATTR2,"HEAD      HEELS"
					DEFM CTRL_SGLPOS,$0C,$01
					DEFM CTRL_ATTR,$00," OVER "
					DEFM CTRL_CURPOS,$01,$00
					DEFM " JON"
					DEFM CTRL_CURPOS,$01,$02
					DEFM "RITMAN"
					DEFM CTRL_CURPOS,$19,$00
					DEFM "BERNIE"
					DEFM CTRL_CURPOS,$18,$02
					DEFM "DRUMMOND"
STR_EMPIRE_BLURB:	EQU $C6
					DEFM DELIM,CTRL_SCREENWIPE,CTRL_ATTRMODE,$06
					DEFM CTRL_CURPOS,$05,$00,CTRL_DOUBLE,CTRL_ATTR3
					DEFM STR_THE,STR_BLACKTOOTH," EMPIRE",CTRL_SINGLE
					DEFM CTRL_CURPOS,$03,$09,CTRL_ATTR1,"EGYPTUS"
					DEFM CTRL_CURPOS,$15,$17,"BOOK WORLD"
					DEFM CTRL_CURPOS,$03,$17,"SAFARI"
					DEFM CTRL_CURPOS,$14,$09,"PENITENTIARY"
					DEFM CTRL_CURPOS,$0B,$10,STR_BLACKTOOTH
STR_BLACKTOOTH:		EQU $C7
					DEFM DELIM,"BLACKTOOTH"
STR_FINISH:		EQU $C8
					DEFM DELIM,"FINISH"
STR_FREEDOM:		EQU $C9
					DEFM DELIM,CTRL_POS6,CTRL_ATTR,$00,"FREEDOM "
STR_WIN_SCREEN:		EQU $CA
					DEFM DELIM,CTRL_SCREENWIPE,CTRL_ATTRMODE,$06
					DEFM CTRL_SGLPOS,$00,$0A,CTRL_ATTR2
					DEFM STR_THE,"PEOPLE SALUTE YOUR HEROISM"
					DEFM CTRL_CURPOS,$08,$0C
					DEFM "AND PROCLAIM YOU"
					DEFM CTRL_DOUBLE,CTRL_CURPOS,$0B,$10,CTRL_ATTR,$00
					DEFM STR_EMPEROR

					DEFM DELIM
