; globals.asm - Global data shared across modules
; Note: dependend modules should use INCLUDE <GLOBALS.INC>
;       to access these data

    LIST P=PIC16F630
    INCLUDE <P16F630.INC>

bAPP_INT    EQU .1  ; Grrrr - should be used from globals.inc


; NOTE: PIC16F630 has SHARED data only! (no UDATA section!)
GLOB_DAT UDATA_SHR
; display bits - bit 5 to bit 0 are mapped to PORTC
; 1st digit
DSP_BITS1 RES 1
    GLOBAL DSP_BITS1
; 2st digit
DSP_BITS2 RES 1
    GLOBAL DSP_BITS2
; shadow PORTA (to avoid read-modify-write problems etc...)
sPORTA  RES 1
    GLOBAL sPORTA
; misc application flags (sit bAPP - app bits in globals.inc)
APP_FLAGS RES 1
    GLOBAL APP_FLAGS
vTEMPR  RES 1
    GLOBAL vTEMPR

vWait1     RES 1 ; local variable

GLOB_CODE CODE
; Wait for interrupt
WAIT4INT:
    GLOBAL WAIT4INT
    BTFSS APP_FLAGS,bAPP_INT
    GOTO WAIT4INT
    BCF APP_FLAGS,bAPP_INT
    RETURN

WAIT1S:
    GLOBAL  WAIT1S
    MOVLW .125 ; interrupt takes 8ms * 125 ~= 1s
    MOVWF vWait1
LOOP3:
    CALL WAIT4INT
    DECFSZ vWait1,f
    GOTO LOOP3
    RETURN

    END