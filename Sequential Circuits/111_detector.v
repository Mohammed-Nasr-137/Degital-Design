module mealy_111 (
    input clk, reset_n, x,
    output y
);

    reg [1:0] state_next, state_reg;
    localparam s0 = 0;
    localparam s1 = 1;
    localparam s2 = 2;
    localparam s3 = 3;

    // state register
    always @(posedge clk, negedge reset_n) begin
        if (!reset_n)
            state_reg <= s0;
        else
            state_reg <= state_next;
    end
    // next state logic
    always @(*) begin
        case (state_reg)
            s0: state_next = x? s1:s0;
            s1: state_next = x? s2:s0;
            s2: state_next = x? s3:s0;
            s3: state_next = x? s3:s0;
            default: state_next = state_reg;
        endcase
    end
    // output logic
    assign y = state_reg == s3;
endmodule