for caseid start time: Fri Oct 22 10:36:32 2010
; automatic code generation for ansi_c PIC16F84A compiler
; EECS337 Compilers by: caseid, date: Fall 20010
; CPU configuration
; (16F84 with RC osc, watchdog timer off, power-up timer on)
	processor 16f84A
	include <p16F84A.inc>
	__config _RC_OSC & _WDT_OFF & _PWRTE_ON
; beginning of program code
	org	0x00	; reset at address 0
reset:	goto	init	; skip reserved program addresses
	org	0x08 	; beginning of user code
init:
; At startup, all ports are inputs.
	bsf	STATUS,RP0	; switch to bank 0 memory
	clrf	TRISB		; set PORTB to all outputs
	bcf	STATUS,RP0	; return to bank 1 memory
mloop:
; here begins the main program
	movf	PORTA,w
	call	main
	goto	mloop
	return
main:
	movwf	0x0c
	movwf	0x0d
	movwf	0x0e
	movwf	0x0f
	movlw	0x04
	movwf	0x10
	movlw	0x05
	movwf	0x11
	movlw	0x07
	movwf	0x12
	movlw	0x06
	movwf	0x10
	movf	0x12,w
	addwf	0x10,w
	movwf	0x0c
	movf	0x11,w
	addwf	0x10,w
	movwf	0x0d
	movlw	0x08
	movwf	0x12
	movf	0x11,w
	addwf	0x12,w
	movwf	0x0e
	movf	0x11,w
	addwf	0x10,w
	movwf	0x0f
	movf	0x0c,w
	call	printf
	movf	0x0d,w
	call	printf
	movf	0x0e,w
	call	printf
	movf	0x0f,w
	call	printf
	retlw	0x00
	return	; if main does not have a return
printf:	; only standard library function
	movwf	PORTB	; output w to stdout
	return
	end		; end of program code
