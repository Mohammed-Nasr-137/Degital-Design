module mux4x1_nbit #(
    parameter n = 4
) (
    input [n-1:0] i0, i1, i2, i3,
    input [1:0] s,
    output reg [n-1:0] f
);

    always @(i0, i1, i2, i3, s) begin
        if (s == 2'b00) begin
            f = i0;
        end 
        else if (s == 2'b01) begin
            f = i1;
        end
        else if (s == 2'b10) begin
            f = i2;
        end
        else if (s == 2'b11) begin
            f = i3;
        end
    end
    
endmodule