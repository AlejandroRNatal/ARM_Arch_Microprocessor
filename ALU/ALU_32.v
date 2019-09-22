
module ALU(output reg N, Z, V, Cout,  output reg signed [0:31]O, input Cin , input signed [0:31]A, B , input [0:3]OP);

  reg pre_sign , keep_sgn_on_ovfl ,set_ovfl;

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
      {Cout , O} <= Cin + A + B;
    end

    


    default:  O <= A;
  endcase

  Z = ( O == 32'b0) ? 1:0;
  
  // N = (O[0] === 1'b1)? 1:0;



  begin
      pre_sign <= (A[31]);
      keep_sgn_on_ovfl<=
          (((OP==4'd7)&&(A[31] != B[31]))//SUB&CMP
          ||((OP==4'd4)&&(A[31] == B[31]))); // ADD
          
      set_ovfl<=(((OP==4'd7)&&(A[0] != B[0]))//SUB&CMP
          ||((OP==4'd4)&&(A[0] == B[0])) );
      
  end

  N = O[31] ^ ((keep_sgn_on_ovfl)&&(pre_sign != O[31]));
  V = (set_ovfl)&&(pre_sign != O[0]);
end

endmodule
