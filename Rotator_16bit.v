
module Rotator(Shift_Out, Shift_In, Shift_Val);

input [15:0] Shift_In; 		// This is the input data to perform shift operation on
input [3:0] Shift_Val; 		// Shift amount (used to right rotate the input)
output [15:0] Shift_Out; 	// Shifted output data

wire[15:0] stage1, stage2, stage3;

assign stage1 = Shift_Val[0]?{Shift_In[0], Shift_In[15:1]}: Shift_In;
assign stage2 = Shift_Val[1]?{stage1[1:0], stage1[15:2]}: stage1;
assign stage3 = Shift_Val[2]?{stage2[3:0], stage2[15:4]}: stage2;
assign Shift_Out = Shift_Val[3]?{stage3[7:0], stage3[15:8]}: stage3;

endmodule
