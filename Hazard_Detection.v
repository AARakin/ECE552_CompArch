module hazard_detection(if_id_rs, if_id_rt, id_ex_rd, ex_mem_rd, if_id_branch, id_ex_regWrite, ex_mem_regWrite, id_ex_memRead, if_id_memWrite,
			load_to_stall, brstall); 

input [3:0] if_id_rs, if_id_rt, id_ex_rd, ex_mem_rd;

input if_id_branch, id_ex_regWrite, ex_mem_regWrite, id_ex_memRead, if_id_memWrite;

output load_to_stall, brstall; //


/* FROM HW4 Solutions  Load-To-Use Stall
if ( ID/EX.MemRead and (ID/EX.RegisterRd ? 0) and ( (ID/EX.RegisterRd = IF/ID.RegisterRs) or ((ID/EX.RegisterRd = IF/ID.RegisterRt)  and not IF/ID.MemWrite))
) enable load-to-use stall; */

assign load_to_stall =  id_ex_memRead & (id_ex_rd != 4'h0) & ((id_ex_rd == if_id_rs) | ((id_ex_rd == if_id_rt) & ~if_id_memWrite)) ;

assign brstall =  if_id_branch; //& ( ( id_ex_regWrite & (id_ex_rd == if_id_rs)  & (id_ex_rd != 4'h0) ) | 
				   //( ex_mem_regWrite & (ex_mem_rd == if_id_rs) & (ex_mem_rd != 4'h0) )  );
				

//TODO Control Hazards!!!


/* FROM HW4 Solutions MEM-to-MEM Forwarding
	if ( EX/MEM.MemWrite and MEM/WB.RegWrite and (MEM/WB.RegisterRd ? 0) and (MEM/WB.RegisterRd = EX/MEM.RegisterRt)) 
	enable MEM-to-MEM forwarding;
*/

/*assign mem_to_mem = ( ex_memWrite & mem_regWrite & ~(mem_dst_reg == 0) & (mem_dst_reg == ex_src_register2));

/* FROM 2018 Mdterm Solutions
	*/

//	assign ex_to_ex_src1 = ( ex_regWrite & ~(ex_dst_reg == 0) & (ex_dst_reg == id_src_register1));
//	
//	assign ex_to_ex_src2 = ( ex_regWrite & ~(ex_dst_reg == 0) & (ex_dst_reg == id_src_register2));
//	
//	assign mem_to_ex_src1 = ( mem_regWrite & ~(mem_dst_reg == 0) & ~(ex_dst_reg == id_src_register1) & (mem_dst_reg == id_src_register1));
//	
//	assign mem_to_ex_src2 = ( mem_regWrite & ~(mem_dst_reg == 0) & ~(ex_dst_reg == id_src_register2) & (mem_dst_reg == id_src_register2));
//

endmodule
