iverilog -o test_const .\test_compare_const_10.v ..\src\naive_compare_const.v ..\src\converter_for_naive.v
vvp .\test_const
del test_const