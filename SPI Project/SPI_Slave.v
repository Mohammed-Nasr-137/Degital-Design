module slave (
    input clk, reset_n, MOSI, tx_valid, SS_n,
    input [7:0] tx_data,
    output reg rx_valid,
    output reg MISO,
    output reg [9:0] rx_data
);

    localparam idle = 0, chk_cmd = 1, write = 2, read_add = 3, read_data = 4;
    reg [2:0] state_reg, state_next;
    reg [9:0] shift_reg_received; // handles serial to parallel ops
    reg [7:0] shift_reg_transmit; // handles parallel to serial ops
    reg [9:0] reg_to_ram; // saves the full received data
    reg loaded; // 1 if reg_to_ram is loaded
    reg transmitted; // 1 if the ram finished transmission to the slave
    reg [3:0] bit_counter;
    
    // init slave & handle data flow
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            state_reg <= idle;
            shift_reg_received <= 0;
            reg_to_ram <= 0;
            loaded <= 0;
            shift_reg_transmit <= 0;
            rx_valid <= 0;
            bit_counter <= 0;
            transmitted <= 0;
            MISO <= 0;
        end
        else begin
            state_reg <= state_next;
            // data reception
            if (SS_n == 0 && state_reg != read_data) begin
                shift_reg_received <= {shift_reg_received[8:0], MOSI}; // msb first
                bit_counter <= bit_counter + 1;
            end
            // data transmission
            if (tx_valid == 1 && state_reg == read_data && SS_n == 0 && transmitted == 1) begin
                MISO <= shift_reg_transmit[0];
                shift_reg_transmit <= {1'b0, shift_reg_transmit[7:1]}; // lsb first
                bit_counter <= bit_counter + 1;
            end

            if (bit_counter == 10) begin
                bit_counter <= 0;
                reg_to_ram <= shift_reg_received;
                loaded <= 1;
            end
        end
    end

    
    always @(*) begin
        case (state_reg)
            idle: begin
                 state_next = SS_n? idle : chk_cmd;
                 rx_valid = 0;
                 bit_counter = 0;
                 transmitted = 0;
            end
            chk_cmd: begin
                if (bit_counter == 10 && SS_n == 0) begin
                    if (shift_reg_received[9] == 1) state_next = read_add; // read
                    else state_next = write; // write
                end
                else if (SS_n == 1) state_next = idle;
                else state_next = chk_cmd;
            end
            write: begin
                if (SS_n == 1) state_next = idle;
                else if (loaded) begin
                    rx_valid = 1;
                    rx_data = reg_to_ram; // send to ram
                    state_next = idle;
                    bit_counter = 0;
                end
                else state_next = write;
            end
            read_add: begin
                if (SS_n == 1) state_next = idle;
                else if (loaded) begin
                    rx_data = reg_to_ram;
                    state_next = read_data;
                    bit_counter = 0;
                end
                else state_next = read_add;
            end
            read_data: state_next = (SS_n == 1 || bit_counter == 10)? idle : read_data;
            default: state_next = idle;
        endcase
    end

    // load data from ram
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n)
            shift_reg_transmit <= 0;
        else if (tx_valid == 1 && state_reg == read_data && transmitted == 0) begin
            shift_reg_transmit <= tx_data;
            transmitted <= 1;
        end
    end

endmodule
