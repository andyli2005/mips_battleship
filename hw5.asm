.data
space: .asciiz " "    # Space character for printing between numbers
newline: .asciiz "\n" # Newline character
extra_newline: .asciiz "\n\n" # Extra newline at end

.text
.globl zeroOut 
.globl place_tile 
.globl printBoard 
.globl placePieceOnBoard 
.globl test_fit 

# Function: zeroOut
# Arguments: None
# Returns: void
zeroOut:
    # Function prologue 
    la $t0, board 
    lw $t1, board_height
    lw $t2, board_width

    li $t3, 0 # i 

row_loop_for_zero: 
    li $t4, 0 # j

column_loop_for_zero:
    mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
    add $t5, $t5, $t0 # base_addr + (i * num_columns + j)
    sb $0, 0($t5) # store byte 0 at array element 

    addi $t4, $t4, 1 # j++
    blt $t4, $t2, column_loop_for_zero

column_loop_for_zero_done: 
    addi $t3, $t3, 1 # i++
    blt $t3, $t1, row_loop_for_zero

zero_done:
    # Function epilogue
    jr $ra

# Function: placePieceOnBoard
# Arguments: 
#   $a0 - address of piece struct
#   $a1 - ship_num
placePieceOnBoard:
    # Function prologue
    addi $sp, $sp, -4 
    sw $ra, 0($sp)
    # Load piece fields

    lw $t0, 0($a0) # type
    move $s3, $t0

    lw $t0, 4($a0) # orientation
    move $s4, $t0

    lw $t0, 8($a0) # row_loc
    move $s5, $t0

    lw $t0, 12($a0) # col_loc
    move $s6, $t0

    li $s2, 0
    move $s1, $a1

    # First switch on type
    li $t0, 1
    beq $s3, $t0, piece_square
    li $t0, 2
    beq $s3, $t0, piece_line
    li $t0, 3
    beq $s3, $t0, piece_reverse_z
    li $t0, 4
    beq $s3, $t0, piece_L
    li $t0, 5
    beq $s3, $t0, piece_z
    li $t0, 6
    beq $s3, $t0, piece_reverse_L
    li $t0, 7
    beq $s3, $t0, piece_T
    j piece_done       # Invalid type

piece_done:
   bne $s2, $0, zeroOut
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   jr $ra
   
# Function: printBoard
# Arguments: None (uses global variables)
# Returns: void
# Uses global variables: board (char[]), board_width (int), board_height (int)

printBoard:
    # Function prologue

    la $t0, board
    lw $t1, board_height # rows
    lw $t2, board_width # columns 
    
    li $t3, 0 # i

row_loop:
	li $t4, 0 # j

column_loop:
	mul $t5, $t3, $t2 # i * num_columns
	add $t5, $t5, $t4 # i * num_columns + j
	add $t5, $t5, $t0 # base_addr + (i * num_columns + j)

	lb $a0, 0($t5)
	addi $a0, $a0, 48 

	li $v0, 11
	syscall # print ascii 

	la $a0, space
	li $v0, 4
	syscall # print space 

	addi $t4, $t4, 1  # j++
	blt $t4, $t2, column_loop
	
column_loop_done:
    la $a0, newline 
    li $v0, 4
    syscall
    
	addi $t3, $t3, 1  # i++
	blt $t3, $t1, row_loop

row_loop_done:
    # Function epilogue
    jr $ra                # Return

# Function: place_tile
# Arguments: 
#   $a0 - row
#   $a1 - col
#   $a2 - value
# Returns:
#   $v0 - 0 if successful, 1 if occupied, 2 if out of bounds
# Uses global variables: board (char[]), board_width (int), board_height (int)

place_tile:
    la $t0, board
    move $t1, $a0 # row 
    move $t2, $a1 # col
    move $t3, $a2 # piece 
    lw $t4, board_height # num_rows 
    lw $t5, board_width # num_columns

    bge $t1, $t4, out_of_bounds
    bge $t2, $t5, out_of_bounds

    bltz $t2, out_of_bounds
    bltz $t1, out_of_bounds

    mul $t6, $t1, $t5 # row * num_columns
	add $t6, $t6, $t2 # row * num_columns + col
	add $t6, $t6, $t0 # base_addr + (row * num_columns + col)

    lb $t7, 0($t6)
	addi $t7, $t7, 48 

    li $t8, '0'
    bne $t7, $t8, occupied 

    sb $t3, 0($t6) # store piece at array element 
    li $v0, 0
    jr $ra

out_of_bounds:
    li $v0, 2 
    jr $ra
    
occupied:
    li $v0, 1
    jr $ra

# Function: test_fit
# Arguments: 
#   $a0 - address of piece array (5 pieces)
test_fit:
    # Function prologue
    addi $sp, $sp, -4 
    sw $ra, 0($sp)

    li $s0, 5 # size of array 
    li $t0, 0 # i = 0
    
check_type_and_orientation_loop: 
    beq $s0, $t0, end_check_loop # repeat until counter == size 
    sll $t1, $t0, 4 # $t1 = 16*i
    add $t1, $t1, $a0 # $t1 holds address of piece array[i]
    lw $t2, 0($t1)
    li $t3, 8 

    bge $t2, $t3, type_out_of_bounds # type >= 8
    blez $t2, type_out_of_bounds # type <= 0

    lw $t2, 4($t1)
    li $t3, 5 
    
    bge $t2, $t3, orientation_out_of_bounds # orientation >= 5
    blez $t2, orientation_out_of_bounds # orientation <= 0

    addi $t0, $t0, 1 # i++ 
    j check_type_and_orientation_loop

end_check_loop:
    li $s0, 5 # size of array 
    li $t0, 0 # i = 0

attempt_populate_loop:
    beq $s0, $t0, end_poulate_loop # repeat until counter == size 

    sll $t1, $t0, 4 # $t1 = 16*i
    add $t1, $t1, $a0 # $t1 holds address of piece array[i]
    addi $t2, $t0, 1 # ship_num

    move $a0, $t1
    move $a1, $t2
   
    jal placePieceOnBoard 

    addi $t0, $t0, 1 # i++
    j attempt_populate_loop

end_poulate_loop:
    lw $ra, 0($sp)
    addi, $sp, $sp, 4
    li $v0, 0
    jr $ra

type_out_of_bounds:
    li $v0, 4
    jr $ra

orientation_out_of_bounds:
    li $v0, 4
    jr $ra

T_orientation4:
    move $a0, $s5          
    addi $a0, $a0, 1       # row + 1
    move $a1, $s6
    addi $a1, $a1, 1       # col + 1
    move $a2, $s1
    jal place_tile
    or $s2, $s2, $v0

    move $a0, $s5
    addi $a0, $a0, 1      # row + 1
    move $a1, $s6         # col 
    move $a2, $s1
    jal place_tile
    or $s2, $s2, $v0

    move $a0, $s5
    addi $a0, $a0, 2       # row + 2
    move $a1, $s6          # col
    move $a2, $s1
    jal place_tile
    or $s2, $s2, $v0

    move $a0, $s5          # row
    move $a1, $s6          # col
    move $a2, $s1
    jal place_tile
    or $s2, $s2, $v0
    j piece_done
    

.include "skeleton.asm"