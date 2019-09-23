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
        A <= 32'hFFFFFFF0;
        B <= 32'hF;

        OP <= 4'd0;



        #10
        begin
    
  

            OP <= 4'd4;
            A<= 32'd10;
            B<=32'd15;

        end

        #15

        begin
           
            OP<=4'd7;
            A<=32'h6;
            B<=32'h8;
        end

        #20
        begin
            
            OP<=4'd7;
            A<=32'hFFFFFFF0;
            B<=32'hFFFFFFFF;
        end


        #25

        begin
            OP <= 4'd4;
            A<= 32'hFFFF;
            B<=32'hFFFF;

        end

    end

    initial begin 
        $display("  N        V          Z          Co                    A                   B                    Y                    YBin");
        $monitor("  %b   |    %b    |     %b     |    %b     |     %d    |    %d     |    %d         |     %b      ",N,V,Z,Co,A,B,Y,Y);
        
    end


endmodule