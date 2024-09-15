module mux4x1 (
    input x0, x1, x2, x3, s0, s1,
    output f
);
    wire w0, w1;
    mux2x1_dataflow m0 (x0, x1, s0, w0);
    mux2x1_dataflow m1(
        .x1(x2),
        .x2(x3),
        .s(s0),
        .f(w1)
    );
    mux2x1_beh m2(w0, w1, s1, f);

endmodule