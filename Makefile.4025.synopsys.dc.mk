all:

$(if $(synopsysPATH),,$(error 'you should define the synopsysPATH and run again'))

# http://www.ece.ubc.ca/~edc/464/xilinx.html
# setenv XACT /usr/applic/XSI
# setenv PATH ${XACT}/bin/sparc:${PATH}
# .synopsys_dc.setup

define DCconfig01

set cache_read "/tmp"
set cache_write "/tmp"

set_app_var designer 		"dyn" ;
set_app_var company  		"C-matrixtech_Zhuhai_China";
set 		plot_command 	"lpr -P PRINTER" ;

set_app_var search_path { \
	.  \
	$(DC_HOME)/libraries/syn \
	$(RTLhdlSearch) \
	}

set_app_var link_library { \
	"*" \
	dw_foundation.sldb \
	lsi_10k.db \
	}

set_app_var target_library { \
	lsi_10k.db \
	}

set_app_var symbol_library { \
	lsi_10k.sdb \
	}

set_app_var synthetic_library { \
	standard.sldb \
	dw_foundation.sldb \
	}


define_design_lib WORK -path $(tmpRunDir2)/dcWORK

set_app_var compile_fix_multiple_port_nets 		true

set_app_var bus_naming_style 					"%s<%d>"
set_app_var bus_dimension_separator_style 		"><"
set_app_var bus_inference_style 				"%s<%d>"

set 		xnfout_library_version 				"2.0.0"

endef
export DCconfig01

define DCconfig02
$(DCconfig01)
endef
export DCconfig02

define DCscript01

#check_library

 $(foreach aa1,$(RTLhdlList),analyze -format verilog $(DCdefine) $(aa1)$(EOL))

elaborate $(topModule)

#set_port_is_pad "*"
#insert_pads

current_design $(topModule)

link

uniquify

#set_wire_load_model 								-name SMALL
#set_wire_load_mode           						$(topModule)
set_wire_load_mode           						top

#set_operating_conditions WORST

create_clock -period 33 -waveform [list 0 16.5] 	$(topClk)
set_clock_latency 2.0 								[get_clocks $(topClk)]

set_clock_uncertainty -setup 3.0 					[get_clocks $(topClk)]
set_clock_transition 0.1							[get_clocks $(topClk)]
#set_dont_touch_network								[list $(topClk)]

#set_driving_cell -cell BUFF1X -pin Z 				[all_inputs]
set_drive 0 										[list $(topClk)]

set_input_delay		20.0	-clock $(topClk) -max 	[all_inputs]
set_output_delay	10.0	-clock $(topClk) -max 	[all_outputs]

set_max_area 0
set_fix_multiple_port_nets	-buffer_constants -all



#check_library
compile

current_design

#report_units
report_clocks
report_clock_tree
# report_design_lib
report_design
report_area
#report_power
###### check_design
report_port
report_hierarchy
report_synthetic 
# report_synthetic *
# report_synthetic */*
report_qor

#report_fpga
#report_timing

#replace_fpga

#create_schematic
#plot

#write -format xnf -hierarchy -output asg3.sxnf

#echo "now , you can exit DC and run : xmake -P 4003APC84-6 asg3 "

#exit


endef
export DCscript01

define DCscript02

quit

endef
export DCscript02


cvd:=clean_dc_tmp_file
cvd:
	rm -f \
		.synopsys_dc.setup  	\
		command.log  			\
		scr_dc.script??.scr  	\
		default.svf  			\
		filenames.log			\
		log.dc.log??.txt  		\
		\
		*.pvl *.syn *.mr \

	rm -fr \
		dcWORK	


bd1:=synopsys_DC_open_and_wait_for_cmd
bd1:
	@echo
	@#echo "$${DCconfig01}" 	> 	.synopsys_dc.setup
	@echo -n 				> 	.synopsys_dc.setup
	echo "$${DCconfig02}" 	> 	scr_dc.script01.scr
	echo "$${DCscript01}" 	>>	scr_dc.script01.scr
	DC_HOME=$(DC_HOME) 						\
	DESIGNCOMPILER=$(DC_HOME) 				\
	$(synopsysBIN)/dc_shell-xg-t  		\
	-f scr_dc.script01.scr					\
	-output_log_file log.dc.log01.txt
	echo ;cat log.dc.log01.txt |grep -i error 	|| echo 'no error'
	echo ;cat log.dc.log01.txt |grep -i Warning 	|| echo 'no Warning'
	echo ;cat log.dc.log01.txt |grep ' Count:' 
	@echo

bd2:=synopsys_DC_check_then_quit
bd2:
	@echo
	@#echo "$${DCconfig01}" 	> 	.synopsys_dc.setup
	@echo -n 				> 	.synopsys_dc.setup
	echo "$${DCconfig02}" 	> 	scr_dc.script02.scr
	echo "$${DCscript01}" 	>>	scr_dc.script02.scr
	echo "$${DCscript02}" 	>>	scr_dc.script02.scr
	DC_HOME=$(DC_HOME) 						\
	DESIGNCOMPILER=$(DC_HOME) 				\
	nohup								\
	$(synopsysBIN)/dc_shell-xg-t  		\
	-f scr_dc.script02.scr					\
	> log.dc.log02.txt ; echo
	echo ;cat log.dc.log02.txt |grep -i error 	|| echo 'no error' ; echo
	echo ;cat log.dc.log02.txt |grep -i Warning 	|| echo 'no Warning'
	echo ;cat log.dc.log02.txt |grep ' Count:' 
	@echo

wd1:=clean_then__$(bd1)
wd2:=clean_then__$(bd2)
$(wd1):=cvd bd1
$(wd2):=cvd bd2
wd1:$($(wd1))
wd2:$($(wd2))

dcCheck : wd2

synopsysDC_OpList:=cvd bd2 wd1 wd2

define DChelp

/e/eda2331/DC_201603/bin/dc_shell-t -help

Usage:  /e/eda2331/DC_201603/linux64/syn/bin/common_shell_exec
	-shell % (Shell Name psyn_shell/dc_shell/dc_sms_shell/de_shell/lc_shell/ptxr)
	-r % (synopsys root path)
	-f % (execute_command file (optional))
	-x % (command to execute (optional))
	-no_init (don't load initialization files (optional))
	-no_home_init (don't load home .synopsys file (optional))
	-no_local_init (don't load local .synopsys file (optional))
	-checkout % (check out these features (optional))
	-timeout # (exit if license server fails to respond
                    after these number of minutes (optional))
	-wait # (exit if feature_list is not all available
                 after these number of minutes (optional))
	-version (show product version and exit immediately (optional))
	-64bit (use 64-bit executable (optional))
	-no_log (don't log commands (optional))
	-output_log_file % (log console output to a file (optional))
	-help  (display this information)
	-galaxy (Galileo license backward compatibility mode)
	-gui (run shell with gui (optional))
	-no_gui (run shell without gui (optional))
	-topographical_mode (run shell in Topographical mode. By default, de_shell commands run in topographical mode)


/e/eda2331/DC_201603/bin/dc_shell-t -help

endef


