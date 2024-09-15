`timescale 1ns/1ps

module synch_up_counter_tb (
);
    
    parameter n = 4;
    reg clk, reset_n;
    wire [n-1:0] Q;

    synch_up_counter #(.n(n)) uut
    (
        .clk(clk),
        .reset_n(reset_n),
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
        #2
        reset_n = 1;    
    end

endmodule
