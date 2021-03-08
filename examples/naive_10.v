


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

  wire [29:0] a_bin_form;
  wire [29:0] b_bin_form;

  reverse_converter_1025_1024_1023
  converter1
  (
    .x1(a1_in),
    .x2(a2_in),
    .x3(a3_in),
    .out(a_bin_form)
  );


  reverse_converter_1025_1024_1023
  converter2
  (
    .x1(b1_in),
    .x2(b2_in),
    .x3(b3_in),
    .out(b_bin_form)
  );

  assign res_le_out = a_bin_form < b_bin_form;
  assign res_eq_out = a_bin_form == b_bin_form;
  assign res_gr_out = a_bin_form > b_bin_form;

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
    seed = 31597;
    rand_value = $urandom(seed);
    for (iter = 0; iter < 2000; iter = iter + 1)
    begin
        rand_value = $urandom_range(1073740799);
        rand_value_2 = $urandom_range(1073740799);

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
        rand_value = $urandom_range(1073740799);
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