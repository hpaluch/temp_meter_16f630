; Temperature meter with DS18B20 sensor, HD-A544D LED display and
; PIC 16F630 controller

; MAIN module (RESET, Init....)
    LIST P=PIC16F630
    INCLUDE <P16F630.INC>
    INCLUDE "globals.inc" ; our global variables
    INCLUDE "display.inc" ; display utilities
; _MCLRE_ON require external Pull-Up - but it would be incompatible with PicKit 3...
    __CONFIG _CP_OFF & _CPD_OFF & _BODEN_OFF & _MCLRE_OFF & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT


RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;*** OSCCAL reservation
RCCAL CODE 0x3ff
OSC_RET RES 1            ; keep RETLW xx

MAIN_DATA UDATA_SHR
vBCD    RES 1
vWait1  RES 1

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
    MOVLW ~(1<<bpDSP_A | 1<<bpDSP_MPLEX)
    BANKSEL TRISA
    MOVWF   TRISA
; clear Timer0 and prescaler - without this the prescaler does not work
; (at least in simulator - why???)
    BANKSEL TMR0
    CLRF    TMR0
; initialize Display bits to something...
;    BANKSEL DSP_BITS - shared BANKSEL not needed
    CLRF    DSP_BITS1
    CLRF    DSP_BITS2
; enable Timer0 and Global Interrupts
	BSF	INTCON,T0IE	; enable Timer interrupts
	BSF	INTCON,GIE	; Global Interrupt Enable

; simple TEST - increment vBCD...
    CLRF vBCD
LOOP1
    MOVLW vBCD
    MOVWF FSR
    CALL DISP_BIN2BITS
    MOVWF DSP_BITS1
; wait 1s
    MOVLW .64 ; interrupt takes 8ms * 125 ~= 1s
    MOVWF vWait1
; wait for interrupt
LOOP2
    BTFSS APP_FLAGS,bAPP_INT
    GOTO LOOP2
    BCF APP_FLAGS,bAPP_INT
    DECFSZ vWait1,f
    GOTO LOOP2
; increment vBCD for testing purposes...
    INCF vBCD,f
    GOTO LOOP1

    END