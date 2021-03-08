module reverse_converter_129_128_127 (x1, x2, x3, out);
	input [7:0] x1;
	input [6:0] x2;
	input [6:0] x3;
	wire [13:0] a1;
	wire [13:0] a2;
	wire [13:0] a3;
	wire [13:0] sum1;
	wire [13:0] sum2;
	wire [13:0] sum3;
	output [20:0] out;
		
	coef_a1 ca1(x1,a1);
	coef_a2 ca2(x2,a2);
	coef_a3 ca3(x3,a3);
	sum_modulo_16383 sm1(a2, a3, sum1);
	sub_a1_x1 sm2(a1, x1, sum2);
	sum_modulo_16383 sm3(sum1, sum2, sum3);
	
	assign out[0] = x2[0];
	assign out[1] = x2[1];
	assign out[2] = x2[2];
	assign out[3] = x2[3];
	assign out[4] = x2[4];
	assign out[5] = x2[5];
	assign out[6] = x2[6];
	
	assign out[7] = sum3[0];
	assign out[8] = sum3[1];
	assign out[9] = sum3[2];
	assign out[10] = sum3[3];
	assign out[11] = sum3[4];
	assign out[12] = sum3[5];
	assign out[13] = sum3[6];
	assign out[14] = sum3[7];
	assign out[15] = sum3[8];
	assign out[16] = sum3[9];
	assign out[17] = sum3[10];
	assign out[18] = sum3[11];
	assign out[19] = sum3[12];
	assign out[20] = sum3[13];
	
endmodule

module coef_a3 (x3, a3);
	input [6:0] x3;
	output [13:0] a3;
	assign a3[13] = x3[0];
	assign a3[12] = x3[6];
	assign a3[11] = x3[5];
	assign a3[10] = x3[4];
	assign a3[9] = x3[3];
	assign a3[8] = x3[2];
	assign a3[7] = x3[1];
	assign a3[6] = x3[0];
	assign a3[5] = x3[6];
	assign a3[4] = x3[5];
	assign a3[3] = x3[4];
	assign a3[2] = x3[3];
	assign a3[1] = x3[2];
	assign a3[0] = x3[1];
endmodule

module coef_a2 (x2, a2);
	input [6:0] x2;
	output [13:0] a2;
	assign a2[13] = ~x2[6];
	assign a2[12] = ~x2[5];
	assign a2[11] = ~x2[4];
	assign a2[10] = ~x2[3];
	assign a2[9] = ~x2[2];
	assign a2[8] = ~x2[1];
	assign a2[7] = ~x2[0];
	assign a2[6] = 1;
	assign a2[5] = 1;
	assign a2[4] = 1;
	assign a2[3] = 1;
	assign a2[2] = 1;
	assign a2[1] = 1;
	assign a2[0] = 1;
endmodule

module coef_a1 (x1, a1);
	input [7:0] x1;
	output [13:0] a1;
	wire bx;
	
	assign bx = x1[7] ^ x1[0];
	assign a1[13] = bx;
	assign a1[12] = x1[6];
	assign a1[11] = x1[5];
	assign a1[10] = x1[4];
	assign a1[9] = x1[3];
	assign a1[8] = x1[2];
	assign a1[7] = x1[1];
	assign a1[6] = bx;
	assign a1[5] = x1[6];
	assign a1[4] = x1[5];
	assign a1[3] = x1[4];
	assign a1[2] = x1[3];
	assign a1[1] = x1[2];
	assign a1[0] = x1[1];
	
endmodule

// Sum modulo (2^14 - 1) = 16383
module sum_modulo_16383 (in1, in2, out);
	input [13:0] in1;
	input [13:0] in2;
	output reg [13:0] out;
	wire [14:0] data;
	wire [14:0] data2;
	assign data = in1 + in2;
	assign data2 = in1 + in2 + 1;
	always @(*)
	begin
		if (data2[14] == 1)
			out <= data2[13:0];
		else
			out <= data[13:0];
	end
endmodule

module sub_a1_x1 (a1, x1, out);
	input [13:0] a1;
	input [7:0] x1;
	output [13:0] out;
	
	assign out = a1 - x1;
	
endmodule


