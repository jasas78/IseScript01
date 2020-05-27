all:

$(if $(wildcard cadencePATH),,$(shell ln -s $(TM)/cadencePATH))

#LM_LICENSE_FILE?=27000@127.0.0.1
LM_LICENSE_FILE?=56789@127.0.0.1
export LM_LICENSE_FILE
$(info LM_LICENSE_FILE=$(LM_LICENSE_FILE))

cadencePATH:=$(shell realpath cadencePATH)
cadencePATHok:=$(firstword $(wildcard cadencePATH/root.LV__eda*cadenceBase))

ifndef cadencePATHok
$(info )
$(info ' cadence tools , need a dir named "cadencePATH" to place the cadence BasePath ')
$(info ' if not exist, will automatich try to link the child-directory from Makefile script direcotry')
$(info )
$(error )
endif

cadenceBIN:=$(shell 	realpath $(cadencePATH)/bin)
NC_HOME:=$(shell       realpath $(cadencePATH)/nowDIR.NC)


ifdef V
$(info )
$(info 'cadencePATHok is $(cadencePATHok)')
$(info )
endif

