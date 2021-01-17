import sys
import os
from veriloggen import *
import veriloggen.verilog.to_verilog as to_verilog
from pyverilog.ast_code_generator.codegen import ASTCodeGenerator
import re


def create_compare_testbench(n, dut):
    n1 = 2 ** n + 1
    n2 = 2 ** n 
    n3 = 2 ** n - 1
    max_num = n1 * n2 * n3

    n1_w = n1.bit_length()
    n2_w = (n2 - 1).bit_length()
    n3_w = n3.bit_length()
    max_num_w = max_num.bit_length()

    module_name = "compare_" + "_testbench_" + str(n1) + "_" + str(n2) + "_" + str(n3)

    main_module = Module(module_name)

    iterint = main_module.Integer("iter")
    reverse_iter = main_module.Integer("reverse_iter")

    x1 = main_module.Reg('x1', n1_w)
    x2 = main_module.Reg('x2', n2_w)
    x3 = main_module.Reg('x3', n3_w)

    y1 = main_module.Reg('y1', n1_w)
    y2 = main_module.Reg('y2', n2_w)
    y3 = main_module.Reg('y3', n3_w)

    gr = main_module.Wire("gr")
    eq = main_module.Wire("eq")
    le = main_module.Wire("le")

    reg_gr = main_module.Reg("reg_gr")
    reg_eq = main_module.Reg("reg_eq")
    reg_le = main_module.Reg("reg_le")

    exp_gr = main_module.Reg("exp_gr")
    exp_eq = main_module.Reg("exp_eq")
    exp_le = main_module.Reg("exp_le")

    dummy = main_module.Reg("dummy")

    main_module.Instance(dut, 'dut', ports = [x1, x2, x3, y1, y2, y3, le, eq, gr])

    init = '''$display ("!!! Stage 1 !!!");
for (iter = 0; iter < {0}; iter = iter + 1)
begin
    reverse_iter = {1} - iter;

    x1 = iter % {2};
    x2 = iter % {3};
    x3 = iter % {4};
    
    y1 = reverse_iter % {2};
    y2 = reverse_iter % {3};
    y3 = reverse_iter % {4};

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

for (iter = 0; iter < {0}; iter = iter + 1)
begin

    x1 = iter % {2};
    x2 = iter % {3};
    x3 = iter % {4};
    
    y1 = iter % {2};
    y2 = iter % {3};
    y3 = iter % {4};

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
for (iter = 0; iter < {0}; iter = iter + 1)
begin
    reverse_iter = {1} - iter;

    y1 = iter % {2};
    y2 = iter % {3};
    y3 = iter % {4};
    
    x1 = reverse_iter % {2};
    x2 = reverse_iter % {3};
    x3 = reverse_iter % {4};

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

$display ("!!! Succsess !!!");'''.format((max_num / 2), (max_num / 2) - 1, n1, n2, n3, )

    main_module.Initial(EmbeddedCode(init))

    return main_module


def create_compare_const_testbench(n, c, dut):
    n1 = 2 ** n + 1
    n2 = 2 ** n 
    n3 = 2 ** n - 1
    max_num = n1 * n2 * n3

    n1_w = n1.bit_length()
    n2_w = (n2 - 1).bit_length()
    n3_w = n3.bit_length()
    max_num_w = max_num.bit_length()

    module_name = "compare_const_" + str(c) + "_testbench_" + str(n1) + "_" + str(n2) + "_" + str(n3)

    main_module = Module(module_name)
    const_x = main_module.Integer("const_x")
    iterint = main_module.Integer("iter")

    const_x1 = main_module.Reg('const_x1', n1_w)
    const_x2 = main_module.Reg('const_x2', n2_w)
    const_x3 = main_module.Reg('const_x3', n3_w)

    x1 = main_module.Reg('x1', n1_w)
    x2 = main_module.Reg('x2', n2_w)
    x3 = main_module.Reg('x3', n3_w)

    gr = main_module.Wire("gr")
    eq = main_module.Wire("eq")
    le = main_module.Wire("le")

    reg_gr = main_module.Reg("reg_gr")
    reg_eq = main_module.Reg("reg_eq")
    reg_le = main_module.Reg("reg_le")

    exp_gr = main_module.Reg("exp_gr")
    exp_eq = main_module.Reg("exp_eq")
    exp_le = main_module.Reg("exp_le")

    dummy = main_module.Reg("dummy")

    main_module.Instance(dut, 'dut', ports = [x1, x2, x3, le, eq, gr])


    init = '''const_x = {0};

const_x1 = const_x % {1};
const_x2 = const_x % {2};
const_x3 = const_x % {3};

for (iter = 0; iter < {4}; iter = iter + 1)
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

$display ("!!! Succsess !!!");'''.format(c, n1, n2, n3, max_num / 2)

    main_module.Initial(EmbeddedCode(init))

    return main_module