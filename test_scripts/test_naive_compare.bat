iverilog -o test ..\verilog\src\naive_compare.v ..\verilog\src\converter_for_naive.v
vvp .\test
del test