import argparse
from Lei_Li_2013_compare_generator import *
from naive_compare_generator import *
from pretty_print import *
from testbench_generator import *

def main():
    basis_n = -1
    comp_type = "num"
    const_val = -1
    test_cases = 2000

    method = ""
    output = "file"
    file_path = ""
    test_enable = False
    print_enable = False

    parser = argparse.ArgumentParser(description='Generates Verilog HDL modules for compare operation for Residue Number Systems with moduli \{2^n-1; 2^n; 2^n+1\}')

    parser.add_argument('-n', type=int, help='n value for moduli set \{2^n-1; 2^n; 2^n+1\}', required=True)
    parser.add_argument('-m', '--method', type=str, help='Choose compare method: naive, lei_li_2013', required=True)

    parser.add_argument('-o','--output', help='Output file name', type=str)
    parser.add_argument('-c', '--const', type=int, help='Generate compare with const (Defaut: compare two numbers). Integer constant should be defined (0 <= const < Max).')

    parser.add_argument('-p', '--print', help='Print result to std output', dest='print', action='store_true')
    parser.add_argument('-t', '--testbench', help='Generate testbench', dest='tb', action='store_true')

    parser.add_argument('-k', '--testcases', help='Set the number of testcases, when n > 7 (Defaut: 2000). he number of test cases must be greater then 0 and less 65536', dest='tc', type=int)

    parser.set_defaults(print=False)
    parser.set_defaults(tb=False)
    parser.set_defaults(tc=2000)
    parser.set_defaults(const=-1)
    parser.set_defaults(output="a.v")

    args = parser.parse_args()


    basis_n = args.n
    const_val = args.const
    if (const_val > -1):
        comp_type = "const"
    
    method = args.method
    file_path = args.output
    test_enable = args.tb
    if test_enable:
        if 0 < args.tc < 65536:
            test_cases = args.tc
        else:
            print("The number of test cases must be greater then 0 and less 65536. TC was set to 2000")

    print_enable = args.print

    n1 = 2 ** basis_n + 1
    n2 = 2 ** basis_n 
    n3 = 2 ** basis_n - 1
    max_val = n1 * n2 * n3

    max_val = max_val//2 if (method == "lei_li_2013") else max_val - 1

    if (basis_n < 3): 
        print("n must be greater than 3")
        exit(-1)

    if (const_val > max_val):
        print("const must be >= 0 and <= max_value (", max_val, "for", method, "method )")
        exit(-1)


    module_str = ""
    testbench = ""
    comp_module = None

    if (comp_type == "const"):
        if (method == "naive"):
            comp_module = create_naive_compare_const_module(basis_n, const_val)
            module_str = pretty_print(comp_module, True)
        if (method == "lei_li_2013"):
            comp_module = create_lei_li_2013_compare_const_module(basis_n, const_val)
            module_str = pretty_print(comp_module, False)

    if (comp_type == "num"):
        if (method == "naive"):
            comp_module = create_naive_compare_module(basis_n)
            module_str = pretty_print(comp_module, True)
        if (method == "lei_li_2013"):
            comp_module = create_lei_li_2013_compare_module(basis_n)
            module_str = pretty_print(comp_module, False)

    method_max_num = max_val if (method == "naive") else max_val // 2

    if (test_enable):
        full_test = True if basis_n < 8 else False
        if (comp_type == "const"):
            testbench = create_compare_const_testbench(basis_n, const_val, comp_module, method_max_num, full_test, test_cases)
        if (comp_type == "num"):
            testbench = create_compare_testbench(basis_n, comp_module, method_max_num, full_test, test_cases)
        testbench = pretty_print(testbench)

    if (len(file_path) > 0):
        f = open(file_path, 'w')
        f.write(module_str)
        f.write(testbench)
        f.close()

    if (print_enable):
        print(module_str)
        print(testbench)


if __name__ == "__main__":
    main()
