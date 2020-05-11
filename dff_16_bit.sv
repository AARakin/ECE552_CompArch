module dff_16bit (q, d, wen, clk, rst_n);

    output [15:0]  q; //DFF output
    input  [15:0]  d; //DFF input
    input 	   wen; //Write Enable
    input          clk; //Clock
    input          rst_n; //Reset_n (used synchronously)

dff dff0 (.q(q[0]),  .d(d[0]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff1 (.q(q[1]),  .d(d[1]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff2 (.q(q[2]),  .d(d[2]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff3 (.q(q[3]),  .d(d[3]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff4 (.q(q[4]),  .d(d[4]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff5 (.q(q[5]),  .d(d[5]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff6 (.q(q[6]),  .d(d[6]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff7 (.q(q[7]),  .d(d[7]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff8 (.q(q[8]),  .d(d[8]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff9 (.q(q[9]),  .d(d[9]),  .wen(wen), .clk(clk), .rst(~rst_n));
dff dff10(.q(q[10]), .d(d[10]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff11(.q(q[11]), .d(d[11]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff12(.q(q[12]), .d(d[12]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff13(.q(q[13]), .d(d[13]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff14(.q(q[14]), .d(d[14]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff15(.q(q[15]), .d(d[15]), .wen(wen), .clk(clk), .rst(~rst_n));

endmodule
