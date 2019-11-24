module ConditionTester(input  N , Z , V , C , input[3:0] Condition , output reg Cond);
    always @*

    case(Condition)

        4'd0:
            begin 
                Cond <= (Z == 1 ) ? 1:0;
            end
        
        4'd1:
            begin
              Cond <= (Z == 0) ? 1:0;
            end
        
        4'd2:
            begin
                Cond <= (C == 1) ? 1:0;
            end
        
        4'd3:
            begin
                Cond <= (C == 0) ? 1:0;
            end

        4'd4:
            begin
                Cond <= (N == 1) ? 1:0;
            end

        4'd5:
            begin
                Cond <= (N == 0) ? 1:0;
            end

        4'd6:
            begin
                Cond <= (V ==  1) ? 1:0;
            end
       
        4'd7:
            begin
                Cond <= (V == 0) ? 1:0;
            end
        
        4'd8:
            begin
                Cond <= (C == 1 & Z == 0) ? 1:0;
            end
        
        4'd9:
            begin
                Cond <= (C == 0 & Z == 1) ? 1:0;
            end
        
        4'd10:
            begin
              Cond <= (N == V )? 1:0;
            end

        4'd11:
            begin
              Cond <= (N != V )? 1:0;
            end
        
        4'd12:
            begin
              Cond <= ((Z == 0) || (N == V))? 1:0;
            end

        4'd13:
            begin
              Cond <= ((Z == 1) || (N != V))? 1:0;
            end

        4'd14:
            begin
              Cond <= 1;
            end
        
        4'd15:
            begin
              //TODO
            end

    endcase

endmodule