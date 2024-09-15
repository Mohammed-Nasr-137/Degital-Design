module bcd_counter
(
    input clk, reset_n, enable,
    output done,
    output [3:0] Q
);

    reg [3:0] Q_reg, Q_next;

    always @(posedge clk, negedge reset_n)
    begin
        if (!reset_n)
            Q_reg <= 0;
        else if (enable)
            Q_reg <= Q_next; 
        else
            Q_reg <= Q_reg;
    end

    assign done = Q_reg == 9;
    always @(*)
        Q_next = done? 0:Q_reg + 1;
    
    assign Q = Q_reg;
    
endmodule