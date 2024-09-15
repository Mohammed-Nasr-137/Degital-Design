module mux2x1{
    input x1, x2, s,
    output f
};
    and (a0, x1, ~s);
    and (a1, x2, s);
    or (f, a0, a1);
endmodule

