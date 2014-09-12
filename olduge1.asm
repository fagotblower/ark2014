problem2.31nej:
	addi    $a0, $zero, 2
	subu	$sp, $sp, 32	#alloker 32bytes stack frame
	sw	$ra, 20($sp)	#gem return adress i stack pointeren
	sw	$fp, 16($sp)    #gemmer den gamle frame pointer
	addiu	$fp, $sp, 28    #s?tter en ny frame pointer
	sw 	$a0, 0($fp)     #gemmer argumentets n's nuv?rende v?rdi
	
	lw	$v0, 0($fp)      #loader n's v?rdi ind i v0, returnv?rdien for funktionen
	 	
	if11:		
		bne $a0, $zero, if2	#hvis n ikke er nul, s? kaldes label if2
		li $a0, 0		#ellers s? returneres 0
		li $v0, 1
		syscall
		jal end			#og programmet hopper til returnadressen, hvilket stopper denne afgrening

	if21:
		bne $a0, 1, else	#hvis n ikke er lig 1, s? k?res det sidste else-tilf?lde
		li $a0, 1
		li $v0, 1		#ellers s? returneres 1
		syscall
		jal end
		#jr $ra			#og programmet hopper til returnadressen, hvilket stopper denne afgrening
	else1:
		lw $v1, 0($fp)		#loader n's v?rdi ind i v1 (den anden returnede v?rdi, skal m?ske bare v?re den normalle return eller en temporary)
		subu $v0, $v1, 1	#n-1 beregnes og gemmes i normal return
		move $a0, $v0		#n-1 bliver sat som argument til n?ste funktionskald
		jal problem2.31		#n?ste kald startes og efter det er beregnet kommer programmet til linje 24
		
		#lw $v0, 0($fp)		#I don't know, ignorer for nu
		
		lw $v1, 0($fp)		#n's v?rdi hentes fra stacken
		subu $v1, $v1, 2	#n-2 beregnes og puttes i argument 1(skal nok v?re temporary i stedet)
		move $a0, $v1		#n-2 flyttes til at v?re argument for n?ste funktionskald
		jal problem2.31		#funktionen k?res med n-2 og kommer s? tilbage til linje 30
		
		
		lw $v1  0($fp)		#resultatet fra k?rsel med n-1 hentes forh?bentligt her
		add $a0, $v0, $v1	#resultat fra n-1 og n-2 plusses sammen
		li $v0, 1
		syscall
		jal end
		
cleanup1:
	lw $ra, 20($sp)			#genskaber return adressen
	lw $fp, 16($sp)			#genskaber frame pointeren
	addiu $sp, $sp, 32		#popper stacken(dette skaber nok adgang til n?ste element, s? m?ske burde det ske mellem at vi pr?ver at hente n-1's og n-2's v?rdiers
	jr $ra				#return for at stoppe den afgrening af programmet
	#.end problem2.31		#dette slutter vidst officielt funktionen p? en m?de, men har ikke set det brugt f?r
		
end1:
	li	$v0, 1
	syscall
