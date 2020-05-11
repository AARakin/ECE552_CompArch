module decoder3to8(encoded, decoded);
	input [2:0] encoded;
	output reg [7:0] decoded;

	always @(*)
	case(encoded)
	3'd0   : decoded = 7'b1 << 1'd0;
	3'd1   : decoded = 7'b1 << 1'd1;
	3'd2   : decoded = 7'b1 << 2'd2;
	3'd3   : decoded = 7'b1 << 2'd3;
	3'd4   : decoded = 7'b1 << 3'd4;
	3'd5   : decoded = 7'b1 << 3'd5;
	3'd6   : decoded = 7'b1 << 3'd6;
	3'd7   : decoded = 7'b1 << 3'd7;

	endcase
endmodule
