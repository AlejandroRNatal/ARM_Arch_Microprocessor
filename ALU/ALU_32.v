
module ALU(output reg N, Z, V, Cout,  output reg  [0:31]O, input Cin , input  [0:31]A, B , input [0:3]OP);

  reg og_sign , shouldbe_sign ,ovfl_sign;

  always @* 
  begin 
  case (OP)

    //Logic Ops

    4'b0000:  // Logic And 
      begin
         O <= A && B; 
      end

    4'b0001: //Bit by bit And
      begin
        O <= A & B;
        
      end
    
    4'b0010: //Logic OR
      begin
         O <= A || B ; 
        
      end

    4'b0011: //Logic OR Bit by BIt
      begin
         O <= A | B ; 
        
      end

    4'b0101: //xor
      begin
         O <= A^B;
      end

    4'b0110:
      begin // bit bit xor
         O <= A^^B;
      end


    //Arithmetic OPs
    4'b0111: //Sum 
      begin
         {Cout ,O }  <= A  +  B ; 
      end

    4'b1000: //SUB CMP
      begin
        {Cout , O} <= {1'b0,A} - {1'b0,B};
      end
    
    4'b1001: //sum with carry
    begin
     {Cout , O} <=  (Cin == 1) ? (A + B + 1):(A+B); 
    end

    4'b1010:
    begin //sub over carry 
      {Cout , O} <= (Cin == 1) ? ({1'b0,A} - {1'b0,B} - {32'h1}) : ({1'b0,A} - {1'b0,B});
    end
    


    default:  O <= A;
  endcase

  Z = ( O == 32'b0) ? 1:0;
  
  // N = (O[0] === 1'b1)? 1:0;



  begin
      og_sign <= (A[0]);
      
      shouldbe_sign<=
          (((OP==4'b1010 || OP == 4'b1000)&&(A[0] != B[0]))//if a sub between different signs 
          ||((OP==4'b1001 || OP==4'b0111)&&(A[0] == B[0]))); // if sum and both signs are the same 
          
      ovfl_sign<=(((OP==4'b1010 || OP == 4'b1000)&&(A[0] != B[0]))
          ||((OP==4'b1001 || OP==4'b0111)&&(A[0] == B[0])) );
  end

  N = O[0] ^ ((shouldbe_sign)&&(og_sign != O[0]));
  V = (ovfl_sign)&&(og_sign != O[0]);
end

endmodule