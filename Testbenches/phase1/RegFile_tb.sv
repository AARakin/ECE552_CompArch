module regfile_tb();

// DUT Stim
logic clk_stm, rst_stm, Write_reg_stm;
logic [3:0] SrcReg1_stm, SrcReg2_stm, DstReg_stm; 
logic [15:0] DstData_stm;
wire [15:0] SrcData1_mon, SrcData2_mon;


RegisterFile RegFile(.clk(clk_stm), .rst(rst_stm), .SrcReg1(SrcReg1_stm), 
		    .SrcReg2(SrcReg2_stm), .DstReg(DstReg_stm), 
		    .WriteReg(Write_reg_stm), .DstData(DstData_stm), 
		    .SrcData1(SrcData1_mon), .SrcData2(SrcData2_mon));

initial begin
	clk_stm = 0;
end

always 
	#5 clk_stm = !clk_stm;

initial begin
	rst_stm = 1;
	Write_reg_stm = 0;

	DstData_stm = 16'hFACE;
	DstReg_stm = 4'h7;
	@(posedge clk_stm);
	rst_stm = 0;
	Write_reg_stm = 1;

	@(posedge clk_stm);
	// Write to a register and then read from it
	SrcReg1_stm = 4'h7;


//	// Test that clock forwarding works
	@(posedge clk_stm);
	Write_reg_stm = 0;
//	DstData_stm = 16'hF0CE;
//	DstReg_stm = 4'hA;
//	SrcReg2_stm = 4'hA;
//
//	@(posedge clk_stm);
//	SrcReg2_stm = 4'h7;

	$stop();

end


endmodule
