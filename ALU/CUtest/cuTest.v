`include "ALU/ALU_32.v"
`include "RAM/control_unit.v"
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

    control_unit cu (state, FR,RF,IR, MDR,MAR,R_W,MOV,MA_1,MA_0,MB_1,MB_0,MC_1,MC_0,MD, ME, OP4,OP3,OP2,OP1,OP0,Moc, Cond, Done, Reset, Clk);
    ALU myAlu (N , Z , V , Co , Y , Ci , A , B , OP);
    regfile reg_file(PC, C , A , B , RF_Ld , Reset , Clk , PA , PB );


endmodule