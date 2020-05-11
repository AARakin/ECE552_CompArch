module CLA_16bit(A, B, C_in, S, Ovfl);
input [15:0] A, B;
input C_in;
output [15:0] S;
output Ovfl;


wire DC1, DC2, DC3;    //Don't care wires for 3 Least Sig CLA's
wire CO3, CO7, CO11, CO15;
wire CI4, CI8, CI12; 
wire G4, G8, G12, G15, P4, P8, P12, P15;

assign CI4 = G4 | (P4&CO3);
assign CI8 = G8 | (P8&CO7);
assign CI12 = G12 | (P12&CO11);

CLA_4bit CLA_3_0(.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .S(S[3:0]), .P_out(P4), .G_out(G4), .C_out(CO3), .Ovfl(DC1));
CLA_4bit CLA_7_4(.A(A[7:4]), .B(B[7:4]), .C_in(CI4), .S(S[7:4]), .P_out(P8), .G_out(G8), .C_out(CO7), .Ovfl(DC2));
CLA_4bit CLA_11_8(.A(A[11:8]), .B(B[11:8]), .C_in(CI8), .S(S[11:8]), .P_out(P12), .G_out(G12), .C_out(CO11), .Ovfl(DC3));
CLA_4bit CLA_15_12(.A(A[15:12]), .B(B[15:12]), .C_in(CI12), .S(S[15:12]), .P_out(P15), .G_out(G15), .C_out(CO15), .Ovfl(Ovfl));


endmodule
