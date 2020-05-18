env64:=LD_LIBRARY_PATH=/lib64:/usr/lib64
env32:=LD_LIBRARY_PATH=/lib:/usr/lib:/lib32:/usr/lib32
awk:=$(env64) awk

tmpRunDir1:=$(shell echo $${PWD}|awk -F/ '{print $$(NF-1) "_" $$NF }')
tmpRunDir2:=/tmp/$(shell echo $${PWD}|awk -F/ '{print $$(NF-1) "_" $$NF }')

all:

File01?=$(shell /usr/bin/realpath --relative-to . ./Makefile)
File01?=$(shell /usr/bin/realpath --relative-to . ./Makefile.notExist038381.mk)
#export File01
TT:=$(shell /usr/bin/realpath --relative-to . .)
$(iinfo File01:$(File01))
TM:=$(shell dirname $(File01))
TN:=$(shell /usr/bin/realpath --relative-to . $(TT)/script.NOW)


CFGmake00env:=$(wildcard $(TM)/Makefile.00.env.mk)
ifeq (,$(CFGmake00env))
$(error "173800 why      $(TM)/Makefile.00.env.mk don't exist ?")
endif
include $(CFGmake00env)

#$(info vvvv1->$(vvvv1))
#$(info vvvv2->$(vvvv2))

# git remote add origin https://dengyanuoapp@github.com/dengyanuoapp/Ise601.3phrase.motoro.git
# git remote add origin https://github.com/dengyanuoapp/IseScript01.git
up:
	git push -u origin master

upp upup:
	make up -C $(TM) 
