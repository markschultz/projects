.data
    endgame: .asciiz "Game Over, Final score:\n"
    equals:  .asciiz "= "

check_done:
    #load in t1=playerscore t2=compscore

    lw $t1, player_score_in_mem
    lw $t2, comp_score_in_mem
    add $t3, $t1, $t2
    
    #t3 now has number of squares filled. if less than 100 then games not over
    negu $t4, $t3
    addi $t3, $t4, 100

    #if 100-filled > 0 then more squares left
    bltz $t3, ContinueGame
    #end game

    #print endgame
    la $a0, endgame
    li $v0, 4
    syscall

    #print user
    la $a0, one
    li $v0, 4
    syscall

    #print "= "
    la $a0, equals
    li $v0, 4
    syscall

    #print score
    move $a0, $t1
    li $v0, 1
    syscall

    #print newline
    la $a0, newline
    li $v0, 4
    syscall

    #print comp
    la $a0, two
    li $v0, 4
    syscall

    #print "= "
    la $a0, equals
    li $v0, 4
    syscall

    #print score2
    move $a0, $t2
    li $v0, 1
    syscall

## exit code somehow...

ContinueGame:
    #loop back to input or something
