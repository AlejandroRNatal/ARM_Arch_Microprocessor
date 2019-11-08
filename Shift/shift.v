    /**
    This module takes the IR to find out which type of shift is to be done and 
    on what number it should be done.

    ASR 
    Arithmetic shift right by n bits moves the left-hand 32-n bits of the register Rm,
     to the right by n places, into the right-hand 32-n bits of the result. And it copies the original bit[31] 
     of the register into the left-hand n bits of the result

    LSR
    Logical shift right by n bits moves the left-hand 32-n bits of the register Rm, to the right by n places, 
    into the right-hand 32-n bits of the result. And it sets the left-hand n bits of the result to 0.
    
    LSL
    Logical shift left by n bits moves the right-hand 32-n bits of the register Rm, to the left by n places, into the left-hand 32-n bits of the result. 
    And it sets the right-hand n bits of the result to 0

    ROR
    Rotate right by n bits moves the left-hand 32-n bits of the register Rm, to the right by n places, into the right-hand 32-n bits of the result.
     And it moves the right-hand n bits of the register into the left-hand n bits of the result. 
    
    RRX
    Rotate right with extend moves the bits of the register Rm to the right by one bit. And it copies the carry flag into bit[31] of the result.
    
    **/
module shifter(output reg [31:0]O , input [31:0]IR , input [0:31]Rm)






endmodule