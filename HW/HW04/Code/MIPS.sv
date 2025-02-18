
module MIPS(
    //Input 
    clk,
    rst_n,
    in_valid,
    instruction,
	output_reg,
    //OUTPUT
    out_valid,
    out_1,
	out_2,
	out_3,
	out_4,
	instruction_fail
);

    //Input 
input clk;
input rst_n;
input in_valid;
input [31:0] instruction;
input [19:0] output_reg;
    //OUTPUT
output logic out_valid, instruction_fail;
output logic [31:0] out_1, out_2, out_3, out_4;

logic out_valid_comb;
logic [31:0] out_1_comb, out_2_comb, out_3_comb, out_4_comb;
logic instruction_fail_comb;

logic [31:0] judge;
logic [31:0] address[0:5], address_reg[0:5];
logic [31:0] ins_reg1, ins_reg1_comb, ins_reg2;
logic [31:0] write_value, write_value_reg, rt, rs, write_value1, write_value2;
logic [2:0] write_address, write_address_reg, rs_index, rt_index, rd_index;
logic [19:0] out_reg1, out_reg1_comb, out_reg2, out_reg3;
logic fail, fail_reg, in_valid1, in_valid1_comb, in_valid2, in_valid3;
logic func_judge;
//0

assign judge = 32'b10000000100001110000000100000000;

//1
assign ins_reg1_comb = (in_valid) ? instruction : 0;
assign out_reg1_comb = (in_valid) ? output_reg : 0;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        ins_reg1 <= 0;
    else
        ins_reg1 <= ins_reg1_comb;
end

always_ff @(posedge clk ) begin
    out_reg1 <= out_reg1_comb;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        in_valid1 <= 0;
    else
        in_valid1 <= in_valid;
end
//2
always_ff @(posedge clk ) begin
    ins_reg2 <= ins_reg1;
end

always_ff @(posedge clk) begin
    out_reg2 <= out_reg1;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        in_valid2 <= 0;
    else
        in_valid2 <= in_valid1;
end
//3
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        out_valid_comb <= 0;
    else
        out_valid_comb <= in_valid2;
end
assign rs_index = {ins_reg2[25]^ins_reg2[21],ins_reg2[24],ins_reg2[22]};
assign rt_index = {ins_reg2[20]^ins_reg2[16],ins_reg2[19],ins_reg2[17]};
assign rd_index = {ins_reg2[15]^ins_reg2[11],ins_reg2[14],ins_reg2[12]};

assign rs = address[rs_index];
assign rt = address[rt_index];


assign write_value1 = rs + ins_reg2[15:0];
//assign write_address1 = rt_index;
always_comb begin
    func_judge = 0;
    case(ins_reg2[5:0])
        6'b100000: begin write_value2 = rs + rt; end
        6'b100100: begin write_value2 = rs & rt; end
        6'b100101: begin write_value2 = rs | rt; end
        6'b100111: begin write_value2 = ~(rs | rt); end
        6'b000000: begin write_value2 = rt << ins_reg2[10:6]; end
        6'b000010: begin write_value2 = rt >> ins_reg2[10:6]; end
        default: begin write_value2 = 0; func_judge = 1; end
    endcase
end
//assign write_address2 = rd_index;
assign fail = ((ins_reg2[31:30] || ins_reg2[28:26]) || (!(judge[ins_reg2[25:21]] && judge[ins_reg2[20:16]]))) || ((!(ins_reg2[29] || judge[ins_reg2[15:11]]))||(!ins_reg2[29] && func_judge) );


assign write_value = (ins_reg2[29]) ? write_value1 : write_value2;
assign write_address = (ins_reg2[29]) ? rt_index : rd_index;
/*always_comb begin
    
    if(ins_reg2[29]) begin
        write_value = rs + ins_reg2[15:0];
        write_address = rt_index;
    end else begin
        write_address = rd_index;
        case(ins_reg2[5:0])
            6'b100000: write_value = rs + rt;
            6'b100100: write_value = rs & rt;
            6'b100101: write_value = rs | rt;
            6'b100111: write_value = ~(rs | rt);
            6'b000000: write_value = rt << ins_reg2[10:6];
            6'b000010: write_value = rt >> ins_reg2[10:6];
            default: begin write_value = 0; fail = 1; end
        endcase
    end
end*/

always_ff @(posedge clk) begin
    fail_reg <= fail;
end
always_ff @(posedge clk) begin
    write_address_reg <= write_address;
end
always_ff @(posedge clk) begin
    write_value_reg <= write_value;
end
always_ff @(posedge clk) begin
    out_reg3 <= out_reg2;
end
//4
always_comb begin
    address = address_reg;
    if(out_valid_comb && !fail_reg)
        address[write_address_reg] = write_value_reg;
end
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        address_reg <= {0,0,0,0,0,0};
    else
        address_reg <= address;
end

//assign out_valid_comb = in_valid3;
assign instruction_fail_comb = (out_valid_comb) ? fail_reg : 0;
assign out_1_comb = (fail_reg) ? 0 : address[{out_reg3[4]^out_reg3[0],out_reg3[3],out_reg3[1]}];
assign out_2_comb = (fail_reg) ? 0 : address[{out_reg3[9]^out_reg3[5],out_reg3[8],out_reg3[6]}];
assign out_3_comb = (fail_reg) ? 0 : address[{out_reg3[14]^out_reg3[10],out_reg3[13],out_reg3[11]}];
assign out_4_comb = (fail_reg) ? 0 : address[{out_reg3[19]^out_reg3[15],out_reg3[18],out_reg3[16]}];

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_valid <= 0;
    else 
        out_valid <= out_valid_comb;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_1 <= 0;
    else 
        out_1 <= out_1_comb;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_2 <= 0;
    else 
        out_2 <= out_2_comb;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_3 <= 0;
    else 
        out_3 <= out_3_comb;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_4 <= 0;
    else 
        out_4 <= out_4_comb;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        instruction_fail <= 0;
    else 
        instruction_fail <= instruction_fail_comb;
end

endmodule



