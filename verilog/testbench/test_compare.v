module compare_test_bench();

    reg [2:0] x1;
	reg [2:0] x2;
	reg [3:0] x3;

    reg [2:0] y1;
	reg [2:0] y2;
	reg [3:0] y3;


	integer l;
    wire gr, eq, le;
    reg reg_gr, reg_eq, reg_le;
    reg exp_gr, exp_eq, exp_le;
	reg dummy;
	integer iter, reverse_iter;
	
	compare_9_8_7 dut(x1, x2, x3, y1, y2, y3, le, eq, gr);
	
	initial
	begin
        $display ("!!! Stage 1 !!!");
        for (iter = 0; iter < 504; iter = iter + 1)
        begin
            reverse_iter = 503 - iter;

            x1 = iter % 7;
            x2 = iter % 8;
            x3 = iter % 9;
            
            y1 = reverse_iter % 7;
            y2 = reverse_iter % 8;
            y3 = reverse_iter % 9;

            exp_gr = (iter > reverse_iter);
            exp_eq = (iter == reverse_iter);
            exp_le = (iter < reverse_iter);

            #1 dummy = 1;

            $display ("Res = (> %b; = %b; < %b) Expect = (> %b; = %b; < %b)", gr, eq, le, exp_gr, exp_eq, exp_le);

            reg_gr = gr;
            reg_eq = eq;
            reg_le = le;

            if (reg_gr != exp_gr || reg_eq != exp_eq || reg_le != exp_le )
            begin
                $display ("!!! Error stage 1!!!");
                $display ("X = (%d; %d; %d) Y = (%d; %d; %d)",x1, x2, x3, y1, y2, y3);
                $finish;
            end
            #1 dummy = 1;
        end

        $display ("!!! Stage 2 !!!");
        
        for (iter = 0; iter < 504; iter = iter + 1)
        begin

            x1 = iter % 7;
            x2 = iter % 8;
            x3 = iter % 9;
            
            y1 = iter % 7;
            y2 = iter % 8;
            y3 = iter % 9;

            exp_gr = 0;
            exp_eq = 1;
            exp_le = 0;

            #1 dummy = 1;

            $display ("Res = (> %b; = %b; < %b) Expect = (> %b; = %b; < %b)", gr, eq, le, exp_gr, exp_eq, exp_le);

            reg_gr = gr;
            reg_eq = eq;
            reg_le = le;

            if (reg_gr != exp_gr || reg_eq != exp_eq || reg_le != exp_le )
            begin
                $display ("!!! Error stage 2 !!!");
                $display ("X = (%d; %d; %d) Y = (%d; %d; %d)",x1, x2, x3, y1, y2, y3);
                $finish;
            end
            #1 dummy = 1;
        end

        $display ("!!! Stage 3 !!!");
        for (iter = 0; iter < 504; iter = iter + 1)
        begin
            reverse_iter = 503 - iter;

            y1 = iter % 7;
            y2 = iter % 8;
            y3 = iter % 9;
            
            x1 = reverse_iter % 7;
            x2 = reverse_iter % 8;
            x3 = reverse_iter % 9;

            exp_gr = (iter < reverse_iter);
            exp_eq = (iter == reverse_iter);
            exp_le = (iter > reverse_iter);

            #1 dummy = 1;

            $display ("Res = (> %b; = %b; < %b) Expect = (> %b; = %b; < %b)", gr, eq, le, exp_gr, exp_eq, exp_le);

            reg_gr = gr;
            reg_eq = eq;
            reg_le = le;

            if (reg_gr != exp_gr || reg_eq != exp_eq || reg_le != exp_le )
            begin
                $display ("!!! Error stage 3!!!");
                $display ("X = (%d; %d; %d) Y = (%d; %d; %d)",x1, x2, x3, y1, y2, y3);
                $finish;
            end
            #1 dummy = 1;
        end

        $display ("!!! Succsess !!!");
	end
endmodule