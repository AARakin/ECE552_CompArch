module PC_control(C, Opcode, Rs_contents, I, F, PC_in, PC_out, rst_n, BranchTaken, bstall);
////////////////////////////////////////
// This module focuses on the Branch  //
// Register instruction to modify the //
// PC       			      //
////////////////////////////////////////

input wire [2:0] C; // condition  code
input wire [3:0] Opcode;
input wire [15:0] Rs_contents; // contents of Rs (From Register)
input wire [2:0] F; // Flag values
input wire [8:0] I; // Immediate
input wire [15:0] PC_in; // PC Initial
input wire rst_n;
input wire bstall;
output wire [15:0] PC_out; // PC Out
output wire BranchTaken;

// Internal Signals
wire take_default, take_branch, take_branch_reg; // take_hlt;
wire [15:0] PC_out_B, PC_out_BR, PC_out_HLT, rst_PC; // PC_out_PCS,; // PC Initial
wire pc_overflow; // Not used for anything (Project Spec Requirements)
//wire [15:0] PC_out_default;

// Determine if branches should be taken or not
PC_control_b 	PC_CTL_B(  .C(C), .F(F), .PC_in(PC_in), .PC_out(PC_out_B), 	.I(I));
PC_control_br 	PC_CTL_BR( .C(C), .F(F), .PC_in(PC_in), .PC_out(PC_out_BR), 	.Rs_contents(Rs_contents));

// Assign Reset PC
assign rst_PC = 16'h0;
assign PC_out_HLT = PC_in; // TODO Could replace... but will leave for now


// Figure out which PC control instruction should be taken
// Take the default +2 if non-special branch instruction, or for any PCS instruction
assign take_default	= (~(Opcode[3:2] == 2'b11) | (Opcode[3:0] == 4'b1110)) ? 1'b1 : 1'b0; // Increment by 2 if either of 2MSB opcodes are 0
assign take_branch 	= ((Opcode[3:0] == 4'b1100 & bstall == 1'b0)) ? 1'b1 : 1'b0;
assign take_branch_reg  = ((Opcode[3:0] == 4'b1101 & bstall == 1'b0)) ? 1'b1 : 1'b0;
//assign take_hlt	        = (Opcode[3:0] == 4'b1111) ? 1'b1 : 1'b0; // Don't need this for now
assign BranchTaken = (take_branch & (PC_out_B != PC_in)) | (take_branch_reg & (PC_out_BR != PC_in));

assign PC_out = ~rst_n ? rst_PC	
	      :	take_default ? PC_in 
	      : (bstall) ? PC_in
	      : take_branch ? PC_out_B 
	      : take_branch_reg ? PC_out_BR 
	      : PC_out_HLT; 




endmodule
