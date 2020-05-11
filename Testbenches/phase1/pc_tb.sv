module pc_tb();
/////////////////////////////////
// This module tests the PC    //
// and all of the instructions //
/////////////////////////////////
logic clk_stm;
logic rst_n;
logic hlt_stm;
logic [15:0] pc_mon;


cpu cpu1(.clk(clk_stm), .rst_n(rst_n), .hlt(hlt_stm), .pc(pc_mon));

initial begin
	clk_stm = 1'b0;
end

always 
	#5 clk_stm = ~clk_stm;

initial begin
	rst_n = 0;
	hlt_stm = 0;
	force cpu1.instr = 16'b0;
	repeat (2) @(posedge clk_stm);	
	@(posedge clk_stm) rst_n = 1;

	// wait here and watch PC increment every 5ns
	repeat (2) @(posedge clk_stm);

	hlt_stm = 1;

end

endmodule
