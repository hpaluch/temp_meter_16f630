; Interrupt handler

    LIST P=PIC16F630
    INCLUDE <P16F630.INC>
    INCLUDE "globals.inc" ; our global variables
; shared registers for context save
INTR_DAT UDATA_SHR
w_temp  RES 1
status_temp RES 1
pclath_temp RES 1


INT_VECT  CODE    0x4               ; INT vector
	BCF	INTCON,T0IF	; timer overflow - ack
    MOVWF   w_temp ; bank is unknown
    SWAPF   STATUS,W ; DON'T use MOVF! (changes Flag register)
    MOVWF   status_temp
    MOVF    PCLATH,W ; NOTE: changes STATUS bits!
    MOVWF   pclath_temp
;*** handler begins
    BSF APP_FLAGS,bAPP_INT  ; interrupt flag for main code
; negate multiplex bit
    MOVLW   1<<bAPP_MPLEX
    XORWF   APP_FLAGS,f
; copy MPLEX bit to sPORTA
    BCF sPORTA,bpDSP_MPLEX
    BTFSC APP_FLAGS,bAPP_MPLEX
    BSF sPORTA,bpDSP_MPLEX
    MOVF    DSP_BITS1,w
    BTFSC   APP_FLAGS,bAPP_MPLEX
    MOVF    DSP_BITS2,w
    BANKSEL  PORTC
    MOVWF    PORTC
;   copy BIT6 from W of display to sPORTA
    BCF sPORTA,bpDSP_A
    ANDLW   1<<DSP_A
    BTFSS   STATUS,Z
    BSF sPORTA,bpDSP_A
    MOVF    sPORTA,w  
    BANKSEL PORTA
    MOVWF   PORTA

;*** handler ends
    MOVF    pclath_temp,W
    MOVWF   PCLATH
    SWAPF   status_temp,W
    MOVWF   STATUS  ; also restores original bank
    SWAPF   w_temp,f
    SWAPF   w_temp,w
    RETFIE

    END