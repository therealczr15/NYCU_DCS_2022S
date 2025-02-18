`include "synchronizer.v"
module CDC(// Input signals
			clk_1,
			clk_2,
			in_valid,
			rst_n,
			in_a,
			mode,
			in_b,
		  //  Output signals
			out_valid,
			out
			);		
input clk_1; 
input clk_2;			
input rst_n;
input in_valid;
input[3:0]in_a,in_b;
input mode;
output logic out_valid;
output logic [7:0]out; 			

parameter S_idle = 2'd0;
parameter S_compute = 2'd1;
parameter S_out = 2'd2;

logic [1:0] cur_state, nxt_state;
logic Xor;
logic clk_1_reg, syn_out, CDC_res, clk_2_reg;
logic [7:0] out_comb, out_reg;

always_ff @(posedge clk_1 or negedge rst_n) begin 
    if(!rst_n)
        clk_1_reg <= 0;
    else 
        clk_1_reg <= Xor;
end
assign Xor = clk_1_reg ^ in_valid;
//synchronizer s1(.clk(clk_2), .input(clk_1_reg), .output(syn_out));
synchronizer x5(.D(clk_1_reg),.Q(syn_out),.clk(clk_2),.rst_n(rst_n));
always_ff @(posedge clk_2 or negedge rst_n) begin 
    if(!rst_n)
        clk_2_reg <= 0;
    else 
        clk_2_reg <= syn_out;
end
assign CDC_res = syn_out ^ clk_2_reg;

always_ff @(posedge clk_2 or negedge rst_n) begin 
    if(!rst_n)
        cur_state <= 0;
    else 
        cur_state <= nxt_state;
end

always_comb begin
    nxt_state = cur_state;
    case(cur_state)
        S_idle: nxt_state = (CDC_res) ? S_compute : S_idle;
        S_compute: nxt_state = S_out;
        S_out: nxt_state = S_idle;
    endcase
end

assign out_comb = (in_valid) ? ((mode) ? (in_a * in_b) : (in_a + in_b)) : 0 ;
always_ff @(posedge clk_1 or negedge rst_n) begin 
    if(!rst_n)
        out_reg <= 0;
    else 
        out_reg <= out_comb;
end 
assign out_valid = (cur_state == S_out);
assign out = (cur_state == S_out) ? out_reg : 0; 


//---------------------------------------------------------------------
//   your design  (Using synchronizer)       
// Example :
//logic P,Q,Y;
//synchronizer x5(.D(P),.Q(Y),.clk(clk_2),.rst_n(rst_n));           
//---------------------------------------------------------------------		



		
endmodule