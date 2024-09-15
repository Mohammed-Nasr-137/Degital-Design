module ram_2ports #(
    parameter addr_width = 3, data_width = 8
) (
    input clk, we,
    input [addr_width-1:0] r_addr, w_addr,
    input [data_width-1:0] w_data,
    output [data_width-1:0] r_data
);
    
    reg [data_width-1:0] memory [0:2**addr_width - 1];

    always @(posedge clk) 
    begin
        if (we)
            memory[w_addr] <= w_data;    
    end

    assign r_data = memory[r_addr];

endmodule