from veriloggen import *
from random import randint

import sys
sys.path.insert(0, '../python/')

from Lei_Li_2013_compare_generator import *
from naive_compare_generator import *
from pretty_print import *
from testbench_generator import *

def max_val_comp(basis_n):
    n1 = 2 ** basis_n + 1
    n2 = 2 ** basis_n 
    n3 = 2 ** basis_n - 1
    return (n1 * n2 * n3)


def test_const_full():
    for n in range(3, 5):
        max_val = max_val_comp(n)
        c = random.randint(0, max_val)
        comp_module = create_naive_compare_const_module(n, c)
        testbench = create_compare_const_testbench(n, c, comp_module, max_val, True)
        module_str = pretty_print(comp_module, True)
        testbench = pretty_print(testbench)
        f = open("tmp.v", 'w')
        f.write(module_str)
        f.write(testbench)
        f.close()
        y = os.system("iverilog tmp.v " + "./reverse/" + str(n) + ".v")
        assert y == 0
        x = os.system("vvp a.out")
        assert x == 0

def test_const_small():
    for n in range(10, 41, 10):
        max_val = max_val_comp(n)
        c = random.randint(0, max_val)
        comp_module = create_naive_compare_const_module(n, c)
        testbench = create_compare_const_testbench(n, c, comp_module, max_val, False, 2000)
        module_str = pretty_print(comp_module, True)
        testbench = pretty_print(testbench)
        f = open("tmp.v", 'w')
        f.write(module_str)
        f.write(testbench)
        f.close()
        y = os.system("iverilog tmp.v " + "./reverse/" + str(n) + ".v")
        assert y == 0
        x = os.system("vvp a.out")
        assert x == 0


def test_num_full():
    for n in range(3, 5):
        max_val = max_val_comp(n)
        comp_module = create_naive_compare_module(n)
        testbench = create_compare_testbench(n, comp_module, max_val, True)
        module_str = pretty_print(comp_module, True)
        testbench = pretty_print(testbench)
        f = open("tmp.v", 'w')
        f.write(module_str)
        f.write(testbench)
        f.close()
        y = os.system("iverilog tmp.v " + "./reverse/" + str(n) + ".v")
        assert y == 0
        x = os.system("vvp a.out")
        assert x == 0


def test_num_small():
    for n in range(10, 41, 10):
        max_val = max_val_comp(n)
        comp_module = create_naive_compare_module(n)
        testbench = create_compare_testbench(n, comp_module, max_val, False, 2000)
        module_str = pretty_print(comp_module, True)
        testbench = pretty_print(testbench)
        f = open("tmp.v", 'w')
        f.write(module_str)
        f.write(testbench)
        f.close()
        y = os.system("iverilog tmp.v " + "./reverse/" + str(n) + ".v")
        assert y == 0
        x = os.system("vvp a.out")
        assert x == 0



