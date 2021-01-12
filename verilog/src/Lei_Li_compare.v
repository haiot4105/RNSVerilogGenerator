module compare_9_8_7(a1_in, a2_in, a3_in, b1_in, b2_in, b3_in, res_le_out, res_eq_out, res_gr_out);
	input wire [3:0] a1_in;      // Module: 7
    input wire [2:0] a2_in;      // Module: 8
    input wire [2:0] a3_in;      // Module: 9

	input wire [3:0] b1_in;      // Module: 7
    input wire [2:0] b2_in;      // Module: 8
    input wire [2:0] b3_in;      // Module: 9
    
    output wire res_le_out;     // equals to 1 if a less than b, 0 otherwise
    output wire res_eq_out;     // equals to 1 if a equal to b, 0 otherwise
    output wire res_gr_out;     // equals to 1 if a greater than b, 0 otherwise

    wire [5:0] U, V, W, neg_d1;
    wire [2:0] halfW; 

    wire [3:0] d1;
    wire [2:0] d2;
    wire [2:0] d3;

    wire [5:0] tmp_sum1, tmp_carry1;
    wire [5:0] tmp_sum2, tmp_carry2;
    wire [5:0] D1;
    wire [8:0] D;
    wire C, E;


    mod_2_n_plus_1_sub  sub1 (a1_in, b1_in, d1);  
    mod_2_n_sub         sub2 (a2_in, b2_in, d2);  
    mod_2_n_minus_1_sub sub3 (a3_in, b3_in, d3); 

    carry_save_adder csa1 (U, V, neg_d1, tmp_sum1, tmp_carry1);
    carry_save_adder csa2 (tmp_sum1, {tmp_carry1[4:0], tmp_carry1[5]}, W, tmp_sum2, tmp_carry2);
    binary_2n_adder bin_adder (tmp_sum2, {tmp_carry2[4:0], tmp_carry2[5]}, D1);

    assign U        = { d3[0], d3[2:0], d3[2:1] };
    assign V        = { ~d2[2:0], 3'b111 };
    assign halfW    = { d1[3]^d1[0], d1[2:1] };
    assign W        = { halfW, halfW };
    assign neg_d1   = { 2'b11, ~d1 };
    assign C = ~(|{d1, d2, d3});

    assign D = {D1, d2};
    assign E = ~(D[8] | &D[7:2]);

    assign res_le_out = ~E;
    assign res_eq_out = C;
    assign res_gr_out = E & ~C;

    wire [5:0] sum11, carry11;
    stage_a testa (d3, d2, d1, sum11, carry11);

endmodule

module mod_2_n_plus_1_sub(A, B, res_out);

	input wire [3:0] A;     
    input wire [3:0] B;      
    output wire [3:0] res_out;     

    wire T, W;
    wire [3:0] R;

    assign T = ~(A[3] & ~B[3]);
    assign W = ~(A[3] | ~B[3]);

    assign R = {1'b0, A[2:0]} + {1'b0, ~B[2:0]} + T;
    assign res_out = {1'b0, R[2:0]} + W + {3'b0, ~R[3]};

endmodule


module mod_2_n_sub(A, B, res_out);
    input wire [2:0] A;     
    input wire [2:0] B;      
    output wire [2:0] res_out;     

    assign res_out = (A + ~B + 1) ;

endmodule


module mod_2_n_minus_1_sub(A, B, res_out);

    input wire [2:0] A;     
    input wire [2:0] B;   
    output wire [3:0] R1;   
    output wire [2:0] R2, res_out;     

    assign R1 = ({1'b0, A} + {1'b0,~B});
    assign R2 = R1[2:0] + {2'b0, R1[3]}; 
    assign res_out = &R2 ? ~R2 : R2;

endmodule


module carry_save_adder(a_in, b_in, c_in, s_out, c_out);

    input wire [5:0] a_in;
    input wire [5:0] b_in;
    input wire [5:0] c_in;

    output wire [5:0] s_out;
    output wire [5:0] c_out;

    assign s_out = a_in ^ b_in ^ c_in;
    assign c_out = (a_in & b_in) | (b_in & c_in) | (a_in & c_in);

endmodule


module binary_2n_adder(a_in, b_in, s_out);

    input wire [5:0] a_in;
    input wire [5:0] b_in;

    output wire [5:0] s_out;
    wire [6:0] R1;
    wire [5:0] R2;

    assign R1 = a_in + b_in;
    assign R2 = R1[5:0] + R1[6];
    assign s_out = &R2 ? ~R2 : R2;
endmodule


module stage_a(a1_in, a2_in, a3_in, sum_out, carry_out);

	input wire [2:0] a1_in;  
    input wire [2:0] a2_in;  
    input wire [3:0] a3_in;  

    output wire [5:0] sum_out;
    output wire [5:0] carry_out;

    wire [5:0] A, B, C, neg_a3;
    wire [2:0] halfC; 

    wire [5:0] csa1_sum, csa2_sum;
    wire [5:0] csa1_carry, csa2_carry;
    wire [5:0] csa1_carry_eac, csa2_carry_eac;

    assign halfC [2:0] = {a3_in[3]^a3_in[0], a3_in[2:1]};
    assign neg_a3 [5:0] = {2'b11, ~a3_in[3:0]};

    assign A[5:0] = { a1_in[0], a1_in[2:1], a1_in[0], a1_in[2:1] };
    assign B[5:0] = { ~a2_in[2:0], 3'b111 };
    assign C[5:0] = { halfC, halfC };

    assign csa1_carry_eac[5:0] = {csa1_carry[4:0], csa1_carry[5]};
    assign csa2_carry_eac[5:0] = {csa2_carry[4:0], csa2_carry[5]};

    assign sum_out = csa2_sum;
    assign carry_out = csa2_carry_eac;

    carry_save_adder csa1_with_eac (neg_a3, B, A, csa1_sum, csa1_carry);
    carry_save_adder csa2_with_eac (C, csa1_sum, csa1_carry_eac, csa2_sum, csa2_carry);

endmodule

// module compare_test_bench();

//     reg [2:0] x1;
//     reg [2:0] y1;
//     wire [2:0] res;

// 	reg dummy;

// 	integer iter, reverse_iter;


//     mod_2_n_minus_1_sub dut(x1, y1, res);
// 	integer dbg;

// 	initial
// 	begin

//         for (iter = 0; iter < 40; iter = iter + 1)
//         begin
//             reverse_iter = 40 - iter;

//             x1 = iter % 7;
//             y1 = reverse_iter % 7;

//             #1 dummy = 1;
//             // if($signed(x1 - y1) < 0)
//             // begin
//             //     dbg = x1-y1+9;
//             // end
//             // else
//             // begin
//             //     dbg = x1-y1;
//             // end


//             $display ("%d %d %d %d %d ",x1, y1, res, $signed(x1 - y1) % 7,  $signed(x1 - y1) % 7 + 7);
//             // $display ("%d %d %b %b %d %b %b",x1, y1, ~dut.R[3], dut.T, dut.W, res, dut.R[2:0] + {2'b0, ~dut.R[3]});    

//             #1 dummy = 1;
//         end

//         $display ("!!! Succsess !!!");
// 	end
// endmodule