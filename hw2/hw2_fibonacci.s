.globl __start

.text
__start:
    # Read input n
    li a0, 5
    ecall
    mv s0, a0
    add x10, s0, x0  #set parameter = n
    jal x1, Fib  #call Fib(n)
    add s1, x10, x0
    j output
    
Fib:
  addi sp, sp, -24
  sw x1, 16(sp)
  sw x5, 8(sp)
  sw x10, 0(sp)
  addi x6, x10, -2
  bge x6, x0, recur  #if n >= 1, jump
  j return
recur:
  addi x10, x10, -1
  jal x1, Fib  #call Fib(n-1)
  add x5, x0, x10
  lw x10, 0(sp)
  addi x10, x10, -2
  jal x1, Fib  #call Fib(n-2)
  add x10, x5, x10
  lw x1, 16(sp)
  lw x5, 8(sp)
  addi sp,sp 24
  jalr x0, 0(x1)
return:
  lw x10, 0(sp)
  lw x5, 8(sp)
  lw x1, 16(sp)
  addi sp, sp, 24
  jalr x0, 0(x1)

output:
    # Output the result
    li a0, 1
    mv a1, s1
    ecall

exit:
    # Exit program
    li a0, 10
    ecall
