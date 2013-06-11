; globals.asm - Global data shared across modules
; Note: dependend modules should use INCLUDE <GLOBALS.INC>
;       to access these data

    LIST P=PIC16F630
    INCLUDE <P16F630.INC>

; NOTE: PIC16F630 has SHARED data only! (no UDATA section!)
GLOB_DAT UDATA_SHR
; display bits - bit 5 to bit 0 are mapped to PORTC
DSP_BITS RES 1
    GLOBAL DSP_BITS

    END