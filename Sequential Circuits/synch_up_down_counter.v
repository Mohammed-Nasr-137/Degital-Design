module up_down_counter #(
    parameter n = 4
) (
    input clk, reset_n, up, enable,
    output [n-1:0] Q
);

    reg [n-1:0] Q_next, Q_reg;

    always @(posedge clk, negedge reset_n)
    begin
        if (!reset_n) 
            Q_reg <= 0;
        else if (enable)
            Q_reg <= Q_next; 
        else
            Q_reg <= Q_reg;  
    end

    always @(*)
    begin
        Q_next = Q_reg;
        if (up)
            Q_next = Q_reg + 1;    
        else
            Q_next  = Q_reg - 1;   
    end

    assign Q = Q_reg;
    
endmodule