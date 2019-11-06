// module regfiletest;

// reg [31:0] C1; reg [31:0] C2; reg [31:0] C3; reg [31:0] C4;
//     reg [31:0] C5; reg [31:0] C6; reg [31:0] C7; reg [31:0] C8;
//     reg [31:0] C9; reg [31:0] C10; reg [31:0] C11; reg [31:0] C12;
//     reg [31:0] C13; reg [31:0] C14; reg [31:0] C15; reg [31:0] C16;
// reg [3:0] decinput; reg [3:0] A1; reg [3:0] B2;
// reg LD, Clrr, Clkk;

// wire [31:0] A; wire [31:0] B;

// regfile newreg(C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, //Port C
//                 decinput, A1, B2, // inputs
//                 LD, Clrr, Clkk, // senales
//                 A, B); // Port A y Port B

// initial begin
//     C1 = 32'h00000000;
//     C2 = 32'h0000000B;
//     C3 = 32'h000000B0;
//     C4 = 32'h00000B0B;
//     C5 = 32'h0000B000;
//     C6 = 32'h000B000B;
//     C7 = 32'h00B00000;
//     C8 = 32'h0B00000B;
//     C9 = 32'hB0000000;
//     C10 = 32'h000000BB;
//     C11 = 32'hF0F0F0F0;
//     C12 = 32'h0000B00B;
//     C13 = 32'h000B0000;
//     C14 = 32'h00B0000B;
//     C15 = 32'h00B0B000;
//     C16 = 32'h0BB0000B;
//     LD = 1'b0;
//   Clrr = 1'b0;
//   Clkk = 1'b0;
// end

// initial #1000 $finish;

// initial begin
// decinput = 4'b0000;
//   repeat(100)  #10 decinput <= decinput + 4'b0001;
// end
  
// initial begin
// A1 = 4'b0000;
//   repeat(100) #10 A1 <= A1 + 4'b0001;
// end
  
// initial begin
// B2 = 4'b0000;
//   repeat(100) #10 B2 <= B2 + 4'b0001;
// end
  
// initial fork
//   LD = 0; 
//   Clrr = 0; Clkk = 0;
//   #10 LD = 1; #10 Clrr = 1; #10 Clkk = 1; #40 Clrr = 0; #40 Clkk = 0;
//             #80 Clrr = 1; #80 Clkk = 1;
// join

// // C1 - C16 son Port C, A es Port A y B es Port B, sel1 y sel2 son las entradas del mux, decin es el input del dec
// // LD es el RF, y las ultimas senales son Clrr y Clkk para el Clr y el Clk respectivamente
// // Senales en binario y los puertos en decimal
// initial begin 
//     $display("C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 decin sel1 sel2 LD Clr Clk A B");
//   $monitor("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %b %b %b %b %b %b %d %d",
//             C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, C16, decinput, A1, B2, LD, Clrr, Clkk, A, B);
// end

// endmodule //tests


// //gate-level register file
// module regfile(input [31:0] D1, input [31:0] D2, input [31:0] D3, input [31:0] D4,
//     input [31:0] D5, input [31:0] D6, input [31:0] D7, input [31:0] D8,
//     input [31:0] D9, input [31:0] D10, input [31:0] D11, input [31:0] D12,
//     input [31:0] D13, input [31:0] D14, input [31:0] D15, input [31:0] D16, 
//     input [3:0] decin, input [3:0] sel1, input [3:0] sel2,
//     input LDEC, Clrreg, Clkreg, 
//     output [31:0] regout1, output [31:0] regout2);

// wire [15:0] regin; // inputs de los loads en los registers
// wire [31:0] Q1; wire [31:0] Q2; wire [31:0] Q3; wire [31:0] Q4;
//     wire [31:0] Q5; wire [31:0] Q6; wire [31:0] Q7; wire [31:0] Q8;
//     wire [31:0] Q9; wire [31:0] Q10; wire [31:0] Q11; wire [31:0] Q12;
//     wire [31:0] Q13; wire [31:0] Q14; wire [31:0] Q15; wire [31:0] Q16; // valores guardados en los registros

// //inicializaciones del decoder, los registers y los dos mux
// dec decreg(decin, LDEC, regin);
// regs regsmux1(Q1,D1,regin[0],Clrreg,Clkreg);
// regs regsmux2(Q2,D2,regin[1],Clrreg,Clkreg);
// regs regsmux3(Q3,D3,regin[2],Clrreg,Clkreg);
// regs regsmux4(Q4,D4,regin[3],Clrreg,Clkreg);
// regs regsmux5(Q5,D5,regin[4],Clrreg,Clkreg);
// regs regsmux6(Q6,D6,regin[5],Clrreg,Clkreg);
// regs regsmux7(Q7,D7,regin[6],Clrreg,Clkreg);
// regs regsmux8(Q8,D8,regin[7],Clrreg,Clkreg);
// regs regsmux9(Q9,D9,regin[8],Clrreg,Clkreg);
// regs regsmux10(Q10,D10,regin[9],Clrreg,Clkreg);
// regs regsmux11(Q11,D11,regin[10],Clrreg,Clkreg);
// regs regsmux12(Q12,D12,regin[11],Clrreg,Clkreg);
// regs regsmux13(Q13,D13,regin[12],Clrreg,Clkreg);
// regs regsmux14(Q14,D14,regin[13],Clrreg,Clkreg);
// regs regsmux15(Q15,D15,regin[14],Clrreg,Clkreg);
// regs regsmux16(Q16,D16,regin[15],Clrreg,Clkreg);
// mux mux1(Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, sel1, regout1);
// mux mux2(Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, sel2, regout2);

// endmodule


// //behavioral mux
// module mux(input [31:0] a, input [31:0] b, input [31:0] c, input [31:0] d, 
//             input [31:0] e, input [31:0] f, input [31:0] g, input [31:0] h,
//             input [31:0] i, input [31:0] j, input [31:0] k, input [31:0] l,
//             input [31:0] m, input [31:0] n, input [31:0] o, input [31:0] p,
//             input [3:0] sel, output reg [31:0] out);

// always @ (a or b or c or d or sel) begin
//     case (sel)
//         4'b0000 : out <= a;
//         4'b0001 : out <= b;
//         4'b0010 : out <= c;
//         4'b0011 : out <= d;
//         4'b0100 : out <= e;
//         4'b0101 : out <= f;
//         4'b0110 : out <= g;
//         4'b0111 : out <= h;
//         4'b1000 : out <= i;
//         4'b1001 : out <= j;
//         4'b1010 : out <= k;
//         4'b1011 : out <= l;
//         4'b1100 : out <= m;
//         4'b1101 : out <= n;
//         4'b1110 : out <= o;
//         4'b1111 : out <= p;
//     endcase
// end
// endmodule // mux

// //behavioral decoder
// module dec(input [3:0] in, //senal que dice que sale
//             input rf, //controla si hay salida o no 
//         output reg [15:0] out);

// always @ (rf or in) begin
//     out <= 0;
//     if(rf) begin
//         case(in)
//             4'h0 : out <= 16'h0001;
//             4'h1 : out <= 16'h0002;
//             4'h2 : out <= 16'h0004;
//             4'h3 : out <= 16'h0008;
//             4'h4 : out <= 16'h0010;
//             4'h5 : out <= 16'h0020;
//             4'h6 : out <= 16'h0040;
//             4'h7 : out <= 16'h0080;
//             4'h8 : out <= 16'h0100;
//             4'h9 : out <= 16'h0200;
//             4'hA : out <= 16'h0400;
//             4'hB : out <= 16'h0800;
//             4'hC : out <= 16'h1000;
//             4'hD : out <= 16'h2000;
//             4'hE : out <= 16'h4000;
//             4'hF : out <= 16'h8000;
//         endcase
//     end
// end

// endmodule // dec

// // behavioral register
// module regs(output reg[31:0] Q, 
//             input [31:0] D, 
//             input L, Clr, Clk);

// always @ (posedge Clk, negedge Clr)

// if (!Clr) Q <= 32'h00000000;
// else if (!L) Q <= D;

// endmodule // regs

module regfiletest;

  reg [31:0] C1;
  reg [3:0] decinput; reg [3:0] A1; reg [3:0] B2;
  reg LD, Clrr, Clkk;

  wire [31:0] A; wire [31:0] B;

  regfile newreg(C1, //Port C
                  decinput, A1, B2, // inputs
                  LD, Clrr, Clkk, // senales
                  A, B); // Port A y Port B

  initial begin
      C1 = 32'h0000000B;
  end

    initial #1000 $finish;

  initial begin
  decinput = 4'h8;
    #010 C1 <= 32'h00000010;
    #100 C1 <= 32'h00000020;
  end

  initial begin
  A1 = 4'b0000;
    repeat(100) #10 A1 <= A1 + 4'b0001;
  end

  initial begin
  B2 = 4'b0000;
    repeat(100) #10 B2 <= B2 + 4'b0001;
  end

  initial begin
    Clkk = 1'b0;
      forever begin
          #5 Clkk = ~Clkk;
      end
  end

  initial fork
    LD = 0; 
    Clrr = 0;
    #5 LD = 1;
    #5 Clrr = 1;
  join

  // C1 - C16 son Port C, A es Port A y B es Port B, sel1 y sel2 son las entradas del mux, decin es el input del dec
  // LD es el RF, y las ultimas senales son Clrr y Clkk para el Clr y el Clk respectivamente
  // Senales en binario y los puertos en decimal
  initial begin 
      $display("C1 decin sel1 sel2 LD Clr Clk A B");
    $monitor("%d %b %b %b %b %b %b %d %d",
              C1, decinput, A1, B2, LD, Clrr, Clkk, A, B);
  end

endmodule //tests


//gate-level register file
module regfile(input [31:0] D1, 
    input [3:0] decin, input [3:0] sel1, input [3:0] sel2,
    input LDEC, Clrreg, Clkreg, 
    output [31:0] regout1, output [31:0] regout2);

wire [15:0] regin; // inputs de los loads en los registers
wire [31:0] Q1; wire [31:0] Q2; wire [31:0] Q3; wire [31:0] Q4;
    wire [31:0] Q5; wire [31:0] Q6; wire [31:0] Q7; wire [31:0] Q8;
    wire [31:0] Q9; wire [31:0] Q10; wire [31:0] Q11; wire [31:0] Q12;
    wire [31:0] Q13; wire [31:0] Q14; wire [31:0] Q15; wire [31:0] Q16; // valores guardados en los registros

//inicializaciones del decoder, los registers y los dos mux
dec decreg(decin, LDEC, regin);
regs regsmux1(Q1,D1,regin[0],Clrreg,Clkreg);
regs regsmux2(Q2,D1,regin[1],Clrreg,Clkreg);
regs regsmux3(Q3,D1,regin[2],Clrreg,Clkreg);
regs regsmux4(Q4,D1,regin[3],Clrreg,Clkreg);
regs regsmux5(Q5,D1,regin[4],Clrreg,Clkreg);
regs regsmux6(Q6,D1,regin[5],Clrreg,Clkreg);
regs regsmux7(Q7,D1,regin[6],Clrreg,Clkreg);
regs regsmux8(Q8,D1,regin[7],Clrreg,Clkreg);
regs regsmux9(Q9,D1,regin[8],Clrreg,Clkreg);
regs regsmux10(Q10,D1,regin[9],Clrreg,Clkreg);
regs regsmux11(Q11,D1,regin[10],Clrreg,Clkreg);
regs regsmux12(Q12,D1,regin[11],Clrreg,Clkreg);
regs regsmux13(Q13,D1,regin[12],Clrreg,Clkreg);
regs regsmux14(Q14,D1,regin[13],Clrreg,Clkreg);
regs regsmux15(Q15,D1,regin[14],Clrreg,Clkreg);
regs regsmux16(Q16,D1,regin[15],Clrreg,Clkreg);
mux mux1(Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, sel1, regout1);
mux mux2(Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16, sel2, regout2);

endmodule


//behavioral mux
module mux(input [31:0] a, input [31:0] b, input [31:0] c, input [31:0] d, 
            input [31:0] e, input [31:0] f, input [31:0] g, input [31:0] h,
            input [31:0] i, input [31:0] j, input [31:0] k, input [31:0] l,
            input [31:0] m, input [31:0] n, input [31:0] o, input [31:0] p,
            input [3:0] sel, output reg [31:0] out);

always @ (a or b or c or d or sel) begin
    case (sel)
        4'b0000 : out <= a;
        4'b0001 : out <= b;
        4'b0010 : out <= c;
        4'b0011 : out <= d;
        4'b0100 : out <= e;
        4'b0101 : out <= f;
        4'b0110 : out <= g;
        4'b0111 : out <= h;
        4'b1000 : out <= i;
        4'b1001 : out <= j;
        4'b1010 : out <= k;
        4'b1011 : out <= l;
        4'b1100 : out <= m;
        4'b1101 : out <= n;
        4'b1110 : out <= o;
        4'b1111 : out <= p;
    endcase
end
endmodule // mux

//behavioral decoder
module dec(input [3:0] in, //senal que dice que sale
            input rf, //controla si hay salida o no 
        output reg [15:0] out);

always @ (rf or in) begin
    out <= 0;
    if(rf) begin
        case(in)
            4'h0 : out <= 16'h0001;
            4'h1 : out <= 16'h0002;
            4'h2 : out <= 16'h0004;
            4'h3 : out <= 16'h0008;
            4'h4 : out <= 16'h0010;
            4'h5 : out <= 16'h0020;
            4'h6 : out <= 16'h0040;
            4'h7 : out <= 16'h0080;
            4'h8 : out <= 16'h0100;
            4'h9 : out <= 16'h0200;
            4'hA : out <= 16'h0400;
            4'hB : out <= 16'h0800;
            4'hC : out <= 16'h1000;
            4'hD : out <= 16'h2000;
            4'hE : out <= 16'h4000;
            4'hF : out <= 16'h8000;
        endcase
    end
end

endmodule // dec

// behavioral register
module regs(output reg[31:0] Q, 
            input [31:0] D, 
            input L, Clr, Clk);

always @ (posedge Clk)

if (L) Q <= D;

endmodule // regs