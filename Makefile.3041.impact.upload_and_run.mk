

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

FNuurEXT0:=$(PROJname)_41_10_uur
FNuurIn1:=$(FNparOut1)
FNuurLog1:=log_$(FNuurEXT0).txt
FNuurCmd1:=cmd_$(FNuurEXT0).txt
FNuurScr1:=scr_$(FNuurEXT0).scr

ifdef AnotherDST
AnotherDSTur:=$(shell realpath $(AnotherDST))
else
AnotherDSTur:=$(shell realpath out/$(FNbitOut1))
endif

define SCRuur1
setMode -bscan
setCable -port auto
Identify -inferir 
identifyMPM 
assignFile -p 1 -file $(AnotherDSTur)
ReadIdcode -p 1 
Program -p 1 -prog 
quit

endef
export SCRuur1

ur:=impact_upload_and_run
$(ur):=Makefile.3041.impact.upload_and_run.mk ==>> using_Xilinx_burn_tools
ur :
	@echo out/$(FNuurLog1) > out/loging.txt
	@echo ;echo '---- $(ur) start --- burn to RAM and run ---->>   $(AnotherDSTur)'
	[ -f $(AnotherDSTur) ]
	@echo "$${SCRuur1}" > out/$(FNuurScr1)
	       cd tmp/ && $(LDso641) $(ISEbin)/impact -batch < ../out/$(FNuurScr1)  > ../out/$(FNuurLog1)
	echo  "cd tmp/ && $(LDso641) $(ISEbin)/impact -batch < ../out/$(FNuurScr1)  > ../out/$(FNuurLog1)" > out/$(FNuurCmd1)
	md5sum $(AnotherDSTur) 

showRunHelpList +=ur   


