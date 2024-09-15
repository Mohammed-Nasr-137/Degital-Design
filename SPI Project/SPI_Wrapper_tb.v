`timescale 1ns/1ps

module wrapper_tb (
);
    
    reg clk;
    reg reset_n;
    reg SS_n;            // Slave Select (Active Low)
    reg MOSI;            // Master Out Slave In (input to the slave)
    wire MISO;           // Master In Slave Out (output from the slave)

    wrapper uut (
        .clk(clk),
        .reset_n(reset_n),
        .SS_n(SS_n),
        .MOSI(MOSI),
        .MISO(MISO)
    );

    localparam t = 4;

    always begin
        clk = 0;
        #(t/2);
        clk = 1;
        #(t/2);
    end

    initial begin
        reset_n = 0;
        SS_n = 1;
        MOSI = 0;

        #8 reset_n = 1;

        #8 SS_n = 0;
        #8 send_bits(10'b0000000111);
        SS_n = 1;
        #8;
        SS_n = 0;
        #8 send_bits(10'b0100000011);
        SS_n = 1;
        #8;
        send_bits(10'b1000000111);
        #32;
        send_bits(10'b1100000101);
        #32;
        $finish;
    end

    task send_bits;
        input [9:0] bits;
        integer i;
        begin
            for (i = 9; i >= 0; i = i-1) begin
                MOSI = bits[i];
                #4;
            end
        end
    endtask

endmodule
