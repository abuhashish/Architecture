.data

arrayA: .double 2,5,4,1
        .double 7,4,7,2
        .double 10,11,20,7
        .double 7,12,4,8
        
level1: .double 1.5, 0.5
        .double 0.5, 1.5
        
level2: .double 0.5, 1.5
        .double 1.5, 0.5

str : .asciiz "\n"       
num4 : .double 4.0
.text

main: 
    la $a0, arrayA      #$t1 = address of arrayA
   la $a1,16
   jal bubbleSort
   move $v0,$a0
   ldc1 $f12,($v0)
   li $v0,3
   syscall
    
    
    
    li $v0, 10           #end the program
    syscall
    #&matrix[i][j] = &matrix + (i×COLS + j) × Element_size
sum:
j one
end1:
j two
end2:
j three
end3:
j four
end4:
bne $s1,0,odd
la $t9,level1
j next
odd:
la $t9,level2
next:
ldc1 $f14,0($t9)
ldc1 $f16,8($t9)
ldc1 $f18,16($t9)
ldc1 $f20,24($t9)

mul.d $f2,$f2,$f14
mul.d $f4,$f4,$f16
mul.d $f6,$f6,$f18   
mul.d $f8,$f8,$f20

add.d $f12,$f2,$f4
add.d $f12,$f12,$f6
add.d $f12,$f12,$f8

ldc1 $f26,num4
div.d $f12,$f12,$f26
la $a0,str
li $v0, 4 # Print string str
syscall
li $v0,3
syscall


jr $ra


one:
    la $t1,arrayA
    mul $t4,$t2,$t5
    add $t4,$t4,$t3
    mul $t4,$t4,8
    add $t1,$t1,$t4    #sum=text[i][j]+text[i+1][j]+text[i][j+1]+text[i+1][j+1]
    ldc1 $f2,0($t1)
j end1

two :
    add $t2,$t2,1 #text[i+1][j]
    la $t1,arrayA
    mul $t4,$t2,$t5
    add $t4,$t4,$t3
    mul $t4,$t4,8
    add $t1,$t1,$t4    #sum=text[i][j]+text[i+1][j]+text[i][j+1]+text[i+1][j+1]
    ldc1 $f4,0($t1)
    sub $t2,$t2,1
j end2

three:
    add $t3,$t3,1
    la $t1,arrayA
    mul $t4,$t2,$t5
    add $t4,$t4,$t3
    mul $t4,$t4,8
    add $t1,$t1,$t4    #sum=text[i][j]+text[i+1][j]+text[i][j+1]+text[i+1][j+1]
    ldc1 $f6,0($t1)
    sub $t3,$t3,1
j end3
four:
    add $t2,$t2,1
    add $t3,$t3,1
    la $t1,arrayA
    mul $t4,$t2,$t5
    add $t4,$t4,$t3
    mul $t4,$t4,8
    add $t1,$t1,$t4    #sum=text[i][j]+text[i+1][j]+text[i][j+1]+text[i+1][j+1]
    ldc1 $f8,0($t1)
    sub $t2,$t2,1
    sub $t3,$t3,1
j end4


bubbleSort: # $a0 = &A, $a1 = n
do: addiu $a1, $a1, -1 # n = n-1 
blez $a1, L2 # branch if (n <= 0)
move $t0, $a0 # $t0 = &A
li $t1, 0 # $t1 = swapped = 0
li $t2, 0 # $t2 = i = 0
for: 
ldc1 $f2, 0($t0) # $t3 = A[i]
ldc1 $f4,8($t0) # $t4 = A[i+1]
c.le.d $f2, $f4 # branch if (A[i] <= A[i+1])
bc1t L1
sdc1 $f4, 0($t0) # A[i] = $t4
sdc1 $f2, 8($t0) # A[i+1] = $t3
li $t1, 1 # swapped = 1
L1: addiu $t2, $t2, 1 # i++
addiu $t0, $t0, 8 # $t0 = &A[i]
bne $t2, $a1, for # branch if (i != n)
bnez $t1, do # branch if (swapped)
L2: jr $ra 
