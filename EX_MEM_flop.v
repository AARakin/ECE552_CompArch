module ex_mem_flop (MemWrite_in, MemWrite_out, RegWrite_in, RegWrite_out, reg_dst_mux_in, reg_dst_mux_out,
		    alu_output_in, alu_output_out, alu_src2_in, alu_src2_out,
		    clk, rst_n, instr_in, instr_out, dst_reg_in, dst_reg_out, cache_stall_n,
		    reg_src2_in, src2_data_in, reg_src2_out, src2_data_out, src_data_1_in, src_data_1_out, pcs_in, pcs_out);

input clk, rst_n;
input MemWrite_in;
input RegWrite_in;
input [3:0] reg_dst_mux_in;
input [15:0] alu_output_in;
input [15:0] alu_src2_in;
input [15:0] instr_in;
input [15:0] pcs_in;
input cache_stall_n;
output MemWrite_out;
output RegWrite_out;
input [15:0] src_data_1_in;
output [3:0] reg_dst_mux_out;
output [15:0] alu_output_out;
output [15:0] alu_src2_out;
output [15:0] instr_out;
output [15:0] src2_data_out;
// For mem-to-mem forwarding, need to know EX/MEM.RegisterRt
input [3:0] reg_src2_in, dst_reg_in;
input [15:0] src2_data_in;
output [3:0] reg_src2_out, dst_reg_out;
output [15:0] src_data_1_out;
output [15:0] pcs_out;

// Instantiate 1-bit DFF for WB signals
dff wb_ff(.q(MemWrite_out), .d(MemWrite_in), .wen(cache_stall_n), .clk(clk), .rst(~rst_n));

// Instantiate 1-bit DFF for M signals
dff m_ff(.q(RegWrite_out), .d(RegWrite_in), .wen(cache_stall_n), .clk(clk), .rst(~rst_n));

// Instantiate 16-bit FF for the alu_outpout control
dff_16bit read1_ff(.q(alu_output_out), .d(alu_output_in), .wen(cache_stall_n), 
	    	   .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the instruction control
dff_16bit read2_ff(.q(alu_src2_out), .d(alu_src2_in), .wen(cache_stall_n), 
	    	   .clk(clk), .rst_n(rst_n));

// Instantiate 4-bit FF for reg dst mux output
dff_4bit src_reg1(.q(reg_dst_mux_out), .d(reg_dst_mux_in), .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the instruction control
dff_16bit EX_MEM_instr_control(.q(instr_out), .d(instr_in), .wen(cache_stall_n), 
	   	              .clk(clk), .rst_n(rst_n));

// Instantiate 4-bit FF for src_reg2 (Rt) in case of Mem-to-Mem forwarding
dff_4bit src_reg2(.q(reg_src2_out), .d(reg_src2_in), .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for src_reg2 (Rt) data in case of Mem-to-Mem forwarding
dff_16bit src_reg2_data(.q(src2_data_out), .d(src2_data_in), .wen(cache_stall_n), 
	   	              .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the PCS pc keeper
dff_16bit pcs_keeper(.q(pcs_out), .d(pcs_in), .wen(cache_stall_n), 
  		              .clk(clk), .rst_n(rst_n));

// Instantiate 4-bit FF for dst reg
dff_4bit dst_reg(.q(dst_reg_out), .d(dst_reg_in), .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for reg file data 1 (only for LLB and LHB commands)
dff_16bit src_data1_ff(.q(src_data_1_out), .d(src_data_1_in), .wen(cache_stall_n), 
	   	              .clk(clk), .rst_n(rst_n));

endmodule