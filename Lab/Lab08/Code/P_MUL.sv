module P_MUL(
    // input signals
	in_1,
	in_2,
	in_3,
	in_valid,
	rst_n,
	clk,
	
    // output signals
    out_valid,
	out
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [46:0] in_1, in_2;
input [47:0] in_3;
input in_valid, rst_n, clk;
output logic out_valid;
output logic [95:0] out;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------


//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
logic in_valid_1, in_valid_1_comb;
logic [46:0] in_1_reg, in_1_comb, in_2_reg, in_2_comb;
logic [47:0] in_3_reg, in_3_comb;

logic [47:0] in_a_comb, in_a_reg;
logic [47:0] in_b_comb, in_b_reg;
logic in_valid_2;


logic in_valid_3;
logic [31:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
logic [31:0] p1_comb, p2_comb, p3_comb, p4_comb, p5_comb, p6_comb, p7_comb, p8_comb, p9_comb;

logic [95:0] p1_shift, p2_shift, p3_shift; 
logic [95:0] p4_shift, p5_shift, p6_shift; 
logic [95:0] p7_shift, p8_shift, p9_shift; 
logic [95:0] out_comb;

//1
assign in_1_comb = (in_valid) ? in_1 : 0;
assign in_2_comb = (in_valid) ? in_2 : 0;
assign in_3_comb = (in_valid) ? in_3 : 0;
//assign in_valid_1_comb = (in_valid) ? in_valid : 0;

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_1_reg <= 0;
    else
        in_1_reg <= in_1_comb;
end

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_2_reg <= 0;
    else
        in_2_reg <= in_2_comb;
end

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_3_reg <= 0;
    else
        in_3_reg <= in_3_comb;
end

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_valid_1 <= 0;
    else
        in_valid_1 <= in_valid;
end

//2
assign in_a_comb = in_1_reg + in_2_reg;
assign in_b_comb = in_3_reg;

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_valid_2 <= 0;
    else
        in_valid_2 <= in_valid_1;
end

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_a_reg <= 0;
    else
        in_a_reg <= in_a_comb;
end

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_b_reg <= 0;
    else
        in_b_reg <= in_b_comb;
end

//3
assign p1_comb = in_a_reg[15:0] * in_b_reg[15:0];
assign p2_comb = in_a_reg[31:16] * in_b_reg[15:0];
assign p3_comb = in_a_reg[47:32] * in_b_reg[15:0];
assign p4_comb = in_a_reg[15:0] * in_b_reg[31:16];
assign p5_comb = in_a_reg[31:16] * in_b_reg[31:16];
assign p6_comb = in_a_reg[47:32] * in_b_reg[31:16];
assign p7_comb = in_a_reg[15:0] * in_b_reg[47:32];
assign p8_comb = in_a_reg[31:16] * in_b_reg[47:32];
assign p9_comb = in_a_reg[47:32] * in_b_reg[47:32];

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        in_valid_3 <= 0;
    else
        in_valid_3 <= in_valid_2;
end

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        p1 <= 0;
        p2 <= 0;
        p3 <= 0;
        p4 <= 0;
        p5 <= 0;
        p6 <= 0;
        p7 <= 0;
        p8 <= 0;
        p9 <= 0;
    end else begin
        p1 <= p1_comb;
        p2 <= p2_comb;
        p3 <= p3_comb;
        p4 <= p4_comb;
        p5 <= p5_comb;
        p6 <= p6_comb;
        p7 <= p7_comb;
        p8 <= p8_comb;
        p9 <= p9_comb;
    end
end

//4

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        out_valid <= 0;
    else
        out_valid <= in_valid_3;
end

assign p1_shift = p1;
assign p2_shift = p2 << 16;
assign p3_shift = p3 << 32;
assign p4_shift = p4 << 16;
assign p5_shift = p5 << 32;
assign p6_shift = p6 << 48;
assign p7_shift = p7 << 32;
assign p8_shift = p8 << 48;
assign p9_shift = p9 << 64;
assign out_comb = (p1_shift + p2_shift + p3_shift) + (p4_shift + p5_shift + p6_shift) + (p7_shift + p8_shift + p9_shift);

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        out <= 0;
    else
        out <= out_comb;
end

endmodule