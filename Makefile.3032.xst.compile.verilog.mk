

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

### XSTdefine

FNxstEXT0:=$(PROJname)_32_1_xst
FNxstEXT1:=$(FNxstEXT0)_scr1_load
FNxstEXT2:=$(FNxstEXT0)_scr2_verilog
FNxstEXT3:=$(FNxstEXT0)_help
FNxstSCR1:=scr_$(FNxstEXT1).scr
FNxstSCR2:=scr_$(FNxstEXT2).scr
FNxstOutNGC:=obj_$(FNxstEXT0).ngc
FNxstCMD1:=cmd_$(FNxstEXT3).txt  
FNxstLOG1:=log_$(FNxstEXT0)_0_help
FNxstLOG2:=log_$(FNxstEXT0).txt

#help -arch spartan3 -command elaborate
RUNxst11:=help -arch $(DEV02) 
RUNxst12:=  run set elaborate timing script time help memory

RUNxst10=cd tmp/ && echo "$(1)" | $(ISEbin)/xst -intstyle silent -ofn ../out/$(FNxstLOG1)_$(IDXxst)_$(shell basename $(lastword $(1))).txt  
RUNxst20=cd tmp/ && $(ISEbin)/xst -intstyle silent -ofn ../out/$(FNxstLOG2) -ifn ../out/$(FNxstSCR1)
IDXxst:=1
define RUNxst14
       $(RUNxst10)

@echo '$(RUNxst10)' >> out/$(FNxstCMD1)

$(eval IDXxst=$$(shell echo $$$$(($(IDXxst)+1))))

endef

# /home/bootH/vm3/VMs/topVM/VM.jg1/virtFS.jg1/xilinx3s500e_example/demoXilinx3s500e/3S500E-Demo/verilog/LED/LED4.xst

# define RUNxst21
# -iuc NO
# -keep_hierarchy No
# -netlist_hierarchy As_Optimized
# -rtlview Yes
# -glob_opt AllClockNets
# -read_cores YES
# -write_timing_constraints NO
# -cross_clock_analysis NO
# -hierarchy_separator /
# -bus_delimiter <>
# -case Maintain
# -slice_utilization_ratio 100
# -bram_utilization_ratio 100
# -verilog2001 YES
# -fsm_extract YES -fsm_encoding Auto
# -safe_implementation No
# -fsm_style LUT
# -ram_extract Yes
# -ram_style Auto
# -rom_extract Yes
# -mux_style Auto
# -decoder_extract YES
# -priority_extract Yes
# -shreg_extract YES
# -shift_extract YES
# -xor_collapse YES
# -rom_style Auto
# -auto_bram_packing NO
# -mux_extract Yes
# -resource_sharing YES
# -async_to_sync NO
# -mult_style Auto
# -max_fanout 500
# -bufg 24
# -register_duplication YES
# -register_balancing No
# -slice_packing YES
# -optimize_primitives NO
# 
# endef
# export RUNxst21

# define RUNxst22
# run 
# -p $(DEV01) 
# -ifmt mixed 
# -ofmt ngc 
# -top $(topModule) 
# -ifn ../out/$(FNxstSCR2) 
# -ofn $(FNxstOutNGC)
# -opt_mode Speed
# -opt_level 1
# -iobuf YES
# -use_clock_enable Yes
# -use_sync_set Yes
# -use_sync_reset Yes
# -iob Auto
# -slice_utilization_ratio_maxmargin 5
# -equivalent_register_removal YES
# $(RUNxst21xxxxx)
# 
# endef
# export RUNxst22

### please note : the    RAM.v RAM.veo RAM.ngc    and    ROM.v RAM.veo RAM.ngc   must be in the search dir
### and note : only one search dir can be used.
iseXstIpDirList:= ../src5 

DSPonly:=-dsp_utilization_ratio 100 -use_dsp48 Auto
define RUNxst23
run
$(XSTdefine)
-sd $(iseXstIpDirList)
-ifn ../out/$(FNxstSCR2) 
-ifmt mixed
-ofn $(FNxstOutNGC)
-ofmt NGC
-p $(DEV01)
-top $(topModule)
-opt_mode Speed
-opt_level 1
-iuc NO
-keep_hierarchy No
-netlist_hierarchy As_Optimized
-rtlview Yes
-glob_opt AllClockNets
-read_cores YES
-write_timing_constraints NO
-cross_clock_analysis NO
-hierarchy_separator /
-bus_delimiter <>
-case Maintain
-slice_utilization_ratio 100
-bram_utilization_ratio 100
-verilog2001 YES
-fsm_extract YES -fsm_encoding Auto
-safe_implementation No
-fsm_style LUT
-ram_extract Yes
-ram_style Auto
-rom_extract Yes
-mux_style Auto
-decoder_extract YES
-priority_extract Yes
-shreg_extract YES
-shift_extract YES
-xor_collapse YES
-rom_style Auto
-auto_bram_packing NO
-mux_extract Yes
-resource_sharing YES
-async_to_sync NO
-iobuf YES
-max_fanout 20
-mult_style Auto
-bufg 24
-register_duplication YES
-register_balancing No
-slice_packing YES
-optimize_primitives NO
-use_clock_enable Yes
-use_sync_set Yes
-use_sync_reset Yes
-iob Auto
-equivalent_register_removal YES
-slice_utilization_ratio_maxmargin 5

endef
export RUNxst23

#/home/bootH/vm3/VMs/topVM/VM.jg1/virtFS.jg1/xilinx3s500e_example/demoXilinx3s500e/3S500E-Demo/verilog/LED/LED4.prj
iseVerilogList:=$(wildcard $(foreach bb1,$(wildcard src?),$(bb1)/*.v))
#$(info iseVerilogList $(iseVerilogList))

define RUNxst42
$(foreach bb2,$(iseVerilogList),\
	verilog work ../$(bb2)$(EOL))


endef
export RUNxst42

FILTERxst23:=sed -e 's;^\s*;;g'|grep -v ^$$

rx:=run_xst_to_compile_the_verilog
$(rx):=_add_the_"HELP=1"_can_generate_the_help_of_xst Makefile.3032.xst.compile.verilog.mk
rx :
	@echo out/$(FNxstLOG2) > out/loging.txt
	@echo ;echo '---- $(rx) start --- out/$(FNxstLOG2)'
	@echo  > out/$(FNxstCMD1)
ifdef HELP
	$(call RUNxst14,$(RUNxst11),help)
	@echo >> out/$(FNxstCMD1)
	$(foreach aa1,$(RUNxst12),$(eval aa2:=$(RUNxst11) -command $(aa1))$(call RUNxst14,$(aa2))$(EOL))
	@echo >> out/$(FNxstCMD1)
endif
	@#echo "$${RUNxst21}" > out/$(FNxstSCR1)
	@#echo "$${RUNxst22}" > out/$(FNxstSCR1)
	echo "$${RUNxst23}" |$(FILTERxst23) > out/$(FNxstSCR1)
	echo "$${RUNxst42}" |$(FILTERxst23) > out/$(FNxstSCR2)
	@echo "you should put the ipCores into the directory : $(iseXstIpDirList)"
	       $(RUNxst20)
	@echo '$(RUNxst20)' >> out/$(FNxstCMD1)
	cp tmp/$(FNxstOutNGC)  out/$(FNxstOutNGC).32_2  
	mv tmp/$(FNxstOutNGC)  out/


showRunHelpList +=rx   

define xst_help


Release 14.7 - xst P.20131013 (lin64)
Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
Usage: xst [-ifn <InputFile>] [-ofn <OutputFile>] [-filter <FilterFile>] [-ise
<iseProjectFile>] [-intstyle <Style>] 
There is no -finalclean architecture-specific help available for "xst".  The
architecture-independent help is instead provided below.
 
Where:
  -ifn = Script file name
      Contains a set of valid Xst commands.
  -ofn = Output log file name
      If not specified, <ifn>.srp will be generated.
      If -intstyle is not used, the output goes on stdout as well.
  -filter = Message Filter file name (for example "filter.filter").
      If specified, the contents of this file will be used to 
      filter messages from this application. The filter file 
      can be created using Xreport.      
  -intstyle [ise | xflow | silent] = Indicate contextual information when
invoking Xilinx applications within a flow or project environment.
      The mode "ise" indicates that the program is being run as part of an
integrated design environment.
      The mode "xflow" indicates that the program is being run as part of a
batch flow.
      The mode "silent" indicates that no output will be displayed to the
screen.
      Default: Program is run as a standalone application.

Note: if no options are specified XST will be run in interactive mode.

endef
