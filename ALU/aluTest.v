
module alutest;
    wire signed [0:31] Y; 
    wire N , V , Z , Co;

    reg Ci;

    reg [4:0]OP;
    reg signed [31:0] A , B;

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


// module ALU(output reg N, Z, V, Cout,  output reg  [0:31]O, input Cin , input  [0:31]A, B , input [0:3]OP);

//   reg og_sign , shouldbe_sign ,ovfl_sign;

//   always @* 
//   begin 
//   case (OP)

//     //Logic Ops

//     4'b0000:  // Logic And 
//       begin
//          O <= A && B; 
//       end

//     4'b0001: //Bit by bit And
//       begin
//         O <= A & B;
        
//       end
    
//     4'b0010: //Logic OR
//       begin
//          O <= A || B ; 
        
//       end

//     4'b0011: //Logic OR Bit by BIt
//       begin
//          O <= A | B ; 
        
//       end

//     4'b0101: //xor
//       begin
//          O <= A^B;
//       end

//     4'b0110:
//       begin // bit bit xor
//          O <= A^^B;
//       end


//     //Arithmetic OPs
//     4'b0111: //Sum 
//       begin
//          {Cout ,O }  <= A  +  B ; 
//       end

//     4'b1000: //SUB CMP
//       begin
//         {Cout , O} <= {1'b0,A} - {1'b0,B};
//       end
    
//     4'b1001: //sum with carry
//     begin
//      {Cout , O} <=  (Cin == 1) ? (A + B + 1):(A+B); 
//     end

//     4'b1010:
//     begin //sub over carry 
//       {Cout , O} <= (Cin == 1) ? ({1'b0,A} - {1'b0,B} - {32'h1}) : ({1'b0,A} - {1'b0,B});
//     end
    


//     default:  O <= A;
//   endcase

//   Z = ( O == 32'b0) ? 1:0;
  
//   // N = (O[0] === 1'b1)? 1:0;



//   begin
//       og_sign <= (A[0]);
      
//       shouldbe_sign<=
//           (((OP==4'b1010 || OP == 4'b1000)&&(A[0] != B[0]))//if a sub between different signs 
//           ||((OP==4'b1001 || OP==4'b0111)&&(A[0] == B[0]))); // if sum and both signs are the same 
          
//       ovfl_sign<=(((OP==4'b1010 || OP == 4'b1000)&&(A[0] != B[0]))
//           ||((OP==4'b1001 || OP==4'b0111)&&(A[0] == B[0])) );
//   end

//   N = O[0] ^ ((shouldbe_sign)&&(og_sign != O[0]));
//   V = (ovfl_sign)&&(og_sign != O[0]);
// end

// endmodule