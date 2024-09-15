module D_neg (
    input D, clk,
    output reg Q
);
    
    always @(negedge clk) 
    begin
        Q = D;
    end

endmodule