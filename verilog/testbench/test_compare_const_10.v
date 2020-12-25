module compare_const_test_bench();
	integer const_x;
    reg [2:0] const_x1;
	reg [2:0] const_x2;
	reg [3:0] const_x3;

    reg [2:0] x1;
	reg [2:0] x2;
	reg [3:0] x3;


	integer l;
    wire gr, eq, le;
    reg reg_gr, reg_eq, reg_le;
    reg exp_gr, exp_eq, exp_le;
	reg dummy;
	integer iter;
	
	compare_9_8_7_const_10 dut(x1, x2, x3, le, eq, gr);
	
	initial
	begin
        const_x = 10;

        const_x1 = const_x % 7;
        const_x2 = const_x % 8;
        const_x3 = const_x % 9;

        for (iter = 0; iter < 504; iter = iter + 1)
        begin
            x1 = iter % 7;
            x2 = iter % 8;
            x3 = iter % 9;
            exp_gr = (iter > const_x);
            exp_eq = (iter == const_x);
            exp_le = (iter < const_x);
            #1 dummy = 1;
            // $display ("%d %d", dut.bin_form, iter);
            $display ("!!! Res =(%b %b %b) Expect=(%b %b %b)", gr, eq, le, exp_gr, exp_eq, exp_le);

            reg_gr = gr;
            reg_eq = eq;
            reg_le = le;

            if (reg_gr != exp_gr || reg_eq != exp_eq || reg_le != exp_le )
            begin
                $display ("!!! Error !!!");
                $finish;
            end
            #1 dummy = 1;
        end
	end
endmodule