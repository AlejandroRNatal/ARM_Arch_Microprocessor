`define LSL 2'b00
`define LSR 2'b01
`define ASR 2'b01
`define ROR 2'b11;
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
    
    **/
module shifter(output reg [31:0]O ,output  reg C, input [31:0]IR , input [31:0]Rm);


    reg nBits ;
    reg [31:0]temp  =32'b0;

    always @* 
    begin  


        /**
            This switch case takes care of the shifts but do not take into account how 
            to decode the IR , that needs to be done beforehand 
        **/
        

        if(IR[27:25] == 3'b001)// 32 Imm shifther operand
        begin
            nBits <= 2*IR[11:8];
            temp[7:0] = IR[7:0];
            temp <=  (temp >> nBits );
            O <= temp;
            if(IR[20])C <= O[31]; 
        end

        if(IR[27:25] == 3'b000 || IR[27:25] == 3'b010) //deals with load/store too 
        begin //Shifth by imm shifther operand

            nBits = IR[11:7];
            
            case(IR[6:5]) 


            `ASR:
                begin
                O <= (Rm >>> nBits);
                end
            
            `LSR:
                begin
                    O <= Rm >> nBits;
                end
            `LSL:
                begin
                    O <= Rm >> nBits;
                end
            
            2'b11:
                begin
                    //Rm  = { }
                    O <= Rm >> nBits;
                end
            



            endcase
        end

   


    end
endmodule