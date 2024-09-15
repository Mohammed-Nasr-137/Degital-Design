module timer #(
    parameter n = 4
) (
    input clk, reset_n, enable,
    input [n-1:0] final_value,
    output done
);

    reg [n-1:0] Q_reg, Q_next;

    always @(posedge clk, negedge reset_n) 
    begin
        if (!reset_n)
            Q_reg <= 0;
        else if (enable)
            Q_reg <= Q_next; 
        else
            Q_reg <= Q_reg;
    end

    assign done = Q_reg == final_value;

    always @(*)
        Q_next = done? 0:Q_reg + 1;
    
endmodule