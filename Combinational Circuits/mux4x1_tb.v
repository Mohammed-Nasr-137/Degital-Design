`timescale 1ns/1ps

module mux4x1_nbit_tb (
);
    parameter n = 4;
    reg [n-1:0] i0, i1, i2, i3;
    reg [1:0] s;
    wire [n-1:0] f;

    mux4x1_nbit #(.n(n)) uut
    (
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .s(s),
        .f(f)
    );

    initial #60 $finish;

    initial begin
        i0 = 4'd0;
        i1 = 4'd1;
        i2 = 4'd2;
        i3 = 4'd3;
        s = 2'b00;
        #15
        s = 2'b01;
        #15
        s = 2'b10;
        #15
        s = 2'b11;
    end
    
endmodule
