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
    n2_w = n
    n3_w = n3.bit_length()
    max_num_w = max_num.bit_length()

    module_name = "compare_" + str(n1) + "_" + str(n2) + "_" + str(n3) + "_const_" + str(c)


    main_module = Module(module_name)

    a1_in = main_module.Input('a1_in', n1_w)
    a2_in = main_module.Input('a2_in', n2_w)
    a3_in = main_module.Input('a3_in', n3_w)

    b1_reg = main_module.Reg('b1_reg', n1_w)
    b2_reg = main_module.Reg('b2_reg', n2_w)
    b3_reg = main_module.Reg('b3_reg', n3_w)

    main_module.Initial(b1_reg(c % n1), b2_reg(c % n2), b3_reg(c % n3))


    res_le_out = main_module.Output('res_le_out')
    res_eq_out = main_module.Output('res_eq_out')
    res_gr_out = main_module.Output('res_gr_out')




    U = main_module.Wire('U', 2 * n2_w)
    V = main_module.Wire('V', 2 * n2_w)
    W = main_module.Wire('W', 2 * n2_w)
    halfW = main_module.Wire('halfW', n2_w)
    neg_d1 = main_module.Wire('neg_d1', 2 * n2_w)

    d1 = main_module.Wire('d1', n1_w)
    d2 = main_module.Wire('d2', n2_w)
    d3 = main_module.Wire('d3', n3_w)

    tmp_sum1 = main_module.Wire('tmp_sum1', 2 * n2_w)
    tmp_sum2 = main_module.Wire('tmp_sum2', 2 * n2_w)
    tmp_carry1 = main_module.Wire('tmp_carry1', 2 * n2_w)
    tmp_carry2 = main_module.Wire('tmp_carry2', 2 * n2_w)
    D1 = main_module.Wire('D1', 2 * n2_w)
    D = main_module.Wire('D', max_num_w)

    C = main_module.Wire('C')
    E = main_module.Wire('E')

    U.assign(Cat(d3[0], d3[0:n3_w], d3[1:n3_w]))
    V.assign(Cat(~d2[0:n2_w],  Int(2 ** n2_w - 1, width=n2_w, base=2, signed=False)))
    halfW.assign(Cat(d1[n1_w-1]^d1[0], d1[1:n2_w] ))
    W.assign(Cat(halfW, halfW))

    neg_d1.assign(Cat( Int(2 ** (n1_w - 2) - 1, width=n1_w - 2, base=2, signed=False), ~d1))
    C.assign(~(Uor(Cat(d1, d2, d3))))
    D.assign(Cat(D1, d2))
    E.assign(Cat(~(D[max_num_w-1] | Uand(D[n2_w - 1 : max_num_w - 1]))))
    
    res_le_out.assign(~E)
    res_eq_out.assign(C)
    res_gr_out.assign(E & ~C)

    sub1, sub2, sub3 = create_subtracting_modules(n1_w, n2_w, n3_w, n1, n2, n3)
    main_module.Instance(sub1, 'sub1', ports = [a1_in, b1_reg, d1])
    main_module.Instance(sub2, 'sub2', ports = [a2_in, b2_reg, d2])
    main_module.Instance(sub3, 'sub3', ports = [a3_in, b3_reg, d3])

    csa = create_csa_with_eac_module(n)

    main_module.Instance(csa, 'csa1', ports = [U, V, neg_d1, tmp_sum1, tmp_carry1])
    main_module.Instance(csa, 'csa2', ports = [tmp_sum1, tmp_carry1, W, tmp_sum2, tmp_carry2])

    adder = create_binary_adder_module(n)
    main_module.Instance(adder, 'adder', ports = [tmp_sum2, tmp_carry2, D1])
    return main_module

def create_subtracting_modules(n1_w, n2_w, n3_w, n1, n2, n3):

    sub_n1 = Module("mod_" + str(n1) + "_sub")
    a_in = sub_n1.Input("a_in", n1_w)
    b_in = sub_n1.Input("b_in", n1_w)
    res_out = sub_n1.Output("res_out", n1_w)
    T = sub_n1.Wire("T")
    W = sub_n1.Wire("W")
    R = sub_n1.Wire("R", n1_w)
    T.assign(~(a_in[n1_w-1] & ~b_in[n1_w-1]))
    W.assign(~(a_in[n1_w-1] | ~b_in[n1_w-1]))
    R.assign(Cat(Int(0,1,2), a_in[0:n1_w-1]) + Cat(Int(0,1,2), ~b_in[0:n1_w-1]) + T)
    res_out.assign(Cat(Int(0,1,2), R[0:n1_w-1]) + W + Cat(Int(0,n1_w-1,2), ~R[n1_w-1]))

    sub_n2 = Module("mod_" + str(n2) + "_sub")
    a_in = sub_n2.Input("a_in", n2_w)
    b_in = sub_n2.Input("b_in", n2_w)
    res_out = sub_n2.Output("res_out", n2_w)
    res_out.assign(a_in + ~b_in + 1)

    sub_n3 = Module("mod_" + str(n3) + "_sub")
    a_in = sub_n3.Input("a_in", n3_w)
    b_in = sub_n3.Input("b_in", n3_w)
    res_out = sub_n3.Output("res_out", n3_w)
    R1 = sub_n3.Wire("R1", n3_w + 1)
    R2 = sub_n3.Wire("R2", n3_w)
    R1.assign(Cat(Int(0,1,2), a_in) + Cat(Int(0,1,2), ~b_in))
    R2.assign(R1[0:n3_w] + Cat(Int(0,n2_w-1,2), R1[n3_w]) )
    res_out.assign(EmbeddedCode("&R2 ? ~R2 : R2"))

    return sub_n1, sub_n2, sub_n3


def create_csa_with_eac_module(n):

    csa = Module("csa_with_eac")
    a_in = csa.Input("a_in", 2*n)
    b_in = csa.Input("b_in", 2*n)
    c_in = csa.Input("c_in", 2*n)
    s_out = csa.Output("s_out", 2*n)
    c_out = csa.Output("c_out", 2*n)
    carry = csa.Wire("carry", 2*n)
    carry.assign((a_in & b_in) | (b_in & c_in) | (a_in & c_in))
    s_out.assign(a_in ^ b_in ^ c_in)
    c_out.assign(Cat(carry[0:2*n-1], carry[2*n-1]))

    return csa


def create_binary_adder_module(n):

    adder = Module("binary_adder")
    a_in = adder.Input("a_in", 2*n)
    b_in = adder.Input("b_in", 2*n)
    s_out = adder.Output("s_out", 2*n)
    R1 = adder.Wire("R1", 2*n+1)
    R2 = adder.Wire("R2", 2*n)
    R1.assign(a_in + b_in)
    R2.assign(R1[0:2*n] + R1[2*n])
    s_out.assign(EmbeddedCode("&R2 ? ~R2 : R2"))
    return adder


def main():
    comp = create_compare_const_module(3, 10)
    testbench = create_compare_const_testbench(3, 10, comp)
    mod = pretty_print(comp, False)
    testmod = pretty_print(testbench)
    f = open('article_compare_const.v', 'w')
    f.write(mod)
    f.write(testmod)
    f.close()

if __name__ == '__main__':
    main()
