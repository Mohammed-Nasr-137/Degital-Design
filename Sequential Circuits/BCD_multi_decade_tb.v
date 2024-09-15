`timescale 1ns/1ps

module bcd_multi_decade_tb (
);

    parameter n = 3;
    reg clk, reset_n, enable;
    wire fdone;
    wire [4*n-1:0] Q_flat;

    bcd_multi_decade #(.n(n)) uut
    (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .fdone(fdone),
        .Q_flat(Q_flat)
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
        enable = 1;
        #1
        reset_n = 1;

    end
    
endmodule

