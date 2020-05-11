module PC_control_b(C, I, F, PC_in, PC_out);
////////////////////////////////////////
// This module focuses on the Branch  //
// instruction to modify the PC       //
////////////////////////////////////////

input wire [2:0] C;
input wire [8:0] I;
input wire [2:0] F;
input wire [15:0] PC_in;
output wire [15:0] PC_out;

// 3 bit CC instructions
// ccc	Condition
// 000	NEQ (Z=0)
// 001	EQ (Z=1)
// 010	GT (Z=N=0)
// 011	LT (N=1)
// 100	GTE (Z=1 or N=Z=0)
// 101	LTE (Z=1 or N=1)
// 110	OVFL (V=1)
// 111	UNCOND
wire [15:0] I_shift_inc; 
wire [15:0] I_shift_inc_plus2;
wire [15:0] PC_out_shift_plus2;
wire [15:0] PC_out_shift; 
wire [15:0] PC_out_inc;
wire error1, error2, error4;
wire pc_overflow1, pc_overflow2; // Not doing anything with this
reg takeb, error3; // takeb-- 0: increment by 2, 1: incremet by offset + 2
// Determine potential offset value
assign I_shift_inc = {{7{I[8]}},(I << 1'b1)};

CLA_16bit shift_adder(.A(PC_in), .B(I_shift_inc), .C_in(1'b0), .S(PC_out_shift_plus2), .Ovfl(pc_overflow2));;

// Combinational logic to determine which value PC_out should get
always @* case(C)
3'b000 : takeb = F[2] 				? 1'b0 : 1'b1;
3'b001 : takeb = F[2] 				? 1'b1 : 1'b0;
3'b010 : takeb = (~F[2]) & (~F[0])		? 1'b1 : 1'b0;
3'b011 : takeb = F[0] 				? 1'b1 : 1'b0;
3'b100 : takeb = F[2] | (~(F[2]) & ~(F[0]))	? 1'b1 : 1'b0;
3'b101 : takeb = F[0] | F[2]			? 1'b1 : 1'b0;
3'b110 : takeb = F[1] 				? 1'b1 : 1'b0;
3'b111 : takeb =  				1'b1;
default: error3 = 1'b1;
endcase

assign PC_out = takeb ? PC_out_shift_plus2 : PC_in;

endmodule
