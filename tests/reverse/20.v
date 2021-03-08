module reverse_converter_1048577_1048576_1048575 (x1, x2, x3, out);
	input [20:0] x1;
	input [19:0] x2;
	input [19:0] x3;
	wire [39:0] a1;
	wire [39:0] a2;
	wire [39:0] a3;
	wire [39:0] sum1;
	wire [39:0] sum2;
	wire [39:0] sum3;
	output [59:0] out;
		
	coef_a1 ca1(x1,a1);
	coef_a2 ca2(x2,a2);
	coef_a3 ca3(x3,a3);
	sum_modulo_1099511627775 sm1(a2, a3, sum1);
	sub_a1_x1 sm2(a1, x1, sum2);
	sum_modulo_1099511627775 sm3(sum1, sum2, sum3);
	
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
	assign out[10] = x2[10];
	assign out[11] = x2[11];
	assign out[12] = x2[12];
	assign out[13] = x2[13];
	assign out[14] = x2[14];
	assign out[15] = x2[15];
	assign out[16] = x2[16];
	assign out[17] = x2[17];
	assign out[18] = x2[18];
	assign out[19] = x2[19];
	
	assign out[20] = sum3[0];
	assign out[21] = sum3[1];
	assign out[22] = sum3[2];
	assign out[23] = sum3[3];
	assign out[24] = sum3[4];
	assign out[25] = sum3[5];
	assign out[26] = sum3[6];
	assign out[27] = sum3[7];
	assign out[28] = sum3[8];
	assign out[29] = sum3[9];
	assign out[30] = sum3[10];
	assign out[31] = sum3[11];
	assign out[32] = sum3[12];
	assign out[33] = sum3[13];
	assign out[34] = sum3[14];
	assign out[35] = sum3[15];
	assign out[36] = sum3[16];
	assign out[37] = sum3[17];
	assign out[38] = sum3[18];
	assign out[39] = sum3[19];
	assign out[40] = sum3[20];
	assign out[41] = sum3[21];
	assign out[42] = sum3[22];
	assign out[43] = sum3[23];
	assign out[44] = sum3[24];
	assign out[45] = sum3[25];
	assign out[46] = sum3[26];
	assign out[47] = sum3[27];
	assign out[48] = sum3[28];
	assign out[49] = sum3[29];
	assign out[50] = sum3[30];
	assign out[51] = sum3[31];
	assign out[52] = sum3[32];
	assign out[53] = sum3[33];
	assign out[54] = sum3[34];
	assign out[55] = sum3[35];
	assign out[56] = sum3[36];
	assign out[57] = sum3[37];
	assign out[58] = sum3[38];
	assign out[59] = sum3[39];
	
endmodule

module coef_a3 (x3, a3);
	input [19:0] x3;
	output [39:0] a3;
	assign a3[39] = x3[0];
	assign a3[38] = x3[19];
	assign a3[37] = x3[18];
	assign a3[36] = x3[17];
	assign a3[35] = x3[16];
	assign a3[34] = x3[15];
	assign a3[33] = x3[14];
	assign a3[32] = x3[13];
	assign a3[31] = x3[12];
	assign a3[30] = x3[11];
	assign a3[29] = x3[10];
	assign a3[28] = x3[9];
	assign a3[27] = x3[8];
	assign a3[26] = x3[7];
	assign a3[25] = x3[6];
	assign a3[24] = x3[5];
	assign a3[23] = x3[4];
	assign a3[22] = x3[3];
	assign a3[21] = x3[2];
	assign a3[20] = x3[1];
	assign a3[19] = x3[0];
	assign a3[18] = x3[19];
	assign a3[17] = x3[18];
	assign a3[16] = x3[17];
	assign a3[15] = x3[16];
	assign a3[14] = x3[15];
	assign a3[13] = x3[14];
	assign a3[12] = x3[13];
	assign a3[11] = x3[12];
	assign a3[10] = x3[11];
	assign a3[9] = x3[10];
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
	input [19:0] x2;
	output [39:0] a2;
	assign a2[39] = ~x2[19];
	assign a2[38] = ~x2[18];
	assign a2[37] = ~x2[17];
	assign a2[36] = ~x2[16];
	assign a2[35] = ~x2[15];
	assign a2[34] = ~x2[14];
	assign a2[33] = ~x2[13];
	assign a2[32] = ~x2[12];
	assign a2[31] = ~x2[11];
	assign a2[30] = ~x2[10];
	assign a2[29] = ~x2[9];
	assign a2[28] = ~x2[8];
	assign a2[27] = ~x2[7];
	assign a2[26] = ~x2[6];
	assign a2[25] = ~x2[5];
	assign a2[24] = ~x2[4];
	assign a2[23] = ~x2[3];
	assign a2[22] = ~x2[2];
	assign a2[21] = ~x2[1];
	assign a2[20] = ~x2[0];
	assign a2[19] = 1;
	assign a2[18] = 1;
	assign a2[17] = 1;
	assign a2[16] = 1;
	assign a2[15] = 1;
	assign a2[14] = 1;
	assign a2[13] = 1;
	assign a2[12] = 1;
	assign a2[11] = 1;
	assign a2[10] = 1;
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
	input [20:0] x1;
	output [39:0] a1;
	wire bx;
	
	assign bx = x1[20] ^ x1[0];
	assign a1[39] = bx;
	assign a1[38] = x1[19];
	assign a1[37] = x1[18];
	assign a1[36] = x1[17];
	assign a1[35] = x1[16];
	assign a1[34] = x1[15];
	assign a1[33] = x1[14];
	assign a1[32] = x1[13];
	assign a1[31] = x1[12];
	assign a1[30] = x1[11];
	assign a1[29] = x1[10];
	assign a1[28] = x1[9];
	assign a1[27] = x1[8];
	assign a1[26] = x1[7];
	assign a1[25] = x1[6];
	assign a1[24] = x1[5];
	assign a1[23] = x1[4];
	assign a1[22] = x1[3];
	assign a1[21] = x1[2];
	assign a1[20] = x1[1];
	assign a1[19] = bx;
	assign a1[18] = x1[19];
	assign a1[17] = x1[18];
	assign a1[16] = x1[17];
	assign a1[15] = x1[16];
	assign a1[14] = x1[15];
	assign a1[13] = x1[14];
	assign a1[12] = x1[13];
	assign a1[11] = x1[12];
	assign a1[10] = x1[11];
	assign a1[9] = x1[10];
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

// Sum modulo (2^40 - 1) = 1099511627775
module sum_modulo_1099511627775 (in1, in2, out);
	input [39:0] in1;
	input [39:0] in2;
	output reg [39:0] out;
	wire [40:0] data;
	wire [40:0] data2;
	assign data = in1 + in2;
	assign data2 = in1 + in2 + 1;
	always @(*)
	begin
		if (data2[40] == 1)
			out <= data2[39:0];
		else
			out <= data[39:0];
	end
endmodule

module sub_a1_x1 (a1, x1, out);
	input [39:0] a1;
	input [20:0] x1;
	output [39:0] out;
	
	assign out = a1 - x1;
	
endmodule

