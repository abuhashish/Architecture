.data
	mdArray: .word 3 ,5 ,6 ,7
	size:    .word 2
	.eqv DATA_SIZE 4
.text
 	main:
 		la $a0,mdArray
 		lw $a1,size
 		jal sumdiagonal
 		move $a0,$v0
 		
 		li $v0,1
 		syscall
 		
 		li $v0,10
 		syscall
 		
 	sumdiagonal:
 		li  $v0,0
 		li  $t0,0
 		
 		summloop:
 			mul   $t1,$t0,$a1
 			add    $t1,$t1,$t0
 			mul   $t1,$t1,DATA_SIZE
 			add    $t1,$t1,$a0
 			
 			lw $t2, ($t1)
 			add $v0,$v0,$t2
 			
 			addi $t0,$t0,1
 			blt  $t0,$a1,summloop
 	jr $ra