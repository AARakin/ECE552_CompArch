module RegisterFile(
	input clk, 		
	input rst, 
	input [3:0] SrcReg1, 	// Source Register 1 for Reads
	input [3:0] SrcReg2, 	// Source Register 2 for Reads
	input [3:0] DstReg,  	// Destination Register for Writes
	input WriteReg,      	// WriteReg = 0 -> Don't write WriteReg = 1 -> WriteReg 
	input [15:0] DstData,	// Where should I write 
	output [15:0] SrcData1, 	// Value read from 
	output [15:0] SrcData2
);

wire [15:0] wordline_1, wordline_2, write_line;
wire [15:0] tempData1, tempData2;

// RF bypassing
// write-before-read bypassing logic
// if reading from the same register written to, then SrcData = DstData
assign SrcData1 = (SrcReg1 == DstReg) ? DstData : tempData1;
assign SrcData2 = (SrcReg2 == DstReg) ? DstData : tempData2;

// assign SrcData1 = tempData1;
// assign SrcData2 = tempData2;

WriteDecoder_4_16 WD_1(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(write_line));
ReadDecoder_4_16 RD_1(.RegId(SrcReg1), .Wordline(wordline_1));
ReadDecoder_4_16 RD_2(.RegId(SrcReg2), .Wordline(wordline_2));

Register reg0( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[0]), 
	       .ReadEnable1(wordline_1[0]), .ReadEnable2(wordline_2[0]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg1( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[1]), 
	       .ReadEnable1(wordline_1[1]), .ReadEnable2(wordline_2[1]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg2( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[2]), 
	       .ReadEnable1(wordline_1[2]), .ReadEnable2(wordline_2[2]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg3( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[3]), 
	       .ReadEnable1(wordline_1[3]), .ReadEnable2(wordline_2[3]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg4( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[4]), 
	       .ReadEnable1(wordline_1[4]), .ReadEnable2(wordline_2[4]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg5( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[5]), 
	       .ReadEnable1(wordline_1[5]), .ReadEnable2(wordline_2[5]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg6( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[6]), 
	       .ReadEnable1(wordline_1[6]), .ReadEnable2(wordline_2[6]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg7( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[7]), 
	       .ReadEnable1(wordline_1[7]), .ReadEnable2(wordline_2[7]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg8( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[8]), 
	       .ReadEnable1(wordline_1[8]), .ReadEnable2(wordline_2[8]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg9( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[9]), 
	       .ReadEnable1(wordline_1[9]), .ReadEnable2(wordline_2[9]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg10( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[10]), 
	       .ReadEnable1(wordline_1[10]), .ReadEnable2(wordline_2[10]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg11( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[11]), 
	       .ReadEnable1(wordline_1[11]), .ReadEnable2(wordline_2[11]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg12( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[12]), 
	       .ReadEnable1(wordline_1[12]), .ReadEnable2(wordline_2[12]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg13( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[13]), 
	       .ReadEnable1(wordline_1[13]), .ReadEnable2(wordline_2[13]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg14( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[14]), 
	       .ReadEnable1(wordline_1[14]), .ReadEnable2(wordline_2[14]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 
Register reg15( .clk(clk), .rst(rst), .D(DstData), .WriteReg(write_line[15]), 
	       .ReadEnable1(wordline_1[15]), .ReadEnable2(wordline_2[15]), 
	       .Bitline1(tempData1), .Bitline2(tempData2)); 

endmodule
