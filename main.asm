; Temperature meter with DS18B20 sensor, HD-A544D LED display and
; PIC 16F630 controller

; MAIN module (RESET, Init....)
    LIST P=PIC16F630
    INCLUDE <P16F630.INC>
    INCLUDE "globals.inc" ; our global variables
    INCLUDE "display.inc" ; display utilities
    INCLUDE "ds18b20.inc" ; DS18B20 sensor
; _MCLRE_ON require external Pull-Up - but it would be incompatible with PicKit 3...
    __CONFIG _CP_OFF & _CPD_OFF & _BODEN_OFF & _MCLRE_OFF & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT


RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;*** OSCCAL reservation
RCCAL CODE 0x3ff
OSC_RET RES 1            ; keep RETLW xx

MAIN_DATA UDATA_SHR

;*** main program code
MAIN_PROG CODE                      ; let linker place main program
START
;*** calibrate internal oscillator
    CALL    OSC_RET
    BANKSEL OSCCAL
    MOVWF   OSCCAL
;*** our application flags
    CLRF    APP_FLAGS
;*** setup OPTION_REG - Prescaler to Timer etc...
    CLRWDT 
    MOVLW ~( 1<<T0CS | 1<<PSA | 1<<PS1 | 1<<PS0 ) ; divide clock by 32
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
; intialize PORTA outputs
    MOVLW ~0
    MOVWF sPORTA
    BANKSEL PORTA
    MOVWF PORTA
    MOVLW ~(1<<bpDSP_A | 1<<bpDSP_MPLEX | 1<<bpDSP_MINUS)
    BANKSEL TRISA
    MOVWF   TRISA
; clear Timer0 and prescaler - without this the prescaler does not work
; (at least in simulator - why???)
    BANKSEL TMR0
    CLRF    TMR0
; initialize Display bits to '-' '-'
;    BANKSEL DSP_BITS - shared BANKSEL not needed
    MOVLW ~(1<<DSP_G)
    MOVWF   DSP_BITS1
    MOVWF   DSP_BITS2
; enable Timer0 and Global Interrupts
	BSF	INTCON,T0IE	; enable Timer interrupts
	BSF	INTCON,GIE	; Global Interrupt Enable

; DEBUG START
;    MOVLW 1
;    MOVWF vTEMPR
;DDD:
;    CALL WAIT4INT
;    CALL BIN2DISP
;    CALL  WAIT1S
;    DECF vTEMPR,f
;    GOTO DDD
; DEBUG END


; wait for interrupt
LOOP2:
    CALL WAIT4INT
    CALL GET_TEMP
    BTFSC APP_FLAGS,bAPP_ERR
    GOTO E0  ; Error 0 - DS18B20 not found
    CALL BIN2DISP
; wait 1s
    CALL  WAIT1S
; measure temperature again
    GOTO LOOP2

    END