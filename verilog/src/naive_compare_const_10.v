module compare_9_8_7_const_10(a1_in, a2_in, a3_in, res_le_out, res_eq_out, res_gr_out);
	input wire [2:0] a1_in;      // Module: 7
    input wire [2:0] a2_in;      // Module: 8
    input wire [3:0] a3_in;      // Module: 9
    
    output wire res_le_out;     // equals to 1 if a less than b, 0 otherwise
    output wire res_eq_out;     // equals to 1 if a equal to b, 0 otherwise
    output wire res_gr_out;     // equals to 1 if a greater than b, 0 otherwise

    reg [8:0] const_reg = 9'd10;
    wire [8:0] bin_form;

    

    reverse_converter_9_8_7 conv(a3_in, a2_in, a1_in, bin_form);

    assign res_le_out = (bin_form < const_reg);
    assign res_eq_out = (bin_form == const_reg);
    assign res_gr_out = (bin_form > const_reg);

endmodule