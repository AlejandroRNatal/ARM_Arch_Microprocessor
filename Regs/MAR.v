module MAR(input[31:0]Ds , input Ld , Clk , output reg[31:0]Qs);

    always @(posedge Clk , Ld)
    begin
        Qs <= Ds;
    end


endmodule