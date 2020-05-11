module dff_3bit (q, d, wen, clk, rst_n);

    output [2:0]  q; //DFF output
    input  [2:0]  d; //DFF input
    input 	   wen; //Write Enable
    input          clk; //Clock
    input          rst_n; //Reset_n (used synchronously)

    dff dff0 (.q(q[0]),  .d(d[0]),  .wen(wen), .clk(clk), .rst(~rst_n));
    dff dff1 (.q(q[1]),  .d(d[1]),  .wen(wen), .clk(clk), .rst(~rst_n));
    dff dff2 (.q(q[2]),  .d(d[2]),  .wen(wen), .clk(clk), .rst(~rst_n));
    
endmodule
