all:

File01?=$(shell realpath ./Makefile)
export File01
TT:=$(shell realpath .)
TM:=$(shell dirname $(File01))

iSoriginDIR:=
ifeq ($(TT),$(TM))
iSoriginDIR:=1
#$(info eqeq)
else
#$(info nene)
endif

CFGmake00env:=$(wildcard $(TM)/Makefile.00.env)
ifndef CFGmake00env
$(error "173800 why      $(TM)/Makefile.00.env don't exist ?")
endif
include $(CFGmake00env)

