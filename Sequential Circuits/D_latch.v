module D_latch (
    input D, clk,
    output reg Q, Q_bar
);

    always @(D, clk) 
    begin
          if (clk) 
          begin
            Q = D;
            Q_bar = ~D;
          end

    end
    
endmodule