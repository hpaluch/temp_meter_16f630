; Temperature meter with DS18B20 sensor, HD-A544D LED display and
; PIC 16F630 controller

; MAIN module (RESET, Init....)
    LIST P=PIC16F630
    INCLUDE <P16F630.INC>

    __CONFIG _CP_OFF & _CPD_OFF & _BODEN_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT & _BOREN_ON


RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;*** OSCCAL reservation
RCCAL CODE 0x3ff
OSC_RET RES 1            ; keep RETLW xx


;*** main program code
MAIN_PROG CODE                      ; let linker place main program
START
;*** calibrate internal oscillator
    CALL    OSC_RET
    BANKSEL OSCCAL
    MOVWF   OSCCAL
;*** setup OPTION_REG - Prescaler to Timer etc...
    CLRWDT 
    MOVLW ~( 1<<T0CS | 1<<PSA  ) ; divide clock by 32
    BANKSEL OPTION_REG
    MOVWF   OPTION_REG
; comparator Off
    MOVLW   1<<CM0 | 1<<CM1 | 1<< CM2
    BANKSEL CMCON
    MOVWF   CMCON
; init PORTC, latch to -1, all pins are outputs...
    MOVLW   ~0 ; latch to -1
    BANKSEL PORTC
    MOVWF   PORTC ; all available PINs set to zero (Output)
    BANKSEL TRISC
    CLRF    TRISC
; enable Timer0 and Global Interrupts
	BSF	INTCON,T0IE	; enable Timer interrupts
	BSF	INTCON,GIE	; Global Interrupt Enable
    GOTO $                          ; loop forever

    END