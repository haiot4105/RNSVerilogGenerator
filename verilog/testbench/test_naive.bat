iverilog -o test .\test_compare.v ..\src\naive_compare.v ..\src\converter_for_naive.v
vvp .\test
del test