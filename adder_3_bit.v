module adder_3_bit(sum, A, B, ovfl_out);

input [2:0] A;
input [2:0] B;
output [2:0] sum;
output ovfl_out;

wire [2:0] ovfl;

full_adder_1bit add1(.a(A[0]), .b(B[0]), .sub(1'b0), .cin(1'b0), .cout(ovfl[0]), .s(sum[0]));
full_adder_1bit add2(.a(A[1]), .b(B[1]), .sub(1'b0), .cin(ovfl[0]), .cout(ovfl[1]), .s(sum[1]) );
full_adder_1bit add3(.a(A[2]), .b(B[2]), .sub(1'b0), .cin(ovfl[1]), .cout(ovfl[2]), .s(sum[2]) );

assign ovfl_out = ovfl[2];

endmodule
