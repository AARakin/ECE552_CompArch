// TODO GET RID OF THIS FILE AND REPLACE WITH CLA
//////////////////////////////////////////
// FULL ADDER 1 BIT //
////////////////////////////////////////

module full_adder_1bit (input a,input b, input cin, output s, output cout, input sub);

wire w1, w2, w3, w4;

assign w1 = sub ^ b;     // w1 is used for either b (add) or ~b(sub) 
assign w2 = a ^ w1; 
assign s = cin ^ w2;     //Find sum

assign w3 = a & w1;		//Check for carry
assign w4 = cin & w2;
assign cout = w3 | w4;

endmodule 
