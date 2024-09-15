module fa (
    input x, y, c_in,
    output s, c_out
);
    wire s1, c1, c2;
    ha ha1 (
        .x(x),
        .y(y),
        .s(s1),
        .c(c1)
    );

    ha ha2 (
        .x(c_in),
        .y(s1),
        .s(s),
        .c(c2)
    );
    assign c_out = c1 | c2;
endmodule