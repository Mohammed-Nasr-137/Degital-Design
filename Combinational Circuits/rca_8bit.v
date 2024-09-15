module adder_8bit (
    input [7: 0] a, b,
    output [7: 0] s,
    output c_out
);
    rca_nbit #(.n(8)) adder (
        .x(a),
        .y(b),
        .c_in(0),
        .s(s),
        .c_out(c_out)
    );
endmodule