`timescale 1ns/1ps

module ram_tb (
);
    
    reg clk;
    reg reset_n;
    reg rx_valid;
    reg [9:0] din;
    wire tx_valid;
    wire [7:0] dout;

    ram uut (
        .clk(clk),
        .reset_n(reset_n),
        .rx_valid(rx_valid),
        .din(din),
        .tx_valid(tx_valid),
        .dout(dout)
    );

    localparam t = 4;

    always begin
        clk = 0;
        #(t/2);
        clk = 1;
        #(t/2);
    end

    initial begin
        reset_n = 0;
        rx_valid = 0;
        din = 10'b0;
        #8 reset_n = 1;
        #8;
        #4 rx_valid = 1;
        din = 10'b0000000111;
        #8 rx_valid = 0;
        #8;
        #4 rx_valid = 1;
        din = 10'b0100000011;  // Write data 3 to address 7
        #8 rx_valid = 0;
        #8;
        #4 rx_valid = 1;
        din = 10'b1000000111;  // Read from address 7
        #16;
        din = 10'b0000000000;
        #36;
        din = 10'b1000000111;
        #8 rx_valid = 0;
        #16 $finish;
    end

endmodule
