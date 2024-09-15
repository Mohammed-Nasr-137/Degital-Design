module uart_rx #(
    parameter data_bits = 8,  // # of data bits
              sb_tick = 16    // # of stop bit ticks
) (
    input clk, reset_n, rx, s_tick,
    output reg rx_done_tick,
    output [data_bits - 1 : 0] rx_dout
);

    localparam idle = 0, start = 1, data = 2, stop = 3;

    reg [1:0] state_reg, state_next;
    reg [3:0] s_reg, s_next; // keep track of the baud rate ticks (16 total)
    reg [$clog2(data_bits) - 1 : 0] n_reg, n_next; // keep track of the # of data bits received
    reg [data_bits - 1 : 0] b_reg, b_next; // stores the received data bits
    
    // state and other registers
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            state_reg <= idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
        end
        else begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end
    end

    // next state logic
    always @(*) begin
        state_next = state_reg;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        rx_done_tick = 0;
        case (state_reg)
            idle:
                if (!rx) begin
                    s_next = 0;
                    state_next = start;
                end
            start:
                if (s_tick) begin
                    if (s_reg == 7) begin
                        s_next = 0;
                        n_next = 0;
                        state_next = data;
                    end
                    else s_next = s_reg + 1;
                end
            data:
                if (s_tick)
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = {rx, b_reg[data_bits - 1 : 1]}; // shift right
                        if (n_reg == (data_bits - 1))
                            state_next = stop;
                        else
                            n_next = n_reg + 1;
                    end
                    else
                        s_next = s_reg + 1;
            stop: 
                if (s_tick) begin
                    if (s_reg == (sb_tick - 1))
                        rx_done_tick = 1;
                        state_next = idle;
                    else s_next = s_reg + 1;
                end
            default: state_next = idle;
        endcase

        // output logic
        assign rx_dout = b_reg;
    end
endmodule