import sys
import os
from veriloggen import *
import veriloggen.verilog.to_verilog as to_verilog
from pyverilog.ast_code_generator.codegen import ASTCodeGenerator
import re

def pretty_print(module, single_module = True):
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
        if(end_pattern.search(line) and single_module):
            return module_string
    return module_string