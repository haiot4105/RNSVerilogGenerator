import sys
import os
from veriloggen import *
import veriloggen.verilog.to_verilog as to_verilog
from pyverilog.ast_code_generator.codegen import ASTCodeGenerator
import re
import random


def create_compare_testbench(n, dut, method_max_num, full_tb = True, testcases_num = 0):
    if full_tb:
        return create_full_compare_testbench(n, dut, method_max_num)
    else:
        return create_small_compare_testbench(n, dut, method_max_num, testcases_num)


def create_compare_const_testbench(n, c, dut, method_max_num, full_tb = True, testcases_num = 0):
    if full_tb:
        return create_full_compare_const_testbench(n, c, dut, method_max_num)
    else:
        return create_small_compare_const_testbench(n, c, dut, method_max_num, testcases_num)


def create_full_compare_const_testbench(n, c, dut, method_max_num):
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
    x1 = iter % {1};
    x2 = iter % {2};
    x3 = iter % {3};
    exp_gr = (iter > const_x);
    exp_eq = (iter == const_x);
    exp_le = (iter < const_x);
    #1 dummy = 1;

    reg_gr = gr;
    reg_eq = eq;
    reg_le = le;
    if (reg_gr !== exp_gr || reg_eq !== exp_eq || reg_le !== exp_le )
    begin
        $display ("!!! Error !!!");
        $display ("X = (%d; %d; %d)",x1, x2, x3);
        $display ("Res = (> %b; = %b; < %b) Expect = (> %b; = %b; < %b)", gr, eq, le, exp_gr, exp_eq, exp_le);
        $finish;
    end
    #1 dummy = 1;
end

$display ("!!! Succsess !!!");'''.format(c, n1, n2, n3, method_max_num)

    main_module.Initial(EmbeddedCode(init))

    return main_module


def create_full_compare_testbench(n, dut, method_max_num):
    n1 = 2 ** n + 1
    n2 = 2 ** n 
    n3 = 2 ** n - 1
    max_num = n1 * n2 * n3

    n1_w = n1.bit_length()
    n2_w = (n2 - 1).bit_length()
    n3_w = n3.bit_length()
    max_num_w = max_num.bit_length()

    module_name = "compare_testbench_" + str(n1) + "_" + str(n2) + "_" + str(n3)

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

$display ("!!! Succsess !!!");'''.format((method_max_num), (method_max_num) - 1, n1, n2, n3, )

    main_module.Initial(EmbeddedCode(init))
    return main_module












def create_small_compare_const_testbench(n, c, dut, method_max_num, testcases_num):
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
    rand_value = main_module.Reg("rand_value", max_num_w)

    seed = main_module.Integer("seed")
    

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
seed = {6};
rand_value = $urandom(seed);
for (iter = 0; iter < {4}; iter = iter + 1)
begin
    rand_value = $urandom_range({5});
    x1 = rand_value % {1};
    x2 = rand_value % {2};
    x3 = rand_value % {3};
    exp_gr = (rand_value > const_x);
    exp_eq = (rand_value == const_x);
    exp_le = (rand_value < const_x);
    #1 dummy = 1;
    reg_gr = gr;
    reg_eq = eq;
    reg_le = le;

    if (reg_gr !== exp_gr || reg_eq !== exp_eq || reg_le !== exp_le )
    begin
        $display ("!!! Error !!!");
        $display ("X = (%d; %d; %d)",x1, x2, x3);
        $display ("Res = (> %b; = %b; < %b) Expect = (> %b; = %b; < %b)", gr, eq, le, exp_gr, exp_eq, exp_le);
        $fatal();
    end
    #1 dummy = 1;
end

$display ("!!! Succsess !!!");'''.format(c, n1, n2, n3, testcases_num, method_max_num, random.randint(0, 32767))

    main_module.Initial(EmbeddedCode(init))

    return main_module


def create_small_compare_testbench(n, dut, method_max_num, testcases_num):
    n1 = 2 ** n + 1
    n2 = 2 ** n 
    n3 = 2 ** n - 1
    max_num = n1 * n2 * n3

    n1_w = n1.bit_length()
    n2_w = (n2 - 1).bit_length()
    n3_w = n3.bit_length()
    max_num_w = max_num.bit_length()

    module_name = "compare_testbench_" + str(n1) + "_" + str(n2) + "_" + str(n3)

    main_module = Module(module_name)

    iterint = main_module.Integer("iter")

    rand_value = main_module.Reg("rand_value", max_num_w)
    rand_value_2 = main_module.Reg("rand_value_2", max_num_w)
    seed = main_module.Integer("seed")

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
seed = {0};
rand_value = $urandom(seed);
for (iter = 0; iter < {1}; iter = iter + 1)
begin
    rand_value = $urandom_range({5});
    rand_value_2 = $urandom_range({5});

    x1 = rand_value % {2};
    x2 = rand_value % {3};
    x3 = rand_value % {4};
    
    y1 = rand_value_2 % {2};
    y2 = rand_value_2 % {3};
    y3 = rand_value_2 % {4};

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

for (iter = 0; iter < {1}; iter = iter + 1)
begin
    rand_value = $urandom_range({5});
    x1 = rand_value % {2};
    x2 = rand_value % {3};
    x3 = rand_value % {4};
    
    y1 = rand_value % {2};
    y2 = rand_value % {3};
    y3 = rand_value % {4};

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

$display ("!!! Succsess !!!");'''.format(random.randint(0, 32767), testcases_num, n1, n2, n3, method_max_num)

    main_module.Initial(EmbeddedCode(init))
    return main_module