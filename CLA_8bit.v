module CLA_8bit(A, B, C_in, S, Cout, Ovfl);

input [7:0] A, B;
input C_in;
output [7:0] S;
output Ovfl, Cout;

wire DC1, DC2, DC3;    //Don't care wires for 3 Least Sig CLA's
wire CO3;
wire CI4; 
wire G4, P4;

assign CI4 = G4 | (P4&CO3);

CLA_4bit CLA_3_0(.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .S(S[3:0]), .P_out(P4), .G_out(G4), .C_out(CO3), .Ovfl(DC1));
CLA_4bit CLA_7_4(.A(A[7:4]), .B(B[7:4]), .C_in(CI4), .S(S[7:4]), .P_out(DC2), .G_out(DC3), .C_out(Cout), .Ovfl(Ovfl));

endmodule
