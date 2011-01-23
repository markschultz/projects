for caseid start time: Mon Nov 15 08:20:00 2010
; automatic code generation for ansi_c PIC16F84A compiler
; EECS337 Compilers by: caseid, date: Fall 2010
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
	clrf	TRISA		; set PORTA to all outputs as standard input
	clrf	TRISB		; set PORTB to all outputs as standard output
	bcf	STATUS,RP0	; return to bank 1 memory
mloop:
; here begins the main program
	movlw	0x00
	movwf	0x0c
	movlw	0x00
	movwf	0x0d
	movlw	0x00
	movwf	0x0e
	movf	PORTA,w
	call	main
	goto	mloop
	return
delay:
	movlw	0xff
	movwf	0x0d
label3:
	movf	0x0d,w
	btfsc	0x03,2
	goto	label4
	movlw	0x01
	subwf	0x0d,w
	movwf	0x0d
	movlw	0xff
	movwf	0x0e
label1:
	movf	0x0e,w
	btfsc	0x03,2
	goto	label2
	movlw	0x01
	subwf	0x0e,w
	movwf	0x0e
	goto	label1
label2:
	goto	label3
label4:
	return
left:
	movlw	0x10
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	movlw	0x30
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	movlw	0x70
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	movlw	0x00
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	return
right:
	movlw	0x08
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	movlw	0x0c
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	movlw	0x0e
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	movlw	0x00
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	return
hazard:
	movlw	0x7e
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	movlw	0x00
	movwf	0x0c
	movf	0x0c,w
	call	printf
	call	delay
	return
main:
	movwf	0x0f
	movlw	0x01
	andwf	0x0f,w
	btfsc	0x03,2
	goto	label5
	call	hazard
label5:
	movlw	0x02
	andwf	0x0f,w
	btfsc	0x03,2
	goto	label6
	call	left
label6:
	movlw	0x04
	andwf	0x0f,w
	btfsc	0x03,2
	goto	label7
	call	right
label7:
	retlw	0x00
	return	; if main does not have a return
printf:	; only standard library function
	movwf	PORTB	; output w to stdout
	return
	end		; end of program code
