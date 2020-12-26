


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

  wire [8:0] a_bin_form;
  wire [8:0] b_bin_form;

  reverse_converter_9_8_7
  converter1
  (
    .x1(a1_in),
    .x2(a2_in),
    .x3(a3_in),
    .out(a_bin_form)
  );


  reverse_converter_9_8_7
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