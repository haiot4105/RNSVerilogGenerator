


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
    for (iter = 0; iter < 503; iter = iter + 1)
    begin
        reverse_iter = 502 - iter;

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

    for (iter = 0; iter < 503; iter = iter + 1)
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
    for (iter = 0; iter < 503; iter = iter + 1)
    begin
        reverse_iter = 502 - iter;

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