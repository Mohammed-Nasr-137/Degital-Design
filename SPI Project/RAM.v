module ram (
    input clk, reset_n, rx_valid,
    input [9:0] din,
    output reg tx_valid,
    output reg [7:0] dout
);
    
    localparam idle = 0, write_address = 1, write_data = 2, read_address = 3, read_data = 4;
    reg [2:0] state_reg, state_next;
    reg [7:0] memory [0:255];
    reg [7:0] address;
    reg [3:0] clk_counter; // counts 9 clocks during of which any input is ignored

    // initializing the memory
    initial begin : init
        integer i;
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] <= 0;
        end
    end

    // Sequential block
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            state_reg <= idle;
            address <= 0;
            tx_valid <= 0;
            dout <= 0;
            clk_counter <= 0;
        end
        else begin
            state_reg <= state_next;
            // write data
            if (state_reg == write_data && rx_valid) begin
                memory[address] <= din[7:0];
            end
            // read data
            if (state_reg == read_data && rx_valid) begin
                dout <= memory[address];
                tx_valid <= 1;
            end
            // handles how much should the reading flag stays active. used to ignore any incoming input during transmission
            if (tx_valid) clk_counter <= clk_counter + 1;
            if (clk_counter == 8) tx_valid <= 0;
        end
    end

    always @(*) begin
        case (state_reg)
            idle: begin
                 state_next = (rx_valid && !tx_valid)? (din[9:8] + 1) : idle; // if slave is sending data and not transmitting go to the required state. otherwise, stay in idle
            end
            write_address: begin
                if (rx_valid) begin
                    address = din[7:0]; // capture write address
                    state_next = write_data;
                end
                else state_next = write_address;
            end
            write_data: begin
                if (rx_valid) begin
                    state_next = idle;
                end
                else state_next = write_data;
            end
            read_address: begin
                if (rx_valid) begin
                    address = din[7:0]; // capture read address
                    state_next = read_data;
                end
                else state_next = read_address;
            end
            read_data: begin
                if (rx_valid) begin
                    state_next = idle;
                end
                else state_next = read_data;
            end
            default: state_next = idle;
        endcase
    end

endmodule