


module compare_9_8_7
(
  input [3:0] a1_in,
  input [2:0] a2_in,
  input [2:0] a3_in,
  input [3:0] b1_in,
  input [2:0] b2_in,
  input [2:0] b3_in,
  output res_le_out,
  output res_eq_out,
  output res_gr_out
);

  wire [5:0] U;
  wire [5:0] V;
  wire [5:0] W;
  wire [2:0] halfW;
  wire [5:0] neg_d1;
  wire [3:0] d1;
  wire [2:0] d2;
  wire [2:0] d3;
  wire [5:0] tmp_sum1;
  wire [5:0] tmp_sum2;
  wire [5:0] tmp_carry1;
  wire [5:0] tmp_carry2;
  wire [5:0] D1;
  wire [8:0] D;
  wire C;
  wire E;
  assign U = { d3[0], d3[2:0], d3[2:1] };
  assign V = { ~d2[2:0], 3'b111 };
  assign halfW = { d1[3] ^ d1[0], d1[2:1] };
  assign W = { halfW, halfW };
  assign neg_d1 = { 2'b11, ~d1 };
  assign C = ~(|{ d1, d2, d3 });
  assign D = { D1, d2 };
  assign E = { ~(D[8] | &D[7:2]) };
  assign res_le_out = ~E;
  assign res_eq_out = C;
  assign res_gr_out = E & ~C;

  mod_9_sub
  sub1
  (
    .a_in(a1_in),
    .b_in(b1_in),
    .res_out(d1)
  );


  mod_8_sub
  sub2
  (
    .a_in(a2_in),
    .b_in(b2_in),
    .res_out(d2)
  );


  mod_7_sub
  sub3
  (
    .a_in(a3_in),
    .b_in(b3_in),
    .res_out(d3)
  );


  csa_with_eac
  csa1
  (
    .a_in(U),
    .b_in(V),
    .c_in(neg_d1),
    .s_out(tmp_sum1),
    .c_out(tmp_carry1)
  );


  csa_with_eac
  csa2
  (
    .a_in(tmp_sum1),
    .b_in(tmp_carry1),
    .c_in(W),
    .s_out(tmp_sum2),
    .c_out(tmp_carry2)
  );


  binary_adder
  adder
  (
    .a_in(tmp_sum2),
    .b_in(tmp_carry2),
    .s_out(D1)
  );


endmodule



module mod_9_sub
(
  input [3:0] a_in,
  input [3:0] b_in,
  output [3:0] res_out
);

  wire T;
  wire W;
  wire [3:0] R;
  assign T = ~(a_in[3] & ~b_in[3]);
  assign W = ~(a_in[3] | ~b_in[3]);
  assign R = { 1'b0, a_in[2:0] } + { 1'b0, ~b_in[2:0] } + T;
  assign res_out = { 1'b0, R[2:0] } + W + { 3'b0, ~R[3] };

endmodule



module mod_8_sub
(
  input [2:0] a_in,
  input [2:0] b_in,
  output [2:0] res_out
);

  assign res_out = a_in + ~b_in + 1;

endmodule



module mod_7_sub
(
  input [2:0] a_in,
  input [2:0] b_in,
  output [2:0] res_out
);

  wire [3:0] R1;
  wire [2:0] R2;
  assign R1 = { 1'b0, a_in } + { 1'b0, ~b_in };
  assign R2 = R1[2:0] + { 2'b0, R1[3] };
  assign res_out = &R2 ? ~R2 : R2;

endmodule



module csa_with_eac
(
  input [5:0] a_in,
  input [5:0] b_in,
  input [5:0] c_in,
  output [5:0] s_out,
  output [5:0] c_out
);

  wire [5:0] carry;
  assign carry = a_in & b_in | b_in & c_in | a_in & c_in;
  assign s_out = a_in ^ b_in ^ c_in;
  assign c_out = { carry[4:0], carry[5] };

endmodule



module binary_adder
(
  input [5:0] a_in,
  input [5:0] b_in,
  output [5:0] s_out
);

  wire [6:0] R1;
  wire [5:0] R2;
  assign R1 = a_in + b_in;
  assign R2 = R1[5:0] + R1[6];
  assign s_out = &R2 ? ~R2 : R2;

endmodule




module compare_testbench_9_8_7
(

);

  integer iter;
  integer reverse_iter;
  reg [3:0] x1;
  reg [2:0] x2;
  reg [2:0] x3;
  reg [3:0] y1;
  reg [2:0] y2;
  reg [2:0] y3;
  wire gr;
  wire eq;
  wire le;
  reg reg_gr;
  reg reg_eq;
  reg reg_le;
  reg exp_gr;
  reg exp_eq;
  reg exp_le;
  reg dummy;

  compare_9_8_7
  dut
  (
    .a1_in(x1),
    .a2_in(x2),
    .a3_in(x3),
    .b1_in(y1),
    .b2_in(y2),
    .b3_in(y3),
    .res_le_out(le),
    .res_eq_out(eq),
    .res_gr_out(gr)
  );


  initial begin
    $display ("!!! Stage 1 !!!");
    for (iter = 0; iter < 126; iter = iter + 1)
    begin
        reverse_iter = 125 - iter;

        x1 = iter % 9;
        x2 = iter % 8;
        x3 = iter % 7;
    
        y1 = reverse_iter % 9;
        y2 = reverse_iter % 8;
        y3 = reverse_iter % 7;

        exp_gr = (iter > reverse_iter);
        exp_eq = (iter == reverse_iter);
        exp_le = (iter < reverse_iter);

        #1 dummy = 1;

        reg_gr = gr;
        reg_eq = eq;
        reg_le = le;

        if (reg_gr !== exp_gr || reg_eq !== exp_eq || reg_le !== exp_le )
        begin
            $display ("!!! Error stage 1!!!");
            $display ("X = (%d; %d; %d) Y = (%d; %d; %d)",x1, x2, x3, y1, y2, y3);
            $fatal();;
        end
        #1 dummy = 1;
    end

    $display ("!!! Stage 2 !!!");

    for (iter = 0; iter < 126; iter = iter + 1)
    begin

        x1 = iter % 9;
        x2 = iter % 8;
        x3 = iter % 7;
    
        y1 = iter % 9;
        y2 = iter % 8;
        y3 = iter % 7;

        exp_gr = 0;
        exp_eq = 1;
        exp_le = 0;

        #1 dummy = 1;

        reg_gr = gr;
        reg_eq = eq;
        reg_le = le;

        if (reg_gr !== exp_gr || reg_eq !== exp_eq || reg_le !== exp_le )
        begin
            $display ("!!! Error stage 2 !!!");
            $display ("X = (%d; %d; %d) Y = (%d; %d; %d)",x1, x2, x3, y1, y2, y3);
            $fatal();
        end
        #1 dummy = 1;
    end

    $display ("!!! Stage 3 !!!");
    for (iter = 0; iter < 126; iter = iter + 1)
    begin
        reverse_iter = 125 - iter;

        y1 = iter % 9;
        y2 = iter % 8;
        y3 = iter % 7;
    
        x1 = reverse_iter % 9;
        x2 = reverse_iter % 8;
        x3 = reverse_iter % 7;

        exp_gr = (iter < reverse_iter);
        exp_eq = (iter == reverse_iter);
        exp_le = (iter > reverse_iter);

        #1 dummy = 1;

        reg_gr = gr;
        reg_eq = eq;
        reg_le = le;

        if (reg_gr !== exp_gr || reg_eq !== exp_eq || reg_le !== exp_le )
        begin
            $display ("!!! Error stage 3!!!");
            $display ("X = (%d; %d; %d) Y = (%d; %d; %d)",x1, x2, x3, y1, y2, y3);
            $fatal();
        end
        #1 dummy = 1;
    end

    $display ("!!! Succsess !!!");
  end


endmodule