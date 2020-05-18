all: 

CFGrunIseINCset1:=\
	Makefile.3031.ise.path.mk		\
	Makefile.3032.xst.compile.verilog.mk    \
	Makefile.3034.ngdbuild.decompress_to_fpga_base_gate.mk    \
	Makefile.3036.map.to.specified.fpga.mk    \
	Makefile.3037.par.mk    \
	Makefile.3038.trc.mk    \
	Makefile.3039.bitgen.mk    \
	Makefile.303a.promgen.bin.mk    \
	Makefile.303b.promgen.mcs.mk    \
	Makefile.3044.impact.gen_svf_for_run.mk		\
	Makefile.3045.impact.gen_svf_for_burn_flash.mk		\
	Makefile.3046.openocd.burn.svf.mk		\
	Makefile.3041.impact.upload_and_run.mk    \
	Makefile.3042.impact.upload_to_flash.mk    \
	Makefile.3043.iseAnalyze.report.resouce.usage.mk    \
	Makefile.3051.partgen.gen_device_pin_info.mk    \
	Makefile.3060.backupBase.mk    \
	Makefile.3061.backupXilinxISE.mk    \
	Makefile.3062.impact.burn.now.mk    \
	Makefile.3071.beautifyBase.mk    \
	Makefile.3072.beautifyVerilog.mk    \

CFGrunIseINCset2:=$(foreach aa1,$(CFGrunIseINCset1),$(TM)/$(aa1))

CFGanalyzeIseINCset1:=\
	Makefile.3101.analyzeIse.mk \
	Makefile.3102.diffISEwinLinx.mk \

CFGanalyzeIseINCset2:=$(foreach aa1,$(CFGanalyzeIseINCset1),$(TM)/$(aa1))

VerilogRunINCset:=$(sort $(wildcard src?/*.v src?/*.ucf ))

LOGing:=$(strip $(shell [ -f out/loging.txt ] && head -n 1 out/loging.txt||echo))

ve:=vim_error
$(ve):=vim_error_report_file
ve:
	@$(if $(LOGing),vim $(LOGing), echo 'out/loging.txt do NOT exist.')


include $(CFGmakeEnv)

topModule?=LED4
export topModule

PROJname:=proj_$(topModule)
export PROJname

ttUCF?=$(topModule)
ttUCF2:=$(firstword $(wildcard $(ttUCF) $(ttUCF).ucf config/$(ttUCF) config/$(ttUCF).ucf \
	$(foreach aa1,9 8 7 6 5 4 3 2 1 0, src$(aa1)/$(ttUCF) src$(aa1)/$(ttUCF).ucf )))
ifdef ttUCF2
ttUCF:=$(shell realpath $(ttUCF2))
endif

ttSRCfull?=$(foreach aa,$(wildcard src?/*.v),$(TT)/$(aa))

create_tmp_dir:=$(shell [ -d  tmp/ ] || mkdir -p tmp/ )
create_tmp_dir+=$(shell [ -d  out/ ] || mkdir -p out/ )

c:=clean_all_tmp_files_during_ise_compile
$(c):= ct co
c:$($(c))

ct:=clean_tmp
$(ct):=clean_tmp_files
ct:
	rm -fr tmp/*
co:=clean_output
$(co):=clean_output_files
co:
	rm -fr out/*

ll:=list_tmp_and_out_directory
ll:
	@ls -dl tmp/* ; echo ;ls -dl out/* ; 


showRunHelpList += ct co c ll

define showRunHelpTEXText1
endef


$(call genVimWithFileList,showSourceCodeTEXT0,$(VerilogRunINCset),vv)


$(eval $(foreach aa2,$(CFGrunIseINCset2),$(call tryINCmustExist,$(aa2),db8193911)))

aaa:=compile_verilog_by_ise_and_generate_bit_mcs_svf
$(aaa):=ct co rx rn rm rp rt rb rr rs gvr gvf 
aaa: $($(aaa))
	@echo ; echo " make $@ end." ; echo

bbb:=compile_verilog_by_ise_then_run_it_by_altera_blaster
$(bbb):=$($(aaa)) obr
bbb: $($(bbb))
	@echo ; echo " make $@ end." ; echo

ccc:=compile_verilog_by_ise_then_run_it_by_xilinx_DLC9G
$(ccc):=$($(aaa)) ur
ccc: $($(ccc))
	@echo ; echo " make $@ end." ; echo

ddd:=compile_verilog_by_ise_then_flash_it_by_altera_blaster
$(ddd):=$($(aaa)) obf obr
ddd: $($(ddd))
	@echo ; echo " make $@ end." ; echo

eee:=compile_verilog_by_ise_then_flash_it_by_xilinx_DLC9G
$(eee):=$($(aaa)) uf ur
eee: $($(eee))
	@echo ; echo " make $@ end." ; echo

dc1:=run_dc_check_the_rtl_files1
dc2:=run_dc_check_the_rtl_files2

dc1:
	make -C topDC  wd1 
	@echo ; ls -l topDC/log.dc.log02.txt 
dc2:
	make -C topDC  wd2 
	@echo ; ls -l topDC/log.dc.log02.txt 

showRunHelpList += aaa bbb ccc ddd eee dc1 dc2

ifdef AnalyzeIseTopDir
showAnalyzeIseHelpList:= 
$(eval $(foreach aa2,$(CFGanalyzeIseINCset2),$(call tryINCmustExist,$(aa2),db8193912)))
endif

#$(info VerilogRunINCset -> $(VerilogRunINCset))
btList01verilog += $(VerilogRunINCset)


