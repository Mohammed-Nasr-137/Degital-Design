`timescale 1ns/1ps

module USR_tb (
);
    parameter n = 4;
    reg clk, reset_n, Msb_in, Lsb_in;
    reg [1:0] s;
    reg [n-1:0] I;
    wire [n-1:0] Q;

    USR #(.n(n)) uut
    (
        .clk(clk),
        .reset_n(reset_n),
        .Msb_in(Msb_in),
        .Lsb_in(Lsb_in),
        .s(s),
        .I(I),
        .Q(Q)
    );

    initial #1000 $finish;

    localparam t = 4;
    always  
    begin
        clk = 1'b0;
        #(t/2);
        clk = 1'b1;
        #(t/2);    
    end

    initial
    begin
        s = 2'b11;
        I = 4'b0000;
        #4
        s = 2'b00;
        #4
        s = 2'b01;
        Msb_in = 1'b1;
        #16
        s = 2'b00;
        reset_n = 1'b0;
        #4
        s = 2'b10;
        Lsb_in = 1'b1;
    end

endmodule
