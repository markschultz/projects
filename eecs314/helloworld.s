#actual start of the main program
#to print "Hello World"
	.globl main
main:				#main has to be a global label
	addu	$s7, $0, $ra	#save the return address in a global register
	
			#Output the string "Hello World" on separate line 
	.data
	.globl	hello
hello:	.asciiz "\nHello World\n"	#string to print
	.text
	li	$v0, 4		#print_str (system call 4)
	la	$a0, hello	# takes the address of string as an argument 
	syscall	

                       #Usual stuff at the end of the main
	addu	$ra, $0, $s7	#restore the return address
	jr	$ra		#return to the main program
	add	$0, $0, $0	#nop
