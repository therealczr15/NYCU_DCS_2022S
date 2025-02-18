module JAM(
  // Input signals
	clk,
	rst_n,
    in_valid,
    in_cost,
  // Output signals
	out_valid,
    out_job,
	out_cost
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [6:0] in_cost;
output logic out_valid;
output logic [3:0] out_job;
output logic [9:0] out_cost;
 
//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [2:0] cnt, cnt_comb, cnt_row, cnt_row_comb;
logic [3:0] row_zero[7:0], row_zero_comb[7:0], col_zero[7:0], col_zero_comb[7:0];
logic [2:0] cur_state, nxt_state;
logic [6:0] row_min, row_min_comb;
logic [6:0] col_min, col_min_comb;
logic [6:0] job_cost[7:0][7:0], job_cost_comb[7:0][7:0];
logic [6:0] mask[7:0][7:0], mask_comb[7:0][7:0];
logic [6:0] a0, a1, a2, a3, b0, b1;
logic [6:0] minus, minus_comb;
//---------------------------------------------------------------------
//   PARAMETER DECLARATION
//---------------------------------------------------------------------
parameter S_idle = 3'd0;
parameter S_row = 3'd1;
parameter S_col = 3'd2;
parameter S_count = 3'd3;
//paremeter S_line = 3'd4;
parameter S_more_zero = 3'd5;
parameter S_out = 3'd6;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (int i=0;i<8;i++) begin
			for (int j=0;j<8; j++) begin
				job_cost[i][j] <= 0;
			end
		end
	end else begin
		for (int i=0;i<8;i++) begin
			for (int j=0;j<8; j++) begin
				job_cost[i][j] <= job_cost_comb[i][j];
			end
		end
	end
end

always_comb begin 
	if(in_valid) begin
		job_cost_comb[7][7] = in_cost;
		job_cost_comb[7][6] = job_cost[7][7];
		job_cost_comb[7][5] = job_cost[7][6];
		job_cost_comb[7][4] = job_cost[7][5];
		job_cost_comb[7][3] = job_cost[7][4];
		job_cost_comb[7][2] = job_cost[7][3];
		job_cost_comb[7][1] = job_cost[7][2];
		job_cost_comb[7][0] = job_cost[7][1];
		job_cost_comb[6][7] = job_cost[7][0];
		job_cost_comb[6][6] = job_cost[6][7];
		job_cost_comb[6][5] = job_cost[6][6];
		job_cost_comb[6][4] = job_cost[6][5];
		job_cost_comb[6][3] = job_cost[6][4];
		job_cost_comb[6][2] = job_cost[6][3];
		job_cost_comb[6][1] = job_cost[6][2];
		job_cost_comb[6][0] = job_cost[6][1];
		job_cost_comb[5][7] = job_cost[6][0];
		job_cost_comb[5][6] = job_cost[5][7];
		job_cost_comb[5][5] = job_cost[5][6];
		job_cost_comb[5][4] = job_cost[5][5];
		job_cost_comb[5][3] = job_cost[5][4];
		job_cost_comb[5][2] = job_cost[5][3];
		job_cost_comb[5][1] = job_cost[5][2];
		job_cost_comb[5][0] = job_cost[5][1];
		job_cost_comb[4][7] = job_cost[5][0];
		job_cost_comb[4][6] = job_cost[4][7];
		job_cost_comb[4][5] = job_cost[4][6];
		job_cost_comb[4][4] = job_cost[4][5];
		job_cost_comb[4][3] = job_cost[4][4];
		job_cost_comb[4][2] = job_cost[4][3];
		job_cost_comb[4][1] = job_cost[4][2];
		job_cost_comb[4][0] = job_cost[4][1];
		job_cost_comb[3][7] = job_cost[4][0];
		job_cost_comb[3][6] = job_cost[3][7];
		job_cost_comb[3][5] = job_cost[3][6];
		job_cost_comb[3][4] = job_cost[3][5];
		job_cost_comb[3][3] = job_cost[3][4];
		job_cost_comb[3][2] = job_cost[3][3];
		job_cost_comb[3][1] = job_cost[3][2];
		job_cost_comb[3][0] = job_cost[3][1];
		job_cost_comb[2][7] = job_cost[3][0];
		job_cost_comb[2][6] = job_cost[2][7];
		job_cost_comb[2][5] = job_cost[2][6];
		job_cost_comb[2][4] = job_cost[2][5];
		job_cost_comb[2][3] = job_cost[2][4];
		job_cost_comb[2][2] = job_cost[2][3];
		job_cost_comb[2][1] = job_cost[2][2];
		job_cost_comb[2][0] = job_cost[2][1];
		job_cost_comb[1][7] = job_cost[2][0];
		job_cost_comb[1][6] = job_cost[1][7];
		job_cost_comb[1][5] = job_cost[1][6];
		job_cost_comb[1][4] = job_cost[1][5];
		job_cost_comb[1][3] = job_cost[1][4];
		job_cost_comb[1][2] = job_cost[1][3];
		job_cost_comb[1][1] = job_cost[1][2];
		job_cost_comb[1][0] = job_cost[1][1];
		job_cost_comb[0][7] = job_cost[1][0];
		job_cost_comb[0][6] = job_cost[0][7];
		job_cost_comb[0][5] = job_cost[0][6];
		job_cost_comb[0][4] = job_cost[0][5];
		job_cost_comb[0][3] = job_cost[0][4];
		job_cost_comb[0][2] = job_cost[0][3];
		job_cost_comb[0][1] = job_cost[0][2];
		job_cost_comb[0][0] = job_cost[0][1];
	end else begin
		for (int i=0;i<8;i++) begin
			for (int j=0;j<8; j++) begin
				job_cost_comb[i][j] = job_cost[i][j];
			end
		end
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cur_state <= 0;
	end else begin
		cur_state <= nxt_state;
	end
end
always_comb begin
	case(cur_state)
		S_idle: nxt_state = in_valid ? S_row : S_idle;
		S_row: nxt_state = ((!in_valid) && (&cnt)) ? S_col : S_row;
		S_col: nxt_state = ((!in_valid) && (&cnt)) ? S_count : S_col;
	endcase
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cnt <= 0;
	end else begin
		cnt <= cnt_comb;
	end
end
always_comb begin
	if(&cnt)
		cnt_comb = 0;
	else if (nxt_state != S_idle)
		cnt_comb = cnt + 1;
	else
		cnt_comb = 0;
end
always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cnt_row <= 0;
	end else begin
		cnt_row <= cnt_row_comb;
	end
end
always_comb begin
	if((nxt_state == S_count)) begin
		if(&cnt)
			cnt_row_comb = cnt_row + 1;
		else
			cnt_row_comb = cnt_row;
	end else
		cnt_row_comb = 0;
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		row_min <= 0;
	end else begin
		row_min <= row_min_comb;
	end
end
always_comb begin
	if(cnt == 0)
		row_min_comb = in_cost;
	else if(in_cost < row_min)
		row_min_comb = in_cost;
	else
		row_min_comb = row_min;
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (int i=0;i<8;i++) begin
			col_min[i] <= 0;
		end
	end else begin
		for (int i=0;i<8;i++) begin
			col_min[i] <= col_min_comb[i];
		end
	end
end
assign a0 = (mask_comb[cnt][0] < mask_comb[cnt][1]) ? mask_comb[cnt][0] : mask_comb[cnt][1];
assign a1 = (mask_comb[cnt][2] < mask_comb[cnt][3]) ? mask_comb[cnt][2] : mask_comb[cnt][3];
assign a2 = (mask_comb[cnt][4] < mask_comb[cnt][5]) ? mask_comb[cnt][4] : mask_comb[cnt][5];
assign a3 = (mask_comb[cnt][6] < mask_comb[cnt][7]) ? mask_comb[cnt][6] : mask_comb[cnt][7];
assign b0 = (a0 < a1) ? a0 : a1;
assign b1 = (a2 < a3) ? a2 : a3;
assign col_min_comb = (b0 < b1) ? b0 : b1;

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		minus <= 0;
	end else begin
		minus <= minus_comb;
	end
end
always_comb begin
	if(&cnt)
		minus_comb = row_min_comb;
	else 
		minus_comb = minus;
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (int i=0;i<8;i++) begin
			row_zero[i] <= 0;
		end
	end else begin
		for (int i=0;i<8;i++) begin
			row_zero[i] <= row_zero_comb[i];
		end
	end
end
always_comb begin
	if(nxt_state == S_count) begin
		if(mask[cnt_row_comb][cnt] == 0)
			row_zero_comb[cnt_row_comb] = row_zero[cnt_row_comb] + 1;
		else
			row_zero_comb[cnt_row_comb] = row_zero[cnt_row_comb];
	end else begin
		for (int i=0;i<8;i++) begin
			row_zero_comb[i] = 0;
		end
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (int i=0;i<8;i++) begin
			col_zero[i] <= 0;
		end
	end else begin
		for (int i=0;i<8;i++) begin
			col_zero[i] <= col_zero_comb[i];
		end
	end
end
always_comb begin
	if(nxt_state == S_count) begin
		if(mask[cnt_row_comb][cnt] == 0)
			col_zero_comb[cnt] = col_zero[cnt] + 1;
		else
			col_zero_comb[cnt] = col_zero[cnt];
	end else begin
		for (int i=0;i<8;i++) begin
			col_zero_comb[i] = 0;
		end
	end
end

always_ff @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (int i=0;i<8; i++) begin
			for (int j=0;j<8;j++) begin
				mask[i][j] <= 0;
			end
		end
	end else begin
		for (int i=0;i<8;i++) begin
			for (int j=0;j<8;j++) begin
				mask[i][j] <= mask_comb[i][j];
			end
		end
	end
end

always_comb begin
	case(nxt_state)
		S_row: begin 
			mask_comb[7][7] = job_cost_comb[7][0] - minus;
			mask_comb[7][6] = mask[7][7];
			mask_comb[7][5] = mask[7][6];
			mask_comb[7][4] = mask[7][5];
			mask_comb[7][3] = mask[7][4];
			mask_comb[7][2] = mask[7][3];
			mask_comb[7][1] = mask[7][2];
			mask_comb[7][0] = mask[7][1];
			mask_comb[6][7] = mask[7][0];
			mask_comb[6][6] = mask[6][7];
			mask_comb[6][5] = mask[6][6];
			mask_comb[6][4] = mask[6][5];
			mask_comb[6][3] = mask[6][4];
			mask_comb[6][2] = mask[6][3];
			mask_comb[6][1] = mask[6][2];
			mask_comb[6][0] = mask[6][1];
			mask_comb[5][7] = mask[6][0];
			mask_comb[5][6] = mask[5][7];
			mask_comb[5][5] = mask[5][6];
			mask_comb[5][4] = mask[5][5];
			mask_comb[5][3] = mask[5][4];
			mask_comb[5][2] = mask[5][3];
			mask_comb[5][1] = mask[5][2];
			mask_comb[5][0] = mask[5][1];
			mask_comb[4][7] = mask[5][0];
			mask_comb[4][6] = mask[4][7];
			mask_comb[4][5] = mask[4][6];
			mask_comb[4][4] = mask[4][5];
			mask_comb[4][3] = mask[4][4];
			mask_comb[4][2] = mask[4][3];
			mask_comb[4][1] = mask[4][2];
			mask_comb[4][0] = mask[4][1];
			mask_comb[3][7] = mask[4][0];
			mask_comb[3][6] = mask[3][7];
			mask_comb[3][5] = mask[3][6];
			mask_comb[3][4] = mask[3][5];
			mask_comb[3][3] = mask[3][4];
			mask_comb[3][2] = mask[3][3];
			mask_comb[3][1] = mask[3][2];
			mask_comb[3][0] = mask[3][1];
			mask_comb[2][7] = mask[3][0];
			mask_comb[2][6] = mask[2][7];
			mask_comb[2][5] = mask[2][6];
			mask_comb[2][4] = mask[2][5];
			mask_comb[2][3] = mask[2][4];
			mask_comb[2][2] = mask[2][3];
			mask_comb[2][1] = mask[2][2];
			mask_comb[2][0] = mask[2][1];
			mask_comb[1][7] = mask[2][0];
			mask_comb[1][6] = mask[1][7];
			mask_comb[1][5] = mask[1][6];
			mask_comb[1][4] = mask[1][5];
			mask_comb[1][3] = mask[1][4];
			mask_comb[1][2] = mask[1][3];
			mask_comb[1][1] = mask[1][2];
			mask_comb[1][0] = mask[1][1];
			mask_comb[0][7] = mask[1][0];
			mask_comb[0][6] = mask[0][7];
			mask_comb[0][5] = mask[0][6];
			mask_comb[0][4] = mask[0][5];
			mask_comb[0][3] = mask[0][4];
			mask_comb[0][2] = mask[0][3];
			mask_comb[0][1] = mask[0][2];
			mask_comb[0][0] = mask[0][1];
		end
		S_col: begin 
			for (int i=0;i<8;i++) begin
				mask_comb[cnt[2:0]][i] = mask[cnt[2:0]][i] - col_min_comb;
			end
		end
	endcase
end

assign out_job = 0;
assign out_cost = 0;
assign out_valid = 0;
endmodule