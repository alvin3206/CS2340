HW#3 - due on 3/4
Write and test a MIPS assembly language program that

1. Prompts the user for a machine code of a MIPS instruction, i.e. a 32-bit binary represented in hexadecimal. Obviously, the input must be a string of 8 hexadecimal digits (the prefix '0x' is not required.)   

    1.a If the input was an empty string exit the program.

2. Checks for the validity of the input and print an error message if an invalid string was inputted (e.g. too long, too short, contain invalid characters, etc..). The error message should tell the user the cause of the error.

3. Checks if the opcode of the instruction is one of the following:

  a. Arithmetic and logical (i.e. the opcode is 0)

  b. Data transfer (lw and sw only)

If it is print out the opcode in decimal.

4. If the opcode was not one of those prints out a message telling the user that the opcode was not recognized.

5. Go back to step 1.

Run the program and test the inputs for at least one valid instruction for each instruction category listed above, and a few invalid input strings.

Refer to the syllabus for submission requirements for MIPS programming assignments.

IMPORTANT: this assignment requires serious effort, so you should start working on this assignment as soon as possible.

Here is the link to a video clip that may help you:

https://web.microsoftstream.com/video/4f247388-5711-4d1b-9b2b-81301ed2eec4
