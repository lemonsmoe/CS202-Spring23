.data
.text
start:
    lui $28,0xFFFF
    ori $28,$28,0xF000
begin_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,begin_1
begin_2:
    lw $t0,0xC7C($28) # 0xC7C confirm the input
    beq $t0,$zero,begin_2

    lw $s0,0xC78($28) # 0xC78 is the testcase
    sw $zero,0xC60($28) # 0xC60 is the led and display the number
    sw $zero,0xC68($28) # 0xC68 is the led and display the judgement

    # input
    # $t0=0xC7C($28)(confirm button), $s1=0xC70($28), $s0=0xC78($28)(testcase)
    # output
    # $s1+$s2=0xC60($28), $s3=0xC68($28)

    # a complete test requires pressing the button 2 times
    # the first press get the testcase
    # the second press get the number and display the result

    addi $t0,$zero,0
    beq $s0,$t0,case_0_1
    addi $t0,$zero,1
    beq $s0,$t0,case_1_1
    addi $t0,$zero,2
    beq $s0,$t0,case_2_1
    addi $t0,$zero,3
    beq $s0,$t0,case_3_1
    addi $t0,$zero,4
    beq $s0,$t0,case_4_1
    addi $t0,$zero,5
    beq $s0,$t0,case_5_1
    addi $t0,$zero,6
    beq $s0,$t0,case_6_1
    addi $t0,$zero,7
    beq $s0,$t0,case_7_1
    #jump to the case

case_0_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_0_1
case_0_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_0_2
    lw $s1,0xC70($28)
    andi $s1,$s1,255
    srl $t1,$s1,7 # sign bit
    andi $s1,$s1,127
    beq $t1,$zero,end_1_in_case_0 # obtain the 2's complement
        xori $s1,$s1,127
        addi $s1,$s1,1
        sub $s1,$zero,$s1 # $s1=-$s1
    end_1_in_case_0:
    bne $t1,$zero,negative_in_case_0
        addi $t2,$zero,1
        j continue_in_case_0
    negative_in_case_0:
        addi $t2,$zero,-1
    continue_in_case_0: # $t2 is loop direction
    addi $s2,$zero,1
    add $s3,$zero,$zero
    loop_in_case_0:
        beq $s2,$s1,end_loop_in_case_0
        add $s3,$s3,$s2
        add $s2,$s2,$t2
        j loop_in_case_0
    end_loop_in_case_0:
    add $s3,$s3,$s2
    add $s4,$zero,$zero
    slt $s4,$s3,$zero # if $s3<0 then $s4=1 and blinks
    sw $s3,0xC60($28)
    bne $s4,$zero,blink_1
    addi $t8,$zero,1
case_0_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_0_3
case_0_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_0_4
    sw $s3,0xC60($28)
    j begin_1

    ##### blink
blink_1:
    
    add $t9,$zero,$zero # delay begin
    lui $t7,0x0010
    ori $t7,$t7,0xF000
    delay_in_blink_1_1:
        addi $t9,$t9,1
        slt $t8,$t9,$t7
        bne $t8,$zero,delay_in_blink_1_1 # delay end
    sw $s3,0xC60($28)    
    add $t9,$zero,$zero # delay begin
    lui $t7,0x0010
    ori $t7,$t7,0xF000
    delay_in_blink_1_2:
        addi $t9,$t9,1
        slt $t8,$t9,$t7
        bne $t8,$zero,delay_in_blink_1_2 # delay end
    sw $zero,0xC60($28)

    lw $t0,0xC7C($28)
    bne $t0,$zero,blink_1

blink_2:

    add $t9,$zero,$zero # delay begin
    lui $t7,0x0010
    ori $t7,$t7,0xF000
    delay_in_blink_2_1:
        addi $t9,$t9,1
        slt $t8,$t9,$t7
        bne $t8,$zero,delay_in_blink_2_1 # delay end
    sw $s3,0xC60($28)    
    add $t9,$zero,$zero # delay begin
    lui $t7,0x0010
    ori $t7,$t7,0xF000
    delay_in_blink_2_2:
        addi $t9,$t9,1
        slt $t8,$t9,$t7
        bne $t8,$zero,delay_in_blink_2_2 # delay end
    sw $zero,0xC60($28)

    lw $t0,0xC7C($28)
    beq $t0,$zero,blink_2
    #####

    # sw $s4,0xC68($28) # how to blink?
    j begin_1

case_1_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_1_1
case_1_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_1_2
    lw $s1,0xC70($28)
    andi $s1,$s1,255
    add $s3,$zero,$zero
    jal recursion_in_case_1
    j begin_1

recursion_in_case_1:
    addi $sp,$sp,-8 
    sw $ra,4($sp)
    sw $s1,0($sp)
    slti $t0,$s1,1 
    beq $t0,$zero,base_in_case_1 
    add $s2,$zero,$zero 
    addi $sp,$sp,8 
    jr $ra
    
base_in_case_1:
    addi $s1,$s1,-1
    lw $s3,0xC60($28)
    addi $s3,$s3,1 # push
    sw $s3,0xC60($28)
    jal recursion_in_case_1
    lw $s1,0($sp)
    lw $ra,4($sp)
    lw $s3,0xC60($28)
    addi $s3,$s3,1 # pop
    sw $s3,0xC60($28)
    addi $sp,$sp,8 
    add $s2,$s1,$s2
    jr $ra

case_2_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_2_1
case_2_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_2_2
    lw $s1,0xC70($28)
    andi $s1,$s1,255
    jal recursion_in_case_2
    j begin_1

recursion_in_case_2:
    addi $sp,$sp,-8 
    sw $ra,4($sp)
    sw $s1,0($sp)
    slti $t0,$s1,1 
    beq $t0,$zero,base_in_case_2
    add $s2,$zero,$zero 
    addi $sp,$sp,8 
    jr $ra
    
base_in_case_2:
    addi $s1,$s1,-1
    sw $sp,0xC60($28) # push 

    add $t9,$zero,$zero # delay begin
    lui $t7,0x0030
    ori $t7,$t7,0xF000
    delay_in_case_2:
        addi $t9,$t9,1
        slt $t8,$t9,$t7
        bne $t8,$zero,delay_in_case_2 # delay end

    jal recursion_in_case_2
    lw $s1,0($sp)
    lw $ra,4($sp)
    addi $sp,$sp,8 
    add $s2,$s1,$s2
    jr $ra

case_3_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_3_1
case_3_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_3_2
    lw $s1,0xC70($28)
    andi $s1,$s1,255
    jal recursion_in_case_3
    j begin_1

recursion_in_case_3:
    addi $sp,$sp,-8 
    sw $ra,4($sp)
    sw $s1,0($sp)
    slti $t0,$s1,1 
    beq $t0,$zero,base_in_case_3
    add $s2,$zero,$zero 
    addi $sp,$sp,8 
    jr $ra
    
base_in_case_3:
    addi $s1,$s1,-1
    jal recursion_in_case_3
    lw $s1,0($sp)
    lw $ra,4($sp)
    sw $sp,0xC60($28) # pop

    add $t9,$zero,$zero # delay begin
    lui $t7,0x0030
    ori $t7,$t7,0xF000
    delay_in_case_3:
        addi $t9,$t9,1
        slt $t8,$t9,$t7
        bne $t8,$zero,delay_in_case_3 # delay end

    addi $sp,$sp,8 
    add $s2,$s1,$s2
    jr $ra

case_4_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_4_1
case_4_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_4_2
    lw $s1,0xC70($28)
    andi $s2,$s1,255
    srl $s1,$s1,8
    # $s3 is operation result
    # $s4 is overflow judgment
    srl $t1,$s1,7 # sign bit
    srl $t2,$s2,7 # sign bit
    add $s3,$s1,$s2
    andi $s3,$s3,255 # obtain the last 8 digits, i.e. 2's complement
    srl $t3,$s3,7 #sign bit
    sub $t3,$zero,$t3
    addi $t3,$t3,1 #$t3=1-$t3
    add $t3,$t3,$t1
    add $t3,$t3,$t2 # if $t3==0 or $t3==3 then overflow
    beq $t3,$zero,overflow_in_case_4
    addi $t4,$zero,3
    beq $t3,$t4,overflow_in_case_4
    j exit_overflow_in_case_4
    overflow_in_case_4:
        addi $s4,$zero,1
    exit_overflow_in_case_4:
    sw $s3,0xC60($28)

case_4_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_4_3
case_4_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_4_4
    sw $s4,0xC68($28)
    j begin_1

case_5_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_5_1
case_5_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_5_2
    lw $s1,0xC70($28)
    andi $s2,$s1,255
    srl $s1,$s1,8
    # $s3 is operation result
    # $s4 is overflow judgment
    srl $t1,$s1,7 # sign bit
    srl $t2,$s2,7 # sign bit
    sub $s3,$s1,$s2
    andi $s3,$s3,255 # obtain the last 8 digits, i.e. 2's complement
    srl $t3,$s3,7 #sign bit
    sub $t1,$zero,$t1
    addi $t1,$t1,1 #$t1=1-$t1
    add $t3,$t3,$t1
    add $t3,$t3,$t2 # if $t3==0 or $t3==3 then overflow
    beq $t3,$zero,overflow_in_case_5
    addi $t4,$zero,3
    beq $t3,$t4,overflow_in_case_5
    j exit_overflow_in_case_5
    overflow_in_case_5:
        addi $s4,$zero,1
    exit_overflow_in_case_5:
    sw $s3,0xC60($28)

case_5_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_5_3
case_5_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_5_4
    sw $s4,0xC68($28)
    j begin_1

case_6_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_6_1
case_6_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_6_2
    lw $s1,0xC70($28)
    andi $s2,$s1,255
    srl $s1,$s1,8
    srl $t1,$s1,7 # sign bit
    srl $t2,$s2,7 # sign bit
    andi $s1,$s1,127
    andi $s2,$s2,127
    beq $t1,$zero,end_1_in_case_6 # obtain the 2's complement
        xori $s1,$s1,127
        addi $s1,$s1,1
    end_1_in_case_6:
    beq $t2,$zero,end_2_in_case_6 # obtain the 2's complement
        xori $s2,$s2,127
        addi $s2,$s2,1
    end_2_in_case_6:
    add $s3,$zero,$zero
    multiply_loop_in_case_6:
        andi $t5,$s2,1
        beq $t5,$zero,end_3_in_case_6
            add $s3,$s3,$s1
        end_3_in_case_6:
        srl $s2,$s2,1
        sll $s1,$s1,1
        bne $s2,$zero,multiply_loop_in_case_6
    xor $t3,$t1,$t2 #sign bit
    beq $t3,$zero,end_4_in_case_6 # obtain the 2's complement
        xori $s3,$s3,32767
        addi $s3,$s3,1
    end_4_in_case_6:
    sll $t3,$t3,15
    add $s3,$s3,$t3
    sw $s3,0xC60($28)
    j begin_1 

case_7_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_7_1
case_7_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_7_2
    lw $s1,0xC70($28)
    andi $s2,$s1,255
    srl $s1,$s1,8
    # $s1 is the remainder/dividend
    # $s2 is the divisor
    # $s3 is the quotient
    bne $s2,$zero,case_7_continue # check if divisor is 0
        addi $s3,$zero,-1
        sw $s3,0xC60($28)
        j begin_1
    case_7_continue:
    srl $t1,$s1,7 # sign bit
    srl $t2,$s2,7 # sign bit
    andi $s1,$s1,127
    andi $s2,$s2,127
    beq $t1,$zero,end_1_in_case_7 # obtain the 2's complement
        xori $s1,$s1,127
        addi $s1,$s1,1
    end_1_in_case_7:
    beq $t2,$zero,end_2_in_case_7 # obtain the 2's complement
        xori $s2,$s2,127
        addi $s2,$s2,1
    end_2_in_case_7:
    add $s3,$zero,$zero
    add $t4,$s2,$zero # $t4 is the original divisor
    sll_loop:
        slt $t9,$s1,$s2
        bne $t9,$zero,divide_loop
        sll $s2,$s2,1
        j sll_loop
    divide_loop:
        slt $t9,$s1,$s2
        bne $t9,$zero,continue_divide_loop
            sub $s1,$s1,$s2
            addi $s3,$s3,1
        continue_divide_loop:
        sll $s3,$s3,1
        srl $s2,$s2,1
        slt $t9,$s2,$t4
        bne $t9,$zero,exit_divide_loop
        j divide_loop
    exit_divide_loop:
    srl $s3,$s3,1
    xor $t3,$t1,$t2 #sign bit
    beq $t3,$zero,end_3_in_case_7 # obtain the 2's complement
        xori $s3,$s3,127
        addi $s3,$s3,1
    end_3_in_case_7:
    sll $t3,$t3,7
    add $s3,$s3,$t3
    # the sign of remainder is the same as dividend if remainder!=0
    beq $s1,$zero,end_4_in_case_7
    addi $t8,$zero,1
    beq $t1,$zero,end_4_in_case_7 # obtain the 2's complement
        xori $s1,$s1,127
        addi $s1,$s1,1
    sll $t1,$t1,7
    add $s1,$s1,$t1
    end_4_in_case_7:
    sll $s3,$s3,8
    add $s3,$s3,$s1
    sw $s3,0xC60($28)
    j begin_1