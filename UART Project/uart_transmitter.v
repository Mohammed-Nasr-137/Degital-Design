module uart_tx #(
    parameter data_bits = 8,  // # of data bits
              sb_tick = 16    // # of stop bit ticks
) (
    input clk, reset_n, tx_start, s_tick,
    input [data_bits - 1 : 0] tx_din,
    output reg tx_done_tick,
    output tx;
);
    
    localparam idle = 0, start = 1, data = 2, stop = 3;

    reg [1:0] state_reg, state_next;
    reg [3:0] s_reg, s_next; // keep track of the baud rate ticks (16 total)
    reg [$clog2(data_bits) - 1 : 0] n_reg, n_next; // keep track of the # of data bits transmitted
    reg [data_bits - 1 : 0] b_reg, b_next; // stores the transmitted data bits
    reg tx_reg, tx_next; // track the transmitted bit

    // state and other registers
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            state_reg <= idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
            tx_reg <= 1; // keep the line high
        end
        else begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
            tx_reg <= tx_next;
        end
    end

    // next state logic
    always @(*) begin
        state_next = state_reg;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        tx_done_tick = 0;
        case (state_reg)
            idle: begin
                tx_next = 1;
                if (tx_start) begin
                    s_next = 0;
                    b_next = tx_din;
                    state_next = start;
                end
            end
            start: begin
                tx_next = 0;
                if (s_tick)
                    if (s_reg == 15) begin
                        s_next = 0;
                        n_next = 0;
                        state_next = data;
                    end
                    else s_next = s_reg + 1;
            end
            data: begin
                tx_next = b_reg[0];
                if (s_tick)
                    if (s_reg == 15) begin
                        s_next = 0;
                        b_next = {1'b0, b_reg[data_bits - 1 : 1]}; // shift right
                        if (n_reg == (data_bits - 1))
                            state_next = stop;
                        else
                            n_next = n_reg + 1;
                    end
                    else s_next = s_reg + 1;
            end
            stop: begin
                tx_next = 1;
                if (s_tick)
                    if (s_reg == (sb_tick - 1)) begin
                        tx_done_tick = 1;
                        state_next = idle;
                    end
                    else s_next = s_reg + 1;
            end
            default: state_next = idle;
        endcase
    end

    // output logic
    assign tx = tx_reg;
endmodule