

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

# nowX/FPGA_TOP.cmd_log
# trce -intstyle ise -v 3 -s 4 -n 3 -fastpaths -xml FPGA_TOP.twx FPGA_TOP.ncd -o FPGA_TOP.twr FPGA_TOP.pcf 

FNtrceEXT0:=$(PROJname)_38_5_trce
FNtrceOut0:=obj_$(FNtrceEXT0)_out
FNtrceOUTxml:=$(FNtrceOut0).xml.twx
FNtrceOUTtwr:=$(FNtrceOut0).twr
FNtrceINncd:=$(FNparOut1)
FNtrceINpcf:=$(FNmapOut2pcf)

FNtrceLog1:=log_$(FNtrceEXT0).txt
FNtrceCmd1:=cmd_$(FNtrceEXT0).txt

define CMDtrceLine1
$(ISEbin)/trce             \
	-intstyle silent		\
	-v 3    				\
	-s 4					\
	-fastpaths				\
	\
	\
	-xml ../out/$(FNtrceOUTxml)     \
	-o ../out/$(FNtrceOUTtwr)     \
	\
	\
	../out/$(FNtrceINncd)     \
	\
	../out/$(FNtrceINpcf)     \

endef
CMDtrceLine2:= cd tmp/ && $(CMDtrceLine1) > ../out/$(FNtrceLog1)
export CMDtrceLine2


rt:=run_trce_to_gen_the_last_ncd
$(rt):=Makefile.3038.trce
rt :
	@echo out/$(FNtrceLog1) > out/loging.txt
	@echo ;echo '---- $(rt) start --- out/$(FNtrceLog1)'
	      $(CMDtrceLine2)
	echo "$(CMDtrceLine2)" 	  > out/$(FNtrceCmd1)
	#cp tmp/$(FNtrceOut1)  		out/$(FNtrceOut1).2
	#mv tmp/$(FNtrceOut1)  		out/
	#cp tmp/$(FNtrceOut0).trce  	out/log2_$(FNtrceOut0).trce

showRunHelpList +=rt   


define HELPtrceText

Release 14.7 - Trace  (lin64)
Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.


Usage: trce [-e|-v [<limit:0,2000000000>]] [-l <limit:0,2000000000>] [-n
[<limit:0,2000000000>]] [-u [<limit:0,2000000000>]] [-a] [-s <speed>] [-o
<report[.twr]>] [-stamp <stampfile>] [-tsi <tsifile[.tsi]>] [-xml
<report[.twx]>] [-nodatasheet] [-timegroups] [-fastpaths] [-noflight] [-intstyle
ise|xflow|silent] [-ise <projectfile>] [-filter <filter_file[.filter]>]
<design[.ncd]> [<constraint[.pcf]>]

<design[.ncd]>     ... Xilinx physical design file (no default)
<constraint[.pcf]> ... optional physical constraint file (default design.pcf)
-o <report[.twr]>  ... report output file (default design.twr)
-xml <report[.twx]> ... XML report output file (default design.twx)
-e [<limit>]       ... produce detailed error report for timing constraints
                       optionally limited to the number of items specified by
                       <limit>
-v [<limit>]       ... produce verbose timing report for timing constraints
                       optionally limited to the number of items specified by
                       <limit>
-l [<limit>]       ... produce timing report for timing constraints
                       optionally limited to the number of items specified by
                       <limit>
-n [<limit>]       ... report paths per endpoint (default is per constraint).
                       Limited to the number of endpoints specified by <limit>.
                       Worst value between setup and hold is used to identify
                       endpoint to report, using that endpoint for both setup
                       and hold details. Use -fastpaths, to report unique
                       endpoints for worst setup and worst hold. The -v <limit>
                       value, dictates the number of reported paths per
                       endpoint. This switch requries -v or -e
-s <speed>         ... run analysis with the speed grade specified by <speed>.
                       This switch requries -v or -e
-a                 ... perform advanced design analysis in the absence
                       of a physical constraint file. This switch requires
                       -v or -e
-u [<limit>]       ... report unconstrained paths optionally limited to the
                       number of items specified by <limit>. This switch
                       requries -v or -e
-f <filename>      ... use the file specified by <filename> as command input
-stamp <stampfile> ... optionally generate STAMP model and data files. This
                       switch requires -v or -e
-tsi <tsifile[.tsi]> ... produce timing specification interaction report. This
                         switch requries -v or -e
-nodatasheet       ... do not create the datasheet section of the report. This
                       switch requires -v or -e
-timegroups        ... create the table of timegroups section of the report
                       This switch requires -v or -e
-fastpaths         ... report fastest paths/verbose hold paths. This switch
                       requires -v or -e
-filter <filter_file[.filter] ... Message Filter file name (for example
                       "filter.filter"). If specified, the contents of this
                       file will be used to filter messages from this
                       application. The filter file can be created using
                       Xreport. This switch requires -v or -e
-noflight          ... turn off the package flight delay
-intstyle <style>  ... use the specified style: ise, xflow, or silent
-ise <projectfile> ... use the ISE project file specified by <projectfile>

TRCE: Creates a Timing Report file (TWR) derived from static timing
analysis of the Physical Design file (NCD). The analysis is typically
based on constraints included in the optional Physical Constraints
file (PCF).


endef
