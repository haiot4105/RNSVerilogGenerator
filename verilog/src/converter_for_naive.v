module reverse_converter_9_8_7 (x1, x2, x3, out);
	input [3:0] x1;
	input [2:0] x2;
	input [2:0] x3;
	wire [5:0] a1;
	wire [5:0] a2;
	wire [5:0] a3;
	wire [5:0] sum1;
	wire [5:0] sum2;
	wire [5:0] sum3;
	output [8:0] out;
		
	coef_a1 ca1(x1,a1);
	coef_a2 ca2(x2,a2);
	coef_a3 ca3(x3,a3);
	sum_modulo_63 sm1(a2, a3, sum1);
	sub_a1_x1 sm2(a1, x1, sum2);
	sum_modulo_63 sm3(sum1, sum2, sum3);
	
	assign out[0] = x2[0];
	assign out[1] = x2[1];
	assign out[2] = x2[2];
	
	assign out[3] = sum3[0];
	assign out[4] = sum3[1];
	assign out[5] = sum3[2];
	assign out[6] = sum3[3];
	assign out[7] = sum3[4];
	assign out[8] = sum3[5];
	
endmodule

module coef_a3 (x3, a3);
	input [2:0] x3;
	output [5:0] a3;
	assign a3[5] = x3[0];
	assign a3[4] = x3[2];
	assign a3[3] = x3[1];
	assign a3[2] = x3[0];
	assign a3[1] = x3[2];
	assign a3[0] = x3[1];
endmodule

module coef_a2 (x2, a2);
	input [2:0] x2;
	output [5:0] a2;
	assign a2[5] = ~x2[2];
	assign a2[4] = ~x2[1];
	assign a2[3] = ~x2[0];
	assign a2[2] = 1;
	assign a2[1] = 1;
	assign a2[0] = 1;
endmodule

module coef_a1 (x1, a1);
	input [3:0] x1;
	output [5:0] a1;
	wire bx;
	
	assign bx = x1[3] ^ x1[0];
	assign a1[5] = bx;
	assign a1[4] = x1[2];
	assign a1[3] = x1[1];
	assign a1[2] = bx;
	assign a1[1] = x1[2];
	assign a1[0] = x1[1];
	
endmodule

// Sum modulo (2^6 - 1) = 63
module sum_modulo_63 (in1, in2, out);
	input [5:0] in1;
	input [5:0] in2;
	output reg [5:0] out;
	wire [6:0] data;
	wire [6:0] data2;
	assign data = in1 + in2;
	assign data2 = in1 + in2 + 1;
	always @(*)
	begin
		if (data2[6] == 1)
			out <= data2[5:0];
		else
			out <= data[5:0];
	end
endmodule

module sub_a1_x1 (a1, x1, out);
	input [5:0] a1;
	input [3:0] x1;
	output [5:0] out;
	
	assign out = a1 - x1;
	
endmodule

