module uart #(
    parameter data_bits = 8, sb_tick = 16
) (
    input clk, reset_n;

    // receiver port
    input rx,
    output [data_bits - 1 : 0] r_data,
    output rx_done_tick,

    // transmitter port
    input [data_bits -1 : 0] t_data,
    output tx,
    output tx_done_tick;
    

    // baud rate generator
    input [10 : 0] timer_final_value
);

    // baud rate generator using a timer
    wire tick;
    timer #(.bits(11)) baud_rate_generator (
        .clk(clk),
        .reset_n(reset_n),
        .en(1),
        .final_value(timer_final_value),
        .done(tick)
    );

    // receiver
    uart_rx #(.data_bits(data_bits), .sb_tick(sb_tick)) receiver (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .s_tick(tick),
        .rx_done_tick(rx_done_tick),
        .rx_dout(r_data)
    );

    // transmitter
    uart_tx #(.data_bits(data_bits), .sb_tick(sb_tick)) transmitter (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(1),
        .s_tick(tick),
        .tx_din(t_data),
        .tx(tx)
    );
    
endmodule