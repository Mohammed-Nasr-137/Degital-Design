`timescale 1ns/1ps

module mealy_111_tb (
);
    reg clk, reset_n, x;
    wire y;

    mealy_111 uut (
        .clk(clk),
        .reset_n(reset_n),
        .x(x),
        .y(y)
    );

    initial #100 $finish;
    localparam t = 4;

    always begin
        clk = 0;
        #(t/2);
        clk = 1;
        #(t/2);
    end

    initial begin
        reset_n = 0;
        #1
        reset_n = 1;
        x = 0;
        #4
        x = 1;
        #4
        x = 0;
        #4
        x = 1;
        #8
        x = 0;
        #16
        x = 1;
        #12
        x = 0;
    end

endmodule