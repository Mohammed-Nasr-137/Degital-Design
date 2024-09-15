`timescale 1ns/1ps

module bpwm_tb (
);
    parameter R = 8;
    reg clk, reset_n;
    reg [R-1:0] duty;
    wire pwm_out;

    basic_pwm #(.R(R)) uut
    (
        .clk(clk),
        .reset_n(reset_n),
        .duty(duty),
        .pwm_out(pwm_out)
    );

    initial #100 $finish;

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
        duty = 171;
    end

endmodule
