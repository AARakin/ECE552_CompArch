module id_ex_flop (MemWrite_in, MemWrite_out, RegWrite_in, RegWrite_out, MemRead_in, MemRead_out, src_reg1_in, src_reg2_in,
		   src_reg1_out, src_reg2_out, read_data1_in, read_data1_out, read_data2_in,
		   read_data2_out, sign_extend_16_in, sign_extend_16_out, instr_in, instr_out,
		   dst_reg_in, dst_reg_out, clk, rst_n, pcs_in, pcs_out, branch_in, branch_out, cache_stall_n);

input clk, rst_n;
input MemWrite_in;
input RegWrite_in;
input MemRead_in;
input branch_in;
input cache_stall_n;
input [15:0] instr_in;
input [15:0] read_data1_in;
input [15:0] read_data2_in;
input [15:0] sign_extend_16_in;
input [15:0] pcs_in;
input [3:0] src_reg1_in, src_reg2_in, dst_reg_in;
output MemWrite_out;
output RegWrite_out;
output MemRead_out;
output [15:0] instr_out;
output [15:0] read_data1_out;
output [15:0] read_data2_out;
output [15:0] sign_extend_16_out;
output [15:0] pcs_out;
output [3:0] src_reg1_out, src_reg2_out, dst_reg_out;
output branch_out;

// Instantiate 1-bit DFF for MemWrite signals
dff MemWrite_ff(.q(MemWrite_out), .d(MemWrite_in), .wen(cache_stall_n), .clk(clk), .rst(~rst_n));

// Instantiate 1-bit DFF for M signals
dff RegWrite_ff(.q(RegWrite_out), .d(RegWrite_in), .wen(cache_stall_n), .clk(clk), .rst(~rst_n));

// Instantiate 1-bit DFF for EX signals
dff MemRead_ff(.q(MemRead_out), .d(MemRead_in), .wen(cache_stall_n), .clk(clk), .rst(~rst_n));

// Instantiate 16-bit FF for the read_data1 control
dff_16bit read1_ff(.q(read_data1_out), .d(read_data1_in), .wen(cache_stall_n), 
	    	   .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the read_data2 control
dff_16bit read2_ff(.q(read_data2_out), .d(read_data2_in), .wen(cache_stall_n), 
	    	   .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for Sign Extended immediate
dff_16bit sign_extend(.q(sign_extend_16_out), .d(sign_extend_16_in), 
		     .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the instruction control
dff_16bit IF_ID_instr_control(.q(instr_out), .d(instr_in), .wen(cache_stall_n), 
  		              .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the PCS pc keeper
dff_16bit pcs_keeper(.q(pcs_out), .d(pcs_in), .wen(cache_stall_n), 
  		              .clk(clk), .rst_n(rst_n));

// Instantiate 4-bit FF for src reg 1
dff_4bit src_reg1(.q(src_reg1_out), .d(src_reg1_in), .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));


// Instantiate 4-bit FF for src reg 2
dff_4bit src_reg2(.q(src_reg2_out), .d(src_reg2_in), .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));


// Instantiate 4-bit FF for dst reg
dff_4bit dst_reg(.q(dst_reg_out), .d(dst_reg_in), .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));

// Instantiate 1-bit DFF for MemWrite signals
dff taken_ff(.q(branch_out), .d(branch_in), .wen(cache_stall_n), .clk(clk), .rst(~rst_n));


endmodule