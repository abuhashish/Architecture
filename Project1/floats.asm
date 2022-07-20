    .data

arrayA: .double 5.0
        
arrayB: .double 1.5  #Array2 to store the second list

endl:   .asciiz "\n"
.text
main: 
    ldc1 $f2 , arrayB
    ldc1 $f0, arrayA
    mul.d $f12,$f2,$f0
    li $v0,3
    syscall
        #system call
    li $v0, 10
    syscall         #end the program
