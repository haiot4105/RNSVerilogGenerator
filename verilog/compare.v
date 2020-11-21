
module comp_modular_0(a1_in, a2_in, a3_in, b1_in, b2_in, b3_in, res_out);
	input wire a1_in[3:0];  // Module: 7
    input wire a2_in[3:0];  // Module: 8
    input wire a3_in[4:0];  // Module: 9

	input wire b1_in[3:0];  // Module: 7
    input wire b2_in[3:0];  // Module: 8
    input wire b3_in[4:0];  // Module: 9
    
    output wire res_out;    // equals to 1 if higher than 0, else lower or equal

    // TODO

endmodule


module full_adder(a_in, b_in, c_in, s_out, c_out);
    input wire  a_in;
    input wire  b_in;
    input wire  c_in;

    output wire s_out;
    output wire c_out;

    assign s_out = a_in ^ b_in ^ c_in;
    assign c_out = (a_in & b_in) | (b_in & c_in) | (a_in & c_in);

endmodule


module half_adder(a_in, b_in, s_out, c_out);
    input wire  a_in;
    input wire  b_in;

    output wire s_out;
    output wire c_out;

    assign s_out = a_in ^ b_in;
    assign s_out = a_in & b_in;
endmodule


module carry_save_adder(a_in, b_in, c_in, s_out, c_out);
    input wire [7:0]    a_in;
    input wire [7:0]    b_in;
    input wire [7:0]    c_in;

    output wire [7:0]   s_out;
    output wire [7:0]   c_out;

    assign s_out = a_in ^ b_in ^ c_in;
    assign c_out = (a_in & b_in) | (b_in & c_in) | (a_in & c_in);

endmodule


module simple_mux(a_in, b_in, c_in, res_out);
    input wire  a_in;
    input wire  b_in;
    input wire  c_in;

    output wire res_out;

    assign res_out = c_in ? b_in : a_in;

endmodule


module carry_detector(sum_in, carry_in, c_in, carry_out);
    input wire [7:0]    sum_in;
    input wire [7:0]    carry_in;
    input wire          c_in;

    output wire         carry_out;

    wire [7:0] tmp_carry;

    assign carry_out = tmp_carry[7];

    simple_mux  mux0(carry_in[0], c_in, carry_in[0] ^ sum_in[0], tmp_carry[0]);
    simple_mux  mux1(carry_in[1], tmp_carry[0], carry_in[1] ^ sum_in[1], tmp_carry[1]);
    simple_mux  mux2(carry_in[2], tmp_carry[1], carry_in[2] ^ sum_in[2], tmp_carry[2]);
    simple_mux  mux3(carry_in[3], tmp_carry[2], carry_in[3] ^ sum_in[3], tmp_carry[3]);
    simple_mux  mux4(carry_in[4], tmp_carry[3], carry_in[4] ^ sum_in[4], tmp_carry[4]);
    simple_mux  mux5(carry_in[5], tmp_carry[4], carry_in[5] ^ sum_in[5], tmp_carry[5]);
    simple_mux  mux6(carry_in[6], tmp_carry[5], carry_in[6] ^ sum_in[6], tmp_carry[6]);
    simple_mux  mux7(carry_in[7], tmp_carry[6], carry_in[7] ^ sum_in[7], tmp_carry[7]);
    
endmodule

// Partial RNS to binary conversion
module stage_a(a1_in, a2_in, a3_in, b1_in, b2_in, b3_in, sum1_out, carry1_out, sum2_out, carry2_out);
	input wire          a1_in[3:0];  
    input wire          a2_in[3:0];  
    input wire          a3_in[4:0];  

	input wire          b1_in[3:0];  
    input wire          b2_in[3:0];  
    input wire          b3_in[4:0];  

    output wire [7:0]   sum1_out;
    output wire [7:0]   carry1_out;
    output wire [7:0]   sum2_out;
    output wire [7:0]   carry2_out;

    // TODO

endmodule

// Partial subtraction
module stage_b(sum1_in, carry1_in, sum2_in, carry2_in, sum_out, carry_out, c1_out, c2_out, c3_out);
    input wire [7:0]   sum1_in;
    input wire [7:0]   carry1_in;
    input wire [7:0]   sum2_in;
    input wire [7:0]   carry2_in;

    output wire [7:0]   sum_out;
    output wire [7:0]   carry_out;
    output wire         c1_out;
    output wire         c2_out;
    output wire         c3_out;

    // TODO

endmodule

// Bitwise equality comparator
module stage_c(sum1_in, carry1_in, sum2_in, carry2_in, c_out)
    input wire [7:0]   sum1_in;
    input wire [7:0]   carry1_in;
    input wire [7:0]   sum2_in;
    input wire [7:0]   carry2_in;

    output wire         c_out;

    // TODO

endmodule

// 2-bit comparator 
module stage_d(sum_3_in, sum_2_in, cout_1_in, sum_1_in, less_out, eq_out, more_out)
    input wire  sum_3_in;
    input wire  sum_2_in;
    input wire  cout_1_in;
    input wire  sum_1_in;

    output wire less_out;
    output wire eq_out;
    output wire more_out;

    // TODO

endmodule

// n-bit comparator 
module stage_E(A_2_in, B_2_in, less_out, eq_out, more_out)
    input wire [3:0] A_2_in;
    input wire [3:0] B_2_in;

    output wire less_out;
    output wire eq_out;
    output wire more_out;

    // TODO

endmodule