; display.asm - display conversion/manipulation
;

    LIST P=PIC16F630
    INCLUDE <P16F630.INC>
    INCLUDE "globals.inc" ; our global variables


DISP_CODE CODE                      ; let linker place main program

; convert lowest for bits from W to display bits (into W)
HALF_TO_BCD
    ANDLW 0xf ; ensure that there is no table overflow
; TODO....
DISP_TBL
    END