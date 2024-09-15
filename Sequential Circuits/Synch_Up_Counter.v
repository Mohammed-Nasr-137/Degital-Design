module synch_up_counter #(
    parameter n = 4
) (
    input clk, reset_n,
    output [n-1:0] Q
);

    wire [n-1:0] Q_next;

    assign Q_next[0] = 1;
    T_FF T0 (
        .clk(clk),
        .T(Q_next[0]),
        .reset_n(reset_n),
        .Q(Q[0])
    );

    generate
        genvar k;
        for (k = 1; k < n ; k = k + 1) 
        begin
            assign Q_next[k] = Q_next[k-1] & Q[k-1];

            T_FF ff (
                .clk(clk),
                .T(Q_next[k]),
                .reset_n(reset_n),
                .Q(Q[k])
            );
        end
    endgenerate
    
endmodule