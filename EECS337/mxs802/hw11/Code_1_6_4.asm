for caseid start time: Fri Oct 22 10:36:56 2010
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
	movlw	0x02
	movwf	0x0c
	movf	PORTA,w
	call	main
	goto	mloop
	return
b1:
	movlw	0x01
	addwf	0x0c,w
	movwf	0x0c
	movf	0x0c,w
	call	printf
	return
c1:
	movlw	0x01
	movwf	0x0d
	movlw	0x01
	addwf	0x0d,w
	call	printf
	return
main:
	call	b1
	call	c1
	return	; if main does not have a return
printf:	; only standard library function
	movwf	PORTB	; output w to stdout
	return
	end		; end of program code
