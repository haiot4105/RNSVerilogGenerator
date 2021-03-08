


module compare_1025_1024_1023
(
  input [10:0] a1_in,
  input [9:0] a2_in,
  input [9:0] a3_in,
  input [10:0] b1_in,
  input [9:0] b2_in,
  input [9:0] b3_in,
  output res_le_out,
  output res_eq_out,
  output res_gr_out
);

  wire [19:0] U;
  wire [19:0] V;
  wire [19:0] W;
  wire [9:0] halfW;
  wire [19:0] neg_d1;
  wire [10:0] d1;
  wire [9:0] d2;
  wire [9:0] d3;
  wire [19:0] tmp_sum1;
  wire [19:0] tmp_sum2;
  wire [19:0] tmp_carry1;
  wire [19:0] tmp_carry2;
  wire [19:0] D1;
  wire [29:0] D;
  wire C;
  wire E;
  assign U = { d3[0], d3[9:0], d3[9:1] };
  assign V = { ~d2[9:0], 10'b1111111111 };
  assign halfW = { d1[10] ^ d1[0], d1[9:1] };
  assign W = { halfW, halfW };
  assign neg_d1 = { 9'b111111111, ~d1 };
  assign C = ~(|{ d1, d2, d3 });
  assign D = { D1, d2 };
  assign E = { ~(D[29] | &D[28:9]) };
  assign res_le_out = ~E;
  assign res_eq_out = C;
  assign res_gr_out = E & ~C;

  mod_1025_sub
  sub1
  (
    .a_in(a1_in),
    .b_in(b1_in),
    .res_out(d1)
  );


  mod_1024_sub
  sub2
  (
    .a_in(a2_in),
    .b_in(b2_in),
    .res_out(d2)
  );


  mod_1023_sub
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



module mod_1025_sub
(
  input [10:0] a_in,
  input [10:0] b_in,
  output [10:0] res_out
);

  wire T;
  wire W;
  wire [10:0] R;
  assign T = ~(a_in[10] & ~b_in[10]);
  assign W = ~(a_in[10] | ~b_in[10]);
  assign R = { 1'b0, a_in[9:0] } + { 1'b0, ~b_in[9:0] } + T;
  assign res_out = { 1'b0, R[9:0] } + W + { 10'b0, ~R[10] };

endmodule



module mod_1024_sub
(
  input [9:0] a_in,
  input [9:0] b_in,
  output [9:0] res_out
);

  assign res_out = a_in + ~b_in + 1;

endmodule



module mod_1023_sub
(
  input [9:0] a_in,
  input [9:0] b_in,
  output [9:0] res_out
);

  wire [10:0] R1;
  wire [9:0] R2;
  assign R1 = { 1'b0, a_in } + { 1'b0, ~b_in };
  assign R2 = R1[9:0] + { 9'b0, R1[10] };
  assign res_out = &R2 ? ~R2 : R2;

endmodule



module csa_with_eac
(
  input [19:0] a_in,
  input [19:0] b_in,
  input [19:0] c_in,
  output [19:0] s_out,
  output [19:0] c_out
);

  wire [19:0] carry;
  assign carry = a_in & b_in | b_in & c_in | a_in & c_in;
  assign s_out = a_in ^ b_in ^ c_in;
  assign c_out = { carry[18:0], carry[19] };

endmodule



module binary_adder
(
  input [19:0] a_in,
  input [19:0] b_in,
  output [19:0] s_out
);

  wire [20:0] R1;
  wire [19:0] R2;
  assign R1 = a_in + b_in;
  assign R2 = R1[19:0] + R1[20];
  assign s_out = &R2 ? ~R2 : R2;

endmodule




module compare_testbench_1025_1024_1023
(

);

  integer iter;
  reg [29:0] rand_value;
  reg [29:0] rand_value_2;
  integer seed;
  reg [10:0] x1;
  reg [9:0] x2;
  reg [9:0] x3;
  reg [10:0] y1;
  reg [9:0] y2;
  reg [9:0] y3;
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

  compare_1025_1024_1023
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
    seed = 23429;
    rand_value = $urandom(seed);
    for (iter = 0; iter < 2000; iter = iter + 1)
    begin
        rand_value = $urandom_range(268435200);
        rand_value_2 = $urandom_range(268435200);

        x1 = rand_value % 1025;
        x2 = rand_value % 1024;
        x3 = rand_value % 1023;
    
        y1 = rand_value_2 % 1025;
        y2 = rand_value_2 % 1024;
        y3 = rand_value_2 % 1023;

        exp_gr = (rand_value > rand_value_2);
        exp_eq = (rand_value == rand_value_2);
        exp_le = (rand_value < rand_value_2);

        #1 dummy = 1;

        reg_gr = gr;
        reg_eq = eq;
        reg_le = le;

        if (reg_gr !== exp_gr || reg_eq !== exp_eq || reg_le !== exp_le )
        begin
            $display ("!!! Error stage 1!!!");
            $display ("X = (%d; %d; %d) Y = (%d; %d; %d)",x1, x2, x3, y1, y2, y3);
            $display ("Res = (> %b; = %b; < %b) Expect = (> %b; = %b; < %b)", gr, eq, le, exp_gr, exp_eq, exp_le);
            $fatal();;
        end
        #1 dummy = 1;
    end

    $display ("!!! Stage 2 !!!");

    for (iter = 0; iter < 2000; iter = iter + 1)
    begin
        rand_value = $urandom_range(268435200);
        x1 = rand_value % 1025;
        x2 = rand_value % 1024;
        x3 = rand_value % 1023;
    
        y1 = rand_value % 1025;
        y2 = rand_value % 1024;
        y3 = rand_value % 1023;

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
            $display ("Res = (> %b; = %b; < %b) Expect = (> %b; = %b; < %b)", gr, eq, le, exp_gr, exp_eq, exp_le);
            $fatal();
        end
        #1 dummy = 1;
    end

    $display ("!!! Succsess !!!");
  end


endmodule