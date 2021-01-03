// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    output CSX, // chip select, active low
    output SDA, // serial data
    output SCL, // serial clock max period 66ns
    output RESX, // reset, active low
    // User/boot LED next to power LED
    output USBPU, // USB pull-up resistor
    input CLK     // 16MHz clock, period 62.5 ns
);
    localparam  LEAD_IN = 6;
    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;
    reg RESX = 1;
    reg CSX = 1;
    reg SCL = 0;
    reg SDA = 0;
    reg [5:0] counter = 0;
    reg [4:0] index = 0;
    reg [17:0] rgb = 18'b100000111000110001;

    // increment the blink_counter every clock
    always @(posedge CLK) begin
      if(CSX == 0) SCL = ~SCL;
      if(counter == 2) RESX = 0;
      if(counter == LEAD_IN-2) RESX = 1;
      if(counter == LEAD_IN) CSX <= 0;
      if(index > 17) CSX <= 1;
      if(counter >= LEAD_IN) begin
        index = counter[5:1] - 3;
        if(counter % 2 == 0) SDA = rgb[index];
      end
      if(index > 17) begin
        SCL <= 0;
        SDA <= 0;
      end
      counter <= counter + 1;
    end

    // light up the LED according to the pattern
    //assign LED = blink_pattern[blink_counter[25:21]];
    //assign LED = clk_8;//blink_counter[2];
endmodule
