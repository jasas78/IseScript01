
ifeq (root,$(USER))
$(info )
$(info you can NOT work as root to call this makefile.)
$(info )
$(error )
endif
all: show_help
	@[ -z '$(wildcard *.cmd_log)' ] || ls -l *.cmd_log
	@echo

define EOL


endef

CFGiseFN1:=$(wildcard *.xise)
CFGiseFN2:=$(firstword $(CFGiseFN1))
ifeq (,$(CFGiseFN1))
$(error 'CFGiseFN1 empty : no *.xise exist' )
endif
ifneq ($(CFGiseFN2),$(CFGiseFN1))
$(error 'too much *.xise file exist.')
endif
CFGiseTop:=$(shell cat $(CFGiseFN1)|grep 'Implementation Top'|grep Module |xargs -n 1|grep =Module |sed -e 's;^.*|;;g')



ifeq (,$(CFGmakeVimBase))
CFGmakeVimBase:=$(firstword $(wildcard Makefile.vimBase.mk scriptX/Makefile.vimBase.mk Makefile.vimTop.mk scriptX/Makefile.vimTop.mk Makefile))
ifeq (,$(CFGmakeVimBase))
$(error 'CFGmakeVimBase not found 001 ')
endif
CFGmakeVimBase:=$(shell realpath $(CFGmakeVimBase))
$(info 'CFGmakeVimBase:$(CFGmakeVimBase)')
CFGmakeVimBase:=$(shell dirname $(CFGmakeVimBase))
CFGmakeVimBase:=$(CFGmakeVimBase)/Makefile.vimBase.mk
CFGmakeVimBase:=$(wildcard $(CFGmakeVimBase))
ifeq (,$(CFGmakeVimBase))
$(error 'CFGmakeVimBase not found 001 ')
endif
endif

ifeq (,$(CFGmakeVimBase))
$(error 'CFGmakeVimBase not found 002 ')
endif
#$(info 'info CFGmakeVimBase $(CFGmakeVimBase)')

export CFGmakeVimBase
include $(CFGmakeVimBase)

vm:
	$(vim) $(CFGmakeVimBase)



	
h help : show_help
show_help:
	@echo "$${show_helpText}"

heu:=showEnvUsage
heu $(heu):
	@echo "$${showEnvUsage}"

m:=Makefile
Makefile:=$(CFGmakeTOP)

m $(m) :
	$(vim) $(m)



define showEnvUsage


endef
export showEnvUsage

define show_helpText

	<$(CFGiseFN1)> <$(CFGiseTop)>
	cx : $(cx)
   $(vvvv2)

endef
export show_helpText

v1:=t.v
v2:=testbench.v
v3:=v_code/CP447_CMI_AL0205.v

vvvv1:=v1 v2 v3
$(foreach aa1,$(vvvv1),$(eval $(aa1):$($(aa1))$(EOL)		$(vim) $$^))
vvvv2:=$(foreach aa1,$(vvvv1),$(aa1): $(vim) $($(aa1))$(EOL)  )
export vvvv2

cx:=clean_xilinx_tmp_files
cx $(cx): cx1 cx2 cx3
cx1:= \
	_ngo/    _xmsgs/ \
	xst/dump.xst/    xst/projnav.tmp/    xst/work/    xst/ \
	xlnx_auto_0_xdb/ iseconfig/ 
cx1:
	rm -fr $(wildcard $(cx1))
cx20:= \
	.xwbt \
	.ut .bit .bgn .drc \
	.bld .cmd_log .csv .gise .html .lso .map .mrp .ncd .ngc .ngd .ngm .ngr .pad .par \
	.pcf .prj .ptwx .stx .syr .twr .twx .txt .unroutes .xml .xpi .xrpt .xst   
cx21:=\
	_bitgen.xwbt _envsettings.html _guide.ncd _map.map _map.mrp _map.ncd _map.ngm \
	_map.xrpt _ngdbuild.xrpt _pad.csv _pad.txt _par.xrpt _summary.html _summary.xml \
	_usage.xml _xst.xrpt
cx22:=\
	usage_statistics_webtalk.html webtalk.log  webtalk_pn.xml

cx2:=$(foreach aa1,$(cx20),$(CFGiseTop)$(aa1))
cx2+=$(foreach aa1,$(cx21),$(CFGiseTop)$(aa1))
cx2+=$(cx22)
cx2+=*.gise

cx2:
	rm -fr $(wildcard $(cx2))

cx3:=*/*.gise */*.ncf */_xmsgs/ */xlnx_auto_0_xdb/
cx3:
	rm -fr $(wildcard $(cx3))
