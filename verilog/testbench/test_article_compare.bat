iverilog -o test .\test_compare.v ..\src\Lei_Li_compare.v
vvp .\test
del test