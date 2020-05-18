

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

SSgvr?=bit.now.bit
DDgvr?=svf.FPGA.run.svf

SSgvrXX:=$(shell realpath $(SSgvr))
DDgvrXX:=$(shell realpath $(DDgvr))

FFgvrScr1:=scr_3044.impact.gen_svf_for_run.scr
FFgvrLog1:=log_3044.impact.gen_svf_for_run.log

define SCRgvrScr1

setMode -bscan
setCable -port svf -file "$(DDgvrXX)"
addDevice -p 1 -part $(JtagPart1)
addDevice -p 2 -part $(JtagPart2)
assignFile -p 1 -file "$(SSgvrXX)"
Program -p 1 
exit

endef
export SCRgvrScr1

define gvrUsageTEXT

make gvr [SSgvr=$(SSgvr)] [DDgvr=$(DDgvr)] [JtagPart1=$(JtagPart1)] [JtagPart2=$(JtagPart2)] 
note : you can re-define SSgvr & DDgvr & JtagPart1 & JtagPart2 in Makefile.env.mk or in command line

endef
export gvrUsageTEXT

gvrUSAGE:=gen_svf_for_FPGA_run_only_USAGE
$(gvrUSAGE):=$(EOL)$(gvrUsageTEXT)
gvrUSAGE:
	@echo "$${gvrUsageTEXT}"





gvr:=gen_svf_for_run_in_fpga_RAM_only
$(gvr):=Makefile.3044.impact.gen_svf_for_run.mk

gvr :
	[ -d tmp ] || mkdir tmp
	rm -f tmp/_impactbatch.log tmp/$(FFgvrScr1) tmp/$(FFgvrLog1) $(DDgvrXX)
	ls -l tmp/
	echo "$${SCRgvrScr1}" > tmp/$(FFgvrScr1)
	md5sum $(SSgvrXX) 
	cd tmp/ && $(LDso641) $(ISEbin)/impact \
		-batch < $(FFgvrScr1)  > $(FFgvrLog1)
	sed -i -e '/^\/\/ Date:/d' $(DDgvrXX)
	md5sum $(DDgvrXX) 


showRunHelpList +=gvr 
## showRunHelpList +=gvrUSAGE

