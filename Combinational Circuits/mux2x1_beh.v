module mux2x1_beh(
    input x1, x2, s,
    output reg f
);

always @(x1, x2, s) begin
    if (s)
    begin
        f = x2;
    end
    else
    begin
        f = x1;
    end
end
endmodule
