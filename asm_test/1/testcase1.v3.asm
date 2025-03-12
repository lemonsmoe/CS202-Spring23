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

    # a complete test requires pressing the button 3 times
    # the first press get the testcase
    # the second press get the number and display numbers
    # the third press (excluding testcase 7) display the result

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
    sw $s1,0xC60($28)
    add $s3,$zero,$zero
    beq $s1,$zero,case_0_3
    add $t1,$s1,$zero
    addi $t2,$s1,-1
    and $t3,$t1,$t2
    beq $t3,$zero,is_power_of_2
        addi $s3,$zero,0
        j case_0_3
    is_power_of_2:
        addi $s3,$zero,1
    # if $s1 is power of 2, then $s1 and ($s1-1) = 0

case_0_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_0_3
case_0_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_0_4
    sw $s3,0xC60($28)
    j begin_1

case_1_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_1_1
case_1_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_1_2
    lw $s1,0xC70($28)
    andi $s1,$s1,255
    sw $s1,0xC60($28)
    andi $s3,$s1,1

case_1_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_1_3
case_1_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_1_4
    sw $s3,0xC60($28)
    j begin_1

case_2_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_2_1
case_2_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_2_2
    lw $s1,0xC70($28)
    sw $s1,0xC60($28)
    andi $s2,$s1,255
    srl $s1,$s1,8

    or $s3,$s1,$s2

case_2_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_2_3
case_2_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_2_4
    sw $s3,0xC60($28)
    j begin_1

case_3_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_3_1
case_3_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_3_2
    lw $s1,0xC70($28)
    sw $s1,0xC60($28)
    andi $s2,$s1,255
    srl $s1,$s1,8

    nor $s3,$s1,$s2
    andi $s3,$s3,255

case_3_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_3_3
case_3_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_3_4
    sw $s3,0xC60($28)
    j begin_1

case_4_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_4_1
case_4_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_4_2
    lw $s1,0xC70($28)
    sw $s1,0xC60($28)
    andi $s2,$s1,255
    srl $s1,$s1,8

    xor $s3,$s1,$s2

case_4_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_4_3
case_4_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_4_4
    sw $s3,0xC60($28)
    j begin_1

case_5_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_5_1
case_5_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_5_2
    lw $s1,0xC70($28)
    sw $s1,0xC60($28)
    andi $s2,$s1,255
    srl $s1,$s1,8

    addi $t3,$zero,-256
    srl $t1,$s1,7 # sign bit
    srl $t2,$s2,7 # sign bit
    beq $t1,$zero,end_1_in_case_5
        or $s1,$s1,$t3 # extend
    end_1_in_case_5:
    beq $t2,$zero,end_2_in_case_5
        or $s2,$s2,$t3 # extend
    end_2_in_case_5:

    slt $s3,$s1,$s2

case_5_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_5_3
case_5_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_5_4
    sw $s3,0xC60($28)
    j begin_1

case_6_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_6_1
case_6_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_6_2
    lw $s1,0xC70($28)
    sw $s1,0xC60($28)
    andi $s2,$s1,255
    srl $s1,$s1,8

    sltu $s3,$s1,$s2

case_6_3:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_6_3
case_6_4:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_6_4
    sw $s3,0xC60($28)
    j begin_1

case_7_1:
    lw $t0,0xC7C($28)
    bne $t0,$zero,case_7_1
case_7_2:
    lw $t0,0xC7C($28)
    beq $t0,$zero,case_7_2
    lw $s1,0xC70($28)
    sw $s1,0xC60($28)

    j begin_1