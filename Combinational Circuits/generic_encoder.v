module encoder(
    input [3: 0] I,
    input en,
    output reg [1: 0] y
);

    always @(I, en) begin
        y = 0;
        if (en)
        begin
            case (I)
                4'b0001: y = 0;
                4'b0010: y = 1;
                4'b0100: y = 2;
                4'b1000: y = 3;
            endcase
        end
    end
    
endmodule