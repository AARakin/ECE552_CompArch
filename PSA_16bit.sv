module PSA_16bit (Res, A, B);
input [15:0] A, B; // Input data values
output [15:0]  Res; // Sum output

wire [15:0] Sum, Saturated_Val;
wire [3:0] c_out, ovfl;
wire [3:0] P_out, G_out;


CLA_4bit CLA1(.A(A[3:0]), .B(B[3:0]), .C_in(1'b0), 
	 .P_out(P_out[0]), .G_out(G_out[0]), .S(Sum[3:0]), .C_out(c_out[0]), .Ovfl(ovfl[0]));
CLA_4bit CLA2(.A(A[7:4]), .B(B[7:4]), .C_in(1'b0), 
	 .P_out(P_out[1]), .G_out(G_out[1]), .S(Sum[7:4]), .C_out(c_out[1]), .Ovfl(ovfl[1]));
CLA_4bit CLA3(.A(A[11:8]), .B(B[11:8]), .C_in(1'b0), 
	 .P_out(P_out[2]), .G_out(G_out[2]), .S(Sum[11:8]), .C_out(c_out[2]), .Ovfl(ovfl[2]));
CLA_4bit CLA4(.A(A[15:12]), .B(B[15:12]), .C_in(1'b0), 
	 .P_out(P_out[3]), .G_out(G_out[3]), .S(Sum[15:12]), .C_out(c_out[3]), .Ovfl(ovfl[3]));

// Assert Error if any sub-word generates a carry
assign Saturated_Val[3:0] = A[3]? 4'h8:4'h7;    //0x8 is most negative and 0x7 is most positive 4 bit num
assign Saturated_Val[7:4] = A[7]? 4'h8:4'h7;
assign Saturated_Val[11:8] = A[11]? 4'h8:4'h7;
assign Saturated_Val[15:12] = A[15]? 4'h8:4'h7;

//For PSA if there is overflow sum should saturate for -2^3 or 2^3-1
assign Res[3:0] = ovfl[0]? Saturated_Val[3:0]:Sum[3:0];
assign Res[7:4] = ovfl[1]? Saturated_Val[7:4]:Sum[7:4];
assign Res[11:8] = ovfl[2]? Saturated_Val[11:8]:Sum[11:8];
assign Res[15:12] = ovfl[3]? Saturated_Val[15:12]:Sum[15:12];


endmodule
