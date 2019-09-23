
module ALU(output reg N, Z, V, Cout,  output reg  [0:31]O, input Cin , input  [0:31]A, B , input [0:3]OP);

  reg og_sign , shouldbe_sign ,ovfl_sign;

  always @* 
  begin 
  case (OP)
    4'd0:  // Logic And 
      begin
         O <= A && B; 
      end

    4'd1: //Bit by bit And
      begin
        O <= A & B;
        
      end
    
    4'd2: //Logic OR
      begin
         O <= A || B ; 
        
      end

    4'd3: //Logic OR Bit by BIt
      begin
         O <= A | B ; 
        
      end

    4'd4: //Sum 
      begin
         {Cout ,O }  <= A  +  B ; 
      end

    4'd5: //xor
      begin
         O <= A^B;
      end

    4'd6:
      begin // bit bit xor
         O <= A^^B;
      end

    4'd7: //SUB CMP
      begin
        {Cout , O} <= {1'b0,A} - {1'b0,B};
      end
    
    4'd8: //sum with carry
    begin
     {Cout , O} <=  (Cin == 1) ? (A + B + 1):(A+B); 
    end

    4'd9:
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
          (((OP==4'd7 || OP == 4'd9)&&(A[0] != B[0]))//if a sub between different signs 
          ||((OP==4'd4 || OP==4'd8)&&(A[0] == B[0]))); // if sum and both signs are the same 
          
      ovfl_sign<=(((OP==4'd7 || OP == 4'd9)&&(A[0] != B[0]))
          ||((OP==4'd4 ||OP ==4'd8)&&(A[0] == B[0])) );
  end

  N = O[0] ^ ((shouldbe_sign)&&(og_sign != O[0]));
  V = (ovfl_sign)&&(og_sign != O[0]);
end

endmodule