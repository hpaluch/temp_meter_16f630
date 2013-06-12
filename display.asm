; display.asm - display conversion/manipulation
;
    LIST P=PIC16F630
    INCLUDE <P16F630.INC>
    INCLUDE "globals.inc" ; our global variables

DISP_DATA UDATA_SHR
vBCD    RES 1
    GLOBAL vBCD
DISP_CODE CODE                      ; let linker place main program


BCD2DISP
    GLOBAL BCD2DISP
    SWAPF vBCD,f
    CALL DISP_BIN2BITS
    MOVWF DSP_BITS1
    SWAPF vBCD,f
    CALL DISP_BIN2BITS
    MOVWF DSP_BITS2
    RETURN

; convert lowest for bits from FSR to display bits (into W)
; Input: vBCD = 4 bit binary number ( 0 - F )
; Output: W Display bits (values for DISP_BITS1 or DISP_BITS2)
DISP_BIN2BITS
    PAGESELW DISP_TBL
    MOVWF PCLATH
    MOVF vBCD,w
    ANDLW 0xf ; ensure that there is no table overflow
    ADDWF PCL,f
DISP_TBL
; NOTE: negative logic ( 0 = LED on, 1= LED off)
    RETLW  1<< DSP_G  ; 0 = G turned off, all other turned on
    RETLW  ~(1<<DSP_B | 1<<DSP_C) ; 1 = B + C
    RETLW  1<<DSP_F | 1<<DSP_C  ; 2 = F off, C off
    RETLW  1<<DSP_F | 1<<DSP_E  ; 3 = F off, E off
    RETLW  1<<DSP_A | 1<<DSP_D | 1<<DSP_E; 4 = A off, D off, E off
    RETLW  1<<DSP_B | 1<<DSP_E ; 5 = B off, E off
    RETLW  1<<DSP_B ; 6 = B off
    RETLW  ~(1<<DSP_A | 1<<DSP_B | 1<<DSP_C); 7 = A + B + C
    RETLW  0; 8 - everything on
    RETLW 1<<DSP_E  ; 9 - E off
    RETLW 1<<DSP_F; a = F off
    RETLW 1<<DSP_A | 1<<DSP_B; b = A off, B off
    RETLW ~(1<<DSP_D | 1<<DSP_E | 1<<DSP_G); c = D  + E + G
    RETLW 1<<DSP_A | 1<<DSP_F ; d= A off, F off
    RETLW 1<<DSP_B | 1<<DSP_C; E = B off, C off
    RETLW 1<<DSP_B | 1<<DSP_C | 1<<DSP_D; F = B off, C off, D off
    END