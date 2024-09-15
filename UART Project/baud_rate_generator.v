module timer #(
    parameter bits = 10
) (
    input clk, reset_n, en,
    input [bits - 1 : 0] final_value,
    output done
);

    reg [bits - 1 : 0] Q_reg, Q_next;

    always @(posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            Q_reg <= 0;
        end
        else if (en) begin
            Q_reg <= Q_next;
        end
        else 
            Q_reg <= Q_reg;
    end

    always @(*) begin
        Q_next = done? 0 : Q_reg + 1;
    end

    assign done = Q_reg == final_value;
    
endmodule