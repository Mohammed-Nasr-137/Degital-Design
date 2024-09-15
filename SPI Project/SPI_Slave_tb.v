`timescale 1ns/1ps

module slave_tb (
);

    reg clk;
    reg reset_n;
    reg MOSI;
    reg SS_n;
    reg tx_valid;
    reg [7:0] tx_data;

    wire MISO;
    wire rx_valid;
    wire [9:0] rx_data;

    slave uut (
        .clk(clk),
        .reset_n(reset_n),
        .MOSI(MOSI),
        .SS_n(SS_n),
        .tx_valid(tx_valid),
        .tx_data(tx_data),
        .MISO(MISO),
        .rx_valid(rx_valid),
        .rx_data(rx_data)
    );

    localparam t = 4;

    always begin
        clk = 0;
        #(t/2);
        clk = 1;
        #(t/2);
    end

    initial begin
        // initializing
        reset_n = 0;
        MOSI = 0;
        SS_n = 1;
        tx_valid = 0;
        tx_data = 0;

        #8 reset_n = 1;

        // test for write address command
        #8 SS_n = 0;
        send_bits(10'b0000000001);
        #4 SS_n = 1;

        // test for write data command
        #8 SS_n = 0;
        send_bits(10'b0100000011);
        #4 SS_n = 1;

        // test for read_add command
        #8 SS_n = 0;
        send_bits(10'b1000000011);
        #4 SS_n = 1;

        // test for read_data command
        #8 SS_n = 0;
        tx_valid = 1;
        send_bits(10'b1100000011);
        tx_data = 8'b11001100;

        #80 $finish;
    end

    task send_bits;
        input [9:0] bits;
        integer i;
        begin
            for (i = 9; i >= 0; i = i-1) begin
                MOSI = bits[i];
                #4;
            end
        end
    endtask

endmodule
