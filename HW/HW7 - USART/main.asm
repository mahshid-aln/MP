;====================================================================
; Main.asm file generated by New Project wizard
;
; Created:   Fri Dec 23 2016
; Processor: ATmega16
; Compiler:  AVRASM (Proteus)
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================

;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
      rjmp  Start

;====================================================================
; CODE SEGMENT
;====================================================================

.equ	LCD_RS	= 1
.equ	LCD_RW	= 2
.equ	LCD_E	= 3

.def	temp	= r16
.def	argument= r17		;argument for calling subroutines
.def	return	= r18		;return value from subroutines

.org 0x00
jmp reset

.org 0x02
	jmp ext_int0_isr

ext_int0_isr:
	cli
	call findkey
	call lcd_wait
	mov argument, r21
usart_trans:	
	sbis UCSRA, UDRE
	rjmp usart_trans
	out UDR, r21
	call lcd_putchar
	ldi r20, (1 << PC0 | 1 << PC1 | 1 << PC2 | 1 << PC3 | 0 << PC4 | 0 << PC5 | 0 << PC6 | 0 << PC7 )
	out PORTC, r20
	sei
	ret
findkey:
	sbis PINC, 0
	jmp column1
	sbis PINC, 1
	jmp column2
	sbis PINC, 2
	jmp column3
	sbis PINC, 3
	jmp column4
	
	
	
column1:
	sbi PORTC, 4
	sbis PINC, 0
	jmp four
	zero:
	    ldi r21, '0'
	    ret
	four:
	    sbi PORTC, 5
	    sbis PINC, 0
	    jmp eight
	    ldi r21, '4'
	    ret
	eight:
	    sbi PORTC, 6
	    sbis PINC, 0
	    jmp C
	    ldi r21, '8'
	    ret
	C:	
	    sbi PORTC, 7
	    sbis PINC, 0
	    ret
	    ldi r21, 'C'
	    ret
column2:
	sbi PORTC, 4
	sbis PINC, 1
	jmp five
	one:
	    ldi r21, '1'
	    ret
	five:
	    sbi PORTC, 5
	    sbis PINC, 1
	    jmp nine
	    ldi r21, '5'
	    ret
	nine:
	    sbi PORTC, 6
	    sbis PINC, 1
	    jmp D
	    ldi r21, '9'
	    ret
	D:
	    sbi PORTC, 7
	    sbis PINC, 1
	    ret
	    ldi r21, 'D'
	    ret
column3:
	sbi PORTC, 4
	sbis PINC, 2
	jmp six
	two:
	    ldi r21, '2'
	    ret
	six:
	    sbi PORTC, 5
	    sbis PINC, 2
	    jmp A
	    ldi r21, '6'
	    ret
	A:
	    sbi PORTC, 6
	    sbis PINC, 2
	    jmp E
	    ldi r21, 'A'
	    ret
	E:
	    sbi PORTC, 7
	    sbis PINC, 2
	    ret
	    ldi r21, 'E'
	    ret
column4:
	sbi PORTC, 4
	sbis PINC, 3
	jmp seven
	three:
	    ldi r21, '3'
	    ret
	seven:
	    sbi PORTC, 5
	    sbis PINC, 3
	    jmp B
	    ldi r21, '7'
	    ret
	B:
	    sbi PORTC, 6
	    sbis PINC, 3
	    jmp F
	    ldi r21, 'B'
	    ret
	F:
	    sbi PORTC, 7
	    sbis PINC, 3
	    ret
	    ldi r21, 'F'
	    ret
	 
	ret
   

reset:
     cli 
     ldi temp, low(RAMEND)
     out SPL, temp
     ldi temp, high(RAMEND)
     out SPH, temp
     call lcd_init
     
    
     
     ldi r20, 0x19
     out UBRRL, r20
     
     ldi r20, 0x00
     out UBRRH, r20
     
     ldi r20, (0 << U2X)
     out UCSRA, r20
     
     ldi r20, (1 << TXEN |  0 << UCSZ2 )
     out UCSRB, r20
     
     
     ldi r20, (1 << URSEL | 0 << UMSEL | 1 << UCSZ0 | 1 << UCSZ1 | 0 << UPM0 | 1 << UPM1 | 0 << USBS)
     out UCSRC, r20
    
     
     
     
     ldi r20, (1 << isc11)|(0<< isc10)|(1 << isc01)|(0 << isc00)
     out MCUCR, r20
     ldi r20, (1 << INT0) //enable INT0
     out GICR, r20
     ldi r20, (0 << PD2)
     out DDRD, r20
     ldi r20, (1 << PD2)
     out PORTD, r20
     
     ldi r20, (0 << PC0 | 0 << PC1 | 0 << PC2 | 0 << PC3 | 1 << PC4 | 1 << PC5 | 1 << PC6 | 1 << PC7)
     out DDRC, r20  
     ldi r20, (1 << PC0 | 1 << PC1 | 1 << PC2 | 1 << PC3 )
     out PORTC, r20 
     
     
     sei 
	

start:
      ; Write your code here
loop:
      jmp loop

     
      

 
      
	 
      
lcd_command8:	;used for init (we need some 8-bit commands to switch to 4-bit mode!)
	in	temp, DDRA		;we need to set the high nibble of DDRA while leaving
					;the other bits untouched. Using temp for that.
	sbr	temp, 0b11110000	;set high nibble in temp
	out	DDRA, temp		;write value to DDRA again
	in	temp, PortA		;then get the port value
	cbr	temp, 0b11110000	;and clear the data bits
	cbr	argument, 0b00001111	;then clear the low nibble of the argument
					;so that no control line bits are overwritten
	or	temp, argument		;then set the data bits (from the argument) in the
					;Port value
	out	PortA, temp		;and write the port value.
	sbi	PortA, LCD_E		;now strobe E
	nop
	nop
	nop
	cbi	PortA, LCD_E
	in	temp, DDRA		;get DDRA to make the data lines input again
	cbr	temp, 0b11110000	;clear data line direction bits
	out	DDRA, temp		;and write to DDRA
ret

lcd_putchar:
	push	argument		;save the argmuent (it's destroyed in between)
	in	temp, DDRA		;get data direction bits
	sbr	temp, 0b11110000	;set the data lines to output
	out	DDRA, temp		;write value to DDRA
	in	temp, PortA		;then get the data from PORTA
	cbr	temp, 0b11111110	;clear ALL LCD lines (data and control!)
	cbr	argument, 0b00001111	;we have to write the high nibble of our argument first
					;so mask off the low nibble
	or	temp, argument		;now set the argument bits in the Port value
	out	PortA, temp		;and write the port value
	sbi	PortA, LCD_RS		;now take RS high for LCD char data register access
	sbi	PortA, LCD_E		;strobe Enable
	nop
	nop
	nop
	cbi	PortA, LCD_E
	pop	argument		;restore the argument, we need the low nibble now...
	cbr	temp, 0b11110000	;clear the data bits of our port value
	swap	argument		;we want to write the LOW nibble of the argument to
					;the LCD data lines, which are the HIGH port nibble!
	cbr	argument, 0b00001111	;clear unused bits in argument
	or	temp, argument		;and set the required argument bits in the port value
	out	PortA, temp		;write data to port
	sbi	PortA, LCD_RS		;again, set RS
	sbi	PortA, LCD_E		;strobe Enable
	nop
	nop
	nop
	cbi	PortA, LCD_E
	cbi	PortA, LCD_RS
	in	temp, DDRA
	cbr	temp, 0b11110000	;data lines are input again
	out	DDRA, temp
ret

lcd_command:	;same as LCD_putchar, but with RS low!
	push	argument
	in	temp, DDRA
	sbr	temp, 0b11110000
	out	DDRA, temp
	in	temp, PortA
	cbr	temp, 0b11111110
	cbr	argument, 0b00001111
	or	temp, argument

	out	PortA, temp
	sbi	PortA, LCD_E
	nop
	nop
	nop
	cbi	PortA, LCD_E
	pop	argument
	cbr	temp, 0b11110000
	swap	argument
	cbr	argument, 0b00001111
	or	temp, argument
	out	PortA, temp
	sbi	PortA, LCD_E
	nop
	nop
	nop
	cbi	PortA, LCD_E
	in	temp, DDRA
	cbr	temp, 0b11110000
	out	DDRA, temp
ret

LCD_getchar:
	in	temp, DDRA		;make sure the data lines are inputs
	andi	temp, 0b00001111	;so clear their DDR bits
	out	DDRA, temp
	sbi	PortA, LCD_RS		;we want to access the char data register, so RS high
	sbi	PortA, LCD_RW		;we also want to read from the LCD -> RW high
	sbi	PortA, LCD_E		;while E is high
	nop
	in	temp, PinA		;we need to fetch the HIGH nibble
	andi	temp, 0b11110000	;mask off the control line data
	mov	return, temp		;and copy the HIGH nibble to return
	cbi	PortA, LCD_E		;now take E low again
	nop				;wait a bit before strobing E again
	nop	
	sbi	PortA, LCD_E		;same as above, now we're reading the low nibble
	nop
	in	temp, PinA		;get the data
	andi	temp, 0b11110000	;and again mask off the control line bits
	swap	temp			;temp HIGH nibble contains data LOW nibble! so swap
	or	return, temp		;and combine with previously read high nibble
	cbi	PortA, LCD_E		;take all control lines low again
	cbi	PortA, LCD_RS
	cbi	PortA, LCD_RW
ret					;the character read from the LCD is now in return

LCD_getaddr:	;works just like LCD_getchar, but with RS low, return.7 is the busy flag
	in	temp, DDRA
	andi	temp, 0b00001111
	out	DDRA, temp
	cbi	PortA, LCD_RS
	sbi	PortA, LCD_RW
	sbi	PORTA, LCD_E
	nop
	in	temp, PINA
	andi	temp, 0b11110000
	mov	return, temp
	cbi	PORTA, LCD_E
	nop
	nop
	sbi	PORTA, LCD_E
	nop
	in	temp, PINA
	andi	temp, 0b11110000
	swap	temp
	or	return, temp
	cbi	PORTA, LCD_E
	cbi	PORTA, LCD_RW
ret

LCD_wait:				;read address and busy flag until busy flag cleared
	rcall	LCD_getaddr
	andi	return, 0x80
	brne	LCD_wait
	ret


LCD_delay:
	clr	r2
	LCD_delay_outer:
	clr	r3
		LCD_delay_inner:
		dec	r3
		brne	LCD_delay_inner
	dec	r2
	brne	LCD_delay_outer
ret
      
LCD_init:
	
	ldi	temp, 0b00001110	;control lines are output, rest is input
	out	DDRA, temp
	
	rcall	LCD_delay		;first, we'll tell the LCD that we want to use it
	ldi	argument, 0x20		;in 4-bit mode.
	rcall	LCD_command8		;LCD is still in 8-BIT MODE while writing this command!!!

	rcall	LCD_wait
	ldi	argument, 0x28		;NOW: 2 lines, 5*7 font, 4-BIT MODE!
	rcall	LCD_command		;
	
	rcall	LCD_wait
	ldi	argument, 0x0F		;now proceed as usual: Display on, cursor on, blinking
	rcall	LCD_command
	
	rcall	LCD_wait
	ldi	argument, 0x01		;clear display, cursor -> home
	rcall	LCD_command
	
	rcall	LCD_wait
	ldi	argument, 0x06		;auto-inc cursor
	rcall	LCD_command
ret
	


;====================================================================
