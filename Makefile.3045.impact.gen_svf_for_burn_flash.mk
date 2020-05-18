

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

SSgvf?=mcs.now.mcs
DDgvf?=svf.FPGA.flash.svf

SSgvfXX:=$(shell realpath $(SSgvf))
DDgvfXX:=$(shell realpath $(DDgvf))

FFgvfScr1:=scr_3044.impact.gen_svf_for_run.scr
FFgvfLog1:=log_3044.impact.gen_svf_for_run.log

define SCRgvfScr1

setMode -bscan
setCable -port svf -file "$(DDgvfXX)"
addDevice -p 1 -part $(JtagPart1)
addDevice -p 2 -part $(JtagPart2)
assignFile -p 2 -file "$(SSgvfXX)"
Program -p 2 -e -v 
exit

endef
export SCRgvfScr1

define gvfUsageTEXT

make gvf [SSgvf=$(SSgvf)] [DDgvf=$(DDgvf)] [JtagPart1=$(JtagPart1)] [JtagPart2=$(JtagPart2)] 
note : you can re-define SSgvf & DDgvf & JtagPart1 & JtagPart2 in Makefile.env.mk or in command line

endef
export gvfUsageTEXT

gvfUSAGE:=gen_svf_for_FPGA_flash_USAGE
$(gvfUSAGE):=$(EOL)$(gvfUsageTEXT)
gvfUSAGE:
	@echo "$${gvfUsageTEXT}"





gvf:=gen_svf_for_burn_into_fpga_flash
$(gvf):=Makefile.3045.impact.gen_svf_for_burn_flash.mk

gvf :
	[ -d tmp ] || mkdir tmp
	rm -f tmp/_impactbatch.log tmp/$(FFgvfScr1) tmp/$(FFgvfLog1) $(DDgvfXX)
	ls -l tmp/
	echo "$${SCRgvfScr1}" > tmp/$(FFgvfScr1)
	md5sum $(SSgvfXX) 
	cd tmp/ && $(LDso641) $(ISEbin)/impact \
		-batch < $(FFgvfScr1)  > $(FFgvfLog1)
	sed -i -e '/^\/\/ Date:/d' $(DDgvfXX)
	md5sum $(DDgvfXX) 


showRunHelpList +=gvf 
## showRunHelpList +=gvfUSAGE
