


module compare_const_10_9_8_7
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