module pwm #(
    parameter R = 8, timer_n = 15
) (
    input clk, reset_n,
    input [R:0] duty,
    input [timer_n-1:0] final_value,
    output pwm_out
);

    reg [R-1:0] Q_reg, Q_next;
    reg d_reg, d_next;
    wire tick;

    always @(posedge clk, negedge reset_n) 
    begin
        if (!reset_n)
        begin
            Q_reg <= 0;
            d_reg <= 0;
        end
        else if (tick)
        begin
            Q_reg <= Q_next;
            d_reg <= d_next; 
        end
        else
        begin
            Q_reg <= Q_reg;
            d_reg <= d_reg;
        end
    end

    always @(*)
    begin
        Q_next = Q_reg + 1;
        d_next = (Q_reg < duty);
    end

    timer #(.n(timer_n)) timer_unit
    (
        .clk(clk),
        .reset_n(reset_n),
        .enable(1),
        .final_value(final_value),
        .done(tick)
    );

    assign pwm_out = d_reg;

endmodule