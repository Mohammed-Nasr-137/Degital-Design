`timescale 1ps/1ps

module register_tb (
);
    parameter n = 4;
    reg clk, load;
    reg [n-1: 0] I;
    wire [n-1: 0] Q;

    register #(.n(n)) uut
    (
        .clk(clk),
        .load(load),
        .I(I),
        .Q(Q)
    );

    initial #160 $finish;

    localparam t = 40;
    always  
    begin
        clk = 1'b0;
        #(t/2);
        clk = 1'b1;
        #(t/2);    
    end

    initial
    begin
        load = 1'b1;
        I = 4'b0000;
        #50
        I = 4'b0001;
        #20
        load = 1'b0;
        I = 4'b0010;
        #20
        I = 4'b0100;
        #20
        load = 1'b1;

    end

endmodule
