module RED_16bit (Sum, Error, A, B);

input [15:0] A, B; 	// Input data values
output [15:0] Sum; 	// Sum output
output Error; 	// To indicate overflows

wire [2:0] c_out;
wire [8:0] ac_sum, bd_sum;
wire [11:0] tmp_sum;

// don't care wires
wire p1, g1, ov1, p2, g2, ov2, p3, g3, ov3, dc_ov1, dc_ov2;

CLA_8bit a_plus_c(.A(A[15:8]), .B(B[15:8]), .C_in(1'b0), .S(ac_sum[7:0]), .Cout(ac_sum[8]), .Ovfl(dc_ov1));
CLA_8bit b_plus_d(.A(A[7:0]), .B(B[7:0]), .C_in(1'b0), .S(bd_sum[7:0]), .Cout(bd_sum[8]), .Ovfl(dc_ov2));

// final addition is 3 4-bit CLAs
CLA_4bit tmp_sum_3_0(.A(ac_sum[3:0]), .B(bd_sum[3:0]), .C_in(1'b0), .S(tmp_sum[3:0]), .P_out(p1), .G_out(g1), .C_out(c_out[0]), .Ovfl(ov1));
CLA_4bit tmp_sum_7_4(.A(ac_sum[7:4]), .B(bd_sum[7:4]), .C_in(c_out[0]), .S(tmp_sum[7:4]), .P_out(p2), .G_out(g2), .C_out(c_out[1]), .Ovfl(ov2));
CLA_4bit tmp_sum_11_8(.A({{3{1'b0}}, ac_sum[8]}), .B({{3{1'b0}}, bd_sum[8]}), .C_in(c_out[1]), .S(tmp_sum[11:8]), .P_out(p3), .G_out(g3), .C_out(c_out[2]), .Ovfl(ov3));

// sign extend sum
assign Sum = {{6{tmp_sum[9]}}, tmp_sum[9:0]};

assign Error = | c_out;

endmodule
