module forward(id_ex_rs, id_ex_rt, ex_mem_rd, mem_wb_rd, ex_mem_regWrite, mem_wb_regWrite,
	       ex_mem_rt, ex_mem_memWrite, fwdA_ex, fwdB_ex, fwd_mem, id_ex_opcode, ex_mem_opcode);

// get registers names (not values) as input 
input [3:0] id_ex_rs, id_ex_rt, ex_mem_rd,
	    mem_wb_rd, ex_mem_rt;
// need to know id_ex opcode and ex_mem opcode for mem-to-mem forwarding
input [3:0] id_ex_opcode, ex_mem_opcode;
// LOAD STALLS: id_ex_rd, if_id_rt, if_id_rs;
// as well as some other control signals
input ex_mem_regWrite, mem_wb_regWrite, ex_mem_memWrite;
// LOAD STALLS: id_ex_memRead, if_id_memWrite;

// output mux select signals to control forwarding
output [1:0] fwdA_ex, fwdB_ex;
output fwd_mem;
// LOAD STALLS: load_to_use_stall; 

/////////////////////////////////////
// FORWARDING MUX SELECTION TABLE //
///////////////////////////////////

// See textbook section 4.5 for EX-to-EX, MEM-to-EX, and Forward select logic

// MUX CONTROL		SOURCE

// fwdA_ex = 00		ID/EX
// fwdA_ex = 10		EX/MEM
// fwdA_ex = 01		MEM/WB

// fwdB_ex = 00		ID/EX
// fwdB_ex = 10		EX/MEM
// fwdB_ex = 01		MEM/WB

// fwd_mem = 0		EX/MEM
// fwd_mem = 1		MEM/WB - enable mem-to-mem forwarding

///////////////////////
// FORWARDING LOGIC //
/////////////////////

// FWDA_EX logic
assign fwdA_ex = (ex_mem_regWrite & (ex_mem_rd != 4'h0) & (ex_mem_rd == id_ex_rs)) ? 2'b10 : // EX-to-EX forwarding
		 (mem_wb_regWrite & (mem_wb_rd != 4'h0) & (mem_wb_rd == id_ex_rs) &
		~(ex_mem_regWrite & (ex_mem_rd != 4'h0) & (ex_mem_rd == id_ex_rs))) ? 2'b01 : // MEM-to-EX forwarding
		  2'b00;

// FWDB_EX logic
assign fwdB_ex = (ex_mem_regWrite & (ex_mem_rd != 4'h0) & (ex_mem_rd == id_ex_rt)) ? 
		 ((ex_mem_opcode == 4'b1000) & (id_ex_opcode == 4'b1001)) ? 2'b00 : 2'b10 : // EX-to-EX forwarding (don't do if MEM-to-MEM forwarding)
		 (mem_wb_regWrite & (mem_wb_rd != 4'h0) & (mem_wb_rd == id_ex_rt) &
		~(ex_mem_regWrite & (ex_mem_rd != 4'h0) & (ex_mem_rd == id_ex_rt))) ? 2'b01 : // MEM-to-EX forwarding
		  2'b00;

// MEM-to-MEM forwarding
assign fwd_mem = (ex_mem_memWrite & mem_wb_regWrite & (mem_wb_rd != 4'h0) & (mem_wb_rd == ex_mem_rt));

// TODO: MOVE TO STALL LOGIC ONCE READY
// Load-to-use stalls: uses id_ex_memRead, id_ex_rd, if_id_rt, if_id_rs, if_id_memWrite
// do not need those signals in this module once stall logic is moved
//assign load_to_use_stall = (id_ex_memRead & (id_ex_rd != 4'h0) & 
//			  ((id_ex_rd == if_id_rs) | 
//			  ((id_ex_rd == if_id_rt) & ~if_id_memWrite)));

endmodule
