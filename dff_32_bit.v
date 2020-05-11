module dff_32bit (q, d, wen, clk, rst_n);

    output [31:0]  q; //DFF output
    input  [31:0]  d; //DFF input
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
dff dff16(.q(q[16]), .d(d[16]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff17(.q(q[17]), .d(d[17]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff18(.q(q[18]), .d(d[18]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff19(.q(q[19]), .d(d[19]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff20(.q(q[20]), .d(d[20]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff21(.q(q[21]), .d(d[21]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff22(.q(q[22]), .d(d[22]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff23(.q(q[23]), .d(d[23]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff24(.q(q[24]), .d(d[24]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff25(.q(q[25]), .d(d[25]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff26(.q(q[26]), .d(d[26]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff27(.q(q[27]), .d(d[27]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff28(.q(q[28]), .d(d[28]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff29(.q(q[29]), .d(d[29]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff30(.q(q[30]), .d(d[30]), .wen(wen), .clk(clk), .rst(~rst_n));
dff dff31(.q(q[31]), .d(d[31]), .wen(wen), .clk(clk), .rst(~rst_n));



endmodule
