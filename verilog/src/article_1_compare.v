// NOT WORKING
// module compare_9_8_7(a1_in, a2_in, a3_in, b1_in, b2_in, b3_in, res_le_out, res_eq_out, res_gr_out);

// 	input wire [3:0] a1_in;      // Module: 7
//     input wire [2:0] a2_in;      // Module: 8
//     input wire [2:0] a3_in;      // Module: 9

// 	input wire [3:0] b1_in;      // Module: 7
//     input wire [2:0] b2_in;      // Module: 8
//     input wire [2:0] b3_in;      // Module: 9
    
//     output wire res_le_out;     // equals to 1 if a less than b, 0 otherwise
//     output wire res_eq_out;     // equals to 1 if a equal to b, 0 otherwise
//     output wire res_gr_out;     // equals to 1 if a greater than b, 0 otherwise

//     wire [5:0] sum1, sum2, carry1, carry2, sub_sum, sub_carry;
//     wire c1, c2, c3;
//     wire cr_sum1, cr_cout1, cr_sum2, cr_cout_tmp, cr_cout2, cr_sum3;
//     wire sub_c1, sub_c2, sub_c3, sub_c_sum, sub_c_carry;
//     wire res_st_c, res_st_d_le, res_st_d_eq, res_st_d_gr, res_st_e_le, res_st_e_eq, res_st_e_gr;

//     stage_a st_a_first (a3_in, a2_in, a1_in, sum1, carry1);
//     stage_a st_a_second (b3_in, b2_in, b1_in, sum2, carry2);
    
//     carry_recognition cr1 (sum1, carry1, 1'b1, c1);
//     carry_recognition cr2 (sum2, carry2, 1'b1, c2);
    
//     half_adder ha1 (c1, ~c2, cr_sum1, cr_cout1);


//     stage_b st_b (sum1, carry1, sum2, carry2, sub_sum, sub_carry, sub_c1, sub_c2, sub_c3);

//     full_adder fa (sub_c1, sub_c2, sub_c3, sub_c_sum, sub_c_carry);

//     carry_recognition cr3 (sub_sum, sub_carry, 1'b0, c3);
    
//     half_adder ha2 (sub_c_sum, c3, cr_sum2, cr_cout_tmp);
//     half_adder ha3 (sub_c_carry, cr_cout_tmp, cr_sum3, cr_cout2);

//     stage_c st_c (sum1, carry1, ~sum2, ~carry2, res_st_c);

//     stage_d st_d (cr_sum3, cr_sum2, cr_cout1, cr_sum1, res_st_d_le, res_st_d_eq, res_st_d_gr);
//     stage_e st_e (a2_in, b2_in, res_st_e_le, res_st_e_eq, res_st_e_gr);

//     assign res_le_out = (res_st_c & res_st_e_le) | (~res_st_c & res_st_d_le);
//     assign res_eq_out = (res_st_c & res_st_e_eq) | (~res_st_c & res_st_d_eq);
//     assign res_gr_out = (res_st_c & res_st_e_gr) | (~res_st_c & res_st_d_gr) | (~res_st_c & cr_cout2);

// endmodule


// module full_adder(a_in, b_in, c_in, s_out, c_out);

//     input wire a_in;
//     input wire b_in;
//     input wire c_in;

//     output wire s_out;
//     output wire c_out;


//     assign s_out = a_in ^ b_in ^ c_in;
//     assign c_out = (a_in & b_in) | (b_in & c_in) | (a_in & c_in);

// endmodule


// module half_adder(a_in, b_in, s_out, c_out);

//     input wire a_in;
//     input wire b_in;

//     output wire s_out;
//     output wire c_out;

//     assign s_out = a_in ^ b_in;
//     assign c_out = a_in & b_in;
// endmodule


// module carry_save_adder(a_in, b_in, c_in, s_out, c_out);

//     input wire [5:0] a_in;
//     input wire [5:0] b_in;
//     input wire [5:0] c_in;

//     output wire [5:0] s_out;
//     output wire [5:0] c_out;

//     assign s_out = a_in ^ b_in ^ c_in;
//     assign c_out = (a_in & b_in) | (b_in & c_in) | (a_in & c_in);

// endmodule


// module simple_mux(a_in, b_in, c_in, res_out);

//     input wire  a_in;
//     input wire  b_in;
//     input wire  c_in;

//     output wire res_out;

//     assign res_out = c_in ? b_in : a_in;

// endmodule


// module carry_recognition(sum_in, carry_in, c_in, carry_out);

//     input wire [5:0]    sum_in;
//     input wire [5:0]    carry_in;
//     input wire          c_in;

//     output wire         carry_out;

//     wire [5:0] tmp_carry;

//     assign carry_out = tmp_carry[5];

//     simple_mux  mux0(carry_in[0], c_in, carry_in[0] ^ sum_in[0], tmp_carry[0]);
//     simple_mux  mux1(carry_in[1], tmp_carry[0], carry_in[1] ^ sum_in[1], tmp_carry[1]);
//     simple_mux  mux2(carry_in[2], tmp_carry[1], carry_in[2] ^ sum_in[2], tmp_carry[2]);
//     simple_mux  mux3(carry_in[3], tmp_carry[2], carry_in[3] ^ sum_in[3], tmp_carry[3]);
//     simple_mux  mux4(carry_in[4], tmp_carry[3], carry_in[4] ^ sum_in[4], tmp_carry[4]);
//     simple_mux  mux5(carry_in[5], tmp_carry[4], carry_in[5] ^ sum_in[5], tmp_carry[5]);

// endmodule

// // Partial RNS to binary conversion
// module stage_a(a1_in, a2_in, a3_in, sum_out, carry_out);

// 	input wire [2:0] a1_in;  
//     input wire [2:0] a2_in;  
//     input wire [3:0] a3_in;  

//     output wire [5:0] sum_out;
//     output wire [5:0] carry_out;

//     wire [5:0] A, B, C, neg_a3;
//     wire [2:0] halfC; 

//     wire [5:0] csa1_sum, csa2_sum;
//     wire [5:0] csa1_carry, csa2_carry;
//     wire [5:0] csa1_carry_eac, csa2_carry_eac;

//     assign halfC [2:0] = {a3_in[3]^a3_in[0], a3_in[2:1]};
//     assign neg_a3 [5:0] = {2'b11, ~a3_in[3:0]};

//     assign A[5:0] = { a1_in[0], a1_in[2:1], a1_in[0], a1_in[2:1] };
//     assign B[5:0] = { ~a2_in[2:0], 3'b111 };
//     assign C[5:0] = { halfC, halfC };

//     assign csa1_carry_eac[5:0] = {csa1_carry[4:0], csa1_carry[5]};
//     assign csa2_carry_eac[5:0] = {csa2_carry[4:0], csa2_carry[5]};

//     assign sum_out = csa2_sum;
//     assign carry_out = csa2_carry_eac;

//     carry_save_adder csa1_with_eac (neg_a3, B, A, csa1_sum, csa1_carry);
//     carry_save_adder csa2_with_eac (C, csa1_sum, csa1_carry_eac, csa2_sum, csa2_carry);

// endmodule

// // Partial subtraction
// module stage_b(sum1_in, carry1_in, sum2_in, carry2_in, sum_out, carry_out, c1_out, c2_out, c3_out);

//     input wire [5:0]   sum1_in;
//     input wire [5:0]   carry1_in;
//     input wire [5:0]   sum2_in;
//     input wire [5:0]   carry2_in;

//     output wire [5:0]   sum_out;
//     output wire [5:0]   carry_out;
//     output wire         c1_out;
//     output wire         c2_out;
//     output wire         c3_out;

//     wire [5:0] csa3_sum, csa4_sum, csa5_sum;
//     wire [5:0] csa3_carry, csa4_carry, csa5_carry;

//     assign c1_out = csa3_carry[5];
//     assign c2_out = csa4_carry[5];
//     assign c3_out = csa5_carry[5];
//     assign sum_out = csa5_sum;
//     assign carry_out = {csa5_carry[4:0], 1'b0};

//     carry_save_adder csa3 (sum1_in, carry1_in, ~carry2_in, csa3_sum, csa3_carry);
//     carry_save_adder csa4 (csa3_sum, {csa3_carry[4:0], 1'b0}, ~sum2_in, csa4_sum, csa4_carry);
//     carry_save_adder csa5 (csa4_sum, 6'b000010, {csa4_carry[4:0], 1'b0}, csa5_sum, csa5_carry);

// endmodule


// // Bitwise equality comparator
// module stage_c(sum1_in, carry1_in, sum2_in, carry2_in, c_out);

//     input wire [5:0]   sum1_in;
//     input wire [5:0]   carry1_in;
//     input wire [5:0]   sum2_in;
//     input wire [5:0]   carry2_in;

//     output wire         c_out;

//     assign c_out = (sum1_in === sum2_in) & (carry1_in === carry2_in);

// endmodule

// // 2-bit comparator 
// module stage_d(cr_sum3_in, cr_sum2_in, cr_cout1_in, cr_sum1_in, less_out, eq_out, greater_out);
//     input wire  cr_sum3_in;
//     input wire  cr_sum2_in;
//     input wire  cr_cout1_in;
//     input wire  cr_sum1_in;

//     output wire less_out;
//     output wire eq_out;
//     output wire greater_out;

//     assign less_out     =   ({cr_sum3_in, cr_sum2_in}  <  {cr_cout1_in, cr_sum1_in});
//     assign eq_out       =   ({cr_sum3_in, cr_sum2_in} === {cr_cout1_in, cr_sum1_in});
//     assign greater_out  =   ({cr_sum3_in, cr_sum2_in}  >  {cr_cout1_in, cr_sum1_in});

// endmodule

// // n-bit comparator for 1's complement numbers
// module stage_e(a2_in, b2_in, less_out, eq_out, greater_out);
//     input wire [2:0] a2_in;
//     input wire [2:0] b2_in;

//     output wire less_out;
//     output wire eq_out;
//     output wire greater_out;

//     assign less_out     = (a2_in  <  b2_in);
//     assign eq_out       = (a2_in === b2_in);
//     assign greater_out  = (a2_in  >  b2_in);

// endmodule