module T_FF (
    input T, clk, reset_n,
    output Q
);

    reg Q_reg;
    wire Q_next;

    always @(posedge clk, negedge reset_n) 
    begin
        if (!reset_n) 
            Q_reg <= 0;
        else
            Q_reg <= Q_next;    
    end

    assign Q_next = T ? ~Q_reg : Q_reg;

    assign Q = Q_reg;
    
endmodule