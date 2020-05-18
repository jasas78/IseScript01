all:

#	-c 's;\s*$$;;g'  \
	#	-c '%s;^\s*;;g' \

bt1:=beautified__the_source_verilog
$(bt1):=Makefile.3071.beautifyBase.mk $(EOL)                    $(btCMD01) 
bt1:
	@echo 
	$(foreach aa1,$(btList01verilog), $(btCMD01) $(aa1) $(EOL))
	@echo 


showRunHelpList += bt1
