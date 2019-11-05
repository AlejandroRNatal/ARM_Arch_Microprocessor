
`define START 6'b000000
`define FIRST 6'b000001
`define SECOND 6'b000010
`define MOC 6'b000011
`define CONDITIONAL 6'b000100
`define ARITH_OP_IMM 6'b000101
`define REG_REG 6'b000110
`define ARITH_OP_SHIFT 6'b000111
`define LD_IMM_OFFSET 6'b001000
`define LD_IMM_POST 6'b001001
`define LD_IMM_PRE 6'b001010
`define LD_IMM_REG_OFFSET 6'b001011
`define LD_IMM_REG_POST 6'b001100
`define LD_IMM_REG_PRE 6'b001101
`define LD_SCALED_OFFSET 6'b001110
`define LD_SCALED_POST 6'b001111
`define LD_SCALED_PRE 6'b010000

`define SEVENTEENTH 6'b010001
`define EIGHTEENTH 6'b010010
`define NINETEENTH 6'b010011
`define TWENTIETH 6'b010100
`define TWENTY_FIRST 6'b010101
`define TWENTY_SECOND 6'b010110
`define TWENTY_THIRD 6'b010111
`define TWENTY_FOURTH 6'b011000
`define TWENTY_FIFTH 6'b011001

`define STR_IMM_OFFSET 6'b011010
`define STR_IMM_POST 6'b011011
`define STR_IMM_PRE 6'b011100
`define STR_REG_OFFSET 6'b011101
`define STR_REG_POST 6'b011110
`define STR_REG_PRE 6'b011111

`define STR_SCALED_OFFSET 6'b100000
`define STR_SCALED_POST 6'b100001
`define STR_SCALED_PRE 6'b100010

`define THIRTY_FIFTH 6'b100011
`define THIRTY_SIXTH 6'b100100
`define THIRTY_SEVENTH 6'b100101
`define THIRTY_EIGHTH 6'b100110
`define THIRTY_NINTH 6'b100111

`define FORTIETH 6'b101000
`define FORTY_FIRST 6'b101001
`define FORTY_SECOND 6'b101010
`define FORTY_THIRD 6'b101011
`define BRANCH 6'b101100
`define MOV 6'b101101
`define CMP 6'b101110

module ControlUnit(output[2:0]State, output CM1, CM0,SM1, SM0,
                    Ld, First, Last, input Done, Reset, Clk);

wire[2:0] NextState;
reg Cond;//This might be wrong

NextStateDecoder NSD(NextState, State, Done, Cond);
ControlSignalsEncoder CSE(CM1, CM0, SM1, SM0, Ld, First, Last, State, Done);
StateReg Register(State, NextState, Reset, Clk);

endmodule

module NextStateDecoder(output reg [5:0] NextState,
                         input[5:0] State, input[31:0] IR, input Done, Cond);

    always@(State, Done)

    case(State)

        START: begin NextState = FIRST;break;end

        FIRST: begin NextState = SECOND;break;end

        SECOND: begin NextState = THIRD;break;end

        MOC: begin if(Done) NextState = COND;break;
                else NextState = MOC;break;
             end
        CONDITIONAL:
            begin
             if(Cond)
                //Distinguish between arith, store, load
                if(IR[27:25] == 3'b010)//Load, store

                    if(IR[20] = 1'b0)//load
                        if(IR[23] == 1'b0)// u = 0 -> suma else resta
                        if(IR[24]== 1'b0)//p == 0 POST
                        else//offset
                    else//store

                        if(IR[23] == 1'b1)// u == 1 -> sum
                            if(IR[24] == 1'b0)//p =0 ->27
                            else if(IR[24] == 1'b0) && IR[21])// -> 28th state
                            else //offset -> 26
                case(IR)
                 NextState = COND;
                 endcase
                 break;
                else NextState = COND;break;
            end
        ARITH_OP_IMM:
            begin
                NextState = FIRST;
                break;
            end
        REG_REG:
             begin
                NextState = FIRST;
                break;
            end
        ARITH_OP_SHIFT:
           begin
                NextState = FIRST;
                break;
            end
        LD_IMM_OFFSET:
            begin
             NextState = SEVENTEENTH;
             end
        LD_IMM_POST:
            begin
               NextState = SEVENTEENTH;
            end
        LD_IMM_PRE:
            begin
             NextState = SEVENTEENTH;
            end
        LD_IMM_REG_OFFSET:  begin
             NextState = SEVENTEENTH;
            end
        LD_IMM_REG_POST:   begin
             NextState = SEVENTEENTH;
            end
        LD_IMM_REG_PRE:
          begin
             NextState = SEVENTEENTH;
            end
        LD_SCALED_OFFSET:
          begin
             NextState = SEVENTEENTH;
            end
        LD_SCALED_POST:
          begin
             NextState = SEVENTEENTH;
            end
        LD_SCALED_PRE:  begin
             NextState = SEVENTEENTH;
            end

        SEVENTEENTH:
        begin
             NextState = EIGHTEENTH;
            break;
        end

        EIGHTEENTH:
         begin
             NextState = 6'b000000;
              break;
         end

        NINETEENTH: begin NextState = 6'b000000; break; end

        TWENTIETH:begin NextState = FIRST;break; end
        TWENTY_FIRST:begin NextState = FIRST; break; end
        TWENTY_SECOND: begin NextState = FIRST; break; end
        TWENTY_THIRD:begin NextState =FIRST; break; end
        TWENTY_FOURTH:begin NextState = FIRST break; end
        TWENTY_FIFTH:begin NextState = FIRST; break; end

        STR_IMM_OFFSET:
        begin
            NextState = THIRTY_FIFTH;
            break;
        end
        
        STR_IMM_POST:
        begin
            NextState = THIRTY_FIFTH;
            break;
        end
        
        STR_IMM_PRE:
        begin
            NextState = THIRTY_FIFTH;
            break;
        end

        STR_REG_OFFSET:
        begin
            NextState = THIRTY_FIFTH;
            break;
        end

        STR_REG_POST:
        begin
            NextState = THIRTY_FIFTH;
            break;
        end

        STR_REG_PRE:
        begin
            NextState = THIRTY_FIFTH;
            break;
        end

        STR_SCALED_OFFSET:
        begin
            NextState = THIRTY_FIFTH;
            break;
        end

        STR_SCALED_POST:
        begin
            NextState = THIRTY_FIFTH;
            break;
        end

        STR_SCALED_PRE:
            begin
                NextState = THIRTY_FIFTH;
                break;
            end

        THIRTY_FIFTH:
            begin
                 NextState = THIRTY_SIXTH;
                 break;
            end

        THIRTY_SIXTH:begin  NextState = THIRTY_SEVENTH; break;end
        
        //NEED TO ADD LOGIC HERE
        THIRTY_SEVENTH:begin  if(!MOC)THIRTY_SEVENTH;break; end


        THIRTY_EIGHTH:begin NextState = FIRST; break;end
        THIRTY_NINTH:begin NextState = FIRST;break; end

        FORTIETH:begin NextState = FIRST;break;end
        FORTY_FIRST:begin NextState = FIRST;break;end
        FORTY_SECOND:begin NextState = FIRST;break;end
        FORTY_THIRD:begin NextState = FIRST;break;end
        BRANCH:begin NextState = FIRST; break;end
        MOV:begin NextState = FIRST;break; end
        CMP: begin NextState = FIRST;break; end


        default:begin  NextState = 3'b000;break; end

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

module StateReg(output reg[5:0]State,
                input[5:0] NextState,
                          input Clr, Clk);

    always @(posedge Clk, negedge Clr)

    if(!Clr)
       State <= 6'b000000;

    else
       State <= NextState;
    
endmodule

module CU_tester;

    reg Done, Reset, Clk, Cond;
    wire[5:0] State;
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