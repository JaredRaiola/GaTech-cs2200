!============================================================
! CS 2200 Homework 2 Part 2: fib
!
! Apart from initializing the stack,
! please do not edit mains functionality
!============================================================

main:
    lea     $sp, stack          ! load ADDRESS of stack label into $sp

    lw			$sp, 0($sp) 				! TODO: Here, you need to initialize the stack
                                ! using the label below by loading its
                                ! VALUE into $sp (CHANGE THIS INSTRUCTION)

    lea     $at, fib            ! load address of fib label into $at
    addi    $a0, $zero, 5	     	! $a0 = 5, the number a to compute fib(n)
    jalr    $ra, $at            ! jump to fib, set $ra to return addr
    halt                        ! when we return, just halt

fib:
    													  ! TODO: perform post-call portion of
                                ! the calling convention. Make sure to
                                ! save any registers youll be using!
    sw			$fp, 0($sp)
    add     $fp, $sp, $zero
    addi		$sp, $sp, -1
    												  	! TODO: Implement the following pseudocode in assembly:
    nand    $t0, $a0, $a0
    addi    $t0, $t0, 1
    addi		$t1, $zero, 1
    add		  $t1, $t1, $t0
    skplt		$t1, $zero
    goto 		base								! IF (a0 <= 1)
    goto    else                !    GOTO BASE
                                ! ELSE
                                !    GOTO ELSE


base:
		add     $t0, $a0, $zero
		addi    $a0, $zero, 1
		nand    $t0, $t0, $t0
		addi    $t0, $t0, 1
		skplt   $t0, $zero
		addi 		$a0, $zero, 0
														    ! TODO: If $a0 is less than 0, set $a0 to 0
    addi    $v0, $a0, 0         ! return a
    goto    teardown            ! teardown the stack


else:
   															 ! TODO: Save the value of the $a0 into a saved register
   	addi    $s0, $a0, 0

   	sw			$ra, 0($sp)
   	addi		$sp, $sp, -1

   	sw			$s0, 0($sp)
   	addi		$sp, $sp, -1

    addi    $a0, $a0, -1        ! $a0 = $a0 - 1 (n - 1)

    													  ! TODO: Implement the recursive call to fib
                                ! You should not have to set any of the argument registers here.
    jalr		$ra, $at
                                ! Per the PDF, do not save any temp registers!

    add     $s1, $v0, $zero 		! TODO: Save the return value of the fib call into a register

    lw			$a0, 1($sp) 		! TODO: Restore the old value of $a0 that we saved earlier

    sw			$s1, 0($sp)
   	addi		$sp, $sp, -1



    addi    $a0, $a0, -2        ! $a0 = $a0 - 2 (n - 2)

    jalr		$ra, $at 					  ! TODO: Implement the recursive call to fib
                                ! If your previous recursive call worked correctly,
                                ! you should be able to copy and paste it here :)
  															! TODO: Compute fib(n - 1) [stored from earlier] + fib(n - 2) [just computed]
  	lw			$s1, 1($sp)
  	lw      $ra, 3($sp)
  	add     $v0, $v0, $s1
                                ! Place the sum of those two values into $v0
    goto    teardown            ! return
    
teardown:
		add     $sp, $fp, $zero
    lw			$fp, 0($fp) 				! TODO: perform pre-return portion
                                !       of the calling convention

    jalr    $zero, $ra          ! return to caller

stack: .word 0xFFFF             ! the stack begins here
