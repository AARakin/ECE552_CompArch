module mem_wb_flop (RegWrite_in, RegWrite_out, reg_dst_mux_in, reg_dst_mux_out,
		    alu_output_in, alu_output_out, data_memory_in, data_memory_out,
		    clk, rst_n, instr_in, instr_out, dst_reg_in, dst_reg_out,
		    src_data_1_in, src_data_1_out, pcs_in, pcs_out, cache_stall_n);

input clk, rst_n;
input RegWrite_in;
input cache_stall_n;
input [3:0] reg_dst_mux_in, dst_reg_in;
input [15:0] alu_output_in;
input [15:0] data_memory_in;
input [15:0] instr_in;
input [15:0] src_data_1_in;
input [15:0] pcs_in;
output RegWrite_out;
output [3:0] reg_dst_mux_out, dst_reg_out;
output [15:0] alu_output_out;
output [15:0] data_memory_out;
output [15:0] instr_out;
output [15:0] src_data_1_out;
output [15:0] pcs_out;

// Instantiate 1-bit DFF for WB signals
dff wb_ff(.q(RegWrite_out), .d(RegWrite_in), .wen(cache_stall_n), .clk(clk), .rst(~rst_n));

// Instantiate 16-bit FF for the alu_outpout control
dff_16bit read1_ff(.q(alu_output_out), .d(alu_output_in), .wen(cache_stall_n), 
	    	   .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the instruction control
dff_16bit read2_ff(.q(data_memory_out), .d(data_memory_in), .wen(cache_stall_n), 
	    	   .clk(clk), .rst_n(rst_n));

// Instantiate 4-bit FF for reg dst mux output
dff_4bit src_reg1(.q(reg_dst_mux_out), .d(reg_dst_mux_in), .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the instruction control
dff_16bit IF_ID_instr_control(.q(instr_out), .d(instr_in), .wen(cache_stall_n), 
	   	              .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the instruction control
dff_16bit src_data_flop(.q(src_data_1_out), .d(src_data_1_in), .wen(cache_stall_n), 
	   	              .clk(clk), .rst_n(rst_n));

// Instantiate 16-bit FF for the PCS pc keeper
dff_16bit pcs_keeper(.q(pcs_out), .d(pcs_in), .wen(cache_stall_n), 
  		              .clk(clk), .rst_n(rst_n));

// Instantiate 4-bit FF for reg dst mux output
dff_4bit dst_reg(.q(dst_reg_out), .d(dst_reg_in), .wen(cache_stall_n), .clk(clk), .rst_n(rst_n));

endmodule