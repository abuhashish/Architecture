#STRINGS
.data
fileName: .asciiz "input.txt"
output: .asciiz "output.txt"
fileWords: .space 1024
arrayA: .word 0
Error1 : .asciiz "number is not divided by 4"
str1: .ASCIIZ "Testing error\n"
level1: .double 1.5, 0.5
        .double 0.5, 1.5
        
level2: .double 0.5, 1.5
        .double 1.5, 0.5
point: .ascii "."
str : .asciiz "\n"       
num4 : .double 4.0
thousand: .double 10000000.0
prompt1: .asciiz "Please enter the way you want \n 1. Mean \n 2. Median \n you choice is \n"
medianstring: .asciiz "median way"
meanway: .asciiz"mean waY"
.text
.globl main
	
main:
	#allocate 1024 byte
	li $v0,9
	li $a0,1024
	syscall
	sw $v0,arrayA      #save pointer
	li $a3,0      #array pointer
	li $t2,0
	li $t3,1
	#HOW TO READ INTO A FILE
	li $v0,13           	# open_file syscall code = 13
	la $a0,fileName     	# get the file name
	li $a1,0           	# file flag = read (0)
	syscall
	move $s0,$v0        	# save the file descriptor. $s0 = file
	#read the file
	li $v0, 14		# read_file syscall code = 14
	move $a0,$s0		# file descriptor
	la $a1,fileWords  	# The buffer that holds the string of the WHOLE file
	la $a2,1024		# hardcoded buffer length
	syscall
	li $v0, 16         		# close_file syscall code
	move $a0,$s0      		# file descriptor to close
	syscall
	#STR TO FLOAT
	move $a0,$a1
	li $t0,10
	start:
	lw  $t9,arrayA
	li $v0,0
	add $t2,$t2,1
	L1: lb $t1, 0($a0) # load $t1 = str[i]
	addiu $a0, $a0, 1 # $a0 = address of next char
	blt $t1, '0', done # exit loop if ($t1 < '0')
	bgt $t1, '9', done # exit loop if ($t1 > '9')
	addiu $t1, $t1, -48 # Convert character to digit
	mul $v0, $v0, $t0 # $v0 = sum * 10
	addu $v0, $v0, $t1 # $v0 = sum * 10 + digit
	j L1 # loop back
	done:
	mtc1.d $v0,$f2    # store the integer to float register
	cvt.d.w  $f2,$f2       # convert it to float
	add $t9,$t9,$a3
	sdc1 $f2,($t9)
	add $a3,$a3,8
	beq $t1 , 32, start    #if the file is not done and we have space
	beq $t1,13,test       # new line
	jal error1	
	#####start computing here....
	la $a0,prompt1
	li $v0,4 
	syscall
	li $v0, 5
	syscall	
	move $t6,$v0
    	li $s5,2
	li $s1,0    #window level	0 even 1 odd start with even
	move $t5,$t3	        #cols
	mean:
	lw $t1, arrayA      #$t1 = address of arrayA
	li $t3,0		#j=0
	li $t2,0		#i=0
	li $s6,0                # my counter for array  
	bne $s1,0,odd
	la $t9,level1
	add $s1,$s1,1
	j next
	odd:
	sub $s1,$s1,1
	la $t9,level2
	next:   				 				
    #&matrix[i][j] = &matrix + (i�COLS + j) � Element_size
    fori:
    bge $t2, $t5, end      #if $t2 > $s1, then go to end 
    li $t3,0
    forj:  
    bge $t3, $t5, endj      #if $t2 == $s1, then go to end 
    lw $t1,arrayA
    mul $t4,$t2,$t5
    add $t4,$t4,$t3
    mul $t4,$t4,8
    add $t1,$t1,$t4     #&matrix[i][j] = &matrix + (i�COLS + j) � Element_size
    jal sum
    add $t3,$t3,2
    j forj
    endj:
    add $t2,$t2,2
    j fori              #go back through the loop
end:
	 bne $t5,1,computeme
	 ### file to output ####
	 jal outputz
endall:
	li $v0, 10 # Exit program
	syscall	
error1:
	li $t4,4
	mul $t5 ,$t3,$t2
	div $t5,$t4
	mfhi $t5
	bne $t5, 0 ,printerror
	la $a0,str1 # display prompt string
	li $v0,4
	syscall	
	j doneme
computeme:
add $s1,$s1,1
add $s5,$s5,1
li $s7,4
div $t5,$s7
mflo $t5
j mean
printerror:
	la $a0,Error1 # display prompt string
	li $v0,4
	syscall	
	doneme:
	jr $ra

test:
	addiu $a0, $a0, 1 # $a0 = address of next char
	addiu $t3,$t3,1
	j start
sum:
j one
end1:
j two
end2:
j three
end3:
j four
end4:
ldc1 $f14,0($t9)
ldc1 $f16,8($t9)
ldc1 $f18,16($t9)
ldc1 $f20,24($t9)
beq $t6,1,meanz
median:
la $a0,medianstring
li $v0,4
syscall
meanz:
lw $t1,arrayA
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
add $t1,$t1,$s6
sdc1  $f12,($t1)
add $s6,$s6,8
exitit:
jr $ra
one:
    lw $t1,arrayA
    mul $t4,$t2,$t5
    add $t4,$t4,$t3
    mul $t4,$t4,8
    add $t1,$t1,$t4    #sum=text[i][j]+text[i+1][j]+text[i][j+1]+text[i+1][j+1]
    ldc1 $f2,0($t1)
j end1
two :
    add $t2,$t2,1 #text[i+1][j]
    lw $t1,arrayA
    mul $t4,$t2,$t5
    add $t4,$t4,$t3
    mul $t4,$t4,8
    add $t1,$t1,$t4    #sum=text[i][j]+text[i+1][j]+text[i][j+1]+text[i+1][j+1]
    ldc1 $f4,0($t1)
    sub $t2,$t2,1
j end2
three:
    add $t3,$t3,1
    lw $t1,arrayA
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
    lw $t1,arrayA
    mul $t4,$t2,$t5
    add $t4,$t4,$t3
    mul $t4,$t4,8
    add $t1,$t1,$t4    #sum=text[i][j]+text[i+1][j]+text[i][j+1]+text[i+1][j+1]
    ldc1 $f8,0($t1)
    sub $t2,$t2,1
    sub $t3,$t3,1
j end4

outputz:
lw $t1,arrayA
ldc1 $f2,($t1)
ldc1 $f26,thousand
mul.d $f2,$f2,$f26
cvt.w.d $f2,$f2
mfc1 $a0,$f2
j int2str
endint2str:
move $a0,$t9
li $v0,4
syscall
li $v0,13           	# open_file syscall code = 13
la $a0,output     	# get the file
li $a1,1           	# file flag = read (0)
syscall
move $s1,$v0        	# save the file descriptor. $s0 = file
#write the file
li $v0,15
move $a0,$s1
move $a1,$t9
la $a2,6
syscall
li $v0,16   #close flie
move $a0,$s1
syscall
jr $ra

int2str:
li $t0, 10 # $t0 = divisor = 10
addiu $v0, $a1, 11 # start at end of buffer
sb $zero, 0($v0) # store a NULL character
L2: divu $a0, $t0 # LO = value/10, HI = value%10
mflo $a0 # $a0 = value/10
mfhi $t1 # $t1 = value%10
addiu $t1, $t1, 48 # convert digit into ASCII
addiu $v0, $v0, -1 # point to previous byte
sb $t1, 0($v0) # store character in memory
bnez $a0, L2 # loop if value is not 0
blt $a0,10,addpoint
endp:
j endint2str
addpoint:
move $t9,$v0
lb $t1,point
sb $t1,1($v0)
j endp

bubbleSort: # $a0 = &A, $a1 = n
do: addiu $a1, $a1, -1 # n = n-1 
blez $a1, L2s # branch if (n <= 0)
move $t0, $a0 # $t0 = &A
li $t1, 0 # $t1 = swapped = 0
li $t2, 0 # $t2 = i = 0
for: 
ldc1 $f2, 0($t0) # $t3 = A[i]
ldc1 $f4,8($t0) # $t4 = A[i+1]
c.le.d $f2, $f4 # branch if (A[i] <= A[i+1])
bc1t L1s
sdc1 $f4, 0($t0) # A[i] = $t4
sdc1 $f2, 8($t0) # A[i+1] = $t3
li $t1, 1 # swapped = 1
L1s: addiu $t2, $t2, 1 # i++
addiu $t0, $t0, 8 # $t0 = &A[i]
bne $t2, $a1, for # branch if (i != n)
bnez $t1, do # branch if (swapped)
L2s: jr $ra 
