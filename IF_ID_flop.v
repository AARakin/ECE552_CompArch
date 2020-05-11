module if_id_flop (if_id_instr_in, if_id_pc_in, if_id_instr_out, if_id_pc_out, if_id_flush_in, clk, rst_n, stall_n);

    input [15:0] if_id_instr_in; 	// Instruction input
    input [15:0] if_id_pc_in;
    input clk; //Clock
    input rst_n, stall_n; //Reset_n (used synchronously)
    input if_id_flush_in;
    output [15:0] if_id_pc_out;
    output [15:0] if_id_instr_out; //Instruction output

    // NOTE: In the case of a stall, may need to handle that in here (not handled yet)

    // Instantiate 16-bit FF for the pc
    dff_16bit IF_ID_PC_counter(.q(if_id_pc_out), .d(if_id_pc_in), .wen(stall_n), 
			       .clk(clk), .rst_n(rst_n));

    // Instantiate 16-bit FF for the instruction control
    dff_16bit IF_ID_instr_control(.q(if_id_instr_out), .d(if_id_instr_in), .wen(stall_n), 
			          .clk(clk), .rst_n(rst_n));

    // Instantiate 1-bit FF for the IF Flush signal
    dff if_flush(.q(if_id_flush_out), .d(if_id_flush_in), .wen(stall_n), .clk(clk), .rst(~rst_n));

endmodule
