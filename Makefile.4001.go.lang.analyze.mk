all:

ifeq (,$(GoTOP))
$(info )
$(info ' go lang project , should has a VAR named GoTOP being defined in Makefile.env.mk')
$(info '                   as the end target name; ')
$(info ' and the src files being put into the src?/*.go' )
$(info )
$(error )
endif

Wput_default :=wput -u -nc 


#GOapkNow=/e/eda5201/src/goInUserHome/GOPATH/bin/gomobile
#GObinNow=/e/eda5201/src/goInUserHome/go/bin/go
#/home/g/gD/nowDIR/bin
GoPath01:=$(wildcard /home/g/gD/nowDIR/bin)
ifeq (,$(GoPath01))
GoPath11:=$(shell  dirname `realpath /usr/bin/go`)
else
GoPath11:=$(shell  realpath $(GoPath01))
endif
$(info GoPath11 $(GoPath11) for bin : go )

GoPath21:=$(shell  realpath $(GoPath11)/../../goInUserHome/go/bin)
$(info     GoPath21 $(GoPath21): for bin : gomobile , gobind )

#  ifdef GoPath00001
#  GobinPathList1:=$${HOME}/go/BBgo $${HOME}/go/bin/ /usr/bin
#  GobinPathList2:=$(foreach aa1,$(GobinPathList1),$(shell echo $(aa1)))
#  GobinPathList3:=$(wildcard $(GobinPathList2))
#  GObinPathX:=PATH="$(shell echo $(GobinPathList2)|tr ' ' ':'):$${PATH}"
#  GObinNow:=$(strip $(firstword $(wildcard $(foreach aa1,$(GobinPathList2),$(shell echo $(aa1)/gomobile)))))
#  
#  GobinPath09:=$(shell realpath $${HOME}/go/bin/)
#  GobinPath11:=$(shell realpath $(GobinPath09)/../../)
#  GobinPath18:=$(GobinPath11)/go/bin
#  else
#  GobinPath18:=$(shell realpath /home/g/gD/nowDIR/bin)
#  endif
#  GobinPath19:=$(GobinPath11)/GOPATH/bin
#  GobinPath20:=$(GobinPath11)/GOPATH
#  export GobinPath20
#  GObinPathX:=PATH="$(GobinPath18):$(GobinPath19):$${PATH}"
#  GObinPathY:=GOPATH=$(GobinPath11)/GOPATH
#  GObinNow:=$(GobinPath18)/go
#  GOapkNow:=$(GobinPath19)/gomobile

GObinPathX:=PATH="$(GoPath11):$(GoPath21):$${PATH}"
GObinPathY:=GOPATH=$(GobinPath11)/GOPATH
GObinNow:=$(GoPath11)/go
GOapkNow:=$(GoPath21)/gomobile

ifeq (,$(wildcard $(shell realpath $(GObinNow))))
$(info )
$(info ' file do NOT exist : $(GobinPathList1)')
$(info ' file do NOT exist : $(GobinPathList2)')
$(info ' file do NOT exist : $(GobinPathList3)')
$(info )
$(error )
endif

# list.001.file.txt  list.002.dir.txt
listPath1:=$(shell realpath $${HOME}/go/)
listPath2:=$(shell realpath $(listPath1)/../)
# ifdef GoPath000002
# listPath3:=$(shell realpath $(listPath2)/now_dir__)
# listPath4:=$(shell realpath $(listPath3)/go/bin)
# listPath5:=$(shell realpath $(listPath3)/GOPATH/bin)
# endif
listPath3:=$(shell realpath $(GoPath11)/../../)
listPath4:=$(shell realpath $(GoPath11))
listPath5:=$(shell realpath $(GoPath21))
listPath91:=$(listPath3).001.file.txt
listPath92:=$(listPath3).002.dir.txt
goPATH1:=PATH=$(listPath4):$(listPath5):$${PATH}

ifeq ($(V),1)
$(info listPath1=$(listPath1))
$(info listPath2=$(listPath2))
$(info listPath3=$(listPath3))
$(info listPath4=$(listPath4))
$(info listPath5=$(listPath5))
$(info listPath91=$(listPath91))
$(info listPath92=$(listPath92))
$(info ' GobinPathList1 : $(GobinPathList1)')
$(info ' GobinPathList2 : $(GobinPathList2)')
$(info ' GobinPathList3 : $(GobinPathList3)')
$(info ' GobinPathList4 : $(GobinPathList4)')
$(info ' GobinPathList5 : $(GobinPathList5)')
endif

vpGO_file:=_vim/dir_09.txt
vpgo:=gen_vim_filelist_for_go_langauge
vpgo:
	echo -n  > $(vpGO_file)
	$(foreach aa2,$(filter %.go,$(goVimFileSetS)), \
		make vpGo9 FFF=$(aa2) RRR=$(listPath92) TTT=$(vpGO_file) $(EOL))
tour:=gotour
$(tour):=tour_of_go_langauge
tour:
	@echo
	@-pkill -9 tour
	@echo
	$(goPATH1) tour &
	@echo

vg:
	@echo 
	make vp
	@[ -n "$(DST)" ] && [ -f "$(DST)" ] || (echo "938381 usage : make vg DST=XXX.go" ; echo ; exit 32 )
	vim $(DST) 
	@$(GObinNow)fmt -w `realpath $(sort $(wildcard $(DST) *.go src?/*.go))`
btgo:
	$(GObinNow)fmt -w src?/*.go
