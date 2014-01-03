	;; 
	;; equs.asm
	;;
	;; Constants file.
	;;
	
	;; All 16-bit constants have been replaced with a 'LXXXX'
	;; label, allowing search and replace of interesting constants
	;; with nice names.
	;;
	;; This file EQUs up those ugly names.
	;;
	;; FIXME: It should go away!
	;; 

L0000:	EQU $0000
L0001:	EQU $0001
L0002:	EQU $0002
L0003:	EQU $0003
L0004:	EQU $0004
L0005:	EQU $0005
L0006:	EQU $0006
L0007:	EQU $0007
L0008:	EQU $0008
L0009:	EQU $0009
L000A:	EQU $000A
L000B:	EQU $000B
L0010:	EQU $0010
L0012:	EQU $0012
L0018:	EQU $0018
L0020:	EQU $0020
L0024:	EQU $0024
L0030:	EQU $0030
L0040:	EQU $0040
L0043:	EQU $0043
L0048:	EQU $0048
L0060:	EQU $0060
L0070:	EQU $0070
L0094:	EQU $0094
L00A8:	EQU $00A8
L00F8:	EQU $00F8
L00FE:	EQU $00FE
L00FF:	EQU $00FF
L0100:	EQU $0100
L0104:	EQU $0104
L012D:	EQU $012D
L0150:	EQU $0150
L01F4:	EQU $01F4
L027C:	EQU $027C
L0401:	EQU $0401
L040F:	EQU $040F
L0501:	EQU $0501
L05FF:	EQU $05FF
L0606:	EQU $0606
L0804:	EQU $0804
L0808:	EQU $0808
L080C:	EQU $080C
L091B:	EQU $091B
L0D00:	EQU $0D00
L0D70:	EQU $0D70
L0D7C:	EQU $0D7C
L1002:	EQU $1002
L1004:	EQU $1004
L1800:	EQU $1800
L180C:	EQU $180C
L181F:	EQU $181F
L184D:	EQU $184D
L1B21:	EQU $1B21
L390C:	EQU $390C
L4000:	EQU $4000
L4048:	EQU $4048
L40C0:	EQU $40C0
L4857:	EQU $4857
L4C50:	EQU $4C50
L523E:	EQU $523E
L569A:	EQU $569A
L5800:	EQU $5800
L5B00:	EQU $5B00
L5C71:	EQU $5C71
L6088:	EQU $6088
L6B16:	EQU $6B16
L7FFD:	EQU $7FFD 		; Numeric constant

	;; References into code area.
LA800:	EQU $A800		; Numeric constant?

	;; Data-ish stuff
LBA00:	EQU $BA00
LBA3E:	EQU $BA3E
LBF20:	EQU $BF20
LC000:	EQU $C000
LC040:	EQU $C040
LC043:	EQU $C043
LC0C0:	EQU $C0C0
LC910:	EQU $C910
LCBB0:	EQU $CBB0
LCD30:	EQU $CD30
LCF3E:	EQU $CF3E
LD12D:	EQU $D12D
LD8B0:	EQU $D8B0
LEB90:	EQU $EB90
LF610:	EQU $F610
LF670:	EQU $F670
LF760:	EQU $F760
LF790:	EQU $F790
LF91B:	EQU $F91B
LF91D:	EQU $F91D
LF933:	EQU $F933
LF943:	EQU $F943
LF9D7:	EQU $F9D7
LFB28:	EQU $FB28
LFB49:	EQU $FB49
LFEFE:	EQU $FEFE
LFF7F:	EQU $FF7F
LFFEE:	EQU $FFEE
LFFF5:	EQU $FFF5
LFFFA:	EQU $FFFA
LFFFE:	EQU $FFFE
LFFFF:	EQU $FFFF
