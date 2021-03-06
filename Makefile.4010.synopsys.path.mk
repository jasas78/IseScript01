all:

$(if $(wildcard synopsysPATH),,$(shell ln -s $(TM)/synopsysPATH))

#LM_LICENSE_FILE?=27000@127.0.0.1
LM_LICENSE_FILE?=56789@127.0.0.1
export LM_LICENSE_FILE
$(info LM_LICENSE_FILE=$(LM_LICENSE_FILE))

synopsysPATH:=$(shell realpath synopsysPATH)
synopsysPATHok:=$(firstword $(wildcard synopsysPATH/root.LV__eda*synopsysBase))

ifndef synopsysPATHok
$(info )
$(info ' synopsys tools , need a dir named "synopsysPATH" to place the synopsys BasePath ')
$(info ' if not exist, will automatich try to link the child-directory from Makefile script direcotry')
$(info )
$(error )
endif

synopsysBIN:=$(shell 	realpath $(synopsysPATH)/bin)
VERDI_HOME:=$(shell     realpath $(synopsysPATH)/nowDIR.Verdi)
VCS_HOME:=$(shell       realpath $(synopsysPATH)/nowDIR.VCS)
DC_HOME:=$(shell       realpath $(synopsysPATH)/nowDIR.DC)


ifdef V
$(info )
$(info 'synopsysPATHok is $(synopsysPATHok)')
$(info )
endif

