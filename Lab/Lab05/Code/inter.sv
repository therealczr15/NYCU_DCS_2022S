module inter(
  // Input signals
  clk,
  rst_n,
  in_valid_1,
  in_valid_2,
  in_valid_3,
  data_in_1,
  data_in_2,
  data_in_3,
  ready_slave1,
  ready_slave2,
  // Output signals
  valid_slave1,
  valid_slave2,
  addr_out,
  value_out,
  handshake_slave1,
  handshake_slave2
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n, in_valid_1, in_valid_2, in_valid_3;
input [6:0] data_in_1, data_in_2, data_in_3; 
input ready_slave1, ready_slave2;
output logic valid_slave1, valid_slave2;
output logic [2:0] addr_out, value_out;
output logic handshake_slave1, handshake_slave2;
//---------------------------------------------------------------------
//   YOUR DESIGN
//---------------------------------------------------------------------

parameter S_idle = 3'd0; 
parameter S_master1 = 3'd1;
parameter S_master2 = 3'd2;
parameter S_master3 = 3'd3;
parameter S_handshake = 3'd4; 

logic [6:0] data1_reg, data2_reg, data3_reg, data1_comb, data2_comb, data3_comb;
logic [2:0] cur_state, next_state, addr_nxt, value_nxt;
logic valid_slave1_nxt, valid_slave2_nxt, handshake_slave1_nxt, handshake_slave2_nxt;
logic flag1, flag2, flag3, flag1_nxt, flag2_nxt, flag3_nxt;

//Store input signal
always_ff @(posedge clk or negedge rst_n) begin 
  if(~rst_n) begin
    data1_reg <= 0;
    data2_reg <= 0;
    data3_reg <= 0;
    flag1 <= 0;
    flag2 <= 0;
    flag3 <= 0;
  end else begin
    data1_reg <= data1_comb;
    data2_reg <= data2_comb;
    data3_reg <= data3_comb;
    flag1 <= flag1_nxt;
    flag2 <= flag2_nxt;
    flag3 <= flag3_nxt;
  end
end

//FSM
always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    cur_state <= S_idle;
  else 
    cur_state <= next_state;
end

always_comb begin
  data1_comb = data1_reg; 
  data2_comb = data2_reg; 
  data3_comb = data3_reg;
  handshake_slave1_nxt = 0;
  handshake_slave2_nxt = 0;
  next_state = cur_state;
  flag1_nxt = flag1;
  flag2_nxt = flag2;
  flag3_nxt = flag3;

  if(in_valid_1) begin
    data1_comb = data_in_1;
    flag1_nxt = 1;
  end
  if(in_valid_2) begin
    data2_comb = data_in_2;
    flag2_nxt = 1;
  end
  if(in_valid_3) begin
    data3_comb = data_in_3; 
    flag3_nxt = 1;
  end

  case(cur_state)
    S_idle: begin
      if(in_valid_1) begin
        next_state = S_master1;
      end else if(in_valid_2) begin
        next_state = S_master2;
      end else if(in_valid_3) begin
        next_state = S_master3;
      end else begin
        next_state = S_idle;
      end
    end
    S_master1: begin
      case(data1_reg[6])
        0: begin 
          if((valid_slave1 == 1) && (ready_slave1 == 1)) begin
            next_state = S_handshake;
            handshake_slave1_nxt = 1;                       
          end else begin
            next_state = S_master1;
          end
        end
        1: begin 
          if((valid_slave2 == 1) && (ready_slave2 == 1)) begin
            next_state = S_handshake;
            handshake_slave2_nxt = 1;                      
          end else begin
            next_state = S_master1;
          end
        end
      endcase
    end
    S_master2: begin
      case(data2_reg[6])
        0: begin 
          if((valid_slave1 == 1) && (ready_slave1 == 1)) begin
            next_state = S_handshake;
            handshake_slave1_nxt = 1;                     
          end else begin
            next_state = S_master2;
          end
        end
        1: begin 
          if((valid_slave2 == 1) && (ready_slave2 == 1)) begin
            next_state = S_handshake;
            handshake_slave2_nxt = 1;                       
          end else begin
            next_state = S_master2;
          end
        end
      endcase
    end
    S_master3: begin
      case(data3_reg[6])
        0: begin 
          if((valid_slave1 == 1) && (ready_slave1 == 1)) begin
            next_state = S_handshake;
            handshake_slave1_nxt = 1;                       
          end else begin
            next_state = S_master3;
          end
        end
        1: begin 
          if((valid_slave2 == 1) && (ready_slave2 == 1)) begin
            next_state = S_handshake;
            handshake_slave2_nxt = 1;                       
          end else begin
            next_state = S_master3;
          end
        end
      endcase 
    end
    S_handshake: begin 
      if(flag1) begin
        flag1_nxt = 0;
        data1_comb = 0;
        if(flag2) 
          next_state = S_master2;
        else if (flag3)
          next_state = S_master3;
        else
          next_state = S_idle;
      end else if(flag2) begin
        flag2_nxt = 0;
        data2_comb = 0;
        if(flag3)
          next_state = S_master3;
        else
          next_state = S_idle;
      end else if(flag3) begin
        flag3_nxt = 0;
        data3_comb = 0;
        next_state = S_idle;
      end else
        next_state = S_idle;
    end
  endcase
end

//Output
always_ff @(posedge clk or negedge rst_n) begin 
    if(~rst_n) begin
        valid_slave1 <= 0;
        valid_slave2 <= 0;
        handshake_slave1 <= 0;
        handshake_slave2 <= 0;
        addr_out <= 0;
        value_out <= 0;
    end else begin
        valid_slave1 <= valid_slave1_nxt;
        valid_slave2 <= valid_slave2_nxt;
        handshake_slave1 <= handshake_slave1_nxt;
        handshake_slave2 <= handshake_slave2_nxt;
        addr_out <= addr_nxt;
        value_out <= value_nxt;
    end
end

always_comb begin
  case(cur_state)
    S_master1: begin
      addr_nxt = data1_reg[5:3];
      value_nxt = data1_reg[2:0];
      valid_slave1_nxt = (!data1_reg[6]);
      valid_slave2_nxt = data1_reg[6];
    end
    S_master2: begin
      addr_nxt = data2_reg[5:3];
      value_nxt = data2_reg[2:0];
      valid_slave1_nxt = (!data2_reg[6]);
      valid_slave2_nxt = data2_reg[6];
    end
    S_master3: begin
      addr_nxt = data3_reg[5:3];
      value_nxt = data3_reg[2:0];
      valid_slave1_nxt = (!data3_reg[6]);
      valid_slave2_nxt = data3_reg[6];
    end
    default: begin
      addr_nxt = 0;
      value_nxt = 0;
      valid_slave1_nxt = 0;
      valid_slave2_nxt = 0;
    end
  endcase
end


endmodule
