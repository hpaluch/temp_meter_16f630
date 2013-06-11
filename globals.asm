; globals.asm - Global data shared across modules
; Note: dependend modules should use INCLUDE <GLOBALS.INC>
;       to access these data

    LIST P=PIC16F630
    INCLUDE <P16F630.INC>

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
    END