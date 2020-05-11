module flag_register(Reg_in, Reg_out, clk, rst_n, Wen);
/////////////////////////////////////////////////////////////
// Module for the flag registers			   //
// Module contains 3 bits for Zero, Overflow and Sign bits //
/////////////////////////////////////////////////////////////
input [2:0] Reg_in;
input [2:0] Wen;
input clk, rst_n;
output [2:0] Reg_out;


dff flag_dff0(.q(Reg_out[0]), .d(Reg_in[0]), .wen(Wen[0]), .clk(clk), .rst(~rst_n));
dff flag_dff1(.q(Reg_out[1]), .d(Reg_in[1]), .wen(Wen[1]), .clk(clk), .rst(~rst_n));
dff flag_dff2(.q(Reg_out[2]), .d(Reg_in[2]), .wen(Wen[2]), .clk(clk), .rst(~rst_n));

endmodule
