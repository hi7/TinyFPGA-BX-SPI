// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    output CSX,   // chip select, active low
    output SDA,   // serial data
    output SCL,   // serial clock max period 66ns
    output RESX,  // reset, active low
    output DCX,   // 1 => data / 0 => command
    output BL,    // backlight
    output USBPU, // USB pull-up resistor
    input CLK     // 16MHz clock, period 62.5 ns
);
    localparam LEAD_IN = 1000;
    localparam LENGTH = 18;
    localparam MSB = LENGTH - 1;
    reg init = 1;
    reg USBPU = 0; // drive USB pull-up resistor to '0' to disable USB
    reg RESX = 1;
    reg DCX = 1;
    reg BL = 0;
    reg SCL = 0;
    reg SDA = 0;
    reg [11:0] counter = 0;
    reg [10:0] index = 0;
    reg [MSB:0] rgb = 18'b100000111000110001;
    reg CSX = 1;

    always @(negedge CLK) begin
      CSX <= counter < LEAD_IN || counter > (LEAD_IN + MSB*2 + 1);
      if(counter >= LEAD_IN) begin
        index = counter[11:1] - (LEAD_IN / 2);
        if(counter % 2 == 0) SDA <= rgb[index];
      end
      if(counter > LEAD_IN + MSB*2 + 1) SDA <= 0;
    end

    always @(posedge CLK) begin
      if(CSX == 0 && counter <= (LEAD_IN + MSB*2 + 2)) SCL <= ~SCL;
      if(init == 1 && counter == 160) RESX <= 0;
      if(init == 1 && counter == 162) RESX <= 1;
      if(counter == LEAD_IN) begin
        init <= 0;
        BL <= 1;
      end
      counter <= counter + 1;
    end
endmodule
