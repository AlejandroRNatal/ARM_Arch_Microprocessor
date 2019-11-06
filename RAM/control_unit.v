
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

module ControlUnit(output[2:0]State, output FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0, input Moc, Cond, Done, Reset, Clk);

wire[5:0] NextState;
//reg Cond, Moc;//This might be wrong

NextStateDecoder NSD(NextState, State, Done, Cond. Moc);
ControlSignalsEncoder CSE(FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0, State , Done);//MIGHT BE NEXTSTATE HERE NOT SURE
StateReg Register(State, NextState, Reset, Clk);

endmodule

module NextStateDecoder(output reg [5:0] NextState,
                         input[5:0] State, input[31:0] IR, input Done, Cond ,Moc);

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
                                NextState = LD_IMM_PRE;//TODO FIX THIS
                            if(IR[24]== 1'b0)//p == 0 POST
                                NestState = LD_IMM_POST;
                            else//offset
                                NextState = LD_IMM_OFFSET;
                        else//store

                            if(IR[23] == 1'b1)// u == 1 -> sum
                                if(IR[24] == 1'b0)//p =0 ->27
                                    NextState = STR_IMM_POST;
                                else if(IR[24] == 1'b0) && IR[21])// -> 28th state
                                    NextState = STR_IMM_PRE;
                                else //offset -> 26
                                    NextState = STR_IMM_OFFSET;
                
                else
                    NextState = COND;
                
                break;
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
            if(!Moc)
                NextState = EIGHTEENTH;
                break;
            else
                NextState = NINETEENTH;
            break;
         end

        NINETEENTH:
            begin

                    if(IR[27:25] == 3'b010)//Load, store

                        if(IR[20] = 1'b0)//load
                            if(IR[23] == 1'b0)// u = 0 -> suma else resta
                                NextState = LD_IMM_PRE;//TODO FIX THIS
                            if(IR[24]== 1'b0)//p == 0 POST
                                NestState = LD_IMM_POST;
                            else//offset
                                NextState = LD_IMM_OFFSET;
                        else//store

                            if(IR[23] == 1'b1)// u == 1 -> sum
                                if(IR[24] == 1'b0)//p =0 ->27
                                    NextState = LD_IMM_REG_POST;
                                else if(IR[24] == 1'b0) && IR[21])// -> 28th state
                                    NextState = LD_IMM_PRE;
                                else //offset -> 26
                                    NextState = LD_SCALED_OFFSET;
                break;
            end
        



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
        THIRTY_SEVENTH:
            begin
                  if(!Moc)
                    THIRTY_SEVENTH;
                    break;
                  else
                    //BRANCH here
                    if(IR[27:25] == 3'b010)//Load, store

                        if(IR[20] = 1'b0)//load
                            if(IR[23] == 1'b0)// u = 0 -> suma else resta
                                NextState = LD_IMM_PRE;//TODO FIX THIS
                            if(IR[24]== 1'b0)//p == 0 POST
                                NestState = LD_IMM_POST;
                            else//offset
                                NextState = LD_IMM_OFFSET;
                        else//store

                            if(IR[23] == 1'b1)// u == 1 -> sum
                                if(IR[24] == 1'b0)//p =0 ->27
                                    NextState = STR_IMM_POST;
                                else if(IR[24] == 1'b0) && IR[21])// -> 28th state
                                    NextState = STR_IMM_PRE;
                                else //offset -> 26
                                    NextState = STR_IMM_OFFSET;

                    break;
            end

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


module ControlSignalsEncoder( output reg FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0,
        input [5:0]State, input Done);

    always@(State, Done)

    case(State)

			START:
			begin
				FR_ld <= 0;
				RF_ld <= 1;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 0;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 1;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 1;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 1;
				OP2 <= 1;
				OP1 <= 0;
				OP0 <= 1;
			end
                break;

			FIRST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 1.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= nan;
				OP4 <= 1.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			SECOND:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 1.0;
				MOV <= 1.0;
				MA1 <= 1.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 1.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 1.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 1.0;
			end
            break;

			MOC:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 1.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 1.0;
				MOV <= 1.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 0.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			CONDITIONAL:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 0.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			ARITH_OP_IMM:
			begin
				FR_ld <= 0;
				RF_ld <= 1;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 0;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 0;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 0;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			REG_REG:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 0.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			ARITH_OP_SHIFT:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 0.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;


			LD_IMM_OFFSET:
			begin
				FR_ld <= 0;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 1;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 1;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			LD_IMM_POST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 1.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			LD_IMM_PRE:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			LD_IMM_REG_OFFSET:
			begin
				FR_ld <= 0;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 1;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 0;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 1;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			LD_IMM_REG_POST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			LD_IMM_REG_PRE:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			LD_SCALED_OFFSET:
			begin
				FR_ld <= 0;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 1;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 1;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			LD_IMM_REG_POST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			LD_SCALED_PRE:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			SEVENTEENTH:
			begin
				FR_ld <= 0;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 0;
				R_W <= 1;
				MOV <= 1;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 0;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 0;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 0;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			EIGHTEENTH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 1.0;
				MDR_ld <= 0.0;
				R_W <= 1.0;
				MOV <= 1.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 0.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			NINETEENTH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 1.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 1.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 1.0;
			end
            break;

			TWENTIETH:
			begin
				FR_ld <= 0;
				RF_ld <= 1;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 0;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 1;
				MC0 <= 0;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 1;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			TWENTY_FIRST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 1.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 1.0;
			end
            break;

			TWENTY_SECOND:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 1.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 1.0;
			end
            break;

			TWENTY_THIRD:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 1.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 1.0;
			end
            break;

			TWENTY_FOURTH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 1.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 1.0;
			end
            break; 

			TWENTY_FIFTH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 1.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 1.0;
			end
            break;

			STR_IMM_OFFSET:
			begin
				FR_ld <= 0;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 1;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 0;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			STR_IMM_POST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 1.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			STR_IMM_PRE:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			STR_REG_OFFSET:
			begin
				FR_ld <= 0;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 1;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 0;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 1;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			STR_REG_POST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			STR_REG_PRE:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			STR_SCALED_OFFSET:
			begin
				FR_ld <= 0;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 1;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 1;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			STR_SCALED_POST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			STR_SCALED_PRE:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 1.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			THIRTY_FIFTH:
			begin
				FR_ld <= 0;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 1;
				MDR_ld <= 0;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 1;
				MB1 <= 0;
				MB0 <= 0;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 0;
				ME <= 0;
				OP4 <= 1;
				OP3 <= 0;
				OP2 <= 0;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			THIRTY_SIXTH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 1.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 0.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			THIRTY_SEVENTH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 0.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 1.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 0.0;
				MC0 <= 0.0;
				MD <= 0.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 0.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			THIRTY_EIGHTH:
			begin
				FR_ld <= 0;
				RF_ld <= 1;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 0;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 1;
				MC0 <= 0;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 1;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			THIRTY_NINTH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			FORTIETH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			FORTY_FIRST:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 0.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			FORTY_SECOND:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			BRANCH:
			begin
				FR_ld <= 0.0;
				RF_ld <= 1.0;
				IR_ld <= 0.0;
				MAR_ld <= 0.0;
				MDR_ld <= 0.0;
				R_W <= 0.0;
				MOV <= 0.0;
				MA1 <= 0.0;
				MA0 <= 0.0;
				MB1 <= 0.0;
				MB0 <= 1.0;
				MC1 <= 1.0;
				MC0 <= 0.0;
				MD <= 1.0;
				ME <= 0.0;
				OP4 <= 0.0;
				OP3 <= 0.0;
				OP2 <= 1.0;
				OP1 <= 0.0;
				OP0 <= 0.0;
			end
            break;

			MOV:
			begin
				FR_ld <= 0;
				RF_ld <= 1;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 0;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 1;
				MD <= 1;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 0;
				OP1 <= 0;
				OP0 <= 0;
			end
            break;

			CMP:
			begin
				FR_ld <= 0;
				RF_ld <= 1;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 0;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 0;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 0;
				OP1 <= 0;
				OP0 <= 0;
			end
			9'd48:
			begin
				FR_ld <= 1;
				RF_ld <= 0;
				IR_ld <= 0;
				MAR_ld <= 0;
				MDR_ld <= 0;
				R_W <= 0;
				MOV <= 0;
				MA1 <= 0;
				MA0 <= 0;
				MB1 <= 0;
				MB0 <= 1;
				MC1 <= 0;
				MC0 <= 0;
				MD <= 0;
				ME <= 0;
				OP4 <= 0;
				OP3 <= 0;
				OP2 <= 0;
				OP1 <= 0;
				OP0 <= 0;
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

    wire N, Z, V , Cout;
    wire[31:0] O;

    regfile reg_file(input [31:0] D1, 
    input [3:0] decin, input [3:0] sel1, input [3:0] sel2,
    input LDEC, Clrreg, Clkreg, 
    output [31:0] regout1, output [31:0] regout2);
    ALU alu(output reg N, Z, V, Cout,  output reg  [0:31]O, input Cin , input  [0:31]A, B , input [0:3]OP);

    reg Done, Reset, Clk, Cond, Moc;
    wire[5:0] State;
    wire FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0;

    ControlUnit CU (State, FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0, Moc, Cond, Done, Reset, Clk);
    
    initial #100 $finish;

    initial begin
        Clk = 1'b0;
        Cond =1'b0;
        Moc = 1'b0;
        repeat(100) #5 Clk = ~Clk;
        repeat(100) #5 Moc = ~Moc;
        repeat(100) #5 Cond = ~Cond;
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
            $display("===Control-Unit===\n");
            $display("State FR RF IR MDR MAR R_W MOV MA_1 MA_0 MB_1 MB_0 MC_1 MC_0 MD ME OP4 OP3 OP2 OP1 OP0 Moc, Cond Done Reset     Time");
            $monitor("%d  %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %d",
                    State, FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0, Moc, Cond, Done, Reset, $time);
        end
    

    

endmodule