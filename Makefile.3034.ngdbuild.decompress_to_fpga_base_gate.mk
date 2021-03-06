

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

# ngdbuild -intstyle ise -dd _ngo -nt timestamp -uc LED4.ucf -p xc3s500e-pq208-4 LED4.ngc LED4.ngd  

FNngdEXT0:=$(PROJname)_34_2_ngd
FNngdInNGC:=$(FNxstOutNGC)
FNngdOut1NGD:=obj_$(FNngdEXT0).ngd
FNngdOut2BLD:=obj_$(FNngdEXT0).bld
FNngdLog1:=log_$(FNngdEXT0).txt
FNngdCMD1:=cmd_$(FNngdEXT0).txt

define RUNngdPara
    -intstyle silent \
	-sd ../src5 \
	-nt timestamp  \
	-uc $(ttUCF) 				\
	-p $(DEV01) 				\
	../out/$(FNngdInNGC) 		\
	$(FNngdOut1NGD) 				\

endef
RUNngd:=cd tmp/ && $(ISEbin)/ngdbuild $(RUNngdPara) > ../out/$(FNngdLog1)

rn:=run_ngdbuild_to_decompress_to_base_fpga_gates 
$(rn):=Makefile.3034.ngdbuild.decompress_to_fpga_base_gate.mk
rn :
	@echo out/$(FNngdLog1) > out/loging.txt
	@echo ;echo '---- $(rn) start --- out/$(FNngdLog1)'
	[ -n "$(ttUCF)" -a -f "$(ttUCF)" ] || ( echo ' you should define the ttUCF as the top UCF file in Makefile.env and run again.' ; echo ; exit 22 )
	       $(RUNngd)
	@echo '$(RUNngd)'             > out/$(FNngdCMD1)
	cp tmp/$(FNngdOut1NGD)    		out/$(FNngdOut1NGD).34_2
	mv tmp/$(FNngdOut1NGD)    		out/
	cp tmp/$(FNngdOut2BLD)    		out/$(FNngdOut2BLD).34_2    
	mv tmp/$(FNngdOut2BLD)    		out/


showRunHelpList +=rn   

define HelpNGDbuild


Release 14.7 - ngdbuild P.20131013 (lin64)
Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
Usage: ngdbuild [-p <partname>] {-sd <source_dir>} {-l <library>} [-ur
<rules_file[.urf]>] [-dd <output_dir>] [-r] [-a] [-u] [-nt timestamp|on|off]
[-uc <ucf_file[.ucf]>] [-aul] [-aut] [-bm <bmm_file[.bmm]>] [-i] [-intstyle
ise|xflow|silent] [-quiet] [-verbose] [-insert_keep_hierarchy] [-filter
<filter_file[.filter]>] <design_name> [<ngd_file[.ngd]>]

      -p  partname     Use specified part type to implement the design
      -sd source_dir   Add "source_dir" to the list of directories
                       to search when resolving netlist file references
      -l library       Add "library" to the list of source libraries
                       passed to the netlisters
      -ur rules_file   User rules file for netlist launcher
      -dd output_dir   Directory to place intermediate .ngo files
      -nt value        NGO file generation
                       Options:       "timestamp", "on", "off"
                       -nt timestamp: Regenerate NGO only when source
                                      netlist is newer than existing
                                      NGO file (default)
                       -nt on:        Always regenerate NGO file from
                                      source design netlists
                       -nt off:       Do not regenerate NGO files
                                      which already exist. Build NGD
                                      file from existing NGO files
      -uc ucf_file     Use specified "User Constraint File".
                       The file <design_name>.ucf is used by default
                       if it is found in the local directory.
      -r               Ignore location constraints
      -aul             Allow unmatched LOC constraints
      -aut             Allow unmatched timing group constraints
      -a               Infer pad components from ports in top-level EDIF
                       netlist (if any)
      -i               Ignore usage of default ucf file, if present
      -u               Allow unexpanded blocks in output NGD design.
      -insert_keep_hierarchy
                       Preserve hierarchical boundaries for timing simulation
                       at module boundaries for designs represented by multiple
                       input netlists.
      -bm bmm_file     Use specified ".bmm file".
      -f <cmdfile>     Read command line arguments from file <cmdfile>.
      -filter          Message Filter file name (for example "filter.filter").
                       If specified, the contents of this file will be used to 
                       filter messages from this application. The filter file 
                       can be created using Xreport.
      -intstyle ise|xflow|silent
                       Indicate contextual information when invoking Xilinx 
                       applications within a flow or project environment.
      -quiet           Only report Warning and Error messages.
      -verbose         Reports all messages
NGDBUILD:  Translates and merges the various source files of a design into a
single "NGD" design database.

endef
