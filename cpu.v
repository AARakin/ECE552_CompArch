 module cpu(clk, rst_n, hlt, pc);
input clk, rst_n;
output hlt;
output reg [15:0] pc;

// Internal Signals for PC
wire [15:0] pc_update, id_pc_out, pc_output, pc_inc_2, pc_inc_0; // New value for the PC
wire [2:0] C; // Condition codes set 
wire [2:0] F; // Flags F[2] = Z, F[1] = V, F[0] = N
wire [15:0] if_instr, id_instr, ex_instr, mem_instr, wb_instr; // Decoded instruction set by instruction memory
wire [3:0] if_opcode, id_opcode, ex_opcode, mem_opcode, wb_opcode;
wire [15:0] id_read_data1, id_read_data2, ex_read_data1, ex_read_data2, mem_read_data2; 

// Internal Signals for data memory
wire [15:0] memAddr, write_mem_data;

// Internal Signals for Register File
wire [15:0] pre_dst_data, alu_mem_write_data, mem_lw_dst_data, wb_lw_dst_data;
wire [3:0] id_dst_register, ex_dst_register, mem_dst_register, wb_dst_register;
wire [3:0] id_src_register1, id_src_register2, ex_src_register1, ex_src_register2, mem_src_register2, reg_dst_mux;
wire [15:0] dst_data_load_byte;
wire wb_writeback_register; 

// for loads and stores
wire [15:0] id_se_offset, ex_se_offset;

// For ALU
wire [15:0] alu_input1;
wire [15:0] ex_alu_input2, mem_alu_input2;
wire [15:0] ex_aluResult, mem_aluResult, wb_aluResult;
wire [3:0] ALUOp;
wire ALUerror;

// For memory
wire data_mem_overflow;


// Pipelining stuff
wire [3:0] ex_reg_dst_mux, mem_reg_dst_mux, wb_reg_dst_mux;
assign if_opcode = if_instr[15:12];
assign id_opcode = id_instr[15:12];
assign ex_opcode = ex_instr[15:12];
assign mem_opcode = mem_instr[15:12];
assign wb_opcode = wb_instr[15:12];

// Forwarding Signals
wire ID_EX_MemWrite_in, ID_EX_MemWrite_out;
wire ID_EX_RegWrite_in, ID_EX_RegWrite_out;
wire ID_EX_MemRead_in, ID_EX_MemRead_out;
wire ID_EX_Branch_in;
wire EX_MEM_MemWrite_in, EX_MEM_MemWrite_out;
wire EX_MEM_RegWrite_in, EX_MEM_RegWrite_out;
wire MEM_WB_RegWrite_in, MEM_WB_RegWrite_out;

// Hazard signals
wire if_id_flush;

//Stall Signals
wire load_to_stall, branch_stall, stall_n; 

wire [15:0] wb_mem_alu_sel_data;
wire [15:0] wb_load_byte_value;
wire [15:0] wb_read_data1;
wire [15:0] mem_read_data1;

// mux select signals
wire memRead;

// branch signals
wire bTaken;
wire [15:0] id_pc_update, pc_flop_input, pc_read_input;
wire [15:0] id_pc_for_pcs, ex_pc_for_pcs, mem_pc_for_pcs, wb_pc_for_pcs;

// cache signals
wire data_valid;
wire instr_fsm_busy, data_fsm_busy, fsm_busy, instr_mem_request, data_mem_request, arbitration;
wire [15:0] mem_to_cache;
wire [15:0] instr_cache_to_mem_address, data_cache_to_mem_address, mem_addr;
wire cache_stall; 
assign fsm_busy = instr_fsm_busy |  data_fsm_busy;
assign cache_stall = fsm_busy | arbitration;
assign arbitration = instr_mem_request & data_mem_request;

///////////////////
// PC Management //
///////////////////

assign pc_flop_input = bTaken ? id_pc_update : pc_update;

// PC Flip Flop
dff_16bit PC_counter(.q(pc_output), .d(pc_flop_input), .wen(1'b1), .clk(clk), .rst_n(rst_n));
assign pc = pc_output;

CLA_16bit pc_2_inc(.A(pc_output), .B(16'h2), .C_in(1'b0), .S(pc_inc_2), .Ovfl(pc_overflow));
//CLA_16bit pc_0_inc(.A(pc_output), .B(16'h0), .C_in(1'b0), .S(pc_inc_0), .Ovfl(pc_overflow));
wire hlt_special;
assign pc_update = (ex_opcode == 4'b1111) ? pc_inc_2 : stall_n ? pc_inc_2 : pc_output; // TODO replace with adder PCsrc logic
assign hlt_special = (ex_opcode == 4'b1111 | mem_opcode == 4'b1111);
////////////////////////
// Instruction Memory // Removed for phase 3
////////////////////////
// Instantiate Instruction Memory Instance
// memory1c instr_memory(.data_out(if_instr), .data_in(16'b0), .addr(pc_output), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(~rst_n));

// Instruction Cache instance
// I-cache will never write to memory after the program runs, so wr_data is left blank
cache instr_cache (  .wr_data_in(), .data_out(if_instr), .address_in(pc_output), .w_en(1'b0), .fsm_busy(instr_fsm_busy), 
		.memory_address(instr_cache_to_mem_address), .memory_data(mem_to_cache), .memory_data_valid(data_valid), 
		.memory_request(instr_mem_request), .enable(1'b1), .clk(clk), .rst_n(rst_n));

//////////////////
// IF / ID Flop //
//////////////////
wire [15:0] if_instr_flushed;
assign if_instr_flushed = bTaken ? 16'b0 : if_instr;

if_id_flop IF_ID(.if_id_pc_in(pc_update), .if_id_pc_out(id_pc_out), .if_id_instr_in(if_instr_flushed), .if_id_instr_out(id_instr), .if_id_flush_in(if_id_flush), 
		 .clk(clk), .rst_n(rst_n), .stall_n(stall_n & ~cache_stall));

// PC Updating
PC_control PC_control(.C(id_instr[11:9]), .Opcode(id_opcode), .Rs_contents(id_read_data1), .I(id_instr[8:0]), .BranchTaken(bTaken), 
		      .F(F), .PC_in(id_pc_out), .PC_out(id_pc_update), .rst_n(rst_n), .bstall(branch_stall));

assign id_pc_for_pcs = id_pc_out;

///////////////////////////
// Hazard Detection Unit //
///////////////////////////
// only stores write to memory
//assign IF_ID_MemWrite_in = (if_opcode == 4'b1001);
//
//// SW, B, BR, HLT are the only instructions that do not write to a register
//assign IF_ID_RegWrite_in = ~(if_opcode == 4'b1001 | if_opcode == 4'b1100 | if_opcode == 4'b1101 | if_opcode == 4'b1111);
//
//// only loads read from memory
//assign IF_ID_MemRead_in = (if_opcode == 4'b1000);
//
//// only stores write to memory
//assign IF_ID_Branch = (if_opcode == 4'b1101);

assign stall_n = ~(load_to_stall | branch_stall | cache_stall);

hazard_detection Haz_Det(.if_id_rs(id_src_register1), .if_id_rt(id_src_register2), .id_ex_rd(reg_dst_mux), .ex_mem_rd(mem_dst_register), 
			.if_id_branch(ID_EX_Branch_in), .id_ex_regWrite(ID_EX_RegWrite_out), .ex_mem_regWrite(EX_MEM_RegWrite_out), .id_ex_memRead(ID_EX_MemRead_out), 
			.if_id_memWrite(ID_EX_MemWrite_in), .load_to_stall(load_to_stall), .brstall(branch_stall)); 

///////////////////
// Register File //
///////////////////
// LLB and LHB logic only

// special instructions in form : opcode rd imm (read-modify-write)
// 	Reg[dddd] = (Reg[dddd] & 0xFF00) | uuuuuuuu for LLB
// 	Reg[dddd] = (Reg[dddd] & 0x00FF) | (uuuuuuuu << 8) for LHB.
//assign dst_data_load_byte = (wb_opcode == 4'b1010) ? (id_read_data1 & 16'hff00) | wb_instr[7:0] :
//		       	    (id_read_data1 & 16'h00ff) | (wb_instr[7:0] << 4'h8); 
//
//assign id_dst_data = (id_opcode[3:1] == 3'b101) ? dst_data_load_byte : 
//		     (id_opcode == 4'b1000) ? wb_lw_dst_data :  
//	             (id_opcode == 4'b1110) ? id_pc_out : ex_aluResult; 

assign hlt = &wb_opcode;


// Instantiate Register File
RegisterFile RegFile(.clk(clk), .rst(~rst_n), .SrcReg1(id_src_register1), 
		    .SrcReg2(id_src_register2), .DstReg(wb_dst_register),  
		    .WriteReg(wb_writeback_register), .DstData(wb_mem_alu_sel_data), 
		    .SrcData1(id_read_data1), .SrcData2(id_read_data2));


/////////////////
// Sign Extend //
/////////////////
assign id_se_offset = {{12{id_instr[3]}}, id_instr[3:0] << 1'b1};

/////////////////////////
// Control Logic Block //
/////////////////////////

// only stores write to memory
assign ID_EX_MemWrite_in = (id_opcode == 4'b1001);

// SW, B, BR, HLT are the only instructions that do not write to a register
assign ID_EX_RegWrite_in = ~(id_opcode == 4'b1001 | id_opcode == 4'b1100 | id_opcode == 4'b1101 | id_opcode == 4'b1111);

// only loads read from memory
assign ID_EX_MemRead_in = (id_opcode == 4'b1000);

wire br_cnt_out;
dff br_cnt(.q(br_cnt_out), .d(ID_EX_Branch_in), .wen(1'b1), .clk(clk), .rst(~rst_n));

assign ID_EX_Branch_in = ((id_opcode[3:1] == 3'b110) &  (id_instr[11:9] != 3'b111) & br_cnt_out != 1'b1);

// propogate these control values for instructions later in the pipeline
assign EX_MEM_MemWrite_in = ID_EX_MemWrite_out;
assign EX_MEM_RegWrite_in = ID_EX_RegWrite_out;
assign MEM_WB_RegWrite_in = EX_MEM_RegWrite_out;

// Each stage in pipeline needs to know at least one of three register values: Rs, Rt, and/or Rd

// propogate Rd register
// instr[11:8] for all instructions except LW, SW, B, BR, HLT
assign id_dst_register = ~(id_opcode[3:1] == 3'b100 | id_opcode == 4'b1100 | id_opcode == 4'b1101 | id_opcode == 4'b1111) ?
			   id_instr[11:8] : 4'b0000;

// propogate Rt register
// instr[3:0] for ADD, SUB, XOR, RED, PADDSB
// instr[11:8] for LW, SW
assign id_src_register2 = (id_opcode[3:1] == 3'b100) ?  id_instr[11:8] :
			 ((id_opcode[3:2] == 2'b00 | id_opcode == 4'b0111) ? id_instr[3:0] : 4'b0000);

// propogate Rs register
// instr[7:4] for ADD. SUB, XOR, RED, SLL, SRA, ROR, PADDSB, LW, SW, BR
// read reg = dest reg for LLB and LHB.
assign id_src_register1 = (id_opcode[3] == 1'b0 | id_opcode[3:1] == 3'b100 | id_opcode == 4'b1101) ? id_instr[7:4] : 
			  ((id_opcode[3:1] == 3'b101) ? id_instr[11:8] : 4'b0000);

//////////////////
// ID / EX Flop //
//////////////////

// Flush Wires
wire ID_EX_MemWrite_in_check_flush;
wire ID_EX_RegWrite_in_check_flush;
wire ID_EX_MemRead_in_check_flush;
wire [3:0] id_src_register1_check_flush;
wire [3:0] id_src_register2_check_flush;
wire [15:0] id_read_data1_check_flush;
wire [15:0] id_read_data2_check_flush;
wire [15:0] id_se_offset_check_flush;
wire [15:0] id_instr_check_flush;
wire [15:0] id_pc_for_pcs_check_flush;
wire [3:0] id_dst_register_check_flush;
wire bTaken_out;
// Flush Assignments
assign ID_EX_MemWrite_in_check_flush = (bTaken_out | ~stall_n) ? 1'b0 : ID_EX_MemWrite_in;
assign ID_EX_RegWrite_in_check_flush = (bTaken_out | ~stall_n) ? 1'b0 : ID_EX_RegWrite_in;
assign ID_EX_MemRead_in_check_flush = (bTaken_out | ~stall_n) ? 1'b0 : ID_EX_MemRead_in;
assign id_src_register1_check_flush = (bTaken_out | ~stall_n) ? 4'b0 : id_src_register1;
assign id_src_register2_check_flush = (bTaken_out | ~stall_n) ? 4'b0 : id_src_register2;
assign id_read_data1_check_flush = (bTaken_out | ~stall_n) ? 16'b0 : id_read_data1;
assign id_read_data2_check_flush = (bTaken_out | ~stall_n) ? 16'b0 : id_read_data2;
assign id_se_offset_check_flush = (bTaken_out | ~stall_n) ? 16'b0 : id_se_offset;
assign id_instr_check_flush = (bTaken_out | ~stall_n) ? 16'b0 : id_instr;
assign id_pc_for_pcs_check_flush = (bTaken_out | ~stall_n) ? 16'b0 : id_pc_for_pcs;
assign id_dst_register_check_flush = (bTaken_out | ~stall_n) ? 4'b0 : id_dst_register;


id_ex_flop ID_EX(.MemWrite_in(ID_EX_MemWrite_in_check_flush), .MemWrite_out(ID_EX_MemWrite_out), .RegWrite_in(ID_EX_RegWrite_in_check_flush), .RegWrite_out(ID_EX_RegWrite_out), 
		  .MemRead_in(ID_EX_MemRead_in_check_flush), .MemRead_out(ID_EX_MemRead_out), .src_reg1_in(id_src_register1_check_flush), 
		  .src_reg2_in(id_src_register2_check_flush), .src_reg1_out(ex_src_register1), .src_reg2_out(ex_src_register2), 
		  .read_data1_in(id_read_data1_check_flush), .read_data1_out(ex_read_data1), .read_data2_in(id_read_data2_check_flush), 
		  .read_data2_out(ex_read_data2), .sign_extend_16_in(id_se_offset), .sign_extend_16_out(ex_se_offset),
		  .instr_in(id_instr_check_flush), .instr_out(ex_instr), .dst_reg_in(id_dst_register_check_flush), .cache_stall_n(~cache_stall),
		  .dst_reg_out(ex_dst_register), .clk(clk), .rst_n(rst_n), .pcs_in(id_pc_for_pcs_check_flush), .pcs_out(ex_pc_for_pcs), .branch_in(bTaken), .branch_out(bTaken_out));

// mask lower bit for computing memory address for loads and stores
assign alu_input1 = (ex_opcode == 4'b1000 | ex_opcode == 4'b1001) ? (ex_read_data1 & 16'hfffe) : ex_read_data1;

////////////////
// RegDst Mux //
////////////////
// RegDst = Rd EXCEPT for loads and stores, which is Rt
assign reg_dst_mux = (ex_opcode[3:1] == 3'b100) ? ex_src_register2 : ex_dst_register;

////////////////////////////
// LLB and LHB processing //
////////////////////////////
wire [15:0] load_byte_value;
assign load_byte_value = (ex_opcode == 4'b1010) ? (ex_read_data1 & 16'hff00) | ex_instr[7:0] :
		         (ex_opcode == 4'b1011) ? (ex_read_data1 & 16'h00ff) | (ex_instr[7:0] << 4'h8) : 16'h0000; 

////////////////////////////////////
// FORWARDING MUX SELECTION TABLE //
////////////////////////////////////

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

wire [1:0] fwdA_sel, fwdB_sel;
wire fwdMem_sel;

forward fwd(.id_ex_rs(ex_src_register1), .id_ex_rt(ex_src_register2), .ex_mem_rd(mem_dst_register), .mem_wb_rd(wb_dst_register), 
		   .ex_mem_regWrite(EX_MEM_RegWrite_out), .mem_wb_regWrite(MEM_WB_RegWrite_out), .ex_mem_rt(mem_src_register2), .ex_mem_memWrite(EX_MEM_MemWrite_out), 
                   .fwdA_ex(fwdA_sel), .fwdB_ex(fwdB_sel), .fwd_mem(fwdMem_sel), .id_ex_opcode(ex_opcode), .ex_mem_opcode(mem_opcode));

// Mux A is for src_register1 (Rs)
reg [15:0] alu_operand1;
reg fwdA_Error;
always @* case (fwdA_sel)
    2'b10   : alu_operand1 = mem_opcode[3:1] == 3'b101 ? mem_read_data1 : mem_aluResult;
    2'b01   : alu_operand1 = wb_mem_alu_sel_data;
    2'b11   : alu_operand1 = alu_input1;
    2'b00   : alu_operand1 = alu_input1;
    default : fwdA_Error = 1'b1;
endcase

// Duplicate Mux A for LLB and LHB instructions
reg [15:0] ex_load_byte_val;
reg fwdA_LLB_ERROR;
always @* case (fwdA_sel)
    2'b10   : ex_load_byte_val = mem_read_data1 | load_byte_value;
    2'b01   : ex_load_byte_val = wb_mem_alu_sel_data | load_byte_value;
    2'b11   : ex_load_byte_val = load_byte_value;
    2'b00   : ex_load_byte_val = load_byte_value;
    default : fwdA_LLB_ERROR = 1'b1;
endcase

// Mux B is for src_register2 (Rt)
reg [15:0] alu_operand2;
reg fwdB_error;
always @* case (fwdB_sel)
    2'b10   : alu_operand2 = mem_opcode[3:1] == 3'b101 ? mem_read_data1 : mem_aluResult;
    2'b01   : alu_operand2 = wb_mem_alu_sel_data;
    2'b00   : alu_operand2 = ex_alu_input2;
    2'b11   : alu_operand2 = ex_alu_input2;
    default : fwdB_error = 1'b1;
endcase

/////////
// ALU //
/////////

// Setup ALU inputs
// choose sign extended immediate for lw and sw
// choose unsigned immediate for sll, sra, and ror
// else choose contents of rt
assign ex_alu_input2 = (ex_opcode == 4'b1000 | ex_opcode == 4'b1001) ? ex_se_offset 
		: (ex_opcode == 4'b0100 | ex_opcode == 4'b0101 | ex_opcode == 4'b0110) ? {{12{1'b0}}, ex_instr[3:0]}
		: ex_read_data2;

// LW and SW will just be addition		assign alu_input2 = read_data2; // TODO Add stuff for immediate
assign ALUOp = (ex_opcode == 4'b1000 | ex_opcode == 4'b1001) ? 4'b0000 : ex_opcode[3:0];

wire [15:0] alu_input2, read_data2;
assign alu_input2 = (ex_opcode == 4'b1000 | ex_opcode == 4'b1001) ? ex_se_offset : alu_operand2;
assign read_data2 = ((ex_opcode == 4'b1001 & wb_opcode[3:1] == 3'b101) & (ex_instr[11:8] == wb_instr[11:8])) ? alu_operand2 : ex_read_data2;

// Instantiate ALU
ALU alu0(.ALU_Out(ex_aluResult), .Error(ALUerror), .ALU_In1(alu_operand1), .ALU_In2(alu_input2), .opcode(ALUOp), .F(F), .rst_n(rst_n), .clk(clk)); 

///////////////////
// EX / MEM Flop //
///////////////////
//wire [15:0] mem_src_data2;
ex_mem_flop EX_MEM(.MemWrite_in(EX_MEM_MemWrite_in), .MemWrite_out(EX_MEM_MemWrite_out), .RegWrite_in(EX_MEM_RegWrite_in), .RegWrite_out(EX_MEM_RegWrite_out), 
		   .reg_dst_mux_in(ex_dst_register), .reg_dst_mux_out(mem_reg_dst_mux),
		   .alu_output_in(ex_aluResult), .alu_output_out(mem_aluResult), .alu_src2_in(alu_operand2), .alu_src2_out(mem_alu_input2),
		   .clk(clk), .rst_n(rst_n), .instr_in(ex_instr), .instr_out(mem_instr), .dst_reg_in(reg_dst_mux), .dst_reg_out(mem_dst_register),   // TODO Could get rid of instr_in
		   .reg_src2_in(ex_src_register2), .reg_src2_out(mem_src_register2), .src2_data_in(read_data2),  .src2_data_out(mem_read_data2), // TODO: Fix for Mem-to-Mem forwarding
		   .src_data_1_in(ex_load_byte_val), .src_data_1_out(mem_read_data1), .pcs_in(ex_pc_for_pcs), .pcs_out(mem_pc_for_pcs), .cache_stall_n(~cache_stall));     

///////////////////////////////
// Mem-to-Mem Forwarding Mux //
///////////////////////////////
wire [15:0] mem_data_val;
assign mem_data_val = fwdMem_sel ? (memRead ? wb_lw_dst_data : wb_aluResult) : mem_read_data2;

/////////////////
// Data Memory //
/////////////////
CLA_16bit default_adder(.A({{12{ex_instr[3]}}, ex_instr[3:0] << 1'b1}), .B(ex_read_data1), .C_in(1'b0), .S(memAddr), .Ovfl(data_mem_overflow));



/////////////
// D cache //
/////////////
wire [15:0] data_cache_data_out;
cache data_cache ( .wr_data_in(mem_data_val), .data_out(data_cache_data_out), .address_in(mem_aluResult), .w_en(EX_MEM_MemWrite_out & ~instr_mem_request), .fsm_busy(data_fsm_busy), 
		.memory_address(data_cache_to_mem_address), .memory_data(mem_to_cache), .memory_data_valid(data_valid), 
		.memory_request(data_mem_request), .enable(~instr_mem_request & (EX_MEM_MemWrite_out | mem_opcode == 4'b1000)), .clk(clk), .rst_n(rst_n));

assign mem_addr = instr_mem_request ? instr_cache_to_mem_address : data_mem_request ? data_cache_to_mem_address : mem_aluResult;

// Instantiate Data Memory
// TODO mem_read_data2 isn't right
//memory1c data_memory(.data_out(mem_lw_dst_data), .data_in(mem_data_val), .addr(mem_aluResult), .enable(1'b1), .wr(mem_opcode[0]), .clk(clk), .rst(~rst_n));
memory4c main_memory(.data_out(mem_to_cache), .data_in(mem_data_val), .addr(mem_addr), .enable(1'b1), .wr(EX_MEM_MemWrite_out & ~data_fsm_busy & ~instr_fsm_busy), 
		    .clk(clk), .rst(~rst_n), .data_valid(data_valid));


///////////////////
// MEM / WB Flop //
///////////////////
mem_wb_flop MEM_WB(.RegWrite_in(MEM_WB_RegWrite_in), .RegWrite_out(MEM_WB_RegWrite_out), .reg_dst_mux_in(mem_reg_dst_mux), .reg_dst_mux_out(wb_reg_dst_mux), //TODO Delete reg dst mux in/out
		   .alu_output_in(mem_aluResult), .alu_output_out(wb_aluResult), .data_memory_in(data_cache_data_out), .data_memory_out(wb_lw_dst_data),
		   .clk(clk), .rst_n(rst_n), .instr_in(mem_instr), .instr_out(wb_instr), .dst_reg_in(mem_dst_register), .dst_reg_out(wb_dst_register),
                   .src_data_1_in(mem_read_data1), .src_data_1_out(wb_read_data1), .pcs_in(mem_pc_for_pcs), .pcs_out(wb_pc_for_pcs), .cache_stall_n(~cache_stall | hlt_special));

assign memRead = wb_opcode == 4'b1000;
//assign wb_load_byte_value =(wb_opcode == 4'b1010) ? (wb_read_data1 & 16'hff00) | wb_instr[7:0] :
//		       (wb_read_data1 & 16'h00ff) | (wb_instr[7:0] << 4'h8); 
assign wb_mem_alu_sel_data = (wb_opcode == 4'b1110) ? wb_pc_for_pcs : (((wb_opcode == 4'b1010) | wb_opcode == 4'b1011) ? wb_read_data1 : (memRead ? wb_lw_dst_data : wb_aluResult));
assign wb_writeback_register = ~(wb_opcode == 4'b1001 | wb_opcode == 4'b1100 | wb_opcode == 4'b1101 | wb_opcode == 4'b1111) & ~(wb_dst_register == 4'b0);



endmodule

