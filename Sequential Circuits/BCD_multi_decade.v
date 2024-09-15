module bcd_multi_decade #(
    parameter n = 3
) (
    input clk, reset_n, enable,
    output fdone,
    output [4*n-1:0] Q_flat
);
    wire  [3:0] Q [n-1:0];
    wire [3:0] Q_next [n-1:0];
    wire [n-1:0] done, a;

    bcd_counter c0 (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .done(done[0]),
        .Q(Q[0])
    );
    assign a[0] = enable & done[0];

    generate
        genvar k;
        for (k = 1; k < n ; k = k + 1) 
        begin
            bcd_counter cc (
                .clk(clk),
                .reset_n(reset_n),
                .enable(a[k-1]),
                .done(done[k]),
                .Q(Q[k])
            );
            assign a[k] = a[k-1] & done[k];
        end
    endgenerate

    assign fdone = a[n-1];

    genvar i;
    for (i = 0; i < n ; i = i + 1)
    begin
       assign Q_flat[4*(i+1)-1:4*i] = Q[i]; 
    end

endmodule
