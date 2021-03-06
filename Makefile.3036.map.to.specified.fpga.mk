

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

# map -intstyle ise -p xc3s500e-pq208-4 -cm area -ir off -pr off -c 100 -o LED4_map.ncd LED4.ngd LED4.pcf

FNmapEXT0:=$(PROJname)_36_3_map
FNmapOut0:=obj_$(FNmapEXT0)
FNmapOut1ncd:=$(FNmapOut0).ncd
FNmapOut2pcf:=$(FNmapOut0).pcf
FNmapIn1:=$(FNngdOut1NGD)
FNmapLog1:=log_$(FNmapEXT0).txt
FNmapCmd1:=cmd_$(FNmapEXT0).txt

define CMDmapLine1
$(ISEbin)/map 				\
	-p $(DEV01) 			\
	-detail 				\
	-c 100 					\
	-cm area 				\
	-intstyle silent		\
	-ir off           		\
	-pr off 				\
	-o $(FNmapOut1ncd) 		\
	../out/$(FNmapIn1) 		\
	$(FNmapOut2pcf) 			\

endef
CMDmapLine2:= cd tmp/ && $(CMDmapLine1) > ../out/$(FNmapLog1)
export CMDmapLine2
CMDmapLine3:= (echo ; echo "... error reason :" ; grep ^ERROR ../tmp/$(FNmapOut0).map ; echo ; exit 35 )

rm:=run_map_to_target_fapga
$(rm):=Makefile.3036.map.to.specified.fpga.mk
rm :
	echo out/$(FNmapLog1) > out/loging.txt
	@echo ;echo '---- $(rm) start --- out/$(FNmapLog1)'
	$(CMDmapLine2) || $(CMDmapLine3)
	@echo "$(CMDmapLine2)" > out/$(FNmapCmd1)
	cp  tmp/$(FNmapOut1ncd)   		out/$(FNmapOut1ncd).36_2
	mv  tmp/$(FNmapOut1ncd)   		out/
	cp  tmp/$(FNmapOut2pcf)   		out/$(FNmapOut2pcf).36_2
	mv  tmp/$(FNmapOut2pcf)   		out/
	mv  tmp/$(FNmapOut0).map   	out/log2_36_$(FNmapOut0).map
	mv  tmp/$(FNmapOut0).mrp   	out/log2_36_$(FNmapOut0).mrp
	mv  tmp/$(FNmapOut0).ngm   	out/$(FNmapOut0).36_2.ngm
	make check_io_standard
cio:=check_io_standard
cio:
	echo ;  grep OUTPUT  out/log2_36_$(FNmapOut0).mrp |$(awk) -F \| '{print $$5 " " $$8 }' |sort -u ; echo

showRunHelpList +=rm    cio

define HELPmapSpartan3e


Release 14.7 - Map P.20131013 (lin64)
Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.

Usage: map [-p <part>] [options] [-o <outfile[.ncd]>] <infile[.ngd]>
           [<pcffile[.pcf]>]

    where:
   -bp               Map slice logic into unused block RAMs.
   -c <packfactor>   Pack unrelated logic into clbs.  <packfactor> indicates
                       what % of CLB resource to target.  Range: 0 <= 
                       <packfactor> <= 100 (default is 100).
   -cm area|speed|balanced
                     Cover mode.  Default is "area".  Synthesis based designs 
                       are not likely to see improvement by changing the 
                       default.
   -detail           Print a more verbose map report. 
   -f <cmdfile>      Read command line arguments from file <cmdfile>.
   -filter  
                     Message Filter file name (for example "filter.filter").
                     If specified, the contents of this file will be used to 
                     filter messages from this application. The filter file 
                     can be created using Xreport.
   -ignore_keep_hierarchy
		     Ignore any KEEP_HIERARCHY properties attached to blocks
   -intstyle ise|xflow|silent|pa
                     Reduce the screen output.
   -ir [off|place|all]
                     Do not use RLOC constraints to generate RPMs. 
                     Default is "off". Use RLOCs to group logic together 
                     within a CLB, but not to control the relative placement 
                     of CLBs with respect to each other.
   -ise <iseProjectFile>
                     Use supplied ISE project file.
   -l                Disable logic replication.
   -logic_opt off|on Perform physical synthesis combinatorial logic
                       optimizations during timing driven packing
                       (default is off).
   -ntd              Perform non-timing driven placement when used with -timing.
   -o                Specify the output file name.
   -ol std|high      Effort level.
   -p <partname>     Map to part <partname>.
   -power off|on     Power optimizations.
   -activityfile <activityfile.vcd|.saif> 
                     Switching activity data file to guide power optimizations
   -pr off|i|o|b     Pack internal flops/latches into input IOBs (i),
                       output IOBs (o), both types of IOBs (b), or internal
                       fabric such as slices, BRAMs, or DSP blocks (off).
                       Default is off.
   -register_duplication [off|on]
                     Duplicate registers/luts during timing-driven packing 
                     in order to improve timing.
   -smartguide <guidefile>
                     Enables SmartGuide using guidefile.ncd as the guide file.
                       guidefile.ncd must be a placed and routed ncd.
   -t <costtable>    Timing-driven cost table entry.  Range:  1 <= <costtable> 
                       <= 100 (default is 1).
   -timing           Perform a timing-driven packing.
   -u                Do not remove unnecessary/disabled logic.
   -x                Enable Performance Evaluation Mode. In this mode, the 
                     tools will ignore any timing constraints specified in 
                     a constraints file and auto-generate timing constraints 
                     to drive tool performance.
   -xe c|n           Extra effort level for timing-driven packing.  'c' means
                       continue to improve timing even if timing constraints
                       cannot be met.  'n' means try additional algorithms to 
                       meet timing.

MAP:  Maps the logic gates of the user's design (previously written to an NGD
file by NGDBUILD) into the Slices and IOBs of the physical device, and writes
out this physical design to an NCD file.

endef
