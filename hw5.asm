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

zero_done:
    # Function epilogue
    jr $ra

# Function: placePieceOnBoard
# Arguments: 
#   $a0 - address of piece struct
#   $a1 - ship_num
placePieceOnBoard:
    # Function prologue

    # Load piece fields
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
	sll $t5, $t5, 2   # 4 * (i * num_columns + j)  Mult by 4 b/c we have an array of 4-byte words
	add $t5, $t5, $t0 # base_addr + 4*(i * num_columns + j)
	lw $a0, 0($t5)
	addi $a0, $a0, 48 
	li $v0, 11
	syscall # print int
	li $a0, ' '
	li $v0, 11
	syscall # print space 
	addi $t4, $t4, 1  # j++
	blt $t4, $t2, column_loop
	
column_loop_done:
	addi $t3, $t3, 1  # i++
	blt $t3, $t1, row_loop

row_loop_done:
	li $a0, '\n' 
	li $v0, 11
	syscall
    
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
    jr $ra

# Function: test_fit
# Arguments: 
#   $a0 - address of piece array (5 pieces)
test_fit:
    # Function prologue
    jr $ra


T_orientation4:
    # Study the other T orientations in skeleton.asm to understand how to write this label/subroutine
    j piece_done

.include "skeleton.asm"