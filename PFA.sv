module PFA(A, B, C, P, G, S);
input A, B, C;
output P, G, S;

wire w1;

assign G = A & B;
assign w1 = A ^ B;
assign S = w1 ^ C;
assign P = w1;

endmodule
