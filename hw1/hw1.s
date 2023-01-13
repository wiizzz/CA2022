.globl __start

.rodata
    division_by_zero: .string "division by zero"
    JumpTable: .word L0,L1,L2,L3,L4,L5,L6

.text
__start:
    # Read first operand
    li a0, 5
    ecall
    mv s0, a0
    # Read operation
    li a0, 5
    ecall
    mv s1, a0
    # Read second operand
    li a0, 5
    ecall
    mv s2, a0
    
###################################
#  TODO: Develop your calculator  #
#                                 #
###################################
 
    #Switch(operator)
    slt x5, s1, x0  #check s1 >= 0
    bne x5, x0, exit
    slti x5, s1, 7  #check s1 < 7
    beq x5, x0, exit
    la x28, JumpTable
    slli x5, s1, 2
    add x6, x5, x28
    lw x7, 0(x6)
    jr x7
    
L0:
  #addition
  add s3, s0, s2
  j output  
L1:
  #subtraction
  sub s3, s0, s2
  j output
L2:
  #multiplication
  mul s3, s0, s2
  j output
L3:
  #division
  beq s2, x0, division_by_zero_except
  div s3, s0, s2
  j output
L4:
  #calc minimum 
  bge s0, s2, else 
  add s3, x0, s0  # min = s0
  j output
else:
  add s3, x0, s2  # min = s2
  j output
L5:
  #calc power
  beq s2, x0, Zero #check exponent == 0
  addi x29, x0, 1  #set i = 1
  add s3, x0, s0 #set s3 = s0
  beq x0, x0, Loop  
Loop:
  beq x29, s2, exitLoop  #if i == s2, leave loop
  mul s3, s3, s0
  addi x29, x29, 1  #i++
  beq x0, x0, Loop
exitLoop:
  j output
Zero:    #zero exponent case
  addi s3, x0, 1
  j output
L6:
  #factorial operation
  bne s2, x0, exit  #check s2 == 0
  add x10, x0, s0
  jal x1, fact
  add s3, x0, x10
  j output 
fact:
  addi sp, sp, -16
  sw x1, 8(sp)
  sw x10, 0(sp)
  addi x5, x10, -1
  bge x5, x0, L  #n >= 1
  addi x10, x0, 1 
  addi sp, sp, 16
  jalr x0, 0(x1)
L:
  addi x10, x10, -1
  jal x1, fact  #call fact(n-1)
  addi x6, x10, 0
  lw x10, 0(sp)
  lw x1, 8(sp)
  addi sp, sp, 16
  mul x10, x10, x6
  jalr x0, 0(x1)
  
output:
    # Output the result
    li a0, 1
    mv a1, s3
    ecall
    

exit:
    # Exit program(necessary)
    li a0, 10
    ecall

division_by_zero_except:
    li a0, 4
    la a1, division_by_zero
    ecall
    jal zero, exit
