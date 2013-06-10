; Temperature meter with DS18B20 sensor, HD-A544D LED display and
; PIC 16F630 controller

; MAIN module (RESET, Init....)
    LIST P=PIC16F630
    INCLUDE <P16F630.INC>



RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED


MAIN_PROG CODE                      ; let linker place main program

START

    GOTO $                          ; loop forever

    END