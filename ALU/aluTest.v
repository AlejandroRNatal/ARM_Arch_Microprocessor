`include "ALU_32.v"

module alutest;
    wire signed [0:31] Y; 
    wire N , V , Z , Co;

    reg Ci;

    reg [0:3]OP;
    reg signed [0:31] A , B;

    parameter sim_time  = 1000;

    ALU myAlu (N , Z , V , Co , Y , Ci , A , B , OP);

    initial #sim_time $finish;     // Especifica cuando termina simulación
    
    initial begin
        
        #5
        begin
            $display("--------------------------------------------------------");
            $display("---------------Logical Operations-----------------------");
            $display("--------------------------------------------------------");
            $display("OPCODE    N        V          Z          Co                    A                   B                 Cin                              Y                    YBin");
        
            A <= 32'b0001010100101;
            B <= 32'b0101001110001;
            OP <= 4'b0000;
            repeat (6) #5 OP<= OP+1;
    
        end
        
        #35begin
            OP<=OP +1;
            $display("--------------------------------------------------------");
            $display("---------------Arthmetic Operations No OVFl-------------");
            $display("--------------------------------------------------------");
            $display("OPCODE    N        V          Z          Co                    A                   B                 Cin                              Y                    YBin");
            Ci<=1;

            repeat (3) #5 OP <= OP +1;
        end


        #55begin
            OP<=4'b0111;
            $display("--------------------------------------------------------");
            $display("---------------OVERFLOW---------------------------------");
            $display("--------------------------------------------------------");
            $display("OPCODE    N        V          Z          Co                    A                   B                 Cin                              Y                    YBin");
            
            A<= 32'h7FFFFFFF;
            B<= 32'h70000000;
            repeat (1) #5 OP <= 4'b1001;
        end

        #65begin
            OP<=4'b1000;
            A<=32'h80000000; //max negative 
            B<=32'h1; 

            repeat(1) #5 OP<= 4'b1010;
        end

    end

    initial begin 
       // $display("OPCODE    N        V          Z          Co                    A                   B                 Cin                              Y                    YBin");
       #5$monitor("%b      %b   |    %b    |     %b     |    %b     |     %d    |    %d            |    %d            |         %d         |    %b      ",OP , N,V,Z,Co,A,B,Ci,Y,Y);

    end


endmodule