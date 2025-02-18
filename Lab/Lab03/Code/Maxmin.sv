module Maxmin(
    // input signals
	in_num,
	in_valid,
	rst_n,
	clk,
	
    // output signals
    out_valid,
	out_max,
	out_min
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [7:0] in_num;
input in_valid, rst_n, clk;
output logic out_valid;
output logic [7:0] out_max, out_min;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [7:0] out_max_nxt, out_min_nxt;
logic [3:0] cnt_add_one, cnt_reg, cnt_comb;
logic out_valid_comb;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
always_comb begin
	if(in_valid) begin
		if(in_num > out_max)
			out_max_nxt = in_num;
		else
			out_max_nxt = out_max;
		if(in_num < out_min)
			out_min_nxt = in_num;
		else
			out_min_nxt = out_min;		
	end
	else begin
		out_max_nxt = 0;
		out_min_nxt = 255;
	end
end

always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        out_max <= 0;
        out_min <= 255;
    end else begin
        out_max <= out_max_nxt;
        out_min <= out_min_nxt;
    end
end

always_ff @(posedge clk or negedge rst_n) begin 
	if(~rst_n)
		cnt_reg <= 0;
	else
		cnt_reg <= cnt_comb;
end

assign cnt_add_one = cnt_reg + 1;
assign cnt_comb = (in_valid)? cnt_add_one : 0;
assign out_valid_comb = (cnt_add_one == 15)? 1:0;

always_ff @(posedge clk or negedge rst_n) begin
	if(~rst_n)
		out_valid <= 0;
	else
		out_valid <= out_valid_comb;
end

endmodule
