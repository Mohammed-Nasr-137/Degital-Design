`timescale 1ns/1ps

module PWM_tb (
);
    
    parameter R = 8;
    parameter timer_n = 15;
    reg clk, reset_n;
    reg [R:0] duty;
    reg [timer_n-1:0] final_value;
    wire pwm_out;

    pwm #(.R(R), .timer_n(timer_n)) uut
    (
        .clk(clk),
        .reset_n(reset_n),
        .duty(duty),
        .final_value(final_value),
        .pwm_out(pwm_out)
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
        duty = 128;
        final_value = 500;
    end

endmodule
