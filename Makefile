env64:=LD_LIBRARY_PATH=/lib64:/usr/lib64
env32:=LD_LIBRARY_PATH=/lib:/usr/lib:/lib32:/usr/lib32
awk:=$(env64) awk

all:

File01?=$(shell realpath ./Makefile)
export File01
TT:=$(shell realpath .)
TM:=$(shell dirname $(File01))
TN:=$(shell realpath $(TT)/script.NOW)


CFGmake00env:=$(wildcard $(TM)/Makefile.00.env)
ifndef CFGmake00env
$(error "173800 why      $(TM)/Makefile.00.env don't exist ?")
endif
include $(CFGmake00env)

#$(info vvvv1->$(vvvv1))
#$(info vvvv2->$(vvvv2))
