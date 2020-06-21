env64:=LD_LIBRARY_PATH=/lib64:/usr/lib64
env32:=LD_LIBRARY_PATH=/lib:/usr/lib:/lib32:/usr/lib32
awk:=$(env64) awk

tmpRunDir1:=$(shell      echo $${PWD}|awk -F/ '{print $$(NF-1) "_" $$NF }')
tmpRunDir2:=/tmp/$(shell echo $${PWD}|awk -F/ '{print $$(NF-1) "_" $$NF }')
tmpRunDir3:=/tmp/$(shell echo $${PWD}|awk -F/ '{print $$(NF-1) "_"      }')

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

define if_home_end_key_do_NOT_work_in_docker
https://superuser.com/questions/94436/how-to-configure-putty-so-that-home-end-pgup-pgdn-work-properly-in-bash
~/.inputrc

set meta-flag on
set input-meta on
set convert-meta off
set output-meta on
"\e[1~": beginning-of-line     # Home key
"\e[4~": end-of-line           # End key
"\e[5~": beginning-of-history  # PageUp key
"\e[6~": end-of-history        # PageDown key
"\e[3~": delete-char           # Delete key
"\e[2~": quoted-insert         # Insert key
"\eOD": backward-word          # Ctrl + Left Arrow key
"\eOC": forward-word           # Ctrl + Right Arrow key

endef

