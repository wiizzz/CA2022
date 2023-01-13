.globl __start

.rodata
  space: .string " "

.data
  array: .word base

.text
__start:
    #Set array base address
    la s0, array   
    #Input n
    li a0, 5
    ecall
    mv s1, a0  
    beq s1, x0, exit  #if n == 0, exit
    #Input a0
    li a0, 5
    ecall
    mv s2, a0
    #Store a0 to array base address
    sw s2, 0(s0)
    #Set i = 0
    add x5, x0, x0 
Loop:
    addi x5, x5, 1  #i++
    beq x5, s1, exitLoop  #if i == n, break
    slli x6, x5, 2  # i<<2
    add x6, s0, x6  #set arr[i] address
    li a0,5  #input arr[i]
    ecall
    mv x7, a0
    sw x7, 0(x6)  #store arr[i]
    beq x0, x0, Loop
exitLoop:
    add x10,x0,x0  #set x = 0
    jal x1, Inorder  #Inorder(root)
    j exit
    
Inorder:
  addi sp, sp, -16
  sw x1, 8(sp)
  sw x10, 0(sp)
  blt x10, s1, recur  #if x < n => not NIL
  addi sp, sp, 16  #x == NIL => return
  jalr x0, 0(x1)
  
recur:
  slli x10, x10, 1  #x.left = arr[2x+1]
  addi x10, x10, 1
  jal x1, Inorder  #call Inorder(x.left)
  
  lw x10, 0(sp)
  add x5, x0, x10
  slli x5, x5, 2
  add x5, x5, s0
  lw x6, 0(x5)
  #output  x
  li a0, 1
  mv a1, x6
  ecall
  #output space " "
  li a0, 4
  la a1, space
  ecall
  
  lw x10, 0(sp)
  slli x10, x10, 1  #x.right = arr[2x+2]
  addi x10, x10, 2
  jal x1, Inorder  #call Inorder(x.right)
  lw x1, 8(sp)
  addi sp,sp 16
  jalr x0, 0(x1)

exit:
    # Exit program
    li a0, 10
    ecall