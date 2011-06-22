.data
arr:    .word     1 : 441       # storage for 10x10 matrix of words
dot:   .asciiz	  ". "
dash:  .asciiz	  "- "
bar:   .asciiz	  "| "
one:   .asciiz	  "1 "
two:   .asciiz	  "2 "
space: .asciiz	  "  "
newline: .asciiz  "\n"

.text

main:

# t1 = i,  t2 = j, t3 = iIsEven, t4 = jIsEven

	move $t1, $zero #  i = 0;
Iloop:

	
	move $t2, $zero #  j = 0;
Jloop:	
	

		#check if i is even
	addi $t3, $t1, 1
	sll  $t3, $t3, 31
	srl  $t3, $t3, 31 
- Show quoted text -
	li $t6, 4
	bne $t8, $t6, SkipOne #skip if arr[i,j] != 4 	
	la $a0, one
	addi $v0, $zero, 4
	syscall
	SkipOne:
	
	#draw 2 inside box
	beq $t3, $zero, SkipTwo #skip if i != even
	bne $t4, $zero, SkipTwo #skip if j  = even	
	li $t6, 5
	bne $t8, $t6, SkipTwo # skip if arr[i,j] != 5
	la $a0, two
	addi $v0, $zero, 4
	syscall
	SkipTwo:

	#draw a " " in the case that arr[i,j] == 0 
	bne $t8, $zero, SkipSpace #skip if arr[i, j] != 0 
	la $a0, space
	addi $v0, $zero, 4
	syscall
	SkipSpace:

	#draw a " " in the case that arr[i,j] == 0,1,2,3, and [i,j] is "inside a box" 
	li $t6, 4
	beq $t8, $t6, SkipSpaceAgain #skip if arr[i, j] = 4
	li $t6, 5
	beq $t8, $zero, SkipSpaceAgain #skip if arr[i, j] =5
  
	la $a0, space
	addi $v0, $zero, 4
	syscall
	SkipSpaceAgain:

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

