iverilog -o test ..\verilog\src\article_compare_const.v
vvp .\test
del test