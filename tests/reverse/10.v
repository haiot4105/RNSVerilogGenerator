module reverse_converter_1025_1024_1023 (x1, x2, x3, out);
	input [10:0] x1;
	input [9:0] x2;
	input [9:0] x3;
	wire [19:0] a1;
	wire [19:0] a2;
	wire [19:0] a3;
	wire [19:0] sum1;
	wire [19:0] sum2;
	wire [19:0] sum3;
	output [29:0] out;
		
	coef_a1 ca1(x1,a1);
	coef_a2 ca2(x2,a2);
	coef_a3 ca3(x3,a3);
	sum_modulo_1048575 sm1(a2, a3, sum1);
	sub_a1_x1 sm2(a1, x1, sum2);
	sum_modulo_1048575 sm3(sum1, sum2, sum3);
	
	assign out[0] = x2[0];
	assign out[1] = x2[1];
	assign out[2] = x2[2];
	assign out[3] = x2[3];
	assign out[4] = x2[4];
	assign out[5] = x2[5];
	assign out[6] = x2[6];
	assign out[7] = x2[7];
	assign out[8] = x2[8];
	assign out[9] = x2[9];
	
	assign out[10] = sum3[0];
	assign out[11] = sum3[1];
	assign out[12] = sum3[2];
	assign out[13] = sum3[3];
	assign out[14] = sum3[4];
	assign out[15] = sum3[5];
	assign out[16] = sum3[6];
	assign out[17] = sum3[7];
	assign out[18] = sum3[8];
	assign out[19] = sum3[9];
	assign out[20] = sum3[10];
	assign out[21] = sum3[11];
	assign out[22] = sum3[12];
	assign out[23] = sum3[13];
	assign out[24] = sum3[14];
	assign out[25] = sum3[15];
	assign out[26] = sum3[16];
	assign out[27] = sum3[17];
	assign out[28] = sum3[18];
	assign out[29] = sum3[19];
	
endmodule

module coef_a3 (x3, a3);
	input [9:0] x3;
	output [19:0] a3;
	assign a3[19] = x3[0];
	assign a3[18] = x3[9];
	assign a3[17] = x3[8];
	assign a3[16] = x3[7];
	assign a3[15] = x3[6];
	assign a3[14] = x3[5];
	assign a3[13] = x3[4];
	assign a3[12] = x3[3];
	assign a3[11] = x3[2];
	assign a3[10] = x3[1];
	assign a3[9] = x3[0];
	assign a3[8] = x3[9];
	assign a3[7] = x3[8];
	assign a3[6] = x3[7];
	assign a3[5] = x3[6];
	assign a3[4] = x3[5];
	assign a3[3] = x3[4];
	assign a3[2] = x3[3];
	assign a3[1] = x3[2];
	assign a3[0] = x3[1];
endmodule

module coef_a2 (x2, a2);
	input [9:0] x2;
	output [19:0] a2;
	assign a2[19] = ~x2[9];
	assign a2[18] = ~x2[8];
	assign a2[17] = ~x2[7];
	assign a2[16] = ~x2[6];
	assign a2[15] = ~x2[5];
	assign a2[14] = ~x2[4];
	assign a2[13] = ~x2[3];
	assign a2[12] = ~x2[2];
	assign a2[11] = ~x2[1];
	assign a2[10] = ~x2[0];
	assign a2[9] = 1;
	assign a2[8] = 1;
	assign a2[7] = 1;
	assign a2[6] = 1;
	assign a2[5] = 1;
	assign a2[4] = 1;
	assign a2[3] = 1;
	assign a2[2] = 1;
	assign a2[1] = 1;
	assign a2[0] = 1;
endmodule

module coef_a1 (x1, a1);
	input [10:0] x1;
	output [19:0] a1;
	wire bx;
	
	assign bx = x1[10] ^ x1[0];
	assign a1[19] = bx;
	assign a1[18] = x1[9];
	assign a1[17] = x1[8];
	assign a1[16] = x1[7];
	assign a1[15] = x1[6];
	assign a1[14] = x1[5];
	assign a1[13] = x1[4];
	assign a1[12] = x1[3];
	assign a1[11] = x1[2];
	assign a1[10] = x1[1];
	assign a1[9] = bx;
	assign a1[8] = x1[9];
	assign a1[7] = x1[8];
	assign a1[6] = x1[7];
	assign a1[5] = x1[6];
	assign a1[4] = x1[5];
	assign a1[3] = x1[4];
	assign a1[2] = x1[3];
	assign a1[1] = x1[2];
	assign a1[0] = x1[1];
	
endmodule

// Sum modulo (2^20 - 1) = 1048575
module sum_modulo_1048575 (in1, in2, out);
	input [19:0] in1;
	input [19:0] in2;
	output reg [19:0] out;
	wire [20:0] data;
	wire [20:0] data2;
	assign data = in1 + in2;
	assign data2 = in1 + in2 + 1;
	always @(*)
	begin
		if (data2[20] == 1)
			out <= data2[19:0];
		else
			out <= data[19:0];
	end
endmodule

module sub_a1_x1 (a1, x1, out);
	input [19:0] a1;
	input [10:0] x1;
	output [19:0] out;
	
	assign out = a1 - x1;
	
endmodule
