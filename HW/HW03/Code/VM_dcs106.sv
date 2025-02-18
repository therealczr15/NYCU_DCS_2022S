
module VM(
//Input 
    clk,
    rst_n,
    in_item_valid,
    in_coin_valid,
    in_coin,
    in_rtn_coin,
    in_buy_item,
    in_item_price,
//OUTPUT
    out_monitor,
    out_valid,
    out_consumer,
    out_sell_num
);

//Input 
input clk;
input rst_n;
input in_item_valid;
input in_coin_valid;
input [5:0] in_coin;
input in_rtn_coin;
input [2:0] in_buy_item;
input [4:0] in_item_price;
//OUTPUT
output logic [8:0] out_monitor;
output logic out_valid;
output logic [3:0] out_consumer;
output logic [5:0] out_sell_num;

logic out_valid_comb;
logic [2:0] cnt, cnt_comb, buy_item_flag;
logic [3:0] out_consumer_comb;
logic [5:0] sell_num[0:5], sell_num_comb[0:5];
logic [8:0] out_monitor_comb;
logic [9:0] total, total_comb;
logic [4:0] item_price [5:0], item_price_comb[5:0];
logic [1:0] cur_state, nxt_state;
logic [3:0] q_50, q_20, q_10, q_5, q_1;
logic [5:0] r_50;
logic [4:0] r_20;
logic [3:0] r_10;
logic [3:0] a, b, c;
parameter S_idle = 2'd0;
parameter S_buy = 2'd2;
parameter S_rtn = 2'd1;
parameter S_invalid = 2'd3; 
//---------------------------------------------------------------------
//  Your design(Using FSM)                            
//---------------------------------------------------------------------
//FSM
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        cur_state <= S_idle;
    else 
        cur_state <= nxt_state;
end
always_comb begin
    nxt_state = cur_state;
    case (cur_state)
        S_idle: nxt_state = (in_rtn_coin) ? S_rtn : (|in_buy_item) ? ((total_comb[9]) ? S_invalid : S_buy ): S_idle;
        S_buy: nxt_state = (cnt == 6) ? S_idle : S_buy;
        S_rtn: nxt_state = (cnt == 6) ? S_idle : S_rtn;
        S_invalid: nxt_state = (cnt == 6) ? S_idle : S_invalid;
    endcase
end

//cnt
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        cnt <= 0;
    else 
        cnt <= cnt_comb;
end
always_comb begin
    if(nxt_state != S_idle)
        cnt_comb = cnt + 1;
    else 
        cnt_comb = 0;
end

//item_price
always_ff @(posedge clk) begin 
    item_price <= item_price_comb;
end
assign item_price_comb = (in_item_valid) ? {in_item_price,item_price[5],item_price[4],item_price[3],item_price[2],item_price[1]} : item_price;

//out_valid
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        out_valid <= 0;
    else
        out_valid <= out_valid_comb;
end
assign out_valid_comb = !(cnt_comb == 0);

//out_monitor
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        out_monitor <= 0;
    else 
        out_monitor <= out_monitor_comb;
end
always_comb begin
    out_monitor_comb = 0;
    case (nxt_state) 
        S_idle: begin           
            if(in_coin_valid) 
                out_monitor_comb = out_monitor + in_coin;
            else if((cnt == 6) || (cnt == 0))
                out_monitor_comb = out_monitor;
        end
        S_invalid: out_monitor_comb = out_monitor;
    endcase
end

//sell_num
always_ff @(posedge clk) begin 
    sell_num <= sell_num_comb;
end
always_comb begin
    sell_num_comb = sell_num;
    if(in_item_valid) begin
        sell_num_comb = {6'd0,6'd0,6'd0,6'd0,6'd0,6'd0};
    end else if(nxt_state == S_buy)
        sell_num_comb[buy_item_flag] = sell_num[buy_item_flag] + 1;              
end

//out_cosumer
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        out_consumer <= 0;
    else 
        out_consumer <= out_consumer_comb;
end
assign buy_item_flag = in_buy_item + 7;
assign total_comb = (|in_buy_item) ? (out_monitor - item_price[buy_item_flag]) : (in_rtn_coin) ? out_monitor : total;
always_ff @(posedge clk) begin
    total <= total_comb;
end
//q means quotient and r means remainder
assign q_50 = total[8:1] / 25;
assign r_50 = total[8:0] - q_50 * 50;
assign a = r_50[5:2] + c;
assign c = (r_50[5:3] >= 5) ? 6 : 11;
always_comb begin
    if(r_50[5:3] >= 5)
        q_20 = 2;
    else if(r_50[5:2] >= 5) 
        q_20 = 1;
    else
        q_20 = 0;
end 
always_comb begin
    if(r_50[5:2] >= 5)
        r_20 = {a, r_50[1:0]};
    else
        r_20 = r_50[4:0];
end
assign q_10 = (r_20[4:1] >= 5) ? 1 : 0; 
assign r_10 = (r_20[4:1] >= 5) ? {r_20[4:1] + 11, r_20[0]} : r_20[3:0];
assign q_5  = (r_10 >= 5) ? 1 : 0; 
assign q_1  = (r_10 >= 5) ? (r_10 + 11) : r_10;
always_comb begin
    out_consumer_comb = 0;
    if(nxt_state != S_invalid) begin
        case(cnt_comb)
            1: out_consumer_comb = in_buy_item ;
            2: out_consumer_comb = q_50;
            3: out_consumer_comb = q_20;
            4: out_consumer_comb = q_10;
            5: out_consumer_comb = q_5;
            6: out_consumer_comb = q_1;
        endcase
    end 
end
always_comb begin
    out_sell_num = 0;
    case(cnt)
        3'd1: out_sell_num = sell_num[0];
        3'd2: out_sell_num = sell_num[1];
        3'd3: out_sell_num = sell_num[2];
        3'd4: out_sell_num = sell_num[3];
        3'd5: out_sell_num = sell_num[4];
        3'd6: out_sell_num = sell_num[5];
    endcase
end
endmodule