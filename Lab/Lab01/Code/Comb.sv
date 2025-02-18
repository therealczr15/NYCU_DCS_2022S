module Comb(
  // Input signals
	in_num0,
	in_num1,
	in_num2,
	in_num3,
  // Output signals
	out_num0,
	out_num1
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input [3:0] in_num0, in_num1, in_num2, in_num3;
output logic [4:0] out_num0, out_num1;

//---------------------------------------------------------------------
//   LOGIC DECLARATION
//---------------------------------------------------------------------
logic [3:0] Xnor, Or, And, Xor;
logic [4:0] sum[0:1];
//---------------------------------------------------------------------
//   Your DESIGN                        
//---------------------------------------------------------------------
assign Xnor = (in_num0 ~^ in_num1);
assign Or = (in_num1 | in_num3);
assign And = (in_num0 & in_num2);
assign Xor = (in_num2 ^ in_num3);
Adder a1(.sum(sum[0]), .in_num0(Xnor), .in_num1(Or));
Adder a2(.sum(sum[1]), .in_num0(And), .in_num1(Xor));
Comparator c1(.in_num0(sum[0]), .in_num1(sum[1]), .out_num0(out_num0), .out_num1(out_num1));
endmodule

module Adder(
	in_num0,
	in_num1,
	sum
);
input [3:0] in_num0, in_num1;
output logic[4:0] sum;
assign sum = in_num0 + in_num1;
endmodule

module Comparator(
	in_num0,
	in_num1,
	out_num0,
	out_num1
);
input [4:0] in_num0, in_num1;
output logic[4:0] out_num0, out_num1;
always_comb begin
	if(in_num0<in_num1)
	begin
		out_num0 = in_num0;
		out_num1 = in_num1;
	end 
	else
	begin
		out_num0 = in_num1;
		out_num1 = in_num0;
	end
end 
endmodule
