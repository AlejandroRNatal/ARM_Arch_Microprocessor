`include "ALU_32.v"
`include "control_unit.v"
`include "RegisterFile.v"


module cuTest;

    wire FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0;
    reg Moc , Cond , Done , Reset, Clk;
    wire signed [0:31] Y; 
    wire N , V , Z , Co;
    reg Ci;
    reg [4:0]OP;
    reg signed [31:0] A , B;
    reg state[2:0];

    control_unit cu(state, FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0,Moc, Cond, Done, Reset, Clk);
    ALU myAlu(N , Z , V , Co , Y , Ci , A , B , OP);

    regfile reg_file(PC, C , A , B , RF_Ld , Reset , Clk , PA , PB );


       initial begin
        State = 6'b000000;
        Clk = 1'b0;
        Cond =1'b0;
        Moc = 1'b0;
        //repeat(100) #5 State += 6'b000001;
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
            Sdisplay("---Input---\n");
            $display("FR | RF | IR | MDR | MAR | R_W | MOV | MA_1 | MA_0 | MB_1 | MB_0 | MC_1 | MC_0| MD | ME | OP4 | OP3 | OP2 | OP1 | OP0 | Time\n");
            $monitor("%b | %b | %b | %b  | %b  | %b  | %b  |  %b  |  %b  |  %b  |  %b  | %b   |  %b | %b | %b | %b  | %b  | %b  | %b  |  %b |  %d",
                     FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0, Moc, Cond, Done, Reset, $time);
            $display("---Ouput---\n");
            $display("State | Moc | Cond | Done | Reset| Time\n");

            $monitor("%d  | %b | %b | %b | %b |  %d",
                    State , Moc ,Cond ,Done ,Reset ,$time);
        end


endmodule