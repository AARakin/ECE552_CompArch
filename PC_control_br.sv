module PC_control_br(C, Rs_contents, F, PC_in, PC_out);
////////////////////////////////////////
// This module focuses on the Branch  //
// Register instruction to modify the //
// PC       			      //
////////////////////////////////////////

input wire [2:0] C;
input wire [15:0] Rs_contents;
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
wire [15:0] PC_out_inc;
wire error1;
reg takeb, error2; // takeb-- 0: increment by 2, 1: incremet by offset + 2
// Determine potential offset value

CLA_16bit inc_adder(.A(PC_in), .B(16'h2), .C_in(1'b0), .S(PC_out_inc), .Ovfl(error1));

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
default: error2 = 1'b1;
endcase

assign PC_out = takeb ? Rs_contents : PC_out_inc;

endmodule
