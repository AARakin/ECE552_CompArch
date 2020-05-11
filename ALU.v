module ALU (ALU_Out, Error, ALU_In1, ALU_In2, opcode, F, rst_n, clk); 
///////////////////////////
// Arithmetic Logic Unit //
///////////////////////////
input [15:0] ALU_In1, ALU_In2; 
input [3:0] opcode; 
input rst_n, clk;
output reg [15:0] ALU_Out; 
output [2:0] F; // Flag
output Error; // Just to show overflow 

reg ALU_CASE_ERROR;

wire [3:0] addsubres; //w0 for NAND and w1 for XOR
wire alu_add_ovrfl, red_error, paddsb_error;

wire [15:0] adder_b_input, ALU_input1, alu_adder_output, alu_xor_output, alu_red_output, alu_shift_output, alu_ror_output, alu_paddsb_output, alu_add_output_unsat;
wire set_over_neg_flag;
wire set_zero_flag;

assign ALU_input1 = ALU_In1;  // TODO Fix? Sim was throwing a waring if this isn't here
assign adder_b_input = opcode[0] ? ~ALU_In2 : ALU_In2;


// Flag Internal Signals
wire add_sub_ovrfl_flag, add_sub_zero_flag, add_sub_neg_flag;
wire xor_zero_flag, shifter_zero_flag, rotator_zero_flag;
wire zero_flag_value;

//////////////////////////
// Adder and Subtractor //
//////////////////////////
CLA_16bit ALU_add(.A(ALU_input1), .B(adder_b_input), .C_in(opcode[0]), .S(alu_add_output_unsat), .Ovfl(alu_add_ovrfl));
assign Error = (opcode == 4'b000) ?  alu_add_ovrfl : 1'b0;  // TODO add error cases for other opcodes
assign add_sub_ovrfl_flag = alu_add_ovrfl;
assign add_sub_zero_flag = (alu_adder_output ==  16'b0);
assign add_sub_neg_flag = (alu_adder_output[15] == 1'b1);
assign alu_adder_output = alu_add_ovrfl == 1'b1 ? (ALU_input1[15] == 1'b1 ? 16'h8000: 16'hFFFF) : alu_add_output_unsat;

///////////////////
// XOR Operation //
///////////////////
assign alu_xor_output = ALU_In1 ^ ALU_In2;
assign xor_zero_flag = (alu_xor_output == 16'b0);

/////////////////////////
// Reduction Operation //
/////////////////////////
RED_16bit red(.Sum(alu_red_output), .Error(red_error), .A(ALU_In1), .B(ALU_In2));

///////////////////////////
// SLL and SRA Operation //
///////////////////////////
Shifter shifter(.Shift_Out(alu_shift_output), .Shift_In(ALU_In1), .Shift_Val(ALU_In2[3:0]), .Mode(opcode[0]));
assign shifter_zero_flag = (alu_shift_output == 16'b0);

////////////////////
// Right Rotation //
////////////////////
Rotator ror(.Shift_Out(alu_ror_output), .Shift_In(ALU_In1), .Shift_Val(ALU_In2[3:0]));
assign rotator_zero_flag = (alu_ror_output == 16'b0);

//////////////////////////////
// Partial Adder Subtractor // 
//////////////////////////////
PSA_16bit psa(.Res(alu_paddsb_output), .A(ALU_In1), .B(ALU_In2));

////////////////////////
// Flag Control Logic //
////////////////////////
// Which flags should be set? 

assign set_over_neg_flag = (opcode == 4'b0) | (opcode == 4'b0001); 
assign set_zero_flag = (set_over_neg_flag) | (opcode == 4'b0010) | (opcode == 4'b0100) | (opcode == 4'b0101) | (opcode == 4'b0110);
// Overflow Logic
// No special logic required. Add/Subtractor is a single block, so we'll always just pass this value in.

assign zero_flag_value = ((opcode == 4'b0000) | (opcode == 4'b001)) ? add_sub_zero_flag 
		: (opcode == 4'b0010) ? xor_zero_flag
		: ((opcode == 4'b0100) | (opcode == 4'b0101))? shifter_zero_flag
		: rotator_zero_flag;
///////////////////
// Flag Register // 
///////////////////
flag_register flag_register0(.Reg_in({(zero_flag_value & set_zero_flag), (add_sub_ovrfl_flag & set_over_neg_flag), (add_sub_neg_flag & set_over_neg_flag)}), 
			     .Reg_out(F), .clk(clk), .rst_n(rst_n), .Wen({set_zero_flag, {2{set_over_neg_flag}}} ));


////////////
// Output //
////////////
 always @*
      case (opcode[2:0])
      3'b000  : ALU_Out = alu_adder_output;
      3'b001  : ALU_Out = alu_adder_output; 
      3'b010  : ALU_Out = alu_xor_output; 
      3'b011  : ALU_Out = alu_red_output; 
      3'b100  : ALU_Out = alu_shift_output; 
      3'b101  : ALU_Out = alu_shift_output; 
      3'b110  : ALU_Out = alu_ror_output; 
      3'b111  : ALU_Out = alu_paddsb_output; 
	default ALU_CASE_ERROR = 1'b1;
    endcase

endmodule
