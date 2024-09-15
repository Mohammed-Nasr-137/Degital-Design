module wrapper (
    input MOSI, SS_n, clk, reset_n,
    output MISO
);

    wire rx_valid, tx_valid;
    wire [7:0] tx_data;
    wire [9:0] rx_data;
    
    slave slave (
        .clk(clk),
        .reset_n(reset_n),
        .MOSI(MOSI),
        .MISO(MISO),
        .tx_valid(tx_valid),
        .SS_n(SS_n),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    ram ram (
        .clk(clk),
        .reset_n(reset_n),
        .rx_valid(rx_valid),
        .din(din),
        .tx_valid(tx_valid),
        .dout(dout)
    );

endmodule