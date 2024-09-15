module USR #(
    parameter n = 4
) (
    input clk, reset_n, Msb_in, Lsb_in,
    input [1:0] s,
    input [n-1:0] I,
    output [n-1:0] Q
);
    
    reg [n-1:0] Q_next, Q_reg;

    always @(posedge clk, negedge reset_n) 
    begin
        if (!reset_n)
            Q_reg <= 0;
        else
            Q_reg <= Q_next;
    end

    always @(*) 
    begin
        case (s)
            2'b00: Q_next = Q_reg;
            2'b01: Q_next = {Msb_in, Q_reg[n-1:1]};
            2'b10: Q_next = {Q_reg[n-2:0], Lsb_in};
            2'b11: Q_next = I;
            default: Q_next = Q_reg;
        endcase
    end

    assign Q = Q_reg;

endmodule