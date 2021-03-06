

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

# par -w -intstyle ise -ol high -t 1 LED4_map.ncd LED4.ncd LED4.pcf

FNparEXT0:=$(PROJname)_37_4_par
FNparOut0:=obj_$(FNparEXT0)_outNCD
FNparOut1:=$(FNparOut0).ncd
FNparIn1:=$(FNmapOut1ncd)
FNparIn2:=$(FNmapOut2pcf)
FNparLog1:=log_$(FNparEXT0).txt
FNparCmd1:=cmd_$(FNparEXT0).txt

define CMDparLine1
$(ISEbin)/par              \
	-ol high    			\
	-intstyle silent		\
	-t 1					\
	../out/$(FNparIn1)      \
	$(FNparOut1)         	\
	../out/$(FNparIn2)      \

endef
CMDparLine2:= cd tmp/ && $(CMDparLine1) > ../out/$(FNparLog1)
export CMDparLine2
CMDparLine3:= (echo ; echo "... error reason :" ; grep ^ERROR ../tmp/$(FNparOut0).par ; echo ; exit 37 )


rp:=run_par_to_gen_the_last_ncd
$(rp):=Makefile.3037.par.mk
rp :
	@echo out/$(FNparLog1) > out/loging_37.txt
	@echo ;echo '---- $(rp) start --- out/$(FNparLog1)'
	      $(CMDparLine2) || $(CMDparLine3) 
	echo "$(CMDparLine2)" 	  > out/$(FNparCmd1)
	cp tmp/$(FNparOut1)  		out/$(FNparOut1).37_2
	mv tmp/$(FNparOut1)  		out/
	cp tmp/$(FNparOut0).par  	out/log2_37_$(FNparOut0).par

showRunHelpList +=rp   


define HELPparText


Release 14.7 - par P.20131013 (lin64)
Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
Usage: par [-ol std|high] [-pl std|high] [-rl std|high] [-xe n|c] [-mt on|off|1|2|3|4] [-t <costtable:1,100>] [-p] [-k]
[-r] [-w] [-smartguide <guidefile[.ncd]>] [-x] [-nopad] [-power on|off|xe] [-activityfile <activityfile[.vcd|.saif]>]
[-ntd] [-intstyle ise|xflow|silent|pa] [-ise <projectrepositoryfile>] [-filter <filter_file[.filter]>] <infile[.ncd]>
<outfile> [<constraintsfile[.pcf]>]
 
Where:
   -ol = Overall effort level. high is maximum effort.
         Default: high except Virtex-4 and Spartan-3 architectures 
                  std (standard) for older architectures 
   -pl = Placer effort level. high is maximum effort. Overrides
         any placer effort level implied by "-ol" option.
         Default: high for Virtex-4 and Spartan-3 architectures 
         Not supported for newer architectures. 
   -rl = Router effort level. high is maximum effort. Overrides
         any router effort level implied by "-ol" option.
         Default: high for Virtex-4 and Spartan-3 architectures 
         Not supported for newer architectures 
   -xe = Extra effort level. c (Continue on Impossible) is maximum effort.
         Default: none
   -mt = Multi-threading enabled. 4 is the maximum number of threads.
         Default: off except Virtex-4 and Spartan-3 architectures 
         Supported only for newer architectures. 
   -t =  Placer cost table entry. Start at this entry.
         Default: 1 for Virtex-4 and Spartan-3 architectures 
         Not supported for newer architectures 
   -p =  Don't run the placer. (Keep current placement)
   -k =  Re-entrant route. Keep the current placement. Continue the routing
         using the existing routing as a starting point.
   -r =  Don't run the router.
   -w =  Overwrite. Allows overwrite of an existing file (including input
         file). If specified output is a directory, allows files in
         directory to be overwritten.
   -f =  Read par command line arguments and switches from file.
   -filter = Message Filter file name (for example "filter.filter"). If 
         specified, the contents of this file will be used to filter messages 
         from this application. The filter file can be created using Xreport.
   -smartguide = Enables SmartGuide using guidefile.ncd as the guide file. 
   -x =  Ignore user timing constraints in physical constraints file and 
         generate timing constraints automatically for all internal clocks to 
         increase performance. Note: the level of performance achieved will 
         be dictated by the effort level (-ol std|high) chosen.
   -nopad = Turns off generation of the pad report.
         Default: Pad Report Generated
   -power = Power Aware Par.  Optimizes the capacitance of non-timing-driven
            design signals.
         Default: off
   -activityfile <activityfile.vcd|saif> = Switching activity data file to 
            guide power optimization.  This option is only valid if the 
            "-power on" option has been used. 
   -intstyle = Indicate contextual information when invoking Xilinx applications 
	 within a flow or project environment.
         The mode "xflow" indicates that the program is being run as part of a 
         batch flow. The mode "silent" indicates that no output will be 
	 displayed to the screen. The mode "ise" indicates that the program is being
	 run as part of an integrated design environment. 
         Default: Program is run as a standalone application.
   -ise = Use supplied ISE project repository file.
   -ntd = Ignore Timing constraints in physical constraints file and do NOT
         generate timing constraints automatically.
   <infile>  = Name of input NCD file.
   <outfile> = Name of output NCD file or output directory.
               Use format "<outfile>.ncd" or "<outfile>.dir".
   <pcffile> = Name of physical constraints file.

   PAR: Places and Routes a design's logic components (mapped physical logic 
        cells) contained within a NCD file based on the layout and timing
	requirements specified within the Physical Constraints File (PCF).

endef
