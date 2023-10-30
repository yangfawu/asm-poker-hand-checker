.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
straight_str: .asciiz "STRAIGHT_HAND"
four_str: .asciiz "FOUR_OF_A_KIND_HAND"
pair_str: .asciiz "TWO_PAIR_HAND"
unknown_hand_str: .asciiz "UNKNOWN_HAND"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION"
invalid_args_error: .asciiz "INVALID_ARGS"

# Put your additional .data declarations here, if any.
strlen_str: .asciiz "strlen="

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory  
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here
    lw $s0, addr_arg0
    
    # get length of arg_0
    move $a0, $s0
    jal str_len

    # check if (v0) length is 1
    li $t0, 1
    bne $v0, $t0, exit_with_invalid_operation_error

    # since we know $s0 is just 1 character
    # we replace it with just 1 byte (no null character)
    lbu $s0, 0($s0)

    # load num_args into s1
    lw $s1, num_args

    li $t0, 'E'
    beq $s0, $t0, case_E

    li $t0, 'D'
    beq $s0, $t0, case_D

    li $t0, 'P'
    beq $s0, $t0, case_P

    # arg0 is not E nor D nor P
    j exit_with_invalid_operation_error

case_E:
    li $t0, 5
    bne $s1, $t0, exit_with_invalid_args_error

    li $s0, 0
    
    # load arg1 and range <= 63
    lw $a0, addr_arg1
    jal str_to_int
    li $t0, 63
    bgt $v0, $t0, exit_with_invalid_args_error # check if char > 63
    
    # store rightmost 6 bits and make space for 5
    andi $s0, $v0, 0x3f
    sll $s0, $s0, 5

    # load arg2 and check if it in range <= 31
    lw $a0, addr_arg2
    jal str_to_int
    li $t0, 31
    bgt $v0, $t0, exit_with_invalid_args_error

    # store rightmost 5 bits and make space for 5
    andi $v0, $v0, 0x1f
    or $s0, $s0, $v0
    sll $s0, $s0, 5

    # load arg3 and check if it in range <= 31
    lw $a0, addr_arg3
    jal str_to_int
    li $t0, 31
    bgt $v0, $t0, exit_with_invalid_args_error

    # store rightmost 5 bits and make space for 16
    andi $v0, $v0, 0x1f # rightmost 5 bits of rs
    or $s0, $s0, $v0
    sll $s0, $s0, 16

    # load arg4 and then check if it in range <= 65535
    lw $a0, addr_arg4
    jal str_to_int
    li $t0, 65535
    bgt $v0, $t0, exit_with_invalid_args_error

    # keep rigthmost 16 bits
    andi $v0, $v0, 0xffff
    or $s0, $s0, $v0

    move $a0, $s0
    li $v0, 34
    syscall

    j end_switch

case_D:
    li $t0, 2
    bne $s1, $t0, exit_with_invalid_args_error

    lw $a0, addr_arg1

    # check that it begins with '0'
    lbu $s1, 0($a0)
    li $s2, '0'
    bne $s1, $s2, exit_with_invalid_args_error

    # check that it is followed by 'x'
    addi $a0, $a0, 1
    lbu $s1, 0($a0)
    li $s2, 'x'
    bne $s1, $s2, exit_with_invalid_args_error

    # store numerical representation of the number (s0)
    addi $a0, $a0, 1
    jal hex_to_int
    move $s0, $v0

    # opcode
    srl $a0, $s0, 26
    andi $a0, $a0, 0x3f
    li $a1, 2
    jal resursive_print
    jal print_space 

    # rs
    srl $a0, $s0, 21
    andi $a0, $a0, 0x1f
    li $a1, 2
    jal resursive_print
    jal print_space 

    # rt
    srl $a0, $s0, 16
    andi $a0, $a0, 0x1f
    li $a1, 2
    jal resursive_print
    jal print_space 

    # imm
    andi $a0, $s0, 0xffff
    li $a1, 5
    jal resursive_print

    j end_switch

case_P:
    li $t0, 2
    bne $s1, $t0, exit_with_invalid_args_error

    # s0 -> arg1
    lw $s0, addr_arg1

    # s1 -> characters left to read
    li $s1, 5

    # s4-7 -> binary encoding of clubs, spades, diamonds, hearts 
    li $s4, 0
    li $s5, 0
    li $s6, 0
    li $s7, 0
case_P_loop:
    beq $s1, $0, case_P_loop_end

    lbu $s2, 0($s0)
    beq $s2, $0, case_P_loop_end
    
    li $s3, 0x3D
    ble $s2, $s3, case_P_loop_case_clubs

    li $s3, 0x4D
    ble $s2, $s3, case_P_loop_case_spades

    li $s3, 0x5D
    ble $s2, $s3, case_P_loop_case_diamonds

    # since inputs are valid, this must be hearts
    j case_P_loop_case_hearts

case_P_loop_case_clubs:
    li $s3, 0x31
    sub $s2, $s2, $s3

    li $s3, 1
    sllv $s3, $s3, $s2 # shift 1-hot binary number to its rank position
    or $s4, $s4, $s3 # store 1-hot in clubs

    j case_P_loop_continue

case_P_loop_case_spades:
    li $s3, 0x41
    sub $s2, $s2, $s3

    li $s3, 1
    sllv $s3, $s3, $s2 # shift 1-hot binary number to its rank position
    or $s5, $s5, $s3 # store 1-hot in spades

    j case_P_loop_continue

case_P_loop_case_diamonds:
    li $s3, 0x51
    sub $s2, $s2, $s3

    li $s3, 1
    sllv $s3, $s3, $s2 # shift 1-hot binary number to its rank position
    or $s6, $s6, $s3 # store 1-hot in diamonds

    j case_P_loop_continue

case_P_loop_case_hearts:
    li $s3, 0x61
    sub $s2, $s2, $s3

    li $s3, 1
    sllv $s3, $s3, $s2 # shift 1-hot binary number to its rank position
    or $s7, $s7, $s3 # store 1-hot in hearts

    j case_P_loop_continue

case_P_loop_continue:
    # reminder: s2->rank (0->A, ..., 12->K) 
    # reminder: s4->suit (0->clubs, 1->spades, 2->diamonds, 3->hearts)

    addi $s0, $s0, 1
    addi $s1, $s1, -1
    j case_P_loop

case_P_loop_end:
    # check for straight
    li $s0, 0
    or $s0, $s0, $s4
    or $s0, $s0, $s5
    or $s0, $s0, $s6
    or $s0, $s0, $s7
    # now s0->binary encoding of all ranks, 0 if rank exist, 1 if rank doesnt

    move $a0, $s0
    jal has_straight
    bne $v0, $0, exit_with_straight_str

    # check for 4 of kind
    move $s0, $s4 # we dont set s0 to 0 because we will alwyas get 0 no matter wat we do after
    and $s0, $s0, $s5
    and $s0, $s0, $s6
    and $s0, $s0, $s7
    # now s0->binary encoding, 1 if rank appears in all 4 suits

    bne $s0, $0, exit_with_four_str

    # check for two pair
    li $s0, 0 # s0 -> num pairs saw
    li $s1, 13 # s1 -> counter from 13 to 0

case_P_pair_loop:
    beq $s1, $0, case_P_pair_loop_end

    li $s2, 0 # s2 -> number of rank

    # add 1 if clubs has rank
    andi $s2, $s4, 1
    
    # add 1 if spades has rank
    andi $s3, $s5, 1
    add $s2, $s2, $s3

    # add 1 if diamonds has rank
    andi $s3, $s6, 1
    add $s2, $s2, $s3

    # add 1 if hearts has rank
    andi $s3, $s7, 1
    add $s2, $s2, $s3

    # check if count is < 2
    li $s3, 2
    blt $s2, $s3, case_P_pair_loop_no_pair
    addi $s0, $s0, 1
case_P_pair_loop_no_pair:
    srl $s4, $s4, 1
    srl $s5, $s5, 1
    srl $s6, $s6, 1
    srl $s7, $s7, 1
    addi $s1, $s1, -1
    j case_P_pair_loop
case_P_pair_loop_end:
    # check if num pairs is >= 2
    li $s1, 2
    bge $s0, $s1, exit_with_pair_str

    j exit_with_unknown_hand_str

end_switch:

    j exit # END OF MAIN

######## END OF MAIN ########

print_something:
    la $a0, strlen_str
    li $v0, 4
    syscall
    jr $ra

######## QUICK RETURN LABELS ########

exit_with_invalid_operation_error:
    la $a0, invalid_operation_error
    li $v0, 4
    syscall
    j exit

exit_with_invalid_args_error:
    la $a0, invalid_args_error
    li $v0, 4
    syscall
    j exit

exit_with_straight_str:
    la $a0, straight_str
    li $v0, 4
    syscall
    j exit

exit_with_four_str:
    la $a0, four_str
    li $v0, 4
    syscall
    j exit

exit_with_pair_str:
    la $a0, pair_str
    li $v0, 4
    syscall
    j exit

exit_with_unknown_hand_str:
    la $a0, unknown_hand_str
    li $v0, 4
    syscall
    j exit

######## FUNCTIONS ########

#start function := check if straight exists
has_straight:
    # a0 -> bianry encoding of ranks
    beq $a0, $0, has_straight_end

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $t0, 0x1f # mask
    and $t1, $a0, $t0
    beq $t1, $t0, has_straight_found

    srl $a0, $a0, 1
    jal has_straight # shift right 1, and recursively check

    # then check if recursive call found straight
    beq $v0, $0, has_straight_not_found
has_straight_found:
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    li $v0, 1
    jr $ra
has_straight_not_found:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
has_straight_end:
    li $v0, 0
    jr $ra

#start function := recursively print a number's bits from LSB to Nth bit
resursive_print:
    # a0 is the number
    # a1 is the N

    # if no more digits needed to be printed, we exit
    beq $a1, $0, resursive_print_end 

    addi $sp, $sp, -8
    sw $ra, 0($sp)

    li $t0, 10
    div $a0, $t0 # divide by 10
    mflo $a0 # store quotient in $a0 for recursive call

    mfhi $t0 # store remainder in t0
    sw $t0, 4($sp) # store t0 on stack so we can print after recursive call

    addi $a1, $a1, -1 # decrement counter by 1
    jal resursive_print # recursively call

    lw $ra, 0($sp)

    lw $a0, 4($sp) # load back t0
    li $v0, 1
    syscall

    addi $sp, $sp, 8
resursive_print_end:
    jr $ra
#end function

#start function := prints a space
print_space:
    addi $sp, $sp, -4
    sw $a0, 0($sp)

    li $v0, 11
    li $a0, ' '
    syscall

    lw $a0, 0($sp)
    addi $sp, $sp, 4
    jr $ra
#end function

#start function := to get length of string at $a0
str_len:
    move $t0, $a0
    li $v0, 0 # set counter [$t1] to 0
str_len_loop:
    lbu $t1, 0($t0) # load latest byte of string address 
    beq $t1, $0, str_len_end # if latest byte is 0, then we end
    addi $t0, $t0, 1 # increment the string address pointer
    addi $v0, $v0, 1 # increment the counter
    j str_len_loop
str_len_end:
    jr $ra
#end function

#start function := turns numeric string into integer
str_to_int:
    move $t0, $a0
    li $v0, 0
    li $t1, 10
str_to_int_loop:
    lbu $t2, 0($t0)
    beq $t2, $0, str_to_int_end

    addi $t2, $t2, -48 # subtract by 48 offset to get decimal value
    
    # result*= 10; resilt+= d;
    mul $v0, $v0, $t1
    addu $v0, $v0, $t2

    addi $t0, $t0, 1
    j str_to_int_loop
str_to_int_end:
    jr $ra
#end function

#start function := convert hex string into number
hex_to_int:
    move $t0, $a0
    li $t1, 8
    li $t2, 0
hex_to_int_loop:
    beq $t1, $0, hex_to_int_end
    lbu $t3, 0($t0)

    beq $t3, $0, hex_to_int_end

    li $t4, 'f'
    bgt $t3, $t4, exit_with_invalid_args_error

    # character must be f or below
    li $t4, 'a'
    bge $t3, $t4, hex_to_int_loop_continue

    li $t4, '9'
    bgt $t3, $t4, exit_with_invalid_args_error

    # character must be 9 or below
    li $t4, '0'
    bge $t3, $t4, hex_to_int_loop_continue

    # character is less than '0'
    j exit_with_invalid_args_error
hex_to_int_loop_continue:
    sub $t3, $t3, $t4

    li $t5, 'a'
    blt $t4, $t5, hex_to_int_loop_continue_no_offset
    addi $t3, $t3, 10 
hex_to_int_loop_continue_no_offset:
    li $t5, 16
    mul $t2, $t2, $t5
    add $t2, $t2, $t3
    
    addi $t1, $t1, -1
    addi $t0, $t0, 1
    j hex_to_int_loop
hex_to_int_end:

    # we load last byte again to ensure this is indeed last byte
    lbu $t3, 0($t0)
    bne $t3, $0, exit_with_invalid_args_error

    move $v0, $t2
    jr $ra
#end function

######## END ########

exit:
    li $v0, 10
    syscall
