module WriteDecoder_4_16(input [3:0] RegId, input WriteReg, output [15:0] Wordline);

	wire [15:0] shift_value;

	Shifter shifterWriteDecoder(.Shift_Out(shift_value), .Shift_In(16'b01), .Shift_Val(RegId), .Mode(1'b0));

	assign Wordline = (WriteReg) ? shift_value : 16'b0;

endmodule
