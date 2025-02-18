module CN(
    // Input signals
    opcode,
    in_n0,
    in_n1,
    in_n2,
    in_n3,
    in_n4,
    in_n5,
    // Output signals
    out_n
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [3:0] in_n0, in_n1, in_n2, in_n3, in_n4, in_n5;
input [4:0] opcode;
output logic [8:0] out_n;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [4:0] value[0:5], a[0:5], a1[0:5], a2[0:5], a3[0:5], a4[0:5], a5[0:5], out[0:5];
logic [9:0] mul_reg;
//---------------------------------------------------------------------
//   Your design                        
//---------------------------------------------------------------------
register_file f1(.address(in_n0),.value(value[0]));
register_file f2(.address(in_n1),.value(value[1]));
register_file f3(.address(in_n2),.value(value[2]));
register_file f4(.address(in_n3),.value(value[3]));
register_file f5(.address(in_n4),.value(value[4]));
register_file f6(.address(in_n5),.value(value[5]));

always_comb begin
    a[0] = value[0];
    a[1] = value[1];
    a[2] = value[2];
    a[3] = value[3];
    a[4] = value[4];
    a[5] = value[5];

    //Bose-Nelson Sort Start
    
    a1[0] = (a[0] < a[1])? a[0] : a[1];
    a1[1] = (a[0] < a[1])? a[1] : a[0];
    a1[2] = (a[2] < a[3])? a[2] : a[3];
    a1[3] = (a[2] < a[3])? a[3] : a[2];
    a1[4] = (a[4] < a[5])? a[4] : a[5];
    a1[5] = (a[4] < a[5])? a[5] : a[4];

    a2[0] = (a1[0] < a1[2])? a1[0] : a1[2];
    a2[2] = (a1[0] < a1[2])? a1[2] : a1[0];   
    a2[3] = (a1[3] < a1[5])? a1[3] : a1[5];
    a2[5] = (a1[3] < a1[5])? a1[5] : a1[3];
    a2[1] = (a1[1] < a1[4])? a1[1] : a1[4];
    a2[4] = (a1[1] < a1[4])? a1[4] : a1[1];

    a3[0] = (a2[0] < a2[1])? a2[0] : a2[1];
    a3[1] = (a2[0] < a2[1])? a2[1] : a2[0];
    a3[2] = (a2[2] < a2[3])? a2[2] : a2[3];
    a3[3] = (a2[2] < a2[3])? a2[3] : a2[2];
    a3[4] = (a2[4] < a2[5])? a2[4] : a2[5];
    a3[5] = (a2[4] < a2[5])? a2[5] : a2[4];

    a4[0] = (a3[1] < a3[2])? a3[1] : a3[2];
    a4[1] = (a3[1] < a3[2])? a3[2] : a3[1];
    a4[2] = (a3[3] < a3[4])? a3[3] : a3[4];
    a4[3] = (a3[3] < a3[4])? a3[4] : a3[3];
    a4[4] = (a4[1] < a4[2])? a4[1] : a4[2];
    a4[5] = (a4[1] < a4[2])? a4[2] : a4[1];

    a5[0] = a3[0]; 
    a5[1] = a4[0]; 
    a5[2] = a4[4]; 
    a5[3] = a4[5]; 
    a5[4] = a4[3]; 
    a5[5] = a3[5]; 
    //Bose-Nelson End

    case(opcode[4:3])
        2'b11:
        begin
            out[0] = a5[0]; 
            out[1] = a5[1]; 
            out[2] = a5[2]; 
            out[3] = a5[3]; 
            out[4] = a5[4]; 
            out[5] = a5[5]; 
        end
        2'b10:
        begin
            out[0] = a5[5]; 
            out[1] = a5[4]; 
            out[2] = a5[3]; 
            out[3] = a5[2]; 
            out[4] = a5[1]; 
            out[5] = a5[0]; 
        end
        2'b01:
        begin            
            out[0] = value[5];
            out[1] = value[4];
            out[2] = value[3];
            out[3] = value[2];
            out[4] = value[1];
            out[5] = value[0];
        end
        2'b00:
        begin 
            out[0] = value[0];
            out[1] = value[1];
            out[2] = value[2];
            out[3] = value[3];
            out[4] = value[4];
            out[5] = value[5];
        end
    endcase
end

assign mul_reg = (out[3] * out[4]);

always_comb begin
    case(opcode[2:0])
        3'b000: out_n = out[2] - out[1];
        3'b001: out_n = out[0] + out[3];
        3'b010: out_n = mul_reg >> 1;
        3'b011: out_n = out[1] + (out[5] << 1);
        3'b100: out_n = out[1] & out[2];
        3'b101: out_n = ~out[0];
        3'b110: out_n = out[3] ^ out[4];
        3'b111: out_n = out[1] << 1;
    endcase
end

endmodule
//---------------------------------------------------------------------
//   Register design from TA (Do not modify, or demo fails)
//---------------------------------------------------------------------
module register_file(
    address,
    value
);
input [3:0] address;
output logic [4:0] value;

always_comb begin
    case(address)
    4'b0000:value = 5'd9;
    4'b0001:value = 5'd27;
    4'b0010:value = 5'd30;
    4'b0011:value = 5'd3;
    4'b0100:value = 5'd11;
    4'b0101:value = 5'd8;
    4'b0110:value = 5'd26;
    4'b0111:value = 5'd17;
    4'b1000:value = 5'd3;
    4'b1001:value = 5'd12;
    4'b1010:value = 5'd1;
    4'b1011:value = 5'd10;
    4'b1100:value = 5'd15;
    4'b1101:value = 5'd5;
    4'b1110:value = 5'd23;
    4'b1111:value = 5'd20;
    default: value = 0;
    endcase
end

endmodule
