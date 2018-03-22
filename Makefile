
ifeq (root,$(USER))
$(info )
$(info you can NOT work as root to call this makefile.)
$(info )
$(error )
endif
all: show_help
define EOL


endef

ifndef CFGmakeTOP
CFGmakeTOP:=$(shell realpath ./Makefile)
CFGmakeDIR:=$(shell dirname $(CFGmakeTOP))
TT:=$(shell realpath ./)
TM:=$(CFGmakeDIR)
CFGmakeEnv:=$(TT)/Makefile.env.Xilinx
ifeq (,$(strip $(wildcard $(CFGmakeEnv))))
$(info )
$(info file not found 183: [$(CFGmakeEnv)])
$(info )
$(error )
endif
PROJdirTop:=$(TT)
PROJname:=$(shell basename $(PROJdirTop))
endif

DEV01?=xc3s500e-pq208-4
DEV02?=$(shell echo $(DEV01)|sed -e 's;[-_].*$$;;g')
DEV11?=spartan3

export CFGmakeTOP
export CFGmakeDIR
export CFGmakeEnv
export PROJdirTop
export PROJname
export TT
export TM
export DEV01
export DEV02
export DEV11

include $(CFGmakeEnv)
### you can pre-define the following envVARs
LDso641?=LD_PRELOAD=/home/bootH/Xilinx/usb-driver/libusb-driver.so.64.so 
RUNpath?=/e/eda2544/ise14.7xinlinx/14.7/ISE_DS/ISE/bin/lin64
topModule?=LED4
export LDso641
export RUNpath
export topModule

ttUCF?=$(TT)/$(firstword $(wildcard src9/*.ucf) $(wildcard config/*.ucf))
ttSRCfull?=$(foreach aa,$(wildcard src1/*.v src2/*.v src3/*.v src9/*.v),$(TT)/$(aa))
ttSRCshort?=$(foreach aa,$(ttSRCfull),$(shell basename $(aa)))
export ttUCF
export ttSRCfull
export ttSRCshort

#    vmx  : $(vmx) : $($(vmx))
#    vmn  : $(vmn) : $($(vmn))
define vimCFG
$$(eval VIMset1+=$(1)  : $($(1))  : $($($(1)))   $$$$(EOL)   )
$(1) $($(1)): $($($(1)))
	@echo " $(1) $($(1)): $($($(1)))"
	vim $$^


endef


CFGmakeXST?=$(shell realpath $(TM)/Makefile.32.xst.compile.verilog)
export CFGmakeXST
include $(CFGmakeXST)

CFGmakeNGD?=$(shell realpath $(TM)/Makefile.34.ngdbuild.decompress_to_fpga_base_gate)
export CFGmakeNGD
include $(CFGmakeNGD)

CFGmakeMAP?=$(shell realpath $(TM)/Makefile.36.map.to.specified.fpga)
export CFGmakeMAP
include $(CFGmakeMAP)

CFGmakePAR?=$(shell realpath $(TM)/Makefile.37.par)
export CFGmakePAR
include $(CFGmakePAR)

CFGmakeBIT?=$(shell realpath $(TM)/Makefile.39.bitgen)
export CFGmakeBIT
include $(CFGmakeBIT)

CFGmakeROM?=$(shell realpath $(TM)/Makefile.3a.promgen.bin)
export CFGmakeROM
include $(CFGmakeROM)

CFGmakeMSC?=$(shell realpath $(TM)/Makefile.3b.promgen.mcs)
export CFGmakeMSC
include $(CFGmakeMSC)

CFGmakeUpRun?=$(shell realpath $(TM)/Makefile.41.impact.upload_and_run)
export CFGmakeUpRun
include $(CFGmakeUpRun)

CFGmakeUpFlash?=$(shell realpath $(TM)/Makefile.42.impact.upload_to_flash)
export CFGmakeUpFlash
include $(CFGmakeUpFlash)

CFGmakePartGen?=$(shell realpath $(TM)/Makefile.51.partgen.gen_device_pin_info)
export CFGmakePartGen
include $(CFGmakePartGen)







	
h help : show_help
show_help:
	@echo "$${show_helpText}"

heu:=showEnvUsage
heu $(heu):
	@echo "$${showEnvUsage}"

m:=Makefile
Makefile:=$(CFGmakeTOP)

m $(m) :
	vim $(m)

vme:=CFGmakeEnv
vmx:=CFGmakeXST
vmn:=CFGmakeNGD
vmm:=CFGmakeMAP
vmp:=CFGmakePAR
vmt:=CFGmakeTRC
vmb:=CFGmakeBIT
vmr:=CFGmakeROM
vms:=CFGmakeMSC
vur:=CFGmakeUpRun
vuf:=CFGmakeUpFlash
vpg:=CFGmakePartGen


define showEnvUsage


endef
define show_helpText

    TT          : $(TT)
    PROJdirTop  : $(PROJdirTop)
    PROJname    : $(PROJname)
    vme  : $(vme) : $($(vme))
    m    : $(m) : $($(m))
    ct   : $(ct)
    co   : $(co)
    heu  : $(heu)

    LDso641     : $(LDso641)
    RUNpath     : $(RUNpath)
    ttUCF       : $(ttUCF)
    ttSRC       : $(TT)/src9 
    ttSRCshort  : $(ttSRCshort)

   $(VIMset1)

   $(RUNcmd) 
    aaa :$(aaa)
   $(KKlist)

endef
export showEnvUsage
export show_helpText

create_tmp_dir:=$(shell [ -d  tmp/ ] || mkdir -p tmp/ )
create_tmp_dir+=$(shell [ -d  out/ ] || mkdir -p out/ )

ct:=clean_tmp
ct:
	rm -fr tmp/*
co:=clean_output
co:
	rm -fr out/*

ll:
	@ls -dl tmp/* ; echo ;ls -dl out/* ; 

VIMset1:=
$(foreach aa,vme vmx vmn vmm vmp vmt vmb vmr vms vur vuf vpg,$(eval $(call vimCFG,$(aa))))

RUNcmd:=
$(foreach aa,$(RUNcmdList),$(eval RUNcmd +=$(aa)  : $($(aa)) : $($($(aa))) $$(EOL)   ))
aaa:=ct co $(filter-out uf pg,$(RUNcmdList))
aaa : $(aaa)

#kk1:=ct co rx 
#kk1:$(kk1)

#kk2:=ct co rx rn
#kk2:$(kk2)

KKlist:=
define KK
KKlist += kk$(1)  : $(wordlist 1,$(1),$(aaa)) $$(EOL)   
$$(eval    kk$(1)  : $(wordlist 1,$(1),$(aaa)) )

endef
$(foreach aa1,3 4 5 6 7 8 9 ,$(eval $(call KK,$(aa1))))

gss:
	cd $(TM) && git status

gcc:
	cd $(TM) && git commit -a

