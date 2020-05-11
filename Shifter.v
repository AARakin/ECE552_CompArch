
module Shifter (Shift_Out, Shift_In, Shift_Val, Mode);
input [15:0] Shift_In; 		// This is the input data to perform shift operation on
input [3:0] Shift_Val; 		// Shift amount (used to shift the input data)
input  Mode; 			// To indicate 0=SLL or 1=SRA 
output [15:0] Shift_Out; 	// Shifted output data

wire[15:0] stage1, stage2, stage3;

assign stage1 = Shift_Val[0]?{(Mode?{Shift_In[15], Shift_In[15:1]} : {Shift_In<<1})}: Shift_In;
assign stage2 = Shift_Val[1]?{(Mode?{{2{stage1[15]}}, stage1[15:2]} : {stage1<<2})}: stage1;
assign stage3 = Shift_Val[2]?{(Mode?{{4{stage2[15]}}, stage2[15:4]} : {stage2<<4})}: stage2;
assign Shift_Out = Shift_Val[3]?{(Mode?{{8{stage3[15]}}, stage3[15:8]} : {stage3<<8})}: stage3;

endmodule
