import sys
import os
from veriloggen import *
import veriloggen.verilog.to_verilog as to_verilog
from pyverilog.ast_code_generator.codegen import ASTCodeGenerator

import re

def create_compare_const_module(n, c):
    n1 = 2 ** n + 1
    n2 = 2 ** n 
    n3 = 2 ** n - 1
    max_num = n1 * n2 * n3

    n1_w = n1.bit_length()
    n2_w = (n2 - 1).bit_length()
    n3_w = n3.bit_length()
    max_num_w = max_num.bit_length()

    module_name = "compare_const_" + str(c) + "_" + str(n1) + "_" + str(n2) + "_" + str(n3)
    conv_name = "reverse_converter_" + str(n1) + "_" + str(n2) + "_" + str(n3)

    main_module = Module(module_name)

    a1_in = main_module.Input('a1_in', n1_w)
    a2_in = main_module.Input('a2_in', n2_w)
    a3_in = main_module.Input('a3_in', n3_w)


    res_le_out = main_module.Output('res_le_out')
    res_eq_out = main_module.Output('res_eq_out')
    res_gr_out = main_module.Output('res_gr_out')

    bin_form = main_module.Wire('bin_form', max_num_w)

    # const_init_str = "reg [" + str(max_num_w-1) + ":0] const_reg"
    # main_module.EmbeddedCode("hello")
    const_reg = main_module.Reg('const_reg', max_num_w)
    main_module.Initial(const_reg(c))
    const_reg.initval = str(c)

    conv_module = Module(conv_name)
    conv_x1 = conv_module.Input('x1', n1_w)
    conv_x2 = conv_module.Input('x2', n2_w)
    conv_x3 = conv_module.Input('x3', n3_w)
    conv_out = conv_module.Output('out', max_num_w)
    main_module.Instance(conv_module, 'converter', ports = [a1_in, a2_in, a3_in, bin_form])
    # main_module.Instance(conv_module, 'converter2', ports = [b1_in, b2_in, b3_in, b_bin_form])


    res_le_out.assign(bin_form < const_reg)
    res_eq_out.assign(bin_form == const_reg)
    res_gr_out.assign(bin_form > const_reg)

    return main_module


def pretty_print(module):
    module_string = ''
    str_verilog = module.to_verilog('tmp.v')
    os.remove('tmp.v')
    str_verilog = str_verilog.split('\n')
    end_pattern = re.compile("endmodule*")
    pattern = re.compile("\d+-1")

    for line in str_verilog:
        nums = re.findall(r'\d+-1', line)
        if(len(nums) != 0):
            for num in nums:
                n = int(num.split("-")[0]) - 1
                re.findall(r'\d+-1', line)
                line = re.sub(num, str(n), line)

        module_string = module_string + "\n" + line
        if(end_pattern.search(line)):
            return module_string


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

$display ("!!! Succsess !!!");'''.format(c, n1, n2, n3, max_num)

    main_module.Initial(EmbeddedCode(init))

    return main_module


def main():
    comp = create_compare_const_module(3, 10)
    testbench = create_compare_const_testbench(3, 10, comp)
    mod = pretty_print(comp)
    testmod = pretty_print(testbench)
    f = open('naive_compare_const.v', 'w')
    f.write(mod)
    f.write(testmod)
    f.close()

if __name__ == '__main__':
    main()
