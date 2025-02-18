module Timer(
    // Input signals
    in,
	in_valid,
	rst_n,
	clk,
    // Output signals
    out_valid
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [4:0] in;
input in_valid,	rst_n,	clk;
output logic out_valid;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [4:0] cnt_reg, mux_reg;

//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
MUX m1(.in(in), .in_valid(in_valid), .clk(clk), .rst_n(rst_n), .in_out(mux_reg));
Counter cnt1(.clk(clk), .rst_n(rst_n), .in_valid(in_valid), .in_out(cnt_reg));
Comparator cmp1(.in_1(mux_reg), .in_2(cnt_reg), .out(out_valid));



endmodule
module MUX(
    // Input signals
    in,
    in_valid,
    clk,
    rst_n,
    // Output signals
    in_out
);

//DECLARATION
input in_valid, clk, rst_n;
input [4:0] in;
output logic [4:0] in_out;

//DESIGN
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        in_out <= 0;
    else if(in_valid)
        in_out <= in;
end

endmodule // MUX

module Counter(
    // Input signals
    clk,
    rst_n,
    in_valid,
    // Output signals
    in_out
);

//DECLARATION
input clk, rst_n, in_valid;
output logic [4:0] in_out;

//DESIGN
always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        in_out <= 0;
    else if(in_valid) 
        in_out <= 0;
    else if(in_out == 31)
        in_out <= 0;
    else
        in_out <= in_out + 1;
end

endmodule // Counter

module Comparator(
    // Input signals
    in_1,
    in_2,
    // Output signals
    out
);

//DECLARATION
input [4:0] in_1, in_2;
output logic out;

//DESIGN
always_comb begin
    if((in_1 == 0) || (in_2 == 0))
        out = 0;
    else if(in_1==in_2)
        out = 1;
    else
        out = 0;
end

endmodule // Comparator

