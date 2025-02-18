module Checkdigit(
    // Input signals
    in_num,
    in_valid,
    rst_n,
    clk,
    // Output signals
    out_valid,
    out
);

input [3:0] in_num;
input in_valid, rst_n, clk;
output logic out_valid;
output logic [3:0] out;
logic [3:0] cnt, cnt_nxt, in_temp, sum, sum_nxt;

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n)
        cnt <= 0;
    else
        cnt <= cnt_nxt;
end

always_ff @(posedge clk ) begin 
        sum <= sum_nxt;
end

always_comb begin
    if (!in_valid)
        cnt_nxt = 0;
    else if(&cnt)
        cnt_nxt = 0;
    else
        cnt_nxt = cnt + 1;
end

assign out_valid = (&cnt ) ? (&cnt) : 0;

always_comb begin
    if(&cnt)
        sum_nxt = 0;
    else if(!in_valid)
        sum_nxt = 0;
    else
        sum_nxt = (in_temp > sum) ? ((sum - in_temp) + 10)  : (sum - in_temp);
end
 
always_comb begin
    in_temp = in_num;
    if(!cnt[0]) begin
        case (in_num)
            0 : in_temp = 0;
            1 : in_temp = 2;
            2 : in_temp = 4;
            3 : in_temp = 6;
            4 : in_temp = 8;
            5 : in_temp = 1;
            6 : in_temp = 3;
            7 : in_temp = 5;
            8 : in_temp = 7;
            9 : in_temp = 9;
        endcase
    end
end

always_comb begin
    if(&cnt )
        out = (|sum) ? sum : cnt;
    else
        out = 0;
end

endmodule