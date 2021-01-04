`default_nettype none
`timescale 100ns / 10ns
//`include "top.v"

module top_tb();

parameter DURATION = 528000; // 8000 * 66ns

reg clk_16=1;
always #31.25 clk_16 = ~clk_16; // 16MHz

wire resx, dcx, bl, csx, sda, scl, usbpu;

top UUT(
  .RESX(resx),
  .DCX(dcx),
  .BL(bl),
  .CSX(csx),
  .SDA(sda),
  .SCL(scl),
  .USBPU(usbpu),
  .CLK(clk_16));

initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);
    #(DURATION) $display("end of sim");
    $finish;
end

endmodule
