module compare_9_8_7(a1_in, a2_in, a3_in, b1_in, b2_in, b3_in, res_le_out, res_eq_out, res_gr_out);
	input wire [2:0] a1_in;      // Module: 7
    input wire [2:0] a2_in;      // Module: 8
    input wire [3:0] a3_in;      // Module: 9

    input wire [2:0] b1_in;      // Module: 7
    input wire [2:0] b2_in;      // Module: 8
    input wire [3:0] b3_in;      // Module: 9
    
    output wire res_le_out;     // equals to 1 if a less than b, 0 otherwise
    output wire res_eq_out;     // equals to 1 if a equal to b, 0 otherwise
    output wire res_gr_out;     // equals to 1 if a greater than b, 0 otherwise

    wire [8:0] a_bin_form;
    wire [8:0] b_bin_form;

    reverse_converter_9_8_7 conv1(a3_in, a2_in, a1_in, a_bin_form);
    reverse_converter_9_8_7 conv2(b3_in, b2_in, b1_in, b_bin_form);

    assign res_le_out = (a_bin_form < b_bin_form);
    assign res_eq_out = (a_bin_form == b_bin_form);
    assign res_gr_out = (a_bin_form > b_bin_form);

endmodule