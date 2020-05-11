module CLA_4bit(A, B, C_in, S, P_out, G_out, C_out, Ovfl);
input [3:0] A, B;
input C_in;
output [3:0] S;
output P_out, G_out, C_out;
output Ovfl;

wire [3:0] P, G;
wire and1, and2, and3, and4, and5, and6, and7, and8, and9, and10;
wire C1, C2, C3;

PFA PFA0(.A(A[0]), .B(B[0]), .C(C_in),   .P(P[0]), .G(G[0]), .S(S[0]));
PFA PFA1(.A(A[1]), .B(B[1]), .C(C1), .P(P[1]), .G(G[1]), .S(S[1]));
PFA PFA2(.A(A[2]), .B(B[2]), .C(C2), .P(P[2]), .G(G[2]), .S(S[2]));
PFA PFA3(.A(A[3]), .B(B[3]), .C(C3), .P(P[3]), .G(G[3]), .S(S[3]));

// Logic block for the first PFA
assign and1 = C_in & P[0];
assign C1 = and1 | G[0];

// Logic block for 2nd PFA
assign and2 = G[0] & P[1];
assign and3 = (P[1] & P[0]) & C_in;
assign C2 = (and2 | and3)| G[1];

// 3rd PFA
assign and4 = P[2] & G[1];
assign and5 = (P[2] & P[1]) & G[0];
assign and6 = ((P[2] & P[1]) & P[0]) & C_in;
assign C3  = (((and4 | and5) | and6) | G[2]);

assign P_out  = ((P[3] & P[2]) & P[1]) & P[0]; // P = and7, but save space
assign and8  = P[3] & G[2];
assign and9  = (P[3] & P[2]) & G[1];
assign and10 = ((P[3] & P[2]) & P[1]) & G[0];

assign G_out = ((G[3] | and8) | and9) | and10;

assign C_out = (P[3] & C3) | G[3];

assign Ovfl = C_out ^ C3;

endmodule
