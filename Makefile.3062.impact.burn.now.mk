
all:

nr:=burn_with_the_tmp_file__into_ram_____run_only_____bit.another.bit
$(nr):= make nr AnotherDST=XXX
nr: bit.another.bit
	       make ur AnotherDST=$^
	@echo 'make ur AnotherDST=$^'

nf:=burn_with_the_tmp_file__into_flash___forever______mcs.another.mcs
$(nf):= make nf AnotherDST=XXX
nf: mcs.another.mcs
	       make ufo AnotherDST=$^
	@echo 'make ufo AnotherDST=$^'


showRunHelpList += nr nf

