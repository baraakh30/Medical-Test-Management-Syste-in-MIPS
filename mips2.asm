#Baraa Khanfar
#1210640
#Lina AbuFarha
#1211968
.data
# Define data segments for storing variables and messages
patientIDPrompt: .asciiz "Enter patient ID: "
testNamePrompt: .asciiz "\nEnter test name: "
testDatePrompt: .asciiz "\nEnter test date (YYYY-MM): "
testResultPrompt: .asciiz "\nEnter test result: "
averageCa: .asciiz "Average results for : "
patientIDNew: .asciiz "Enter new patient ID: "
testNameNew: .asciiz "\nEnter new test name: "
testDateNew: .asciiz "\nEnter new test date (YYYY-MM): "
testResultNew: .asciiz "\nEnter new test result: "

enterPatientIDPrompt: .asciiz "Enter patient ID to search: "
testNotFoundPrompt: .asciiz "Error: Test not found.\n"
tempFile: .asciiz "temp.txt"
delete:.asciiz "Test deleted successfully.\n" # Load address of success message
update:.asciiz "Test deleted successfully.\n" # Load address of success message
testFileName: .asciiz "medical_tests.txt"  # File name for storing medical tests
menuPrompt: .asciiz "Select an option:\n1. Add a new medical test\n2. Search for a test by patient ID\n3. Average test value\n4. Update an existing test result\n5. Delete a test\n6. Print All abnormal Tests.\n7. Print Tests\n8. Exit\n"
errorPrompt: .asciiz "Invalid input. Please try again.\n"
invalidFilePrompt: .asciiz "Error: Invalid file name or file not found.\n"
invalidTestPrompt: .asciiz "Error: Test does not exist.\n"
invalidPatientPrompt: .asciiz "Error: Patient does not exist.\n"
foundPrompt: .asciiz "\nFound tests : \n"
retrieveAllTestsPrompt: .asciiz "\n1. Retrieve all patient tests\n2. Retrieve all abnormal patient tests\n3. Retrieve all patient tests in a specific period\nSelect an option: "
startDatePrompt: .asciiz "\nEnter start date (YYYY-MM): "
endDatePrompt: .asciiz "\nEnter end date (YYYY-MM): "

msgerror: .asciiz "The string does not contain valid digits."
   
endDate: .asciiz "YYYY-MM"
startDate: .asciiz "YYYY-MM"

noTestsFoundPrompt: .asciiz "No tests found in the specified period.\n"


BGT:.asciiz "BGT"
LDL:.asciiz "LDL"
HGB:.asciiz "HGB"
BPT:.asciiz "BPT"


# Normal ranges for each test
hgb_lower_bound: .float 13.8
hgb_upper_bound: .float 17.2
bgt_lower_bound: .word 70
bgt_upper_bound: .word 99
ldl_upper_bound: .word 100
bpt_systolic_upper_bound: .word 120
bpt_diastolic_upper_bound: .word 80
float_divisor: .float 10.0
comma: .asciiz ","
sep: .asciiz ":"
newLine: .asciiz "\n"
return: .asciiz "\r"
testName: .space 4
testDate: .space 8
testResult: .space 8
patientID: .space 8
year: .space 4
buffer_read: .space 30     # Buffer for reading lines from file
buffer_write: .space 30    # Buffer for storing modified content
extractedPatientID: .space 8
testLine: .space 30
.text
main:
    # Display menu and handle user input
    displayMenu:
    la $a0,testName
    li $a1,4
    jal clearMemory
    
    la $a0,testDate
    li $a1,8
    jal clearMemory    
    
     la $a0,testResult
    li $a1,8
    jal clearMemory   
    
    la $a0,patientID
    li $a1,8
    jal clearMemory
    
     la $a0,year
    li $a1,4
    jal clearMemory       
            
    la $a0,extractedPatientID
    li $a1,8
    jal clearMemory                
                    
    la $a0,testLine
    li $a1,30
    jal clearMemory                        
                            
     la $a0,buffer_write
    li $a1,30
    jal clearMemory                               
                                    
      la $a0,buffer_read
    li $a1,30
    jal clearMemory                                           
                                            
                                                
                                                        
# Clear all $s registers
    move $s0, $zero
    move $s1, $zero
    move $s2, $zero
    move $s3, $zero
    move $s4, $zero
    move $s5, $zero
    move $s6, $zero
    move $s7, $zero

    # Clear all $t registers
    move $t0, $zero
    move $t1, $zero
    move $t2, $zero
    move $t3, $zero
    move $t4, $zero
    move $t5, $zero
    move $t6, $zero
    move $t7, $zero
    move $t8, $zero
    move $t9, $zero

    # Clear all $a registers
    move $a0, $zero
    move $a1, $zero
    move $a2, $zero
    move $a3, $zero
    
    
    
    # Clear all $ registers
    move $a0, $zero
    move $a1, $zero
    move $a2, $zero
    move $a3, $zero
    
    # Clear all $f registers
    mtc1 $t0,$f0
    cvt.s.w $f0,$f0

    mov.s  $f1,$f0
    mov.s  $f2, $f0
    mov.s  $f3,$f0
    mov.s  $f4,$f0
    mov.s  $f5,$f0
    mov.s  $f6,$f0
    mov.s  $f7,$f0
    mov.s  $f8,$f0
    mov.s  $f9,$f0
    
    
    

        li $v0, 4               # System call for printing string
        la $a0, newLine      # Load address of menu prompt
        syscall

    
        # Display menu prompt
        li $v0, 4               # System call for printing string
        la $a0, menuPrompt      # Load address of menu prompt
        syscall

        # Receive user input
        li $v0, 5               # System call for reading integer
        syscall
        move $t0, $v0           # Store user input in $t0

        # Branch based on user input
        li $t1, 1               # Load option 1
        beq $t0, $t1, addt   # If user selects option 1, call addTest
        li $t1, 2               # Load option 2
        beq $t0, $t1, search   # If user selects option 2, call searchTestByID
        li $t1, 3               # Load option 3
        beq $t0, $t1, calculateAverage   # If user selects option 3, call calculateAverage
        li $t1, 4               # Load option 4
        beq $t0, $t1, updateTest   # If user selects option 4, call updateTest
        li $t1, 5               # Load option 5
        beq $t0, $t1, deletet   # If user selects option 5, call deleteTest   
        li $t1, 6               # Load option 5
        beq $t0, $t1,allAbnormal
        li $t1, 7               # Load option 6
        beq $t0, $t1, printTests   # If user selects option 6, exit program
        li $t1, 8               # Load option 6
        beq $t0, $t1, exitProgram   # If user selects option 6, exit program

        # Invalid input, display error message
        li $v0, 4               # System call for printing string
        la $a0, errorPrompt     # Load address of error prompt
        syscall
        j displayMenu           # Repeat menu display


addt:
la $a0,patientIDPrompt
la $s1,testNamePrompt
la $a2,testDatePrompt
la $a3,testResultPrompt


addd:
      # Prompt user to enter patient ID
    li $v0, 4               # System call for printing string
    move $a0, $a0 # Load address of patient ID prompt
    syscall

    # Receive user input for patient ID
    li $v0, 8               # System call for reading integer
    la $a0, patientID         # Load address of patient ID buffer
    li $a1, 8             # Maximum length of patient ID
    syscall
    move $t0, $v0           # Store patient ID in $t0

    # Validate patient ID
    la $a0, patientID       # Load address of patient ID
    jal validatePatientID   # Call validatePatientID function
    beq $v0, 0, invalid_input_patient_id  # If patient ID is invalid, show error message
add_no_id:

    # Prompt user to enter test name
    li $v0, 4               # System call for printing string
    move $a0, $s1  # Load address of test name prompt
    syscall

    # Receive user input for test name
    li $v0, 8               # System call for reading string
    la $a0, testName         # Load address of test name buffer
    li $a1, 4             # Maximum length of test name
    syscall

    # Validate test name
    la $a0, testName        # Load address of test name
    jal validateTestName    # Call validateTestName function
    beq $v0, 0, invalid_input_test_name   # If test name is invalid, show error message

    # Prompt user to enter test date
    li $v0, 4               # System call for printing string
    move $a0, $a2  # Load address of test date prompt
    syscall

    # Receive user input for test date
    li $v0, 8               # System call for reading string
    la $a0, testDate         # Load address of test date buffer
    li $a1, 8               # Maximum length of test date
    syscall

    # Validate test date
    la $a0, testDate        # Load address of test date
    jal validateTestDate    # Call validateTestDate function
    beq $v0, 0, invalid_input_test_date   # If test date is invalid, show error message

    # Prompt user to enter test result
    li $v0, 4               # System call for printing string
    move $a0, $a3 # Load address of test result prompt
    syscall

    # Receive user input for test result
    li $v0, 8              # System call for reading float
     la $a0, testResult         # Load address of test date buffer
    li $a1, 9               # Maximum length of test date
    syscall
   
    
    # Validate test resultla $a0,testResult
    la $a0,testResult
    jal len_to_new_line
    la $a0,testResult
    jal validateTestResult  # Call validateTestResult function
    beq $v0, 0, invalid_input_test_result  # If test result is invalid, show error message

    # If input is valid, continue with writing to file
    j continue_add_test

invalid_input_patient_id:
        li $v0, 4               # System call for printing string
        la $a0, newLine      # Load address of menu prompt
        syscall

    li $v0, 4               # System call for printing string
    la $a0, errorPrompt   # Load address of error message
    syscall
    j displayMenu           # Return to main menu

invalid_input_test_name:
    li $v0, 4               # System call for printing string
    la $a0, newLine      # Load address of menu prompt
    syscall

    li $v0, 4               # System call for printing string
    la $a0, errorPrompt   # Load address of error message
    syscall
    j displayMenu           # Return to main menu

invalid_input_test_date:
   li $v0, 4               # System call for printing string
   la $a0, newLine      # Load address of menu prompt
   syscall

    li $v0, 4               # System call for printing string
    la $a0, errorPrompt     # Load address of error message
    syscall
    j displayMenu           # Return to main menu

invalid_input_test_result:
    li $v0, 4               # System call for printing string
    la $a0, newLine      # Load address of menu prompt
    syscall

    li $v0, 4               # System call for printing string
    la $a0, errorPrompt     # Load address of error message
    syscall
    j displayMenu           # Return to main menu
    
continue_add_test:    
    la $a0,patientID
  #  jal len_to_new_line

    
    la $a0,testName
   # jal len_to_new_line

    
    la $a0,testDate
    #jal len_to_new_line
   # Open file for appending
    li $v0, 13              # System call for open file
    la $a0, testFileName    # Load address of file name
    li $a1, 0      # Open mode: append
    li $a2, 0               # File permissions
    syscall
move $s0,$v0
     li $v0, 14        # syscall 14 - read from file
    move $a0, $s0     # file descriptor
    la $a1, buffer_read   # buffer to read into
    li $a2, 1         # read 1 byte
    syscall           # read a byte
    move $s1,$v0

   # Close the file
    li $v0, 16              # System call for close file
    move $a0, $s0           # File descriptor
    syscall
     # Open file for appending
    li $v0, 13              # System call for open file
    la $a0, testFileName    # Load address of file name
    li $a1,9       # Open mode: append
    li $a2, 0               # File permissions
    syscall
    move $s0, $v0           # Store file descriptor in $s0

 ble $s1, 0, file_empty  # If end of file reached, jump to file_empty

        li $a2,1
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, return          # Length of string to write
    syscall 
    li $a2,1
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, newLine          # Length of string to write
    syscall 
    
 file_empty:
       # Write patient ID to file
    la $a0, patientID
    jal strlen
    move $a2, $v0           # Move string length to $a2
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, patientID           # Length of string to write
    syscall

    # Write comma to separate fields
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, sep           # Load address of comma
    li $a2, 1               # Length of comma
    syscall

    # Write test name to file
    la $a0, testName
    jal strlen
    move $a2, $v0           # Move string length to $a2
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, testName         # Length of string to write
    syscall

    # Write comma to separate fields
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, comma           # Load address of comma
    li $a2, 1               # Length of comma
    syscall 

    # Write test date to file
    la $a0, testDate
    jal strlen
    move $a2, $v0           # Move string length to $a2
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, testDate          # Length of string to write
    syscall

    # Write comma to separate fields
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, comma           # Load address of comma
    li $a2, 1               # Length of comma
    syscall 

    # Write test result to file
    la $a0, testResult
    jal strlen
    move $a2, $v0           # Move string length to $a2
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, testResult          # Length of string to write
    syscall 
     # Write test result to file
    la $a0, testResult
    jal strlen
    move $a2, $v0           # Move string length to $a2
 bne $s1, -1, close  # If end of file reached, jump to file_empty
    li $a2,1
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, return          # Length of string to write
    syscall 
    li $a2,1
    li $v0, 15              # System call for write string to file
    move $a0, $s0           # File descriptor
    la $a1, newLine          # Length of string to write
    syscall 
    


close:
    # Close the file
    li $v0, 16              # System call for close file
    move $a0, $s0           # File descriptor
    syscall

    j displayMenu           # Return to main menu
   



len_to_new_line:
    lb $t2, ($a0) # t2 = *a0
    beq $t2, '\n', end # if t2 == '\n' -> stop
    addi $a0, $a0, 1 # a0++
    b len_to_new_line   
end:
    sb $zero, ($a0) # overwrite '\n' with 0
    jr $ra 

# Function to calculate the length of a null-terminated string
# Input: $a0 - address of the string
# Output: $v0 - length of the string
strlen:
    # Initialize length counter to 0
    li $v0, 0       # $v0 will hold the length of the string

    # Start loop to iterate through the string
loop1:
  
    lb $t0, 0($a0)

    # Check if the byte is the null terminator (end of string)
    beqz $t0, end1   # If null terminator found, exit loop

    # Increment length counter
    addi $v0, $v0, 1

    # Move to the next byte in the string
    addi $a0, $a0, 1

    # Repeat loop
    j loop1

end1:
    # Return the length of the string in $v0
    jr $ra          # Return to the calling function





search:
    # Search for a test by patient ID
    # Prompt user to enter patient ID
    li $v0, 4               # System call for printing string
    la $a0, enterPatientIDPrompt   # Load address of enter patient ID prompt
    syscall

    # Receive user input for patient ID
    li $v0, 8               # System call for reading string
    la $a0, patientID       # Load address of patient ID buffer
    li $a1, 8               # Maximum length of patient ID
    syscall
    # Validate patient ID
    la $a0, patientID       # Load address of patient ID
    jal validatePatientID   # Call validatePatientID function
    beq $v0, 0, invalid_input_patient_id  # If patient ID is invalid, show error message
    # Prompt for additional options
    li $v0, 4               # System call for printing string
    la $a0, retrieveAllTestsPrompt   # Load address of retrieve all tests prompt
    syscall

    # Receive user input for option
    li $v0, 5               # System call for reading integer
    syscall
    move $t0, $v0           # Store user input in $t0

    # Branch based on user input
    li $t1, 1               # Load option 1
    beq $t0, $t1, searchAllTests   # If user selects option 1, call searchAllTests
    li $t1, 2               # Load option 2
    beq $t0, $t1,searchAbnormalTests   # If user selects option 2, call searchAbnormalTests
    li $t1, 3               # Load option 3
    beq $t0, $t1, searchTestsInPeriod  # If user selects option 3, call searchTestsInPeriod

    # Invalid input, display error message
    li $v0, 4               # System call for printing string
    la $a0, errorPrompt     # Load address of error prompt
    syscall
    j displayMenu           # Return to main menu



searchAllTests:
    # Search for a test by patient ID
  

    # Open file for reading
    li $v0, 13              # System call for open file
    la $a0, testFileName    # Load address of file name
    li $a1, 0               # Open mode: read only
    li $a2, 0               # File permissions
    syscall
    move $s0, $v0           # Store file descriptor in $s0

    # Search for tests with matching patient ID
    li $t1, 0               # Counter for found tests
search_loop:

     la $t3, testLine       # initialize index for buffer_write

    # Read characters from the file
read_file_loop2:
   
    # Read a character from the file
    li $v0, 14          # syscall code for read
    move $a0, $s0       # file handle for reading
    la $a1, buffer_read    # buffer address for reading
    li $a2, 1           # buffer size: read one character at a time
    syscall

    # Check if end of file reached
    move $s2,$v0
    beq $v0, $zero, check    # if return value is 0, end of file reached
 
    # Check if current character is newline
    li $t0, 10          # ASCII code for newline character
      la $t4,buffer_read
   lb $t4,0($t4)
 
    sb $t4, 0($t3)      # store current character in buffer_write
    addi $t3, $t3, 1    # increment index for buffer_write
    beq $t4, $t0, check   # if current character is newline, check end of line

    # Store current character in buffer_write


    j read_file_loop2    # continue reading characters from file
check:

    # Extract patient ID from the line
    li $t2, 0               # Initialize digit counter for patient ID
    la $t1,testLine
    la $t3, patientID       # Load address of patient ID buffer
    la $t4, extractedPatientID  # Load address of extracted patient ID buffer
    li $t5, ':'             # ASCII code for colon (separator)
extract_patient_id:
  

    lb $t6, ($t1)           # Load byte from the line
    beqz $t6, end_extract_patient_id   # If end of line, exit loop
    beq $t6, $t5, end_extract_patient_id   # If colon (separator), exit loop
    sb $t6, ($t4)           # Store byte in extracted patient ID buffer
    addi $t1, $t1, 1        # Move to next byte in the line
    addi $t4, $t4, 1        # Move to next byte in the extracted patient ID buffer
    addi $t2, $t2, 1        # Increment digit counter
    j extract_patient_id    # Repeat loop
end_extract_patient_id:
  
    li $t6, 7               # Expected number of digits for patient ID
    bne $t2, $t6, search_loop   # If not 7 digits, continue to next line

    # Compare patient ID with user input
    la $t2, patientID       # Load address of user input patient ID buffer
    la $t3, extractedPatientID # Load address of extracted patient ID buffer
    jal strcmp              # Call strcmp function
 
    beq $v0, 0, found_test # If patient IDs match, found test
    beq $s2, $zero, end_search    # if return value is 0, end of file reached
    j search_loop           # Continue to next line

found_test:
    # Patient ID found, print test information

    
    li $v0, 4               # System call for printing string
    la $a0, foundPrompt        # Load address of the line
    syscall

    
    li $v0, 4               # System call for printing string
    la $a0, testLine        # Load address of the line
    syscall
    addi $t1, $t1, 1        # Increment found tests counter
    
     li $v0, 4               # System call for printing string
    la $a0, newLine        # Load address of the line
    syscall

    beq $s2, $zero, end_search    # if return value is 0, end of file reached
    j search_loop           # Continue searching for more tests

end_search:
    # Close the file
    li $v0, 16              # System call for close file
    move $a0, $s0           # File descriptor
    syscall

    # If no tests found, display error message
    beq $t1, 0, no_tests_found
    j displayMenu

no_tests_found:
    li $v0, 4               # System call for printing string
    la $a0, testNotFoundPrompt # Load address of test not found prompt
    syscall
    j displayMenu

searchAbnormalTests:
  # Search for a test by patient ID
 
 
    # Open file for reading
    li $v0, 13              # System call for open file
    la $a0, testFileName    # Load address of file name
    li $a1, 0               # Open mode: read only
    li $a2, 0               # File permissions
    syscall
    move $s0, $v0           # Store file descriptor in $s0
    move $s5,$s0
 
    # Search for tests with matching patient ID
    li $t5, 0               # Counter for found tests
search_loop_abnormal:

     la $t3, testLine      # initialize index for buffer_write
     move $s0,$s5

read_file_loop3:
    # Read a character from the file
    li $v0, 14          # syscall code for read
    move $a0, $s0       # file handle for reading
    la $a1, buffer_read    # buffer address for reading
    li $a2, 1           # buffer size: read one character at a time
    syscall

    # Check if end of file reached
    move $s2,$v0
    beq $v0, $zero,eof4  # if return value is 0, end of file reached
 
    # Check if current character is newline

      la $t4,buffer_read
   lb $t4,0($t4)
       # Store current character in buffer_write
 
    sb $t4, 0($t3)      # store current character in buffer_write

    beq $t4, 10, continue   # if current character is newline, check end of line
        addi $t3, $t3, 1    # increment index for buffer_write


    j read_file_loop3    # continue reading characters from file
    # Check if end of file is reached


eof4:
li $s7,111111
   
continue:
    # Extract patient ID from the line
    li $t2, 0               # Initialize digit counter for patient ID
    la $t1,testLine
    la $t3, patientID       # Load address of patient ID buffer
    la $t4, extractedPatientID  # Load address of extracted patient ID buffer
    li $t5, ':'             # ASCII code for colon (separator)
extract_patient_id_abnormal:

    lb $t6, ($t1)           # Load byte from the line
    beqz $t6, end_extract_patient_id_abnormal   # If end of line, exit loop
    beq $t6, $t5, end_extract_patient_id_abnormal   # If colon (separator), exit loop
    sb $t6, ($t4)           # Store byte in extracted patient ID buffer
    addi $t1, $t1, 1        # Move to next byte in the line
    addi $t4, $t4, 1        # Move to next byte in the extracted patient ID buffer
    addi $t2, $t2, 1        # Increment digit counter
    j extract_patient_id_abnormal    # Repeat loop
end_extract_patient_id_abnormal:
 
    li $s4, 7               # Expected number of digits for patient ID
    bne $t2, $s4, search_loop   # If not 7 digits, continue to next line
 
    # Compare patient ID with user input
    la $t2, patientID       # Load address of user input patient ID buffer
    la $t3, extractedPatientID # Load address of extracted patient ID buffer
    jal strcmp              # Call strcmp function
 
    beq $v0, 0, found_test_abnormal # If patient IDs match, found test
 
    j search_loop_abnormal           # Continue to next line
 
found_test_abnormal:
jal extract
 
print:    
 
    la $a0,testResult
    la $a1,testName
  
   j check_test_normal
continue_check:

    beq $v0,0,print2 
    beq $s7,111111,end_search_abnormal
    j search_loop_abnormal
   
print2: 
    li $v0, 4               # System call for printing string
    la $a0, foundPrompt        # Load address of the line
    syscall
 
    li $v0, 4               # System call for printing string
    la $a0, testLine       # Load address of the line
    syscall
    addi $t5, $t5, 1        # Increment found tests counter
    
     li $v0, 4               # System call for printing string
    la $a0, newLine        # Load address of the line
    syscall
    beq  $s7,111111,end_search_abnormal
    j search_loop_abnormal           # Continue searching for more tests
 
end_search_abnormal:
    # Close the file
    li $v0, 16              # System call for close file
    move $a0, $s0           # File descriptor
    syscall
 
    # If no tests found, display error message
     beqz $t5,no_tests_found_abnormal
    j displayMenu
 
no_tests_found_abnormal:
    li $v0, 4               # System call for printing string
    la $a0, testNotFoundPrompt # Load address of test not found prompt
    syscall
    j displayMenu
 
 
# Function to check if the test result is normal
# Input: $a0 - Pointer to the string representation of the result
#        $a1 - Pointer to the string representation of the test name
# Output: $v0 - 1 if normal, 0 if abnormal
 
check_test_normal:
    # Initialize result to abnormal (0)
    li $v0, 0

    # Load test name
    lb $t0, 0($a1)
    lb $t1, 1($a1)
 
    # Check for HGB test
    li $t2, 'H'  # First character of "HGB"
    beq $t0, $t2, hgb_check
 
 
    # Check for LDL test
    li $t2, 'L'  # First character of "LDL"
    beq $t0, $t2, ldl_check
  # Check for BGT test
    li $t2, 'G'  # First character of "BGT"
    beq $t1, $t2, bgt_check
 
    # Check for BPT test
    li $t2, 'P'  # First character of "BPT"
    beq $t1, $t2, bpt_check
 
    # Test name not recognized, return abnormal
    j end_check
 
hgb_check:
    # Load test result as a float
     la $a0,testResult
     li $s6,111111
    j convert_string_to_float
    
continue_hgb_check:
    mov.s $f0, $f12   # Pass the float result to $a0


    # Check if HGB test result is within normal range (13.8 to 17.2 grams per deciliter)
    l.s $f1, hgb_lower_bound
    l.s $f2, hgb_upper_bound
    c.lt.s $f0, $f1
    bc1t hgb_above_lower_bound
    c.lt.s $f2, $f0
    bc1t  hgb_below_upper_bound
    li $v0,1  # Set $v0 to 1 (normal) if both conditions are met
    j end_check
 
hgb_above_lower_bound:
    li $v0, 0    # Result is abnormal (below lower bound)
    j end_check
 
hgb_below_upper_bound:
    li $v0, 0    # Result is abnormal (above upper bound)
    j end_check
 
bgt_check:

    # Load test result as an integer
    jal convert_string_to_integer
    move $a0, $v0   # Pass the integer result to $a0

    # Check if BGT test result is within normal range (70 to 99 milligrams per deciliter)
    li $t3, 70
    li $t4, 99
    blt $a0, $t3, bgt_above_lower_bound
    blt $t4, $a0, bgt_below_upper_bound
    li $v0,1  # Set $v0 to 1 (normal) if both conditions are met
   
    j end_check
 
bgt_above_lower_bound:
    li $v0, 0    # Result is abnormal (below lower bound)
    j end_check
 
bgt_below_upper_bound:
    li $v0, 0    # Result is abnormal (above upper bound)
    j end_check
 
ldl_check:
 la $a0,testResult
    # Load test result as an integer
    jal convert_string_to_integer
    move $a0, $v0   # Pass the integer result to $a0
 
    # Check if LDL test result is within normal range (less than 100 mg/dL)
    li $t3, 100
    blt $a0, $t3, ldl_below_upper_bound
    li $v0, 0    # Result is abnormal (above upper bound)
    j end_check
 
ldl_below_upper_bound:
   li $v0,1 # Set $v0 to 1 (normal)
    j end_check
 
bpt_check:
 la $a0,testResult
    # Load test result as an integer
    jal convert_string_to_integer
    move $a0, $v0   # Pass the integer result to $a0
 
    # Check if BPT test result is within normal range
    # Systolic Blood Pressure: Less than 120 mm Hg
    # Diastolic Blood Pressure: Less than 80 mm Hg
    li $t3, 120
    li $t4, 80
    blt $a0, $t3, bpt_systolic_below_upper_bound
    blt $a0, $t4, bpt_diastolic_below_upper_bound
   li $v0,1  # Set $v0 to 1 (normal) if both conditions are met
    j end_check
 
bpt_systolic_below_upper_bound:
    li $v0, 0    # Result is abnormal (systolic above upper bound)
    j end_check
 
bpt_diastolic_below_upper_bound:
    li $v0, 0    # Result is abnormal (diastolic above upper bound)
    j end_check
 
end_check:
      beq $s6,1111111,continue_check2
       j continue_check
 

searchTestsInPeriod:
  # Prompt user to enter start date
    li $v0, 4               # System call for printing string
    la $a0,startDatePrompt   # Load address of enter start date prompt
    syscall

    # Receive user input for start date
    li $v0, 8               # System call for reading string
    la $a0, startDate       # Load address of start date buffer
    li $a1, 8             # Maximum length of start date
    syscall
    # Validate test date
    la $a0, startDate        # Load address of test date
    jal validateTestDate    # Call validateTestDate function
    beq $v0, 0, invalid_input_test_date   # If test date is invalid, show error message
    # Prompt user to enter end date
    li $v0, 4               # System call for printing string
    la $a0, endDatePrompt   # Load address of enter end date prompt
    syscall

    # Receive user input for end date
    li $v0, 8               # System call for reading string
    la $a0, endDate         # Load address of end date buffer
    li $a1, 8              # Maximum length of end date
    syscall
        # Validate test date
    la $a0, endDate        # Load address of test date
    jal validateTestDate    # Call validateTestDate function
    beq $v0, 0, invalid_input_test_date   # If test date is invalid, show error message

    # Open file for reading
    li $v0, 13              # System call for open file
    la $a0, testFileName    # Load address of file name
    li $a1, 0               # Open mode: read only
    li $a2, 0               # File permissions
    syscall
    move $s0, $v0           # Store file descriptor in $s0
    li $s5,0
    # Read and process each test in the file
    li $t0, 0               # Initialize test counter
read_test:

     la $t3, testLine       # initialize index for buffer_write

    # Read characters from the file
read_file_loop1:
   
    # Read a character from the file
    li $v0, 14          # syscall code for read
    move $a0, $s0       # file handle for reading
    la $a1, buffer_read    # buffer address for reading
    li $a2, 1           # buffer size: read one character at a time
    syscall

    # Check if end of file reached
    move $s2,$v0
    beq $v0, $zero, eof1   # if return value is 0, end of file reached
  
 
    # Check if current character is newline
    li $t0, 10          # ASCII code for newline character
      la $t4,buffer_read
   lb $t4,0($t4)
    sb $t4, 0($t3)      # store current character in buffer_write
    addi $t3, $t3, 1    # increment index for buffer_write

    beq $t4, $t0, end_of_line_check1   # if current character is newline, check end of line

    # Store current character in buffer_write
 

    j read_file_loop1    # continue reading characters from file
eof1:
li $s3,11111

end_of_line_check1:
    # Check if line matches the record to delete
   li $t4,'\0'
  sb $t4,0($t3)  
  
          la $t0, patientID    # load address of patient ID buffer
    la $t1, testLine     # load address of current line buffer

    # Compare patient ID
    li $t2, 0           # index for character comparison
    patient_id_loop1:
        lb $t4, 0($t0)      # load character from patient ID buffer
        lb $t5, 0($t1)      # load character from current line buffer
        beq $t5,':',compare
        beq $t4,'\n',compare
        beqz $t4, compare  # if end of patient ID, check test name
        beq $t4, $t5, patient_id_match_check1 # if characters match, continue comparing
        j read_test    # otherwise, characters don't match

    patient_id_match_check1:
        addi $t0, $t0, 1    # increment index for patient ID buffer
        addi $t1, $t1, 1    # increment index for current line buffer
        j patient_id_loop1   # continue comparing characters
compare:
    la $t1, testLine        # Load address of the test line
    addi $t1, $t1, 12      # Move to the start of the date in the line
# Print the test information

    # Compare test date with start date
    la $t2, startDate       # Load address of start date
    jal compare_dates       # Call compare_dates function
    move $s4, $v0           # Store comparison result in $t3
    la $t1, testLine        # Load address of the test line
    addi $t1, $t1, 12      # Move to the start of the date in the line
    # Compare test date with end date
    la $t2, endDate         # Load address of end date
    jal compare_dates       # Call compare_dates function
    move $t4, $v0           # Store comparison result in $t4

    # If test date is within the specified period, print the test information
    bne $s4, 1, read_con_check      # If test date is after or equal to start date

    bne $t4, 1, print_test_info   # If test date is before end date, exit loop
     beq $s3,11111,end_print_test

read_con_check:
     beq $s3,11111,end_print_test
    j read_test             # Continue reading next test

print_test_info:
    # Print the test information
    li $v0, 4               # System call for printing string
    la $a0, foundPrompt        # Load address of the test line
    syscall

    li $v0, 4               # System call for printing string
    la $a0, testLine        # Load address of the test line
    syscall
    
    li $v0, 4               # System call for printing string
    la $a0, newLine        # Load address of the test line
    syscall


    # Increment test counter
    addi $s5, $s5, 1
beq $s3,11111,end_print_test
    j read_test             # Continue reading next test

end_print_test:
    # Close the file
    li $v0, 16              # System call for close file
    move $a0, $s0           # File descriptor
    syscall
beqz $s5,notest
    j displayMenu           # Return to the main menu
notest:
    li $v0, 4               # System call for printing string
    la $a0, newLine        # Load address of the test line
    syscall
        li $v0, 4               # System call for printing string
    la $a0, noTestsFoundPrompt        # Load address of the test line
    syscall
    j displayMenu           # Return to the main menu


# Function to compare two dates
# Input: $t1 - Pointer to the first date string
#        $t2 - Pointer to the second date string
# Output: $v0 - 1 if the first date is after or equal to the second date, -1 if the first date is before the second date

compare_dates:
    # Extract year and month from the first date
    lb $t3, 0($t1)          # Load the first digit of the year
  
    lb $t4, 1($t1)          # Load the second digit of the year
    
    lb $t5, 2($t1)          # Load the third digit of the year
    lb $t6, 3($t1)          # Load the fourth digit of the year
    mul $t3, $t3, 1000      # Multiply thousands digit by 1000
    mul $t4, $t4, 100       # Multiply hundreds digit by 100
    mul $t5, $t5, 10        # Multiply tens digit by 10
    add $t3, $t3, $t4       # Add hundreds and thousands digits
    add $t3, $t3, $t5       # Add tens digit
    add $t3, $t3, $t6       # Add ones digit to get the year as integer
    move $s2,$t3
    


    lb $t7, 5($t1)          # Load the first digit of the month
    lb $t8, 6($t1)          # Load the second digit of the month
    mul $t7, $t7, 10        # Multiply tens digit by 10
    add $t7, $t7, $t8       # Add ones digit to get the month as integer
        move $s1,$t7
        
   

    # Extract year and month from the second date
    lb $t9, 0($t2)          # Load the first digit of the year
    lb $t8, 1($t2)         # Load the second digit of the year
    lb $t7, 2($t2)         # Load the third digit of the year
    lb $t6, 3($t2)         # Load the fourth digit of the year
    mul $t9, $t9, 1000      # Multiply thousands digit by 1000
    mul $t8, $t8, 100     # Multiply hundreds digit by 100
    mul $t7, $t7, 10      # Multiply tens digit by 10
    add $t9, $t9, $t6      # Add hundreds and thousands digits
    add $t9, $t9, $t8      # Add tens digit
    add $t9, $t9, $t7      # Add ones digit to get the year as integer

    lb $t7, 5($t2)         # Load the first digit of the month
    lb $t8, 6($t2)         # Load the second digit of the month
    mul $t7, $t7, 10      # Multiply tens digit by 10
    add $t7, $t7, $t8    # Add ones digit to get the month as integer

    # Compare years
    beq $s2, $t9, check_month    # If the first year is after or equal to the second year, check months
    bgt $s2, $t9,  date_after
    li $v0, -1              # If the first year is before the second year, return -1
    jr $ra                  # Return from function

check_month:
    # If the years are equal, compare months
    bge $s1, $t7, date_after   # If the first month is after or equal to the second month, return 1
    li $v0, -1              # If the first month is before the second month, return -1
    jr $ra                  # Return from function

date_after:
    li $v0, 1               # If the first date is after or equal to the second date, return 1
    jr $ra                  # Return from function


# Function to convert the string representation of a float to a float value
# Input: $a0 - Pointer to the string representation of the float
# Output: $v0 - Float value

convert_string_to_float:

jal convert_string_to_integer

mtc1 $v0,$f2

cvt.s.w $f2, $f2

addi $s0,$s0,1

move $a0,$s0

jal count_characters
move $s2,$v0
move $t0,$s0
li $s0,10
mtc1 $s0,$f1
cvt.s.w $f1, $f1  

move $s1,$s2
re1:

subi $s1,$s1,1
start1:
lb $t1, 0($t0)        #Get first digit of string
beq $t1,13,end2
beq $t1,10,end2
beqz $t1,end2
addi $t1,$t1,-48  #Convert from ASCII to digit
mtc1 $t1,$f0
cvt.s.w $f0, $f0

j div1
con:

add $t0,$t0,1
add.s $f2,$f2,$f0
j re1

div1:
sub $s3,$s2,$s1

loop_div:
beqz $s3,con
div.s $f0,$f0,$f1
sub $s3,$s3,1
j loop_div
end2:

mov.s $f12,$f2
beq $s6,1111,continue_avg_hgb
j continue_hgb_check

# Function to convert the string representation of an integer to an integer value
# Input: $a0 - Pointerr value
convert_string_to_integer:
  

   li $t3,0
   li $t4,9
   move $t0, $a0        #address of string
   lb $t1, 0($t0)        #Get first digit of string


   li $a0, 0            #accumulator

   addi $t1,$t1,-48  #Convert from ASCII to digit

   add $a0, $a0, $t1      #Accumulates
   addi $t0, $t0, 1      #Advance string pointer 
   lb $t1, 0($t0)        #Get next digit

buc1:   
  beq $t1, 10, endd #if $t1=10(linefeed) then print
   beq $t1,'\0',endd
   beq , $t1,46,endd
   beq , $t1,13,endd
   addi $t1,$t1,-48  #Convert from ASCII to digit
   mul $t2, $a0, 10  #Multiply by 10
   add $a0, $t2, $t1      #Accumulates
   addi $t0, $t0, 1      #Advance string pointer 
   lb $t1, 0($t0)        #Get next digit 
   b buc1


error:
   la $a0, msgerror
   li $v0, 4            #print eror
   syscall
  

endd:    
  move $v0,$a0
  move $s0,$t0
  
  
   jr $ra






deletet:
 # Function to delete a test record based on patient ID and test name
  # Prompt user to enter patient ID
    li $v0, 4           # syscall code for print_string
    la $a0, patientIDPrompt     # load address of patient ID prompt
    syscall

    # Read patient ID from user
    li $v0, 8           # syscall code for read_string
    la $a0, patientID    # buffer to store patient ID
    li $a1, 8        # buffer size
    syscall
       # Validate patient ID
    la $a0, patientID       # Load address of patient ID
    jal validatePatientID   # Call validatePatientID function
    beq $v0, 0, invalid_input_patient_id  # If patient ID is invalid, show error message


    # Prompt user to enter test name
    li $v0, 4           # syscall code for print_string
    la $a0,testNamePrompt     # load address of test name prompt
    syscall

    # Read test name from user
    li $v0, 8           # syscall code for read_string
    la $a0, testName     # buffer to store test name
    li $a1, 4        # buffer size
    syscall
        # Validate test name
    la $a0, testName        # Load address of test name
    jal validateTestName    # Call validateTestName function
    beq $v0, 0, invalid_input_test_name   # If test
     # Prompt user to enter test name
    li $v0, 4           # syscall code for print_string
    la $a0,testDatePrompt     # load address of test name prompt
    syscall

    # Read test name from user
    li $v0, 8           # syscall code for read_string
    la $a0, testDate     # buffer to store test name
    li $a1, 8        # buffer size
    syscall
    la $a0, testDate        # Load address of test date
    jal validateTestDate    # Call validateTestDate function
    beq $v0, 0, invalid_input_test_date   # If test date is invalid, show error message

    # Open the file for reading
    la $a0,testFileName  # load address of the file name
    li $a1, 0           # mode: read only
    li $v0, 13          # syscall code for open
    syscall

    # Check if file opened successfully
    bnez $v0, file_opened_read   # if file handle is not 0, file opened successfully
    j file_open_error   # otherwise, file open error

file_opened_read:
    move $s0, $v0       # save file handle in $s0

    # Open the file for writing
    la $a0, tempFile   # load address of temporary file name
    li $a1, 1           # mode: write only
    li $v0, 13          # syscall code for open
    syscall

    # Check if file opened successfully
    bnez $v0, file_opened_write   # if file handle is not 0, file opened successfully
    j file_open_error   # otherwise, file open error

file_opened_write:
    move $s1, $v0       # save file handle in $s1
     la $t3, buffer_write          # initialize index for buffer_write
re:
     la $t3, buffer_write          # initialize index for buffer_write

    # Read characters from the file
read_file_loop:
    # Read a character from the file
    li $v0, 14          # syscall code for read
    move $a0, $s0       # file handle for reading
    la $a1, buffer_read    # buffer address for reading
    li $a2, 1           # buffer size: read one character at a time
    syscall

    # Check if end of file reached
    move $s2,$v0
    beq $v0, $zero, end_of_line_check   # if return value is 0, end of file reached
 
    # Check if current character is newline

      la $t4,buffer_read
   lb $t4,0($t4)
    sb $t4, 0($t3)      # store current character in buffer_write
    addi $t3, $t3, 1    # increment index for buffer_write
    beq $t4, 10, end_of_line_check   # if current character is newline, check end of line


    # Store current character in buffer_write


    j read_file_loop    # continue reading characters from file

end_of_line_check:
    # Check if line matches the record to delete
   li $t4,'\0'
  sb $t4,0($t3)  

          la $t0, patientID    # load address of patient ID buffer
    la $t1, buffer_write     # load address of current line buffer
 
    # Compare patient ID
    li $t2, 0           # index for character comparison
    patient_id_loop:
        lb $t4, 0($t0)      # load character from patient ID buffer
        lb $t5, 0($t1)      # load character from current line buffer
         
        beq $t5,':',test_test_name_check
        beqz $t4, test_test_name_check   # if end of patient ID, check test name
        beq $t4, $t5, patient_id_match_check # if characters match, continue comparing
        j mismatch_check    # otherwise, characters don't match

    patient_id_match_check:
        addi $t0, $t0, 1    # increment index for patient ID buffer
        addi $t1, $t1, 1    # increment index for current line buffer
        j patient_id_loop   # continue comparing characters

    test_test_name_check:
        la $t0, testName   # load address of test name buffer
        addi $t1, $t1, 1    # increment index for current line buffer
    
     
        # Compare test name
        li $t2, 0           # index for character comparison
        test_name_loop:
            lb $t4, 0($t0)      # load character from test name buffer
            lb $t5, 0($t1)      # load character from current line buffer
            beq $t5,',',date_check
            beqz $t4, date_check   # if end of test name, match found
            beq $t4, $t5, test_name_match_check  # if characters match, continue comparing
            j mismatch_check    # otherwise, characters don't match

        test_name_match_check:
            addi $t0, $t0, 1    # increment index for test name buffer
            addi $t1, $t1, 1    # increment index for current line buffer
            j test_name_loop   # continue comparing characters


    date_check:
     
        la $t0, testDate  # load address of test name buffer
        addi $t1, $t1, 1    # increment index for current line buffer
        # Compare test name
        li $t2, 0           # index for character comparison
        test_date_loop:
            lb $t4, 0($t0)      # load character from test name buffer
            lb $t5, 0($t1)      # load character from current line buffer
            beq $t5,',',match_check
            beqz $t4, match_check   # if end of test name, match found
            beq $t4, $t5, test_date_match_check  # if characters match, continue comparing
            j mismatch_check    # otherwise, characters don't match

        test_date_match_check:
            addi $t0, $t0, 1    # increment index for test name buffer
            addi $t1, $t1, 1    # increment index for current line buffer
            j test_date_loop   # continue comparing characters


    match_check:
    add $s4,$s4,1
    beq $s2,$zero,end_of_file_read

     j re     # continue reading lines from file

    mismatch_check:
        # Write current line to temporary file

          la $a0, buffer_write    # load address of current line buffer
          jal count_characters

       
                    
        la $a1, buffer_write    # load address of current line buffer  
        move $a2,$v0
        move $a0, $s1       # file handle for writing
        li $v0, 15          # syscall code for write
        syscall
         beq $s2,$zero,end_of_file_read
        j re    # continue reading lines from file

end_of_file_read:
    # Close the file
    li $v0, 16          # syscall code for close
    move $a0, $s0       # file handle for reading
    syscall

    # Close the temporary file
    li $v0, 16          # syscall code for close
    move $a0, $s1       # file handle for writing
    syscall
    
        # Open the file for reading
    la $a0,tempFile  # load address of the file name
    li $a1, 0           # mode: read only
    li $v0, 13          # syscall code for open
    syscall
    move $s0,$v0
        # Open the file for reading
    la $a0,testFileName  # load address of the file name
    li $a1, 1           # mode: read only
    li $v0, 13          # syscall code for open
    syscall
    
        move $s1,$v0
read_write:    
   # Read a character from the file
    li $v0, 14          # syscall code for read
    move $a0, $s0       # file handle for reading
    la $a1, buffer_read    # buffer address for reading
    li $a2, 1           # buffer size: read one character at a time
    syscall

    # Check if end of file reached

    beq $v0, $zero, eof   # if return value is 0, end of file reached
 
    la $a1, buffer_read    # load address of current line buffer  
        move $a0, $s1       # file handle for writing
        li $a2,1
        li $v0, 15          # syscall code for write
        syscall
     
    j read_write    # continue reading characters from file   

eof:
    # Exit the function
       # Close the file
    li $v0, 16          # syscall code for close
    move $a0, $s0       # file handle for reading
    syscall

    # Close the temporary file
    li $v0, 16          # syscall code for close
    move $a0, $s1       # file handle for writing
    syscall
    li $v0,1
    beq $s7,111111,cont_upd
    beq $s4,0,displayMenu
     la $a0,newLine
     li $v0,4
     syscall

    la $a0,foundPrompt
     li $v0,4
     syscall

      la $a0,newLine
     li $v0,4
     syscall
     la $a0,delete
     li $v0,4
     syscall
      la $a0,newLine
     li $v0,4
     syscall
    j displayMenu

file_open_error:
    # Print file open error message
    li $v0, 4           # syscall code for print_string
    la $a0,invalidFilePrompt  # load address of file open error message
    syscall

    # Exit the function
    j displayMenu         # return to caller



# Function to count the number of characters in a null-terminated string
# Arguments:
#   $a0: address of the string
# Returns:
#   $v0: number of characters in the string
count_characters:
    # Initialize counter
    li $v0, 0           # Counter for characters

    count_loop:
        lb $t0, 0($a0)      # Load a character from the string
        beqz $t0, count_done   # If character is null, end of string reached

        addi $v0, $v0, 1    # Increment character count
        addi $a0, $a0, 1    # Move to the next character
        j count_loop        # Repeat the loop

    count_done:
        jr $ra              # Return to caller




calculateAverage:
  # Search for a test by patient ID
 
 
    # Open file for reading
    li $v0, 13              # System call for open file
    la $a0, testFileName    # Load address of file name
    li $a1, 0               # Open mode: read only
    li $a2, 0               # File permissions
    syscall
    move $s0, $v0           # Store file descriptor in $s0
    move $s5,$s0
    
    li $v0,4
    la $a0,testNamePrompt
    syscall


    li $v0,8
    la $a0,buffer_write
    li $a1,4
    syscall

 
    # Search for tests with matching patient ID
    li $t1, 0               # Counter for found tests

    mtc1 $t3,$f4
    cvt.s.w $f4, $f4
    li $s4,0

    
    
average:

     la $t3, testLine      # initialize index for buffer_write
     move $s0,$s5

read_file_loop4:
    # Read a character from the file
    li $v0, 14          # syscall code for read
    move $a0, $s0       # file handle for reading
    la $a1, buffer_read    # buffer address for reading
    li $a2, 1           # buffer size: read one character at a time
    syscall

    # Check if end of file reached

    beq $v0, $zero,eof5  # if return value is 0, end of file reached
 
    # Check if current character is newline
    li $t0, 10          # ASCII code for newline character
      la $t4,buffer_read
   lb $t4,0($t4)
    
    sb $t4, 0($t3)      # store current character in buffer_write
    addi $t3, $t3, 1    # increment index for buffer_write

    beq $t4, $t0, continue2   # if current character is newline, check end of line

    # Store current character in buffer_write

    j read_file_loop4   # continue reading characters from file
    # Check if end of file is reached


eof5:

li $s7,111111
   
continue2:
 
checkTestName:

la $t2, buffer_write
la $t3,HGB
jal strcmp
beqz $v0,HGB_avg
la $t2, buffer_write
la $t3,BGT
jal strcmp
beqz $v0,others_avg
la $t2, buffer_write
la $t3,BPT
jal strcmp
beqz $v0,others_avg
la $t2, buffer_write
la $t3,LDL
jal strcmp
beqz $v0,others_avg
j average


HGB_avg:
jal extract
la $a0,testResult
li $s6,1111
j convert_string_to_float

others_avg:
jal extract
la $a0,testResult
jal convert_string_to_integer
mtc1 $v0,$f5
cvt.s.w $f5,$f5
j continue_avg_other


continue_avg_hgb:
la $t2, testName
la $t3,buffer_write
jal strcmp
bnez $v0,check_end
add $s4,$s4,1
add.s $f4,$f4,$f12
beq $s7,111111,end_avg
j average

continue_avg_other:

la $t2, testName
la $t3,buffer_write
jal strcmp
bnez $v0,check_end
add.s $f4,$f4,$f5
add $s4,$s4,1
beq $s7,111111,end_avg
j average

check_end:
beq $s7,111111,end_avg
j average

end_avg:

 # Close the  file
    li $v0, 16          # syscall code for close
    move $a0, $s5     # file handle for writing
    syscall
        li $v0,4
    la $a0,newLine
    syscall
    
    li $v0,4
    la $a0,averageCa
    syscall
    
     li $v0,4
    la $a0,buffer_write
    syscall
    
     li $v0,4
    la $a0,newLine
    syscall
    
mtc1 $s4,$f7
cvt.s.w $f7,$f7
div.s $f4,$f4,$f7
mov.s $f12,$f4
li $v0,2
syscall
    li $v0,4
    la $a0,newLine
    syscall
j displayMenu

extract:
   la $t1,testLine

    addi $t1,$t1,20
    la $t4,testResult
 
 
start4:   
 
    lb $t6, ($t1)           # Load byte from the line
    beqz $t6, start_name1   # If end of line, exit loop
    beq $t6, '\n', start_name1   # If colon (separator), exit loop
    sb $t6, ($t4)           # Store byte in extracted patient ID buffer
    addi $t1, $t1, 1        # Move to next byte in the line
    addi $t4, $t4, 1        # Move to next byte in the extracted patient ID buffer
 
    j start4
start_name1:
    la $t1,testLine
    addi $t1,$t1,8
    la $t4,testName
start3:     
    lb $t6, ($t1)           # Load byte from the line
    beqz $t6, enddd  # If end of line, exit loop
    beq $t6, ',', enddd   # If colon (separator), exit loop
    sb $t6, ($t4)           # Store byte in extracted patient ID buffer
    addi $t1, $t1, 1        # Move to next byte in the line
    addi $t4, $t4, 1        # Move to next byte in the extracted patient ID buffer
 
    j start3   
enddd:
jr $ra

updateTest:
li $s7,111111
j deletet
cont_upd:

blt $s4,1, end_up
la $a0,patientIDNew
la $s1,testNameNew
la $a2,testDateNew
la $a3,testResultNew

j add_no_id
end_up:
la $a0,testNotFoundPrompt
li $v0,4
syscall
j displayMenu


# Function to compare two strings
# Input: $a0 - address of the first string
#        $a1 - address of the second string
# Output: $v0 - 0 if strings are equal, -1 otherwise
strcmp:
    strcmp_loop:
        lb $t0, ($t2)      # Load byte from first string
        lb $t1, ($t3)      # Load byte from second string
        beq $t0, $zero, strcmp_end   # If end of first string, exit loop
        beq $t1, $zero, strcmp_end   # If end of second string, exit loop
        bne $t0, $t1, strcmp_not_equal   # If bytes are not equal, strings are not equal
        addi $t2, $t2, 1  # Move to next byte in first string
        addi $t3, $t3, 1  # Move to next byte in second string
        j strcmp_loop      # Repeat loop
    strcmp_not_equal:
        li $v0, -1         # Set return value to -1 (strings are not equal)
        jr $ra             # Return from strcmp function
    strcmp_end:
        li $v0, 0          # Set return value to 0 (strings are equal)
        jr $ra             # Return from strcmp function
  
    
# Function to validate patient ID
# Input: $a0 - address of the string
# Output: $v0 - 0 if invalid, 1 if valid
validatePatientID:
    li $t0, 0             # Counter for number of digits
loop_patient_id:
    lb $t1, ($a0)         # Load byte from address
    beqz $t1, end_patient_id   # If end of string, exit loop
    li $t2, 10            # ASCII code for '0'
    blt $t1, $t2, invalid_patient_id   # If not a digit, invalid
    li $t2, 57            # ASCII code for '9'
    bgt $t1, $t2, invalid_patient_id   # If not a digit, invalid
    addi $a0, $a0, 1      # Move to next byte
    addi $t0, $t0, 1      # Increment digit counter
    b loop_patient_id     # Repeat loop
end_patient_id:
    li $v0, 0             # Default: invalid
    li $t2, 7             # Expected number of digits
    beq $t0, $t2, valid_patient_id   # If correct number of digits, valid
    jr $ra                # Return
invalid_patient_id:
    li $v0, 0             # Invalid
    jr $ra                # Return
valid_patient_id:
    li $v0, 1             # Valid
    jr $ra                # Return

# Function to validate test name
# Input: $a0 - address of the string
# Output: $v0 - 0 if invalid, 1 if valid
validateTestName:
    li $t0, 0             # Counter for number of letters
loop_test_name:
    lb $t1, ($a0)         # Load byte from address
    beqz $t1, end_test_name   # If end of string, exit loop
    li $t2, 65            # ASCII code for 'A'
    blt $t1, $t2, invalid_test_name   # If not a letter, invalid
    li $t2, 122           # ASCII code for 'z'
    bgt $t1, $t2, invalid_test_name   # If not a letter, invalid
    addi $a0, $a0, 1      # Move to next byte
    addi $t0, $t0, 1      # Increment letter counter
    b loop_test_name      # Repeat loop
end_test_name:
    li $v0, 0             # Default: invalid
    li $t2, 3             # Expected number of letters
    beq $t0, $t2, valid_test_name   # If correct number of letters, valid
    jr $ra                # Return
invalid_test_name:
    li $v0, 0             # Invalid
    jr $ra                # Return
valid_test_name:
    li $v0, 1             # Valid
    jr $ra                # Return

# Function to validate test date
# Input: $a0 - address of the string
# Output: $v0 - 0 if invalid, 1 if valid
validateTestDate:
    li $v0, 1               # Assume date is valid
    move $s1,$ra
    # Check if the string length is exactly 7 characters (YYYY-MM)
    move $t0, $a0        # Load address of the string
    li $t1, 0               # Initialize character count
    loop_date_length:
        lb $t2, ($t0)       # Load byte from address
        beqz $t2, end_date_length   # If end of string, exit loop
        addi $t0, $t0, 1    # Move to next byte
        addi $t1, $t1, 1    # Increment character count
        b loop_date_length  # Repeat loop
    end_date_length:
    li $t2, 7               # Expected length of date string
    
    bne $t1, $t2, invalid_date    # If length is not 7, date is invalid

    # Check if the first four characters are digits (YYYY)
    li $t1, 0               # Reset character count
    move $t0, $a0        # Load address of the string
    la $t3,year
    loop_year_digits:
        lb $t2, ($t0)       # Load byte from address

        blt $t2, 48, invalid_date  # If character is not a digit, date is invalid
        bgt $t2, 57, invalid_date
        sb $t2,0($t3)
        addi $t0, $t0, 1    # Move to next byte
        addi $t3, $t3, 1    # Move to next byte
        addi $t1, $t1, 1    # Increment character count
        blt $t1, 4, loop_year_digits  # Repeat loop for the first four characters

    # Check if the fifth character is a hyphen '-'
    la $a0,year
    move $s2,$t0
    jal convert_string_to_integer
 
    bgt $v0,2024,invalid_date
    blt $v0,2023,invalid_date
    move $t0,$s2
    lb $t2, ($t0)
    li $t3, 45              # ASCII code for '-'

    bne $t2, $t3, invalid_date   # If character is not a hyphen, date is invalid

    # Check if the next two characters are digits (MM)
    li $t1, 0               # Reset character count
    addi $t0, $t0, 1        # Move to the next character (after the hyphen)

    loop_month_digits:
        lb $t2, ($t0)       # Load byte from address
       
        beq $t1, 0, check_first  # If character is not a digit, date is invalid
        beq $t1, 1, check_second # If character is not a digit, date is invalid
        con2:

        addi $t0, $t0, 1    # Move to next byte     
        addi $t1, $t1, 1    # Increment character count
        bge $t1, 2, check_cont # Repeat loop for the next two characters
        j loop_month_digits
check_first:
move $s5,$t2
beq $t2,48,con2
beq $t2,49,con2
j invalid_date

check_second:
beq $s5,49,sec_check
blt $t2,49,invalid_date
bgt $t2,57,invalid_date
j con2

sec_check:
blt $t2,48,invalid_date
bgt $t2,50,invalid_date
j con2


check_cont:
    # Check if there's a null terminator at the end
    lb $t2, ($t0)
    beqz $t2, end_valid_date   # If end of string, date is valid
    j invalid_date          # If not, date is invalid

    end_valid_date:
    move $ra,$s1
    jr $ra                  # Return
    invalid_date:
    li $v0, 0               # Date is invalid
    move $ra,$s1
    jr $ra                  # Return

# Function to validate test result
# Input: $a0 - address of the string
# Output: $v0 - 0 if invalid, 1 if valid
validateTestResult:
    li $v0, 1               # Assume result is valid

    # Check if the string is empty
    lb $t0, ($a0)           # Load byte from address
    beqz $t0, invalid_result    # If empty string, result is invalid

    # Check if the string contains only digits and at most one decimal point
    li $t1, 46              # ASCII code for '.'
    li $t2, 0               # Counter for decimal points
    la $t3, 48              # ASCII code for '0'
    la $t4, 57              # ASCII code for '9'
    loop_check_digits:
        lb $t5, ($a0)       # Load byte from address
        beqz $t5, end_check_digits   # If end of string, exit loop
        beq $t5, $t1, check_decimal_point2   # If character is a decimal point, check
        blt $t5, $t3, invalid_result    # If character is not a digit, result is invalid
        bgt $t5, $t4, invalid_result
        
        addi $a0, $a0, 1    # Move to next character
        j loop_check_digits   # Continue checking digits
    check_decimal_point2:
        addi $t2, $t2, 1    # Increment decimal point counter
        bgt $t2, 1, invalid_result    # If more than one decimal point, result is invalid
        addi $a0, $a0, 1    # Move to next character
        j loop_check_digits   # Continue checking digits
    end_check_digits:
    jr $ra                 # Return

    invalid_result:
    li $v0, 0              # Result is invalid
    jr $ra                 # Return

printTests:

    # Open the file for writing
    la $a0, testFileName   # load address of temporary file name
    li $a1, 0           # mode: write only
    li $v0, 13          # syscall code for open
    syscall

 
file_read:
    move $s0, $v0       # save file handle in $s1

re3:
     la $t3, buffer_write          # initialize index for buffer_write

    # Read characters from the file
read_file_loop6:
    # Read a character from the file
    li $v0, 14          # syscall code for read
    move $a0, $s0       # file handle for reading
    la $a1, buffer_read    # buffer address for reading
    li $a2, 1           # buffer size: read one character at a time
    syscall

    # Check if end of file reached
    move $s2,$v0
    beq $v0, $zero, eof7   # if return value is 0, end of file reached
 
    # Check if current character is newline

      la $t4,buffer_read
   lb $t4,0($t4)
    sb $t4, 0($t3)      # store current character in buffer_write
    addi $t3, $t3, 1    # increment index for buffer_write
    beq $t4, 10,printLine  # if current character is newline, check end of line

    # Store current character in buffer_write

    j read_file_loop6    # continue reading characters from file

printLine:
li $v0,4
la $a0,buffer_write
syscall
j re3

eof7:
li $v0,4
la $a0,buffer_write
syscall
li $v0,16
move $a0,$s0
syscall
j displayMenu



allAbnormal:

 
    # Open file for reading
    li $v0, 13              # System call for open file
    la $a0, testFileName    # Load address of file name
    li $a1, 0               # Open mode: read only
    li $a2, 0               # File permissions
    syscall
    move $s0, $v0           # Store file descriptor in $s0
    move $s5,$s0
 
    # Search for tests with matching patient ID
    li $t5, 0               # Counter for found tests
search_loop_abnormal2:

     la $t3, testLine      # initialize index for buffer_write
     move $s0,$s5

read_file_loop22:
    # Read a character from the file
    li $v0, 14          # syscall code for read
    move $a0, $s0       # file handle for reading
    la $a1, buffer_read    # buffer address for reading
    li $a2, 1           # buffer size: read one character at a time
    syscall

    # Check if end of file reached
    move $s2,$v0
    beq $v0, $zero,eof8  # if return value is 0, end of file reached
 
    # Check if current character is newline

      la $t4,buffer_read
   lb $t4,0($t4)
       # Store current character in buffer_write
 
    sb $t4, 0($t3)      # store current character in buffer_write

    beq $t4, 10, continue5   # if current character is newline, check end of line
        addi $t3, $t3, 1    # increment index for buffer_write


    j read_file_loop22    # continue reading characters from file
    # Check if end of file is reached


eof8:
li $s7,111111
   
continue5:
  

jal extract
 
print3:    
 
    la $a0,testResult
    la $a1,testName
   li $s6,1111111
   j check_test_normal
continue_check2:

    beq $v0,0,print2 
    beq $s7,111111,end_search_abnormal2
    j search_loop_abnormal2
   
print4: 
    li $v0, 4               # System call for printing string
    la $a0, foundPrompt        # Load address of the line
    syscall
 
    li $v0, 4               # System call for printing string
    la $a0, testLine       # Load address of the line
    syscall
    addi $t5, $t5, 1        # Increment found tests counter
 
     li $v0, 4               # System call for printing string
    la $a0, newLine        # Load address of the line
    syscall
    beq  $s7,111111,end_search_abnormal2
    j search_loop_abnormal2          # Continue searching for more tests
 
end_search_abnormal2:
    # Close the file
    li $v0, 16              # System call for close file
    move $a0, $s0           # File descriptor
    syscall
 
    # If no tests found, display error message
    beqz $t5,no_tests_found_abnormal2
    j displayMenu
 
no_tests_found_abnormal2:
    li $v0, 4               # System call for printing string
    la $a0, testNotFoundPrompt # Load address of test not found prompt
    syscall
    j displayMenu
 
 








clearMemory:
# Clear the space allocated for 'test'
li $t0, 0          # Load 0 into register $t0
li $t3,0
move $t1,$a0
clear_loop:
    sb $t0, 0($t1)  # Store 0 into the memory location 'test' with offset $t1
    addi $t1, $t1, 1   # Increment the offset
    addi $t3,$t3,1
    blt $t3,$a1, clear_loop  # Continue looping until all bytes are cleared
    jr $ra


exitProgram:
    # Exit program
    li $v0, 10              # System call for exit
    syscall


