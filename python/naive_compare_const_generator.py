import sys
import os
from veriloggen import *
import veriloggen.verilog.to_verilog as to_verilog
from pyverilog.ast_code_generator.codegen import ASTCodeGenerator
import re

from testbench_generator import create_compare_const_testbench
from pretty_print import pretty_print

def create_compare_const_module(n, c):
    n1 = 2 ** n + 1
    n2 = 2 ** n 
    n3 = 2 ** n - 1
    max_num = n1 * n2 * n3

    n1_w = n1.bit_length()
    n2_w = (n2 - 1).bit_length()
    n3_w = n3.bit_length()
    max_num_w = max_num.bit_length()

    module_name = "compare_" + str(n1) + "_" + str(n2) + "_" + str(n3) + "_const_" + str(c)
    conv_name = "reverse_converter_" + str(n1) + "_" + str(n2) + "_" + str(n3)

    main_module = Module(module_name)

    a1_in = main_module.Input('a1_in', n1_w)
    a2_in = main_module.Input('a2_in', n2_w)
    a3_in = main_module.Input('a3_in', n3_w)


    res_le_out = main_module.Output('res_le_out')
    res_eq_out = main_module.Output('res_eq_out')
    res_gr_out = main_module.Output('res_gr_out')

    bin_form = main_module.Wire('bin_form', max_num_w)


    const_reg = main_module.Reg('const_reg', max_num_w)
    main_module.Initial(const_reg(c))
    const_reg.initval = str(c)

    conv_module = Module(conv_name)
    conv_x1 = conv_module.Input('x1', n1_w)
    conv_x2 = conv_module.Input('x2', n2_w)
    conv_x3 = conv_module.Input('x3', n3_w)
    conv_out = conv_module.Output('out', max_num_w)
    main_module.Instance(conv_module, 'converter', ports = [a1_in, a2_in, a3_in, bin_form])


    res_le_out.assign(bin_form < const_reg)
    res_eq_out.assign(bin_form == const_reg)
    res_gr_out.assign(bin_form > const_reg)

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
