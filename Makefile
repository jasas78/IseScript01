
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

#$$(info include $($($(1))))
define incMAKE
$$(eval export    $($(1)))
$$(eval include $($($(1))))

endef


CFGmakeXST:=$(TM)/Makefile.32.xst.compile.verilog
CFGmakeNGD:=$(TM)/Makefile.34.ngdbuild.decompress_to_fpga_base_gate
CFGmakeMAP:=$(TM)/Makefile.36.map.to.specified.fpga
CFGmakePAR:=$(TM)/Makefile.37.par
CFGmakeTRC:=$(TM)/Makefile.38.trc
CFGmakeBIT:=$(TM)/Makefile.39.bitgen
CFGmakeBIN:=$(TM)/Makefile.3a.promgen.bin
CFGmakeMSC:=$(TM)/Makefile.3b.promgen.mcs
CFGmakeUpRun:=$(TM)/Makefile.41.impact.upload_and_run
CFGmakeUpFlash:=$(TM)/Makefile.42.impact.upload_to_flash
CFGmakePartGen:=$(TM)/Makefile.51.partgen.gen_device_pin_info
vme:=CFGmakeEnv
vmx:=CFGmakeXST
vmn:=CFGmakeNGD
vmm:=CFGmakeMAP
vmp:=CFGmakePAR
vmt:=CFGmakeTRC
vmb:=CFGmakeBIT
vmr:=CFGmakeBIN
vms:=CFGmakeMSC
vur:=CFGmakeUpRun
vuf:=CFGmakeUpFlash
vpg:=CFGmakePartGen


INClist:=vmx vmn vmm vmp vmt vmb vmr vms vur vuf vpg
$(foreach aa,$(INClist),$(eval $(call incMAKE,$(aa))))


#    vmx  : $(vmx) : $($(vmx))
#    vmn  : $(vmn) : $($(vmn))
define vimCFG
$$(eval VIMset1+=$(1)  : $($(1))  : $($($(1)))   $$$$(EOL)   )
$(1) $($(1)): $($($(1)))
	@echo " $(1) $($(1)): $($($(1)))"
	vim $$^


endef





	
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
    c    : $(c)
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

c:= ct co
c:$(c)
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

