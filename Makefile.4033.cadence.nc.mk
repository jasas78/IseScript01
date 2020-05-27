all:

$(if $(cadencePATH),,$(error 'you should define the cadencePATH and run again'))

bn1_CMD:= \
	NC_HOME=$(NC_HOME) 				\
	$(cadenceBIN)/nc  		        \
	$(RTLhdlSearch)			            \
	$(TBhdlList) $(RTLhdlList) 

bn1:=cadence_NC_build_only___withouth_Verdi_FSDB
bn1:
	@echo
	@echo    --------- process $@ ------- begin
	cd $(tmpRunDir2) && $(bn1_CMD)
	@echo    --------- process $@ ------- end
	@echo

define no-pie-g++

#!/bin/bash
exec g++ -no-pie $*

endef

ncPara1:= -lca -debug_access+all -full64 


bn2_CMD:= \
	NC_HOME=$(NC_HOME)                \
	VERDI_HOME=$(VERDI_HOME)            \
	$(cadenceBIN)/nc  	            \
	$(ncPara1)   			            \
	$(NCdefine)   			            \
	$(RTLhdlSearch)			            \
	$(TBhdlList) $(RTLhdlList) 
bn2:=cadence_NC_build___with_Verdi_FSDB
bn2:
	@echo    --------- process $@ ------- begin
	@pwd
	cd $(tmpRunDir2) && $(bn2_CMD) 				
	@echo    --------- process $@ ------- end


cvn:=clean_nc_tmp_file
cvn:
	mkdir -p $(tmpRunDir2) 
	cd $(tmpRunDir2) && rm -f \
		opendatabase.log \
		*.vcd \
		*.vcd.vpd \
		inter.vpd \
		command.log \
		$(tmpRunDir2)/verdi.fsdb			\
		verdi.fsdb			\
		novas_dump.log			\
		Simv simv ucli.key 
	cd $(tmpRunDir2) && rm -fr \
		DVEfiles \
		simv.daidir/ \
		csrc/

tn1:=run_the_test_of_NC___without_Verdi_FSDB
tn1:
	@echo
	rm -f verdi.fsdb $(tmpRunDir2)/verdi.fsdb
	cd $(tmpRunDir2) && ./simv
	pwd
#	cp $(tmpRunDir2)/verdi.fsdb ./
	@echo

tn2:=run_the_test_of_NC___with_Verdi_FSDB
tn2:
	@echo
	rm -f verdi.fsdb $(tmpRunDir2)/verdi.fsdb
	pwd
	cd $(tmpRunDir2) && LD_LIBRARY_PATH=$(VERDI_HOME)/share/PLI/NC/linux64   \
					./simv
	pwd
#	cp $(tmpRunDir2)/verdi.fsdb ./
	@echo

ws1:=all_nc_without_Verdi_FSDB
$(ws1):=cvn bn1 tn1
ws1: $($(ws1))

wn2:=all_nc_with_Verdi_FSDB
$(wn2):=cvn bn2 tn2
wn2:$($(wn2))

cadenceNC_OpList:=cvn bn1 bn2 tn1 tn2 ws1 wn2

define NChelp


endef


