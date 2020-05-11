// TODO GET RID OF THIS FILE AND REPLACE WITH CLA
//////////////////////////////////////////
// 4-BIT RIPPLE CARRY ADDER //
////////////////////////////////////////

module addsub_4bit (Sum, Ovfl, A, B, sub); 

input [3:0] A, B; 	//Input values 
input sub; 		// add-sub indicator 
output [3:0] Sum; 	//sum output 
output Ovfl; 		//To indicate overflow 

wire co0, co1, co2, co3, addovfl, subovfl;

full_adder_1bit FA0(.a(A[0]), .b(B[0]), .sub(sub), .cin(sub), .cout(co0), .s(Sum[0]));
full_adder_1bit FA1(.a(A[1]), .b(B[1]), .sub(sub), .cin(co0), .cout(co1), .s(Sum[1]));
full_adder_1bit FA2(.a(A[2]), .b(B[2]), .sub(sub), .cin(co1), .cout(co2), .s(Sum[2]));
full_adder_1bit FA3(.a(A[3]), .b(B[3]), .sub(sub), .cin(co2), .cout(co3), .s(Sum[3]));


assign Ovfl = co2 ^ co3;
//assign subovfl = ;
//assign schk1 = A[3] ~^ B[3];   	//Check if input signs match
//assign Ovfl = ~(schk1 & Sum[3]); //Check if sign of Sum matches with input signs

endmodule