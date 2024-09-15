`timescale 1ns/1ps

module UDC_tb (
);
    parameter n = 4;
    reg clk, reset_n, up, enable;
    wire [n-1:0] Q;

    up_down_counter #(.n(n)) uut
    (
        .clk(clk),
        .reset_n(reset_n),
        .up(up),
        .enable(enable),
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
        reset_n = 0;
        #1
        reset_n = 1;
        up = 1;
        enable = 1;
        #10
        up = 0;
        #10
        enable = 0;
        #10
        reset_n = 0;
        up = 1;
        enable = 1;
        #1
        reset_n = 1;
    end

endmodule
