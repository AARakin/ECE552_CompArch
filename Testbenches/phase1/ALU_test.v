//////////////////////////////////////////
// ALU Test Bench //
////////////////////////////////////////

module ALU_test();

reg [3:0] A, B;
reg [1:0]OpCode;

wire [3:0] Res;
wire ERR;

reg [3:0] Real_ans;

ALU testALU(.ALU_Out(Res), .Error(ERR), .ALU_In1(A), .ALU_In2(B), .Opcode(OpCode)); 

integer i;  //iterator
initial begin
	OpCode = 2'b00;
	for (i=0; i<10; i=i+1) begin
	 A=$random%15; 
    	 B=$random%15;
	 assign Real_ans = ~(A&B); 
   		if (ERR == 1'b1) begin //Pos+Pos can't give Neg and Neg+Neg can't give Pos
		$display("ERROR: NAND operation can't give Error");
		$stop;
  		 end
   		else if (Real_ans != Res) begin
        	$display("ERROR: Expected %d NAND %d = %d, but received %d\n",A,B,Real_ans,Res);
        	$stop;
   		end 
	end
	
	OpCode = 2'b01;
	for (i=0; i<10; i=i+1) begin
	 A=$random%15; 
    	 B=$random%15;
	 assign Real_ans = A^B; 
   		if (ERR == 1'b1) begin //Pos+Pos can't give Neg and Neg+Neg can't give Pos
		$display("ERROR: XOR operation can't give Error");
		$stop;
  		 end
   		else if (Real_ans != Res) begin
        	$display("ERROR: Expected %d XOR %d = %d, but received %d\n",A,B,Real_ans,Res);
        	$stop;
   		end 
	end
	
	OpCode = 2'b10;
	for (i=0; i<10; i=i+1) begin
	 A=$random%15; 
    	 B=$random%15;
	 assign Real_ans = A+B; 
   		if (A[3] == B[3] && A[3] != Res[3] && ERR != 1'b1) begin //Pos+Pos can't give Neg and Neg+Neg can't give Pos
		$display("ERROR: Should have give Error for Overflow");
		$stop;
  		 end
   		else if (Real_ans != Res) begin
        	$display("ERROR: Expected %d XOR %d = %d, but received %d\n",A,B,Real_ans,Res);
        	$stop;
   		end 
	end

	OpCode = 2'b11;
	for (i=0; i<10; i=i+1) begin
	 A=$random%15; 
    	 B=$random%15;
	 assign Real_ans = A-B; 
   		if (A[3] != B[3] && A[3] != Res[3] && ERR != 1'b1) begin //Pos-Neg can't give Neg and Neg-Pos can't give Pos
		$display("ERROR: Should have give Error for Overflow");
		$stop;
  		 end
   		else if (Real_ans != Res) begin
        	$display("ERROR: Expected %d XOR %d = %d, but received %d\n",A,B,Real_ans,Res);
        	$stop;
   		end 
	end
end

endmodule
