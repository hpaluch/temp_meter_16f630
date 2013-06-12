; globals.inc - include this file to access
;               global variables from globals.asm

; DSP_BITS bit definitions (segments A-G and Minus sign)
DSP_G   EQU .0
DSP_F   EQU .1
DSP_E   EQU .2
DSP_D   EQU .3
DSP_C   EQU .4
DSP_B   EQU .5
DSP_A   EQU .6

; DSP_BITS export
    extern  DSP_BITS1
    extern  DSP_BITS2
; port bits for display on PORTA
bpDSP_A     EQU .5     ; RA5
bpDSP_MPLEX EQU .4 ; RA4
bpDSP_MINUS EQU .0 ; RA0
    extern sPORTA
; app flags
    extern APP_FLAGS
bAPP_MPLEX  EQU .0  ; multiplex bit
bAPP_INT    EQU .1  ; set on interrupt (when main code waits for INT)
bAPP_ERR    EQU .2  ; error flag
; DS18B20 specific constants
dsPORT  EQU PORTA
dsTRIS  EQU TRISA
dsBIT   EQU .2
    EXTERN vTEMPR
; global utilities (globals.asm)
    EXTERN WAIT4INT
    EXTERN WAIT1S