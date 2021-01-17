


module compare_9_8_7_const_10
(
  input [3:0] a1_in,
  input [2:0] a2_in,
  input [2:0] a3_in,
  output res_le_out,
  output res_eq_out,
  output res_gr_out
);

  wire [8:0] bin_form;
  reg [8:0] const_reg;

  initial begin
    const_reg = 10;
  end


  reverse_converter_9_8_7
  converter
  (
    .x1(a1_in),
    .x2(a2_in),
    .x3(a3_in),
    .out(bin_form)
  );

  assign res_le_out = bin_form < const_reg;
  assign res_eq_out = bin_form == const_reg;
  assign res_gr_out = bin_form > const_reg;

endmodule


module compare_const_10_testbench_9_8_7
(

);

  integer const_x;
  integer iter;
  reg [3:0] const_x1;
  reg [2:0] const_x2;
  reg [2:0] const_x3;
  reg [3:0] x1;
  reg [2:0] x2;
  reg [2:0] x3;
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

  compare_9_8_7_const_10
  dut
  (
    .a1_in(x1),
    .a2_in(x2),
    .a3_in(x3),
    .res_le_out(le),
    .res_eq_out(eq),
    .res_gr_out(gr)
  );


  initial begin
    const_x = 10;

    const_x1 = const_x % 9;
    const_x2 = const_x % 8;
    const_x3 = const_x % 7;

    for (iter = 0; iter < 252.0; iter = iter + 1)
    begin
        x1 = iter % 9;
        x2 = iter % 8;
        x3 = iter % 7;
        exp_gr = (iter > const_x);
        exp_eq = (iter == const_x);
        exp_le = (iter < const_x);
        #1 dummy = 1;
        $display ("Res = (> %b; = %b; < %b) Expect = (> %b; = %b; < %b)", gr, eq, le, exp_gr, exp_eq, exp_le);

        reg_gr = gr;
        reg_eq = eq;
        reg_le = le;

        if (reg_gr != exp_gr || reg_eq != exp_eq || reg_le != exp_le )
        begin
            $display ("!!! Error !!!");
            $display ("X = (%d; %d; %d)",x1, x2, x3);
            $finish;
        end
        #1 dummy = 1;
    end

    $display ("!!! Succsess !!!");
  end


endmodule