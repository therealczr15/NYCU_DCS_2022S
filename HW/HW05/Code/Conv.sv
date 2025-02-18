module Conv(
  // Input signals
  clk,
  rst_n,
  image_valid,
  filter_valid,
  in_data,
  // Output signals
  out_valid,
  out_data
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk, rst_n, image_valid, filter_valid;
input [3:0] in_data;
output logic signed [15:0] out_data;
output logic out_valid;

logic signed [3:0] image[0:4];
logic signed [10:0] image_8x4[0:16], image_8x4_comb[0:16];
logic signed [15:0] image_4x4[0:7], image_4x4_comb[0:7];
logic signed [15:0] out_data_comb;
logic signed [3:0] filter[0:9], filter_comb[0:9];
logic [5:0] cnt, cnt_comb, cnt_reg;
logic image_valid_reg;
//---------------------------------------------------------------------
//   Your design                       
//---------------------------------------------------------------------
assign filter_comb = (filter_valid) ? {filter[1],filter[2],filter[3],filter[4],filter[5],filter[6],filter[7],filter[8],filter[9],in_data} : filter;
always_ff @(posedge clk or negedge rst_n) begin 
  if(!rst_n) begin
    filter[0] <= 0;
    filter[1] <= 0;
    filter[2] <= 0;
    filter[3] <= 0;
    filter[4] <= 0;
    filter[5] <= 0;
    filter[6] <= 0;
    filter[7] <= 0;
    filter[8] <= 0;
    filter[9] <= 0;
  end else begin
    filter[0] <= filter_comb[0];
    filter[1] <= filter_comb[1];
    filter[2] <= filter_comb[2];
    filter[3] <= filter_comb[3];
    filter[4] <= filter_comb[4];
    filter[5] <= filter_comb[5];
    filter[6] <= filter_comb[6];
    filter[7] <= filter_comb[7];
    filter[8] <= filter_comb[8];
    filter[9] <= filter_comb[9];
  end
end

always_ff @(posedge clk or negedge rst_n) begin 
  if(!rst_n) 
    image_valid_reg <= 0;
  else 
    image_valid_reg <= image_valid;
end

always_comb begin
  if(&cnt)
    cnt_comb = 0;
  else if(image_valid_reg)
    cnt_comb = cnt + 1;
  else
    cnt_comb = 0;
end
always_ff @(posedge clk or negedge rst_n) begin 
  if(!rst_n) 
    cnt <= 0;
  else 
    cnt <= cnt_comb;
end
always_ff @(posedge clk or negedge rst_n) begin 
  if(!rst_n) 
    cnt_reg <= 0;
  else 
    cnt_reg <= cnt;
end

always_ff @(posedge clk or negedge rst_n) begin 
  if(!rst_n) begin
    image[0] <= 0;
    image[1] <= 0;
    image[2] <= 0;
    image[3] <= 0;
    image[4] <= 0;
  end else begin
    image[0] <= image[1];
    image[1] <= image[2];
    image[2] <= image[3];
    image[3] <= image[4];
    image[4] <= in_data;
  end
end

always_comb begin
  image_8x4_comb[0] = image_8x4[0];
  image_8x4_comb[1] = image_8x4[1];
  image_8x4_comb[2] = image_8x4[2];
  image_8x4_comb[3] = image_8x4[3];
  image_8x4_comb[4] = image_8x4[4];
  image_8x4_comb[5] = image_8x4[5];
  image_8x4_comb[6] = image_8x4[6];
  image_8x4_comb[7] = image_8x4[7];
  image_8x4_comb[8] = image_8x4[8];
  image_8x4_comb[9] = image_8x4[9];
  image_8x4_comb[10] = image_8x4[10];
  image_8x4_comb[11] = image_8x4[11];
  image_8x4_comb[12] = image_8x4[12];
  image_8x4_comb[13] = image_8x4[13];
  image_8x4_comb[14] = image_8x4[14];
  image_8x4_comb[15] = image_8x4[15];
  image_8x4_comb[16] = image_8x4[16];
  if(cnt[2]) begin
    image_8x4_comb[0] = image_8x4[1];
    image_8x4_comb[1] = image_8x4[2];
    image_8x4_comb[2] = image_8x4[3];
    image_8x4_comb[3] = image_8x4[4];
    image_8x4_comb[4] = image_8x4[5];
    image_8x4_comb[5] = image_8x4[6];
    image_8x4_comb[6] = image_8x4[7];
    image_8x4_comb[7] = image_8x4[8];
    image_8x4_comb[8] = image_8x4[9];
    image_8x4_comb[9] = image_8x4[10];
    image_8x4_comb[10] = image_8x4[11];
    image_8x4_comb[11] = image_8x4[12];
    image_8x4_comb[12] = image_8x4[13];
    image_8x4_comb[13] = image_8x4[14];
    image_8x4_comb[14] = image_8x4[15];
    image_8x4_comb[15] = image_8x4[16];
    image_8x4_comb[16] = image[0] * filter[0] + image[1] * filter[1] + image[2] * filter[2] + image[3] * filter[3] + image[4] * filter[4]; 
  end
end
always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    image_8x4[0] <= 0;
    image_8x4[1] <= 0;
    image_8x4[2] <= 0;
    image_8x4[3] <= 0;
    image_8x4[4] <= 0;
    image_8x4[5] <= 0;
    image_8x4[6] <= 0;
    image_8x4[7] <= 0;
    image_8x4[8] <= 0;
    image_8x4[9] <= 0;
    image_8x4[10] <= 0;
    image_8x4[11] <= 0;
    image_8x4[12] <= 0;
    image_8x4[13] <= 0;
    image_8x4[14] <= 0;
    image_8x4[15] <= 0;
    image_8x4[16] <= 0;
  end else begin
    image_8x4[0] <= image_8x4_comb[0];
    image_8x4[1] <= image_8x4_comb[1];
    image_8x4[2] <= image_8x4_comb[2];
    image_8x4[3] <= image_8x4_comb[3];
    image_8x4[4] <= image_8x4_comb[4];
    image_8x4[5] <= image_8x4_comb[5];
    image_8x4[6] <= image_8x4_comb[6];
    image_8x4[7] <= image_8x4_comb[7];
    image_8x4[8] <= image_8x4_comb[8];
    image_8x4[9] <= image_8x4_comb[9];
    image_8x4[10] <= image_8x4_comb[10];
    image_8x4[11] <= image_8x4_comb[11];
    image_8x4[12] <= image_8x4_comb[12];
    image_8x4[13] <= image_8x4_comb[13];
    image_8x4[14] <= image_8x4_comb[14];
    image_8x4[15] <= image_8x4_comb[15];
    image_8x4[16] <= image_8x4_comb[16];
  end
end

always_comb begin
  image_4x4_comb[0] = image_4x4[0];
  image_4x4_comb[1] = image_4x4[1];
  image_4x4_comb[2] = image_4x4[2];
  image_4x4_comb[3] = image_4x4[3];
  image_4x4_comb[4] = image_4x4[4];
  image_4x4_comb[5] = image_4x4[5];
  image_4x4_comb[6] = image_4x4[6];
  image_4x4_comb[7] = image_4x4[7];
  if(cnt_reg[2] && cnt_reg[5]) begin
    image_4x4_comb[0] = image_8x4[0] * filter[5] + image_8x4[4] * filter[6] + image_8x4[8] * filter[7] + image_8x4[12] * filter[8] + image_8x4[16] * filter[9];
    image_4x4_comb[1] = image_4x4[0];
    image_4x4_comb[2] = image_4x4[1];
    image_4x4_comb[3] = image_4x4[2];
    image_4x4_comb[4] = image_4x4[3];
    image_4x4_comb[5] = image_4x4[4];
    image_4x4_comb[6] = image_4x4[5];
    image_4x4_comb[7] = image_4x4[6];
  end
end
always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    image_4x4[0] <= 0;
    image_4x4[1] <= 0;
    image_4x4[2] <= 0;
    image_4x4[3] <= 0;
    image_4x4[4] <= 0;
    image_4x4[5] <= 0;
    image_4x4[6] <= 0;
    image_4x4[7] <= 0;
  end else begin
    image_4x4[0] <= image_4x4_comb[0];
    image_4x4[1] <= image_4x4_comb[1];
    image_4x4[2] <= image_4x4_comb[2];
    image_4x4[3] <= image_4x4_comb[3];
    image_4x4[4] <= image_4x4_comb[4];
    image_4x4[5] <= image_4x4_comb[5];
    image_4x4[6] <= image_4x4_comb[6];
    image_4x4[7] <= image_4x4_comb[7];
  end
end
assign out_valid_comb = (cnt_reg[5:4] == 3);
always_ff @(posedge clk or negedge rst_n) begin 
  if(!rst_n) 
    out_valid <= 0;
  else 
    out_valid <= out_valid_comb;
end
always_comb begin
  if(cnt_reg[5:4] == 3)  begin
    case(cnt_reg[3:2])
      2'b00: out_data_comb = image_4x4_comb[~(cnt_reg[2:0])];
      2'b01: out_data_comb = image_4x4_comb[4];
      2'b10: out_data_comb = image_4x4_comb[~(cnt_reg[1:0])];
      2'b11: out_data_comb = image_4x4_comb[0];
    endcase
  end else
    out_data_comb = 0;
end

always_ff @(posedge clk or negedge rst_n) begin 
  if(!rst_n) 
    out_data <= 0;
  else 
    out_data <= out_data_comb;
end
endmodule
