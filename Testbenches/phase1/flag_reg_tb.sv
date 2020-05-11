module flag_reg_tb();


// Internal Signals
logic [2:0] Reg_in_stm, Reg_out_mon, Wen_stm;
logic clk, rst_n;

flag_register flag_register0(.Reg_in(Reg_in_stm), .Reg_out(Reg_out_mon), .clk(clk), .rst_n(rst_n), .Wen(Wen_stm));

initial clk = 0;

always 
	#5 clk = ~clk;

initial begin
	rst_n = 0;
	#10;
	rst_n = 1;
	Wen_stm = 3'b001;
	Reg_in_stm = 3'b111;
	repeat (2) @(posedge clk);
	

	if (Reg_out_mon !== 3'b001) begin
		$display("ERROR: FLAG NOT SET CORRECTLY");
		$stop;
	end
	

	Wen_stm = 3'b100;
	Reg_in_stm = 3'b111;
	repeat (2) @(posedge clk);

	if (Reg_out_mon !== 3'b101) begin
		$display("ERROR: FLAG NOT SET CORRECTLY");
		$stop;
	end
	rst_n =0;

	
	$display("Success!");
	$stop;



end


endmodule
