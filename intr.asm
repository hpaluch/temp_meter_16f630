; Interrupt handler

    LIST P=PIC16F630
    INCLUDE <P16F630.INC>

; shared registers for context save
CTX_SAVE    UDATA_SHR
w_temp  RES 1
status_temp RES 1
pclath_temp RES 1


INT_VECT  CODE    0x4               ; INT vector
    MOVWF   w_temp ; bank is unknown
    SWAPF   STATUS,W ; DON'T use MOVF! (changes Flag register)
    MOVWF   status_temp
    MOVF    PCLATH,W ; NOTE: changes STATUS bits!
    MOVWF   pclath_temp
;*** handler begins
    BANKSEL TMR0
    CLRF    TMR0     ; This seems to bi necessary, but why???
    BANKSEL PORTC
    INCF    PORTC,f ; just debug...
;*** handler ends
    MOVF    pclath_temp,W
    MOVWF   PCLATH
    SWAPF   status_temp,W
    MOVWF   STATUS  ; also restores original bank
    SWAPF   w_temp,f
    SWAPF   w_temp,w
	BCF	INTCON,T0IF	; timer overflow - ack
    RETFIE

    END