
module ALU(output reg N, Z, V, Cout,  output reg  [31:0]O, input Cin , input  [31:0]A, B , input [4:0]OP);

  reg og_sign , shouldbe_sign ,ovfl_sign,flagUpdate;
  
  always @* 
  begin 
  case (OP)

    5'b00000:  // And
      begin
        O <= A && B;
      end
    
    5'b00001: //Xor
      begin
        O <= A^^B; 
      end
    
    5'b00010: // A - B
      begin
        {Cout , O} <= {1'b0,A} - {1'b0,B};
      end

    5'b00011: // B - A
      begin
        {Cout , O} <= {1'b0,B} - {1'b0,A};
      end
    
    5'b00100: // A + B
      begin
        {Cout , O }  <= A  +  B ;
      end

    5'b00101: // A + B + Cin
      begin
        {Cout , O} <=  (Cin == 1) ? (A + B + 1):(A+B); 
      end

    5'b00110: // A - B - (not Cin)
      begin
        {Cout , O} <= (Cin == 1) ? ({1'b0,A} - {1'b0,B} - {32'h1}) : ({1'b0,A} - {1'b0,B});
      end

    5'b00111:  //B - A - ( not Cin)
      begin
        {Cout , O} <= (Cin == 1) ? ({1'b0,B} - {1'b0,A} - {32'h1}) : ({1'b0,B} - {1'b0,A});
      end
    
    5'b01000:  // And
      begin
        flagUpdate <= 1'b1;
        O <= A && B;
      end
    
    5'b01001: //Xor
      begin
        flagUpdate <= 1'b1;
        O <= A^^B; 
      end
    
    5'b01010: // A - B
      begin
        flagUpdate <= 1'b1;
        {Cout , O} <= {1'b0,A} - {1'b0,B};
      end

    5'b01011: // B - A
      begin
        flagUpdate <= 1'b1;
        {Cout , O} <= {1'b0,B} - {1'b0,A};
      end
    
    5'b01100: // A + B
      begin
        flagUpdate <= 1'b1;
        {Cout , O }  <= A  +  B ;
      end

    5'b01101: // A + B + Cin
      begin
        flagUpdate <= 1'b1;
        {Cout , O} <=  (Cin == 1) ? (A + B + 1):(A+B); 
      end

    5'b01110: // A - B - (not Cin)
      begin
        flagUpdate <= 1'b1;
        {Cout , O} <= (Cin == 1) ? ({1'b0,A} - {1'b0,B} - {32'h1}) : ({1'b0,A} - {1'b0,B});
      end

    5'b01111:  //B - A - ( not Cin)
      begin
        flagUpdate <= 1'b1;
        {Cout , O} <= (Cin == 1) ? ({1'b0,B} - {1'b0,A} - {32'h1}) : ({1'b0,B} - {1'b0,A});
      end

    5'b01100: // OR
      begin
        O <= A || B ;
      end
    
    5'b01101: //Return B
      begin
        O <= B;
      end
    
    5'b01110: // A and ( not B)
      begin
        O <= A && ~B;
      end
    
    5'b01111: //not B
      begin
        O <= ~B;
      end
    
    5'b10000: //return A
      begin
        O <= A;
      end
    
    5'b10000: //return A + 4
      begin
        {Cout , O } <= A + 32'd4;
      end
   
    5'b10000: //return A + B + 4
      begin
        {Cout , O }<= A + B + 32'd4;
      end

    
  endcase


  if(flagUpdate)
    begin
      Z = ( O == 32'b0) ? 1:0;
      
      N = (O[0] === 1'b1)? 1:0;



      begin
          og_sign <= (A[0]);
          
          // shouldbe_sign<=
          //     (((OP==4'b1010 || OP == 4'b1000)&&(A[0] != B[0]))//if a sub between different signs 
          //     ||((OP==4'b1001 || OP==4'b0111)&&(A[0] == B[0]))); // if sum and both signs are the same 
              
          ovfl_sign<=(((OP==4'b1010 || OP == 4'b1000)&&(A[0] != B[0]))
              ||((OP==4'b1001 || OP==4'b0111)&&(A[0] == B[0])) );
      end

    // N = O[0] ^ ((shouldbe_sign)&&(og_sign != O[0]));
       V = (ovfl_sign)&&(og_sign != O[0]);
    end
end

endmodule