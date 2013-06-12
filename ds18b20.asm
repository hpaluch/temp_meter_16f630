; ds18b20.asm - routines to handle temperature sensor DS18B20
; based on http://www.maximintegrated.com/app-notes/index.mvp/id/2420

    LIST P=PIC16F630
    INCLUDE <P16F630.INC>
    INCLUDE "globals.inc" ; our global variables

; *******************************************************
; Maxim 1-Wire MACROS
; *******************************************************
OW_HIZ:MACRO
      BSF           STATUS,RP0                  ; Select Bank 1 of data memory
      BSF           dsTRIS, dsBIT                   ; Make dsBIT pin High Z
      BCF           STATUS,RP0                  ; Select Bank 0 of data memory
      ENDM
; --------------------------------------------------------
OW_LO:MACRO
      BCF           STATUS,RP0                  ; Select Bank 0 of data memory
      BCF           dsPORT, dsBIT                   ; Clear the dsBIT bit
      BSF           STATUS,RP0                  ; Select Bank 1 of data memory
      BCF           dsTRIS, dsBIT                   ; Make dsBIT pin an output
      BCF           STATUS,RP0                  ; Select Bank 0 of data memory
      ENDM
; --------------------------------------------------------
WAIT:MACRO TIME
;Delay for TIME µs.
;Variable time must be in multiples of 5µs.
      MOVLW         (TIME/5)-1                  ;1µs
      MOVWF         TMP0                        ;1µs
      CALL          WAIT5U                      ;2µs
      ENDM

DS_DATA UDATA_SHR
TMP0    RES 1
COUNT   RES 1
IOBYTE  RES 1
PDBYTE  RES 1

DS_CODE CODE
; *******************************************************
;       Maxim 1-Wire ROUTINES
; *******************************************************
WAIT5U:
;This takes 5µS to complete
      NOP                                       ;1µs
      NOP                                       ;1µs
      DECFSZ        TMP0,F                      ;1µs or 2µs
      GOTO          WAIT5U                      ;2µs
      RETLW 0                                   ;2µs
; --------------------------------------------------------
OW_RESET:
      OW_HIZ                                    ; Start with the line high
      BCF APP_FLAGS,bAPP_ERR                               ; Clear the PD byte
      OW_LO
      WAIT          .500                        ; Drive Low for 500µs
      OW_HIZ
      WAIT          .70                         ; Release line and wait 70µs for PD Pulse
      BTFSC         dsPORT,dsBIT                    ; Read for a PD Pulse
      BSF APP_FLAGS,bAPP_ERR       ; Set PDBYTE to 1 if get a PD Pulse
      WAIT          .400                        ; Wait 400µs after PD Pulse
      RETLW 0
; --------------------------------------------------------
DSRXBYTE: ; Byte read is stored in IOBYTE
      MOVLW         .8
      MOVWF         COUNT                       ; Set COUNT equal to 8 to count the bits
DSRXLP:
      OW_LO
      NOP
      NOP
      NOP
      NOP
      NOP
      NOP                                       ; Bring dsBIT low for 6µs
      OW_HIZ
      NOP
      NOP
      NOP
      NOP                                       ; Change to HiZ and Wait 4µs
      MOVF          dsPORT,W                     ; Read dsBIT
      ANDLW         1<<dsBIT                       ; Mask off the dsBIT bit
      ADDLW         .255                        ; C=1 if dsBIT=1: C=0 if dsBIT=0
      RRF           IOBYTE,F                    ; Shift C into IOBYTE
      WAIT          .50                         ; Wait 50µs to end of time slot
      DECFSZ        COUNT,F                     ; Decrement the bit counter
      GOTO          DSRXLP
      RETLW         0
; --------------------------------------------------------
DSTXBYTE:                                       ; Byte to send starts in W
      MOVWF         IOBYTE                      ; We send it from IOBYTE
      MOVLW         .8
      MOVWF         COUNT                       ; Set COUNT equal to 8 to count the bits
DSTXLP:
      OW_LO
      NOP
      NOP
      NOP                                       ; Drive the line low for 3µs
      RRF           IOBYTE,F
      BSF           STATUS,RP0                  ; Select Bank 1 of data memory
      BTFSC         STATUS,C                    ; Check the LSB of IOBYTE for 1 or 0
      BSF           dsTRIS,dsBIT                    ; HiZ the line  if LSB is 1
      BCF           STATUS,RP0                  ; Select Bank 0 of data memory
      WAIT          .60                         ; Continue driving line for 60µs
      OW_HIZ                                    ; Release the line for pullup
      NOP
      NOP                                       ; Recovery time of 2µs
      DECFSZ        COUNT,F                     ; Decrement the bit counter
      GOTO          DSTXLP
      RETLW         0
; --------------------------------------------------------

GET_TEMP:
    GLOBAL GET_TEMP
      CALL          OW_RESET                    ; Send Reset Pulse and read for Presence Detect Pulse
      BTFSC         APP_FLAGS,bAPP_ERR          ; 1 = Presence Detect Detected
      RETLW 0
      MOVLW         0xCC
      CALL          DSTXBYTE                    ; Send Skip ROM Command (0xCC)
      MOVLW         0x44
      CALL          DSTXBYTE                    ; Convert T

      CALL  WAIT1S  ; Convert T may took up to 750ms, so wait 1s
      CALL          OW_RESET                    ; Send Reset Pulse and read for Presence Detect Pulse
      BTFSC         APP_FLAGS,bAPP_ERR          ; 1 = Presence Detect Detected
      RETLW 0
      MOVLW         0xCC
      CALL          DSTXBYTE                    ; Send Skip ROM Command (0xCC)
      MOVLW         0xBE
      CALL          DSTXBYTE                    ; Read ScratchPad
      ; temperature LSB
      CALL          DSRXBYTE
      SWAPF IOBYTE,w
      ANDLW 0xf
      MOVWF vTEMPR
      ; temperature MSB
      CALL          DSRXBYTE
      SWAPF IOBYTE,w
      ANDLW 0xf0
      XORWF vTEMPR,f ; equivalent of OR in this case
      ; no interest in other bytes -> reset
      CALL          OW_RESET                    ; Send Reset Pulse
        RETURN
    END