module decoder #(
    parameter n = 4
) (
    input [n-1: 0] I,
    input en,
    output reg [2**n - 1: 0] y
);

    always @(I, en) begin
        y = 0;
        if (en) begin
            y[I] = 1;
        end
        else
            y = 0;
    end
    
endmodule