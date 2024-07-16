.data
#Buffers
buffer: .space 32       # Space for 32 bits + null terminator
buffer2:.space 32
fileWords:.space 2048
#Filepath
fileName: .asciiz "{Insert Path to help.txt file here]" #When pasting the path replace [\] by [/]
#Constants
float0: .float 0.0
float1: .float 1.0
float2: .float 2.0
float3: .float 3.0
floatx: .float 6.0
floaty: .float 120.0
#Menu Inputs
menu: .asciiz "\nChoose an option: 0-Basic Operations, 1-Conversions, 2-Advanced Operations, 3-Help\n"
#Conversions
bin:.asciiz"\nBinary: \n"
dec:.asciiz"\nDecimal: \n" 
hex:.asciiz"\nHexadecimal: \n"
hexValues: .asciiz "0123456789ABCDEF"
conversion: .asciiz "\nDecimal(D) Binary(B) Hexadecimal(H)\nChoose the conversion: 0(D->B), 1(D->H), 2(B->D), 3(B->H), 4(H->D), 5(H->B), 6-Back\n"
#Inputs
input: .asciiz "\nEnter a value: "
input_integer: .asciiz "\nEnter a positive integer value: "
input_positive: .asciiz "\nEnter a positive value: "
choose_arithmetic: .asciiz "\nChoose an arithmetic function: +, -, *, /, =\n"
choose_advanced: .asciiz "\nChoose an advanced function: 0-Log2, 1-Log10, 2-Power, 3-Root, 4-Sine, 5-Cosine, 6-Back\n"
continueYN: .asciiz "\nContinue?(y/n)"
result: .asciiz "Result: "
exponent: .asciiz "Enter an exponent: "
#Syscalls
syscall_open: .word 13
syscall_read: .word 14
syscall_write: .word 15
syscall_close: .word 16

.text
li $t4, -1
li $t6, 0
li $t7, 0
li $s0, 0 
##############
#### Menu ####
MainMenu:
li $v0, 4
la $a0, menu
syscall #print("Choose an option: 0-Basic Operations, 1-Conversions, 2-Advanced Operations, 3-Help\n"

li $v0, 5
syscall
move $t0, $v0 

li $t1, 0
beq $t0, $t1, BasicOperations
li $t1, 1
beq $t0, $t1, Convert
li $t1, 2
beq $t0, $t1, AdvancedOperations
li $t1, 3
beq $t0, $t1, Help
j Exit
############
############
############
###Op.Av.##
AdvancedOperations:
li $v0, 4
la $a0, choose_advanced
syscall #print(Choose an advanced function..)

li $v0, 5
syscall
move $t0, $v0

li $t1, 0
beq $t0, $t1, Log2_Main
li $t1, 2
beq $t0, $t1, Power
li $t1, 3
beq $t0, $t1, Root
li $t1, 4
beq $t0, $t1, Sine
li $t1, 6
beq $t0, $t1, MainMenu

###############################################################
Log2_Main:
li $t1, -1 #Shifts Counter

li $v0, 4 #Print String
la $a0, input_integer
syscall #print(Enter a positive integer value: )

li $v0, 5 #Scan Integer
syscall
move $s0, $v0

Log2_Loop:
beqz $s0, Log2_End #if s0 = 0, loop end
srl $s0, $s0, 1
addi $t1, $t1, 1

j Log2_Loop

Log2_End:
li $v0, 4 #Print String
la $a0, result
syscall

li $v0, 1 #Print Integer
move $a0, $t1
syscall
j AdvancedOperations
###########################################################
Power:
li $v0, 4 #Print String
la $a0, input_integer
syscall

li $v0, 5 #Scan Integer
syscall
move $s0, $v0

li $v0, 4 #Print String
la $a0, exponent
syscall

li $v0, 5 #Scan Integer
syscall
move $s1, $v0
li $t0, 1
move $t1, $s1

Power_Loop: #calculates power
beq $t1, $zero, Power_End
mul $t0, $t0, $s0
subi $t1, $t1, 1
j Power_Loop

Power_End: #prints result
li $v0, 4 #Print String
la $a0, result
syscall

li $v0, 1 #Print Integer
move $a0, $t0
syscall
j AdvancedOperations #Return

#################################################################
Root:
li $v0, 4 #Print String
la $a0, input_integer
syscall

li $v0, 6 #Scan Float
syscall
mov.s $f12, $f0

sqrt.s $f0, $f12 # Instruction to calculate the square root of a number

li $v0, 4 #Print String
la $a0, result
syscall

li $v0, 2 #Print Float
mov.s $f12, $f0
syscall
j AdvancedOperations

#################################################################
Sine:
li $v0, 4
la $a0, input_positive
syscall #print(Enter a positive value:  )

li $v0, 6
syscall
mov.s $f12, $f0
# Taylor series to approximate Sin(x)
mul.s $f12, $f12, $f12
mul.s $f12, $f12, $f12
l.s $f2, floatx
div.s $f11, $f12, $f2
sub.s $f0, $f0, $f11
mul.s $f12, $f12, $f12
mul.s $f12, $f12, $f12
l.s $f2, floaty
div.s $f11, $f12, $f2
add.s $f0, $f0, $f11

li $v0, 4
la $a0, result
syscall

li $v0, 2
mov.s $f12, $f0
syscall
j AdvancedOperations

##################################################################
##################################################################
BasicOperations:
li $v0, 4
la $a0, input
syscall #print(Enter a value: )

li $v0, 7
syscall 
mov.d $f2, $f0 #stored in $f2

ArithmeticFunction:
li $v0, 4
la $a0, choose_arithmetic
syscall #print(Choose an arithmetic function: +, -, *, /, =)

li $v0, 12
syscall

beq $v0, 43, Add# +
beq $v0, 45, Sub# -
beq $v0, 42, Mul# *
beq $v0, 47, Div# /
beq $v0, 61, Equal# =

Add: #Add Chosen
li $v0, 4
la $a0, input
syscall #print(Enter a value: )

li $v0, 7
syscall 

add.d $f2, $f2, $f0 
li $t0, 1
j ArithmeticFunction

Sub: #Sub Chosen
li $v0, 4
la $a0, input
syscall #print(Enter a value: )

li $v0, 7
syscall 

sub.d $f2, $f2, $f0
li $t1, 1
j ArithmeticFunction

Mul: #Mul Chosen
li $v0, 4
la $a0, input
syscall #print(Enter a value: )

li $v0, 7
syscall 

mul.d $f2, $f2, $f0
li $t1, 1
j ArithmeticFunction

Div: #Div Chosen
li $v0, 4
la $a0, input
syscall #print(Enter a value: )

li $v0, 7
syscall 

div.d $f2, $f2, $f0
li $t1, 1
j ArithmeticFunction

Equal:
li $v0, 3
mov.d $f12, $f2
syscall
li $v0, 4
la $a0, continueYN
syscall #print(Continue?(y/n))

li $v0, 12
syscall

beq $v0, 121, ArithmeticFunction# y

j MainMenu
####################################################
Convert:
li $v0, 4
la $a0, conversion
syscall #print(Decimal(D) Binario(B) Hexadecimal(H)\nEscolha a conversão: 0(D->B), 1(D->H), 2(B->D), 3(B->H), 4(H->D), 5(H->B))


li $v0, 5
syscall
move $t0, $v0

beq $t0, 0, DecToBin
beq $t0, 1, DecToHex
beq $t0, 2, BinToDec
beq $t0, 3, BinToHex
beq $t0, 4, HexToDec
beq $t0, 5, HexToBin
beq $t0, 6, MainMenu

DecToBin:
li $v0, 4 #Print String
la $a0, input
syscall

li $v0, 5
syscall
move $t0, $v0 #stored in $t0

UsingFunction:
la $a1, buffer        
addi $a1, $a1, 32     
sb $zero, 0($a1) 

DBLoop:
li $t1, 2
div $t0, $t1# $t0/2
mflo $t0   # Stores the quotient back in $t0.
mfhi $t2   # Stores the remainder in $t2.
addi $t2, $t2, 48  # Converts the remainder (0 or 1) to the corresponding ASCII character.
addi $a1, $a1, -1   # Decrements the buffer pointer.
sb $t2, 0($a1)     # Stores the character in the buffer.
bnez $t0, DBLoop   # Repeats the loop if $t0 is not zero.

beqz $t4, FirstSet
bgtz $t4, StoreForHex

j ContinueDB
FirstSet:
li $t3, 0
move $t1, $a1       # First 4-bit value
or $t3, $t3, $t1   # Store it in $t3
li $t4, 1
j HBLoop
StoreForHex:
move $t1, $a1        # Second 4-bit value
sll $t3, $t3, 4    # Make room in $t3
or $t3, $t3, $t1   # Store it in $t3
j HBLoop

ContinueDB:
li $v0, 4
la $a0, bin
syscall #print(Binary: )
move $a0, $a1
li $v0, 4  
syscall

jal ResetValues  

li $v0, 4
la $a0, continueYN
syscall #print(Continue?(y/n))

li $v0, 12
syscall
beq $v0, 121, Convert# y

j MainMenu

# Beggining of DecToHex function
DecToHex:
li $v0, 4
la $a0, input
syscall #print(Enter a value: )

li $v0, 5
syscall
move $t0, $v0 #stored in $t0

# Helper function to handle a specific condition.
BorrowFunction:
bnez $t6, Move_s0  # If $t6 is not zero, jump to Move_s0.
j continue   # Continues execution after the helper function.

Move_s0:
move $t0, $s0   # Copies the value of $s0 to $t0.
li $t6, 0    # Zeroes the $t6 register.
        
continue:
# Prepare for conversion
la $a1, buffer        # Base address of the buffer
addi $a1, $a1, 32     # Start at the end of the buffer
sb $zero, 0($a1)      # Null terminator for the string

# Loop for converting decimal to hexadecimal.
DHLoop:
li $t1, 16
div $t0, $t1          # Divide the number by 16
mflo $t0              # Quotient goes back to $t0
mfhi $t2              # Remainder goes to $t2
la $t3, hexValues     # Loads the base address of hex_digits
add $t3, $t3, $t2     # Adds the offset for the correct digit
lb $t3, 0($t3)        # Loads the hexadecimal digit
addi $a1, $a1, -1     # Decrements the pointer to store the digit.
sb $t3, 0($a1)        # Stores the digit in the buffer
bnez $t0, DHLoop      # If $t0 is not zero, continue the loop

# Print result
li $v0, 4
la $a0, hex
syscall

move $a0, $a1
li $v0, 4 # syscall to print string
syscall

jal ResetValues  

# Request to continue.
li $v0, 4
la $a0, continueYN #"Continue?(y/n)".
syscall 
li $v0, 12  # Set syscall code to read a character.
syscall     
beq $v0, 121, Convert # If the user types 'y', return to the conversion menu.

# Returns to the main menu if not continuing.
j MainMenu              

# Start of BinToDec function
BinToDec:
li $v0, 4
la $a0, input
syscall #print(Enter a value: )

la $a0, buffer  # Loads the address of the buffer into $a0.
li $a1, 32      # Sets the buffer size to 32 in $a1.
li $v0, 8      
syscall        # Calls the system to read the user-entered string into the buffer.

# Prepares variables for the conversion loop.
la $t1, buffer   # Loads the initial address of the buffer into $t1.
li $t9, 32       # Sets the initial counter to 32 in $t9.

BDLoop:
lb $a0, ($t1)        # Loads byte by byte from the binary string.
blt $a0, 48, printDec# Jumps to printDec if the character is less than '0' (invalid characters).
addi $t1, $t1, 1     # Increments the buffer pointer.
subi $a0, $a0, 48    # Converts the ASCII character to its numeric value (0 or 1).
subi $t9, $t9, 1      # Decrements the counter.
beq $a0, 0, BDLoop    # Continues the loop if the character is '0'.
beq $a0, 1, One       # Goes to the One block if the character is '1'.
       
# Block to handle the digit '1'.
One:
li $t8, 1                
sllv $t5, $t8, $t9 # Shifts the value 1 left by $t9 times (the power of 2 corresponding to the bit position).
add $s0, $s0, $t5  # Adds the calculated value to the total sum stored in $s0.
j BDLoop  # Returns to the beginning of the loop to process the next character.

          
# After processing all characters, print the result.
printDec:
srlv $s0, $s0, $t9 # Adjusts the value of $s0 to the right based on the remaining counter.
bgtz $t6, BorrowFunction             
la $a0, dec   # Loads the address of the string "Decimal: ".
li $v0, 4                 
syscall   # print(Decimal: )    

move $a0, $s0             
li $v0, 1                
syscall           

# Call to reset the register values and ensure there are no side effects.
jal ResetValues 
 
# Asks the user if they wish to continue.
li $v0, 4
la $a0, continueYN
syscall #print(Continue?(y/n))

li $v0, 12 
syscall
beq $v0, 121, Convert# y

j MainMenu # Returns to the main menu if not.
# Start of the BinToHex function, which redirects to BinToDec to leverage some of the already implemented logic.
BinToHex:
li $t6, 1 # Sets a flag for some specific purpose within the BinToDec function.
j BinToDec          # Jumps directly to the BinToDec function.

# HexToBin function: requests hexadecimal input from the user and converts it to binary.
HexToBin:
li $v0, 4
la $a0, input
syscall # print(Enter a value: )

la $a0, buffer            
li $a1, 32              
li $v0, 8               
syscall              # Reads the user's input and stores it in 'buffer'.
li $t4, 0            # Initializes $t4 for use as a flag or counter.
la $t7, buffer       # $t7 points to the beginning of the buffer.                  

# Main loop to process each hexadecimal character.
HBLoop:
lb $a0, 0($t7)       # Loads a byte (character) from the buffer.
blt $a0, 48, printHex # If the character is less than '0', jumps to printHex.
blt $a0, '0', Skip   # If not a valid hexadecimal digit or letter, jumps to Skip.
bgt $a0, 'f', Skip   # If greater than 'f', also jumps.
blt $a0, 'a', CheckDigit # If between '0' and '9', goes to CheckDigit.
subi $a0, $a0, 87       # Converts 'a'-'f' to 10-15
j StoreValue

# Block for converting uppercase letters 'A'-'F'.
CheckDigit:
blt $a0, 'A', ConvertDigit
bgt $a0, 'F', ConvertDigit
addi $a0, $a0, -55       # Converts 'A'-'F' to 10-15
j StoreValue

ConvertDigit:
subi $a0, $a0, 48        # Converts '0'-'9' to 0-9

# Stores the converted value and continues the loop.
StoreValue:
addi $t7, $t7, 1         # Increments the buffer pointer to the next character.
move $t0, $a0            # Moves the converted numeric value to $t0.
j UsingFunction # Calls a function to continue processing.

# If needing to skip invalid characters.
Skip:
addi $t7, $t7, 1         # Increments the pointer to skip the character.
j HBLoop                 # Continues the loop  

# If it has reached the end of the valid characters.
printHex:
li $t4, -1      # Sets $t4 to -1.
bltz $t6, BDLoop # If $t6 is negative, goes to BDLoop.

la $a0, bin           
li $v0, 4                 
syscall   # print(Binary: )    
move $a0, $t3             
li $v0, 4               
syscall          # Prints more data or formatting.

jal ResetValues  # Calls function to reset register values.

li $v0, 4
la $a0, continueYN
syscall # print(Continue?(y/n))
li $v0, 12
syscall
beq $v0, 121, Convert # If the user types 'y', returns to Conversion.

j MainMenu # Otherwise, returns to the Main Menu.

# Conversion from Hexadecimal to Decimal, reuses part of the HexToBin code.
HexToDec:
li $t6, -1
j HexToBin

# Function to reset register values.
ResetValues:
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, -1
li $t5, 0
li $t6, 0
li $t7, 0
li $t8, 0
li $t9, 0 
jr $ra # Returns to the return address (continues from where it was called)
######################################
######################################
######################################
Help:
    # Opens file help.txt
li $v0, 13          
la $a0, fileName
li $a1, 0
syscall
move $s0, $v0
    
li $v0, 14
move $a0, $s0
la $a1, fileWords
la $a2, 2048
syscall
        
li $v0, 4
la $a0, fileWords
syscall   
            
j MainMenu
    
Exit:
li $v0, 10 # End of program
syscall
