module decoder_2x4 (
    input [1:0] I,
    output reg [3:0] y
);
    always @(I) begin
        y = 4'b000;
        case (I)
        2'b00: y[0] = 1;
        2'b01: y[1] = 1; 
        2'b10: y[2] = 1; 
        2'b11: y[3] = 1; 
    endcase
    end
    
endmodule