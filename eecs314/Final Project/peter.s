




















































.data
arr:    .word     0 : 441       # storage for 10x10 matrix of words
dot:   .asciiz	  ".   "
dash:  .asciiz	  "-   "
bar:   .asciiz	  "|   "
one:   .asciiz	  "1   "
two:   .asciiz	  "2   "
space: .asciiz	  "    "
newline: .asciiz  "\n"

.text

main:

# t1 = i,  t1 = j, t3 = iIsEven, t4 = jIsEven

	move $t1, $zero #  i = 0;
Iloop:

	
	move $t2, $zero #  j = 0;
Jloop:	
	

		#check if i is even
	addi $t3, $t1, 1
	sll  $t3, $t3, 7
	srl  $t3, $t3, 7 
	
		#check if j is even
	addi $t4, $t2, 1
	sll  $t4, $t4, 31
	srl  $t4, $t4, 31 

	## t3 and t4 are now booleans holding whether j and i are even
	
	#read arr[i,j] into $t8
	la $t6, arr
	li $t7, 10
	mul $t8, $t1, $t7    # t8 holds 10*i
	add $t8, $t8, $t2    # t8 holds 10*i + j
	li $t7, 4
	mul $t8, $t8, $t7    #t8 holds (10*i + j) * 4
	add $t8, $t6, $t8    #t8 holds arr + (the above)
	lw $t8, ($t8)        #t8 holds arr[i,j]
	
	
	#draw dot
	beq $t3, $zero, SkipDot #skip if i != even
	beq $t4, $zero, SkipDot #skip if j != even	
	la $a0, dot
	addi $v0, $zero, 4
	syscall

SkipDot:

	#draw bar
	bne $t3, $zero, SkipBar #skip if i  = even
	beq $t4, $zero, SkipBar #skip if j != even
	beq $t8, $zero, SkipBar #skip if arr[i,j] == 0	
	la $a0, bar
	addi $v0, $zero, 4
	syscall

SkipBar:

	#draw dash
	beq $t3, $zero, SkipDash #skip if i != even
	bne $t4, $zero, SkipDash #skip if j  = even
	beq $t8, $zero, SkipDash #skip if arr[i,j] == 0		
	la $a0, dash
	addi $v0, $zero, 4
	syscall

SkipDash:

	#draw 1 inside box
	beq $t3, $zero, SkipOne #skip if i != even
	bne $t4, $zero, SkipOne #skip if j  = even	
	li $t6, 5
	beq $t8, $t6, SkipOne #skip if arr[i,j] == 5 	
	la $a0, one
	addi $v0, $zero, 4
	syscall

SkipOne:
	
	#draw 2 inside box
	beq $t3, $zero, SkipTwo #skip if i != even
	bne $t4, $zero, SkipTwo #skip if j  = even	
	la $a0, two
	addi $v0, $zero, 4
	syscall

SkipTwo:

	#draw a " " in the case that arr[i,j] == 0 or iodd jodd
	bne $t3, $zero, SkipSpace #skip if i = even
	bne $t4, $zero, SkipSpace #skip if j = even	
	bne $t8, $zero, SkipSpace #skip if arr[i, j] != 0 
	la $a0, space
	addi $v0, $zero, 4
	syscall

SkipSpace:

	addi $t2, $t2, 1 #  j++
	li $t6, 21
	blt $t2, $t6, Jloop	# if j<10, goto Jloop
	
	#  print \n
	la $a0, newline
	addi $v0, $zero, 4
	syscall


	addi $t1, $t1, 1#  i++
	li $t6, 21
	blt $t1, $t6, Iloop	# if i<10, goto Iloop

	li $v0, 10
	syscall		# finished printing board

