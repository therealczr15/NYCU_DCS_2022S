module Fpc(
// input signals
clk,
rst_n,
in_valid,
in_a,
in_b,
mode,
// output signals
out_valid,
out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid, mode;
input [15:0] in_a, in_b;
output logic out_valid;
output logic [15:0] out;

logic [15:0] mul;
logic [6:0] mul_shift;
logic [15:0] in_a_reg, in_b_reg;
logic [15:0] out_comb;
logic [8:0] extend_a_shift, extend_b_shift;
logic [8:0] a_comp, b_comp;
logic [8:0] sum, sum_comp;
logic [7:0] sum_shift;
logic [8:0] extend_a, extend_b;
logic [4:0] exp_a, exp_b, exp_big, exp_total, exp_comp, exp_a_comp, exp_b_comp, exp_plus, exp_minusa, exp_minusb;
logic [5:0] exp_a_sign, exp_b_sign;
logic [5:0] exp_mul, exp_mul_comp;
logic [7:0] exp_mul_total;
logic [7:0] exp;
logic [2:0] exp_diff;
logic [1:0] exp_diff_comp;
logic out_valid_comb;
logic judgeBig, sign;
logic in_valid_reg;
logic mode_reg;
//---------------------------------------------------------------------
//   Your design                       
//--------------------------------------------------------------------- 
always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_valid_reg <= 0;
    else
        in_valid_reg <= in_valid;
end
always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_a_reg <= 0;
    else
        in_a_reg <= in_a;
end
always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_b_reg <= 0;
    else
        in_b_reg <= in_b;
end
always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        mode_reg <= 0;
    else
        mode_reg <= mode;
end


assign judgeBig = (in_valid_reg) ? (in_a_reg[14:0] > in_b_reg[14:0]) ? 1 : 0 : 0;
always_comb begin 
	case({in_a_reg[15],in_b_reg[15]})
		2'b00: sign = 0;
		2'b01: sign = !judgeBig;
		2'b10: sign = judgeBig;
		2'b11: sign = 1;
	endcase
end
assign extend_a = (in_valid_reg) ? {2'b01,in_a_reg[6:0]} : 0;
assign extend_b = (in_valid_reg) ? {2'b01,in_b_reg[6:0]} : 0;
assign mul = extend_a * extend_b;
assign mul_shift = (mul[15]) ? mul[14:8] : mul[13:7];
assign exp_a = (in_valid_reg) ? (in_a_reg[14:7] - 127) : 0;
assign exp_b = (in_valid_reg) ? (in_b_reg[14:7] - 127) : 0;
assign exp_a_comp = (exp_a[4]) ? (~exp_a + 1) : exp_a;
assign exp_a_sign = (exp_a[4]) ? {exp_a[4],exp_a_comp} : {exp_a[4], exp_a};
assign exp_b_comp = (~exp_b + 1);
assign exp_b_sign = (exp_b[4]) ? {exp_b[4],exp_b_comp} : {exp_b[4], exp_b};
assign exp_diff = (in_valid_reg) ? (in_a_reg[14:7] - in_b_reg[14:7]) : 0;
assign exp_diff_comp = (exp_diff[2]) ? (~exp_diff + 1): exp_diff[1:0];
assign exp_big = (judgeBig) ? exp_a : exp_b;
assign exp_plus = exp_a_sign[4:0] + exp_b_sign[4:0];
assign exp_minusa = exp_b_sign[4:0] - exp_a_sign[4:0];
assign exp_minusb = exp_a_sign[4:0] - exp_b_sign[4:0];
always_comb begin
	case({exp_a_sign[5],exp_b_sign[5]})
		2'b00: exp_mul = {1'b0,exp_plus};
		2'b01: exp_mul = (exp_a_sign[4:0] > exp_b_sign[4:0]) ? {1'b0, exp_minusb} : {1'b1, exp_minusa};
		2'b10: exp_mul = (exp_a_sign[4:0] > exp_b_sign[4:0]) ? {1'b1, exp_minusb} : {1'b0, exp_minusa};
		2'b11: exp_mul = {1'b1,exp_plus};
	endcase
end
//assign exp_mul_comp = (exp_mul[6] ) ? (~exp_mul + 1) : exp_mul;
assign exp_mul_total = (exp_mul[5] > 0) ? (127 - exp_mul[4:0] + mul[15]) : (127 + exp_mul[4:0] + mul[15]);
assign extend_a_shift = (exp_diff[2]) ? {(extend_a >> exp_diff_comp)} : extend_a;
assign extend_b_shift = (exp_diff[2]) ? extend_b : {(extend_b >> exp_diff_comp)};
assign a_comp = (in_a_reg[15]) ? (~extend_a_shift + 1) : extend_a_shift;
assign b_comp = (in_b_reg[15]) ? (~extend_b_shift + 1) : extend_b_shift;
assign sum = (a_comp + b_comp);
assign sum_comp = (sign) ? (~sum + 1) : sum;
always_comb begin
	if(sum_comp[8]) begin
		sum_shift = sum_comp >> 1;
		exp_total = exp_big + 1;
	end else if (sum_comp[7])begin
		sum_shift = sum_comp;
		exp_total = exp_big;
	end else if (sum_comp[6])begin
		sum_shift = sum_comp << 1;
		exp_total = exp_big - 1;
	end else if (sum_comp[5])begin
		sum_shift = sum_comp << 2;
		exp_total = exp_big - 2;
	end else if (sum_comp[4])begin
		sum_shift = sum_comp << 3;
		exp_total = exp_big - 3;
	end else if (sum_comp[3])begin
		sum_shift = sum_comp << 4;
		exp_total = exp_big - 4;
	end else if (sum_comp[2])begin
		sum_shift = sum_comp << 5;
		exp_total = exp_big - 5;
	end else if (sum_comp[1])begin
		sum_shift = sum_comp << 6;
		exp_total = exp_big - 6;
	end else if (sum_comp[0])begin
		sum_shift = sum_comp << 7;
		exp_total = exp_big - 7;
	end else begin
		sum_shift = 0;
		exp_total = 0;
	end
end




assign exp_comp = ~exp_total + 1;
assign exp = (exp_total[4]) ? (127 - exp_comp) : (127 + exp_total);
always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        out_valid <= 0;
    else
        out_valid <= out_valid_comb;
end
always_comb begin
	if(in_valid_reg) begin
		if(mode_reg) 
			out_comb = {(in_a_reg[15] ^ in_b_reg[15]),exp_mul_total,mul_shift};
		else
			out_comb = {sign, exp ,sum_shift[6:0]};
	end else
		out_comb = 0;
end
assign out_valid_comb = (in_valid_reg) ? 1 : 0;
always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        out <= 0;
    else
        out <= out_comb;
end
//assign out_comb = (in_valid_reg) ? {sign, exp ,sum_shift[6:0]} : 0;
endmodule

