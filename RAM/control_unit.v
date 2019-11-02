




module ControlUnit(output[2:0]State, output CM1, CM0,SM1, SM0,
                    Ld, First, Last, input Done, Reset, Clk);

wire[2:0] NextState;

NextStateDecoder NSD(NextState, State, Done);
ControlSignalsEncoder CSE(CM1, CM0, SM1, SM0, Ld, First, Last, State, Done);
StateReg Register(State, NextState, Reset, Clk);

endmodule

module NextStateDecoder(output reg [2:0] NextState,
                         input[2:0] State, input Done);

    always@(State, Done)

    case(State)
        3'b000: NextState = 3'b001;
        3'b001: NextState = 3'b010;
        3'b010: NextState = 3'b011;
        3'b011: if(Done) NextState = 3'b100;
                else NextState = 3'b011;
        3'b100: NextState = 3'b000;
        default: NextState = 3'b000;

    endcase

endmodule


module ControlSignalsEncoder( output reg CM1, CM0, SM1, SM0, Ld, First, Last,
        input [2:0]State, input Done);

    always@(State, Done)

    case(State)
        3'b000: begin
                    CM1 = 1;
                    CM0 = 1;
                    Ld = 0;
                    SM1 <=0;
                    SM0 = 0;

                    First = 0;
                    Last = 0;
                end

        3'b001: begin
                    CM1 = 0;
                    CM0 = 0;
                    Ld = 1;
                    SM1 =1;
                    SM0 = 0;
                end

        3'b010: begin
                    CM0 = 0;
                    CM1 = 1;
                    SM1 =0;
                    SM0 = 1;

                    First = 1;
                end

        3'b011: begin
                    First = 0;
                    if(Done) Last = 1;
                end

        3'b100: begin
                    CM1= 0;
                    SM0 = 0;
                    Last = 0;
                end

        default:
                begin
                    CM1 = 0;
                    CM0 = 0
                    SM1=0;
                    SM0 =0;
                    Ld=1;
                    First = 0;
                    Last = 0;
                end
    endcase

endmodule

module StateReg(output reg[2:0]State,
                input[2:0] NextState,
                          input Clr, Clk);

    always @(posedge Clk, negedge Clr)

    if(!Clr)
       State <= 3'b000;

    else
       State <= NextState;
    
endmodule

module CU_tester;

    reg Done, Reset, Clk;
    wire[2:0] State;
    wire CM0, CM1, SM1, SM0, Ld, First, Last;

    ControlUnit CU (State, CM1, CM0, SM1, SM0, Ld, First, Last, Done, Reset, Clk);

    initial #100 $finish;

    initial begin
        Clk = 1'b0;
        repeat(100) #5 Clk = ~Clk;
    end

    initial fork
        Reset = 1'b0;
        #3 Reset = 1'b1;
        #80 Reset = 1'b0;
        #83 Reset = 1'b1;

        Done = 1'b0;
        #50 Done = 1'b1;
        #60 Done = 1'b0;
    join

        initial begin
            $display("State CM1 CM0 SM1 SM0 Ld First Last Done Reset     Time");
            $monitor("%d  %b %b %b %b %b %b %b %b %b %d",
                    State, CM1, CM0, SM1, SM0, Ld, First, Last, Done, Reset, $time);
        end

endmodule