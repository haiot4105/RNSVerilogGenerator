iverilog -o test_const  ..\verilog\src\naive_compare_const.v ..\verilog\src\converter_for_naive.v
vvp .\test_const
del test_const