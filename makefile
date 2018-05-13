files = test.vhdl test_tb.vhdl 

run: $(files)
		ghdl -a *.vhdl
		ghdl -e test_tb
		ghdl -r test_tb --vcd=test.vcd

wave: $(files)
		gtkwave test.vcd
clean:
		rm -f test_tb test.vcd 
