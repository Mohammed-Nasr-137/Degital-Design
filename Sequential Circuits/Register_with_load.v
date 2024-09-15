module register #(
    parameter n = 4
) (
    input clk, load,
    input [n-1: 0] I,
    output [n-1: 0] Q
);
    
    reg [n-1: 0] Q_reg, Q_next;

    always @(negedge clk) 
    begin
        Q_reg <= Q_next;    
    end

    always @(I, load)
    begin
        if (load) 
        begin
            Q_next = I;
        end
        else
        begin
            Q_next = Q_reg;
        end
    end
    assign Q = Q_reg;
endmodule