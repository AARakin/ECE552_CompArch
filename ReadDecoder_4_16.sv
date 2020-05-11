module ReadDecoder_4_16(input [3:0] RegId, output [15:0] Wordline);

	wire [15:0] shift_value;
	Shifter shifterWriteDecoder(.Shift_Out(Wordline), .Shift_In(16'b01), .Shift_Val(RegId), .Mode(1'b0));


endmodule
