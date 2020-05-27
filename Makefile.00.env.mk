all: 

ifeq (root,$(USER))
$(info )
$(info you can NOT work as root to call this makefile.1)
$(info )
#$(error )
endif

define EOL


endef
M6=`cat $1|md5sum|awk '{printf $$1}'|cut -c27-`
M8=`cat $1|md5sum|awk '{printf $$1}'|cut -c25-`

RAR0:=/home/bootH/bin/rar
RAR1:=$(wildcard $(RAR0))
ifeq (,$(strip $(RAR1)))
RAR1:=$(wildcard $(shell which rar))
endif
ifeq (,$(strip $(RAR1)))
$(error 'why RAR not found ? $(RAR0)' )
endif
RAR9:=$(RAR1) a -m5 -s -hp1 -r

time_called?=$(shell LANG=LANG=en_US.UTF-8 date +"%Y_%m%d__%H%M%P")
export time_called

define TTtmTEXT

TT  dir_current
TM  dir_of_MakefileScriptBASE
TN  dir_of_MakefileScriptNOW

endef

ifeq (,$(TT))
$(info you should define TT at first.$(EOL)$(TTtmTEXT))
$(error ENVtt001)
endif
ifeq (,$(TM))
$(info you should define TM at first.$(EOL)$(TTtmTEXT))
$(error ENVtt002)
endif
ifeq (,$(time_called))
$(info you should define time_called at first.$(EOL)$(TTtmTEXT))
$(error ENVtt003)
endif


inMakeScriptDIR:=
$(info )
ifeq ($(TT),$(TM))
inMakeScriptDIR:=1
$(info on the make script dir ... )
else
$(info on the runing dir ... )
endif
$(info )

showOptionListDefault:=m e h so srh ss sml
CFGmakeINCset01:= Makefile.1011.git.mk Makefile.1013.vim.mk
CFGmakeINCset61:= Makefile.alone.iseAnalyze.vimBase.mk Makefile.alone.iseAnalyze.vimTop.mk
CFGmakeInc91firstVimAndGit:=Makefile.2091.vimAndGit.mk
CFGmakeInc99endAll:=Makefile.2099.endAll.mk

CFGmakeINCsetNOW?=						\
	Makefile.run.document01.mk 			\
	Makefile.run.ise01.mk 					\
	Makefile.run.OpenOCD.mk 				\
	Makefile.run.go01.mk 					\
	Makefile.run.go02.mk 					\
	Makefile.run.js01.mk 					\
	Makefile.run.synopsysVCS.mk 			\
	Makefile.run.synopsysVERDI.mk 			\
	Makefile.run.synopsysDC.mk 			\
	Makefile.run.cadenceNC.mk 			\
	Makefile.run.NFT.mk    	 			\


define tryINCmustExist
$(if $(wildcard $(shell test -f $(1) && echo $(1))),,$(info )$(info file <$(1)> do not exist 218381 , $(2).)$(info )$(error ))
$(if $(V),$(info INCLUDEing ... <$(1)>))
$(eval include $(1))
endef

define CFGmakeEnvTEXT

you must define the following VARs in the Makefile.env.mk in current directory:
1. CFGmakeRun     : must   : $(CFGmakeINCsetNOW) --> now $(CFGmakeRun)
2. showOptionList : option :default is "$(showOptionListDefault)" 

endef

define testVARmustExist
$(if $($(1)),,                           $(info )$(info $(3):$($(2)):a00000011:varNotExist)$(info        )$(error ))
endef
define testVARmustBelongTo
$(if $($(1)),,                           $(info )$(info $(3):$($(3)):a00000021:varNotExist)$(info        )$(error ))
$(if $(findstring $($(1)),$($(2))),,     $(info )$(info $(3):$($(3)):a00000022:varNotInAllowRange)$(info )$(error ))
endef

#$(eval $(call testVARmustExist,CFGmakeRun,CFGmakeEnvTEXT))
ifndef inMakeScriptDIR
$(eval $(call tryINCmustExist,$(TT)/Makefile.env.mk,db1873101))
$(eval $(call testVARmustBelongTo,CFGmakeRun,CFGmakeINCsetNOW,CFGmakeEnvTEXT))
endif

$(eval $(call tryINCmustExist,$(TM)/$(CFGmakeInc91firstVimAndGit),db1873102))

#CFGmakeRun?=$(firstword $(CFGmakeINCsetNOW))
ifdef CFGmakeRun
#showRunHelpList:= 
$(eval $(call tryINCmustExist,$(TM)/$(CFGmakeRun),db1873103))
endif

ifeq (root,$(USER))
$(info you can NOT work as root to call this makefile.2)
$(info $(rootShowTEXT))
$(error )
endif


showOptionList:=

$(eval $(call tryINCmustExist,$(TM)/$(CFGmakeInc99endAll),db1873105))
