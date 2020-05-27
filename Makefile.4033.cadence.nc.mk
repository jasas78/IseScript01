all:

$(if $(cadencePATH),,$(error 'you should define the cadencePATH and run again'))

VERDI_HOME?=/e/eda2312/verdi_2018.09

bn1_ENV:= \
	LD_LIBRARY_PATH=$(VERDI_HOME)/share/PLI/IUS/linux64/boot	\
	NC_HOME=$(NC_HOME) 											\
	VERDI_HOME=$(VERDI_HOME)                    				\
    LM_LICENSE_FILE=$(LM_LICENSE_FILE)                          \
    VRST_HOME=$(NC_HOME)                      					\
    PATH=$(NC_HOME)/tools.lnx86/bin/64bit:$(NC_HOME)/bin:$${PATH}


bn1_CMD1:= \
	$(bn1_ENV)       xmvlog 				\
	-messages 								\
	-define VERDI_HOME=\"1\"				\
	$(NCrtlHdlSearch)			            \
	$(TBhdlList)           $(RTLhdlList) 

bn1_CMD2:= \
	$(bn1_ENV)  		    xmelab 			\
	-loadpli1 debpli:novas_pli_boot 		\
	-NOLICSuspend -messages 				\
	-access +r+w+c 							\
	$(topModule)

bn1:=cadence_NC_build_only___withouth_Verdi_FSDB
bn1:
	@echo
	@echo    --------- process $@ ------- begin
	cd $(tmpRunDir2) && $(bn1_CMD1)
	@echo;echo
	cd $(tmpRunDir2) && $(bn1_CMD2)
	@echo    --------- process $@ ------- end
	@echo

ncPara1:= -lca -debug_access+all -full64 


bn2_CMD:= \
	NC_HOME=$(NC_HOME)                \
	VERDI_HOME=$(VERDI_HOME)            \
	$(cadenceBIN)/nc  	            \
	$(ncPara1)   			            \
	$(NCdefine)   			            \
	$(NCrtlHdlSearch)			            \
	$(TBhdlList) $(RTLhdlList) 
bn2:=cadence_NC_build___with_Verdi_FSDB
bn2:
	@echo    --------- process $@ ------- begin
	@pwd
	cd $(tmpRunDir2) && $(bn2_CMD) 				
	@echo    --------- process $@ ------- end


cvn:=clean_nc_tmp_file
cvn:
	mkdir -p $(tmpRunDir2) 
	cd $(tmpRunDir2) && rm -f \
		opendatabase.log \
		*.vcd \
		*.vcd.vpd \
		inter.vpd \
		command.log \
		$(tmpRunDir2)/verdi.fsdb			\
		verdi.fsdb			\
		novas_dump.log			\
		Simv simv ucli.key 
	cd $(tmpRunDir2) && rm -fr \
		DVEfiles \
		simv.daidir/ \
		csrc/

tn1:=run_the_test_of_NC___without_Verdi_FSDB
tn1:
	@echo
	rm -f verdi.fsdb $(tmpRunDir2)/verdi.fsdb
	cd $(tmpRunDir2) && ./simv
	pwd
#	cp $(tmpRunDir2)/verdi.fsdb ./
	@echo

tn2:=run_the_test_of_NC___with_Verdi_FSDB
tn2:
	@echo
	rm -f verdi.fsdb $(tmpRunDir2)/verdi.fsdb
	pwd
	cd $(tmpRunDir2) && LD_LIBRARY_PATH=$(VERDI_HOME)/share/PLI/NC/linux64   \
					./simv
	pwd
#	cp $(tmpRunDir2)/verdi.fsdb ./
	@echo

wn1:=all_nc_without_Verdi_FSDB
$(wn1):=cvn bn1 tn1
wn1: $($(wn1))

wn2:=all_nc_with_Verdi_FSDB
$(wn2):=cvn bn2 tn2
wn2:$($(wn2))

cadenceNC_OpList:=cvn bn1 bn2 tn1 tn2 wn1 wn2

define NChelp

xmvlog: 19.09-s001: (c) Copyright 1995-2019 Cadence Design Systems, Inc.
  Usage:
	xmvlog [options] source_file ...

  Options:
	-64BIT                       -- Invoke 64 bit executable
	-ABV2COPT                    -- Enable optimization for two cycle implication style assertion
	-ABVEVALNOCHANGE             -- Reverses optimization for no-change in inputs expressions scenario
	-ABVNOEBSINAOPT              -- Enable finish->inactive transition in single cycle SVA
	-ABVRECORDDEBUGINFO          -- Enhance debugging message for concurrent assertions
	-ABVRECORDVACUOUS            -- Enable recording of vacuous and attempts counts
	-AMS                         -- Enable ams parsing
	-APPEND_LOG                  -- Append the log to an existing logfile
	-ASSERT                      -- Enable PSL language features
	-CBNOFORWARDCLOCKINGEVENT    -- Don't allow identifier in clocking event of clocking block to be declared after the block
	-CDSLIB <arg>                -- Specifies the cds.lib file to be used
	-CDS_ALTERNATE_TMPDIR <arg>  -- Specify alternate location for reading design data
	-CDS_IMPLICIT_TMPDIR <arg>   -- Specify location for design data storage
	-CDS_IMPLICIT_TMPONLY        -- Force xmvlog to read design data only from the TMPDIR area
	-CD_LEXPRAGMA                -- process verilog preprocessor directive before lexical pragmas
	-CHECKTASKS                  -- Checks that all $tasks are predefined system tasks
	-CLASSLINEDEBUG              -- Enable line debug only for design units with classes
	-CMDFILE <arg>               -- Specifies a configuration file for design-top compilation
	-COMPARE_STRICT_TIMESCALE    -- Compare strict LRM timescale calculation and default
	-COMPCNFG                    -- Compile Verilog configuration in source HDL
	-CONFIG_ALLOW_ESCAPED_NAME   -- Support escaped names inside Verilog config blocks
	-CONTROLASSERT <arg>         -- Specifies a file containing assertion control statements
	-CP_EXPR_AS_NAME             -- Use coverpoint expression as its name 
	-DEFAULT_SPICE_OOMR          -- Use default value for Spice OOMR
	-DEFINE <arg>                -- Defines a macro
	-DELAY_TRIGGER               -- Delay triggering of @ waiters
	-DESIGN_TOP <arg>            -- Specifies top design-unit for design-top compilation
	-DISABLE_CF                  -- Disable marking system functions as const expr
	-DISABLE_DBITS               -- Disable improved $bits behavior
	-DISABLE_FAST_DECOMPRESS     -- Disable faster decompression of compressed files (prepared by gzip or compress)
	-ENABLE_CF                   -- Enable marking system functions as const expr
	-ENABLE_DBITS                -- Enable improved $bits behavior
	-ENABLE_STRICT_TIMESCALE     -- Enable strict LRM timescale calculation
	-ENABLE_SVAFUNCCALLFIX       -- Enable function call sampling and evalaution in assertions
	-ERRORMAX <arg>              -- Specifies the maximum number of errors processed
	-ESCAPEDNAME                 -- Prints out escaped name of the design unit
	-FILE <arg>                  -- Load command line arguments from <arg>
	-GENASSERT_SYNTH_PRAGMA      -- Enable generation of assertions from synthesis pragmas
	-HDLVAR <arg>                -- Specifies the hdl.var file to be used
	-HELP                        -- Prints this message
	-IAL <arg>                   -- Specifies the configuration of the IAL verification library to be compiled
	-IEEE1364                    -- Report errors according to the IEEE 1364 standard
	-IGNORE_PRAGMA <arg>         -- Ignore the specified pragma
	-IGNORE_SPICE_OOMR           -- Ignore Spice OOMR
	-INCDIR <arg>                -- Specifies an include directory 
	-LEXPRAGMA                   -- Enable Lexical Pragma processing
	-LIBCELL                     -- Mark all cells with `celldefine
	-LIBMAP <arg>                -- Specify the Verilog library mapping file
	-LINEDEBUG                   -- Enable line debug capabilities
	-LOGFILE <arg>               -- Specifies the file to contain log information
	-MESSAGES                    -- Specifies printing of informative messages
	-MODELINCDIR <arg>           -- to specify a list of directories separated by ':'
	-MODELPATH <arg>             -- to specify a list of source files/directories of source files [with/without section identifiers]
	-NEVERWARN                   -- Disables printing of all warning messages
	-NEWPERF                     -- Umbrella option for new performance optimizations
	-NOASSERT_SYNTH_PRAGMA       -- Disable generation of assertions from synthesis pragmas
	-NOCOPYRIGHT                 -- Suppresses printing of copyright banner
	-NOLINE                      -- Do not locate source line on errors
	-NOLINK                      -- When using 5x structure do not create links
	-NOLOG                       -- Suppress generation of the default logfile
	-NOMEMPACK
	-NOPRAGMAWARN                -- Disable pragma related warning messages.
	-NOSTDOUT                    -- Turn off output to screen
	-NOWARN <arg>                -- Disables printing of the specified warning message
	-NXMBIND  [Deprecates: NNCBIND] -- Turn on new SV bind. This implementation is now available as default, hence the switch need not be specified any longer.
	-OVL <arg>                   -- Specifies the configuration of the OVL verification library to be compiled
	-OXMBIND                     -- Use old SV bind flow.
	-PARSEINFO <arg>             -- Print tick-inlcude full path information. 
	-PERFLOG <arg>               -- Writes performance statistics in the specified file
	-PERFSTAT                    -- Writes performance statistics in xmperfstat.out
	-PLUSPERF                    -- Umbrella option for simulation perf optimizations
	-PRAGMA                      -- Enable pragma processing
	-PROPDIR <arg>               -- Specifies the directory to consider when searching for external property files
	-PROPEXT <arg>               -- Specifies extensions to consider when searching for external property files
	-PROPFILE <arg>              -- Specifies a file containing PSL verification code
	-PROPSPATH <arg>             -- to specify an occurence property data base file
	-QUIET                       -- No error/warning summary output
	-RMKEYWORD <arg>             -- Specifies the keyword to be removed
	-RNM_RELAX                   -- Non-compliant IEEE 1800 usage for Real Number Modeling
	-SCU                         -- Multiple compile unit while compiler directives are cleared at end of each file
	-SHORTREAL                   -- Enables shortreal parsing
	-SPECIFICUNIT <arg>          -- Only compile the specified unit from the source file
	-SPECTRE_E                   -- run spectre parser with '-E' option (cpp on) when parsing files specified by -MODELPATH
	-SPECTRE_SPP                 -- run spectre parser with '-SPP' option (spp on) when parsing files specified by -MODELPATH
	-STATUS                      -- dump out the status line at the end
	-SV                          -- Enable SystemVerilog features
	-SYSV05                      -- Enable SystemVerilog features with only SV-2005 and earlier keywords
	-SYSV09                      -- Enable SystemVerilog features with only SV-2009 and earlier keywords
	-SYSV2005                    -- Enable SystemVerilog features with only SV-2005 and earlier keywords
	-SYSV2009                    -- Enable SystemVerilog features with only SV-2009 and earlier keywords
	-UNADORNED_CLASS_CHK         -- Detect SV rule about unadorned references to parameterized classes in scope operators
	-UNCLOCKEDSVA                -- Unclocked assertion support in SystemVerilog
	-UNIT <arg>                  -- Specifies the unit to be compiled upon invocation
	-UPCASE                      -- Changes all identifiers to upper case (case insensitive)
	-UPDATE                      -- Check if unit is up-to-date before writing
	-UPTODATE_MESSAGES           -- print module name even if it is up-to-date
	-USE5X                       -- Enable full 5.x library system operation
	-UVMACCESS                   -- Enable uvm debug APIs
	-UVMLINEDEBUG                -- Enable uvm line debug capabilities
	-UVMPACKAGENAME <arg>        -- Provide UVM package name
	-V01                         -- Turn off new Verilog-2005 keywords
	-V1995                       -- Turn off new Verilog-2001 keywords
	-V2001                       -- Turn off new Verilog-2005 keywords
	-V95                         -- Turn off new Verilog-2001 keywords
	-VERSION                     -- Prints the version number
	-VIEW <arg>                  -- Specifies the view association
	-VTIMESCALE <arg>            -- Define the initial timescale for files on the command line
	-WORK <arg>                  -- Specifies the work library association
	-XMALLERROR                  -- Increases the severity of all warnings to error.
	-XMERROR <arg> [Deprecates: NCERROR] -- Increases the severity of a warning to an error
	-XMFATAL <arg> [Deprecates: NCFATAL] -- Increases the severity of a warn/error to a fatal
	-XMNOTE
	-ZLIB <arg>                  -- Compress PAK file using level 1 to 9, with 1 being the default value
	-ZPARSE <arg>                -- enable zparsing 

  Examples:
	-- To compile all the modules in source.v
	   % xmvlog source.v
	
	-- To compile with informative messages
	   % xmvlog -messages source.v

xmelab: 19.09-s001: (c) Copyright 1995-2019 Cadence Design Systems, Inc.
  Usage:
	xmelab [options] [lib.]cell[:view]

  Options:
	-64BIT                                -- Invoke 64 bit executable
	-ABVDISABLEASRTST                     -- Disable ASRTST failure and finish message of system verilog assertions which have corresponding action block
	-ACCESS <arg>                         -- Set default access visibility. {+rwc} turn on read/write/connectivity.
	-ACCESSREG <arg>                      -- Set default access visibility for registers only. {+rwc} turn on read/write/connectivity.
	-ACCU_PATH_DELAY                      -- Enable the enhanced timing features
	-ACCU_PATH_VERBOSE                    -- Enable warnings during ETO characterization
	-ADD_SEQ_DELAY <arg>                  -- Update undelayed sequential UDPS to have delays
	-ADV_MS                               -- turn on some advanced ms feature 
	-AFILE <arg>                          -- Access file.
	-ALLOWINDEXVIOLATION                  -- Enable index violation handling for xprop enabled hierarchy
	-ALWAYS_TRIGGER                       -- Enable always trigger mode
	-AMS_DIG_WREAL                        -- Keep wreal net in discrete domain
	-AMS_FLEX_RELEASE                     -- To enable AMSD Flexible Release Matrix flow
	-AMS_SVINTF                           -- Enable SV interface in AMS
	-AMS_WEAK_SETD                        -- setd has lower priority than propagated discipline
	-AMSDROPT                             -- AMS discipline resolution optimization 
	-AMSFASTSPICE                         -- use fastspice simulator (ultrasim)
	-AMSINPUT <arg>                       -- Specifies the AMSD control block file to be used
	-AMSMATLAB                            -- dynamically link vpi code for AMS/Matlab
	-AMSPARTINFO <arg>                    -- mixed-signal partition information
	-ANALOGCONTROL <arg>                  -- Analog Simulation control file
	-ANNO_SIMTIME                         -- Enables delay annotation at simulation time
	-APPEND_LOG                           -- Append the log to an existing logfile
	-ARMFM <arg>                          -- Allow simulation of given Fast Model from ARM (e.g. ARM926CT, ARMCortexM3CT, etc.) or invoke ARM model-specific capability (e.g. modeldebugger, rvdebug, debug, trace, image)
	-ARR_ACCESS                           -- Allow tf_nodeinfo access by turning off verilog array layout optimization
	-ATSTAR_LSP                           -- Use longest static prefix rule for @* 
	-ATSTAR_SELFTRIGGER                   -- Use self-triggering behavior of always@(*) blocks 
	-AUTOSPICEIGNORE <arg>                -- ignore spice oomrs (and set to 0|1|X|Z)
	-AUTOSPICEOOMR                        -- process spice oomrs
	-AUTOXSPICE                           -- process spice oomrs, add prefix 'X' to each spice instance
	-BB_CELL_LIST <arg>                   -- List of Black boxes lib.cell:view
	-BBCELL <arg>                         -- Black box lib.cell:view
	-BBCONNECT                            -- Preserve the BBcell, BB_cell_list instantiation and port mapping information
	-BBINST <arg>                         -- Black box instance name
	-BBLIST <arg>                         -- List of instances which will be back boxed
	-BBOX_CREATE <arg>                    -- Copied all the dependents to their corresponding implicit tmp directories
	-BBOX_LINK <arg>                      -- Copied all the dependents to their corresponding implicit tmp directories
	-BBOX_OVERWRITE                       -- overwrite the content of the tmp directory
	-BBVERBOSE                            -- Verbose output of BBINST option
	-BINDING <arg>                        -- Force an explicit sub-module or sub-unit L.C:V binding
	-CATROOT <arg>                        -- Specify SystemC Model Catalog search path for .conf files
	-CCIPARAM <arg>                       -- Associate values with SystemC cci parameters
	-CDS_ALTERNATE_TMPDIR <arg>           -- Specify a read-only alternate tmpdir location
	-CDS_IMPLICIT_TMPDIR <arg>            -- Specify location for design data storage
	-CDS_IMPLICIT_TMPONLY                 -- Force xmelab to read design data only from the TMPDIR area
	-CDSLIB <arg>                         -- Specifies the cds.lib file to be used
	-CEDRIVERSLOADS                       -- Generate a Tcl file, cedriversloads.tcl, with the drivers and loads for Conversion Elements. Automatically enforces -cereport if none of -cereport or -ceverbose is explicitly specified
	-CEPROBES                             -- Generate a Tcl file, ceprobes.tcl, with the probes for Conversion Elements. Automatically enforces -cereport if none of -cereport or -ceverbose is explicitly specified
	-CEREPORT                             -- Generate VHDL-SPICE Conversion Element report
	-CEVERBOSE                            -- Generate detailed VHDL-SPICE Conversion Element report
	-CHECK_SEM2009_IMPACT                 -- check if a design might be affected by 2009 LRM semantics
	-CHECKPOINT_ENABLE                    -- Enables process-based save and restart
	-CHKDIGDISP                           -- perform digital net's discipline compatibility check
	-CMDFILE <arg>                        -- Search-path support
	-COMPILE                              -- (requires -CONFFILE) Compile the configuration file after creating it
	-CONFFILE <arg>                       -- Generate a configuration file with the given name
	-CONFFLAT                             -- (requires -CONFFILE) Generate a VHDL flat configuration declaration
	-CONFHIER                             -- (requires -CONFFILE) Generate a VHDL hierarchical configuration declaration
	-CONFIGVERBOSE                        -- Print messages for instances resolved using USE rules and first in hierarchy for LIBLIST rules from Verilog configuration 
	-CONFNAME <arg>                       -- (requires -CONFFILE) Specify the output configuration's name (top unit for the hierarchical case)
	-CONG_FILE <arg>                      -- Congruency configuration file
	-CONGRUENCY                           -- Enable congruent behavior
	-CONGVERBOSE                          -- Enable congrueny logging. Equivalent to 'set_log -on' in congruency configuration file
	-COV_CGSAMPLE                         -- Enable covergroup sampling if get_coverage() is called, even when function coverage is not enabled
	-COV_NOCGSAMPLE                       -- Disable covergroup sampling when function coverage is not enable even if get_coverage() is called (This has become default now)
	-COVDUT <arg>                         -- Name design under test for coverage
	-COVERAGE <arg>                       -- Enable coverage instrumentation
	-COVFILE <arg>                        -- Coverage Instrumentation Configuration file
	-COVPARTIAL                           -- Enable coverage instrumentation with -partialdesign/-bbinst options
	-CREATEDEBUGDB                        -- Generate data to support post simulation debug.
	-CREATEDEBUGDB_NOIES                  -- Generate debug data for third party simulators
	-DBSSNAP <arg>                        -- Current elaboration will add a package to this given snapshot
	-DEFAULT_DELAY_MODE <arg>             -- Default Delay mode {Zero,Unit,Path,Distr,Def,None}
	-DEFPARAM <arg>                       -- Associates values with Verilog parameters
	-DELAY_MODE <arg>                     -- Delay mode {Zero, Unit, Path, Distr, None}
	-DELTA_SEQUDP_DELAY                   -- Add delta delay to zero-delay sequential UDP's
	-DEPOSIT_VALUE_CHANGE                 -- Enable gate/UDP's value change on deposit
	-DFILE <arg>                          -- Random Batch Deposit configuration file
	-DISABLE_AA_ASSIGN_OPT                -- Disable AA assignment optimization
	-DISABLE_AMSDROPT                     -- disable discipline resolution optimization 
	-DISABLE_AMSOPTIE                     -- disable IE optimization - overrides AMSOPTIE
	-DISABLE_CF                           -- Disable marking system functions as const expr
	-DISABLE_CONGRUENCY                   -- Disable congruent behavior
	-DISABLE_DBITS                        -- Disable improved $bits behavior
	-DISABLE_DPES                         -- Disable Dynamic PES optimization
	-DISABLE_ENHT                         -- Disable the enhanced timing features
	-DISABLE_ETO_PULSE                    -- Disable ETO pulse modeling
	-DISABLE_OPTION <arg>                 -- disable a feature which was earlier enabled via an option but has become default now
	-DISABLE_PARAM_PARTSEL_REC            -- Disable parameter part select rectification
	-DISABLE_SEM2009                      -- do not use 2009 LRM semantics for scheduling
	-DISABLE_TF_DEADCODE                  -- Disable dead optimization for tasks/functions
	-DISCIPLINE <arg>                     -- discipline to use for undisciplined digital wires
	-DISRES <arg>                         -- to specify a mode of discipline resolution
	-DPI_VOID_TASK                        -- Return value of export and import tasks will be VOID. 
	-DPIHEADER <arg>                      -- generate the header file for export functions/tasks
	-DPIIMPHEADER <arg>                   -- generate the header file for import functions/tasks
	-DRESOLUTION                          -- Sets discipline resolution to '-disres detailed'
	-DSSDRIVERS <arg>                     -- Override the default number of drivers for the cross partition net
	-DUMP_ELAB_ARGS <arg>                 -- Saves the xmelab arguments to the specified file.
	-DUMPSTACK                            -- enable stack dump in case of error
	-DUMPTIMING <arg>                     -- Dump timing information to the given file
	-DVERBOSE                             -- Prints logs of Dfile activity
	-DYNAMICSNAP <arg>                    -- Deprecated option, use DBSSNAP instead
	-DYNVHPI                              -- Enable user to create driver at run time
	-EMHIER_DVS                           -- Enable embedded hierarchical dynamic voltage supply
	-ENABLE_AA_ASSIGN_OPT                 -- Enable AA assignment optimization
	-ENABLE_CF                            -- Enable marking system functions as const expr
	-ENABLE_DBITS                         -- Enable improved $bits behavior
	-ENABLE_DPES                          -- Enable Dynamic PES optimization
	-ENABLE_ERRCHK_DBITS                  -- Enable error checking for $bits with dynamic types
	-ENABLE_ETO_PULSE                     -- Enable  ETO pulse modeling 
	-ENABLE_FGPC_EXT                      -- process::kill on dead process will kill its descendants
	-ENABLE_INACTIVEQUEUE                 -- Enable inactive queue
	-ENABLE_MULDRVCHK                     -- Enable improved multiple driver check
	-ENABLE_PS_AP                         -- Correct datatype for part-select for assignment patterns
	-ENABLE_RELAX_MULTIPLE_DRIVER_CHECK   -- Enable constant loop unroll for multiple driver check
	-ENABLE_TF_DEADCODE                   -- Enable dead optimization for tasks/functions
	-ENCTRAN                              -- Enable CTRAN engine
	-ENFORCETO                            -- Disable TO optimization as user can force timing output gate nets
	-ENITCTRAN                            -- Enable CTRAN iterative engine
	-ENMSIECTRAN                          -- Enable CTRAN engine support with MSIE
	-ENTCHWIDTHCOND                       -- Enable condition evaluation at both edges of width tcheck
	-ENTFILEENV                           -- Allow environment variables in tfile.
	-ENTRANDELAY                          -- Allow the path delay in case source and destination are connected with tran terminal
	-EPULSE_NEG                           -- Filter cancelled events (negative pulses) to e (overrides specify block settings)
	-EPULSE_NONEG                         -- Do not filter cancelled events (negative pulses) to e (overrides specify block settings)
	-EPULSE_ONDETECT                      -- On-detect filtering of error pulses
	-EPULSE_ONEVENT                       -- On-event filtering of error pulses
	-ERRORMAX <arg>                       -- Specifies the maximum number of errors processed
	-EXPAND                               -- Force expansion of all vector nets
	-EXTBIND <arg>                        -- Bind file for binding SV/VHDL to SV/VHDL
	-EXTEND_TCHECK_DATA_LIMIT <arg>       -- Relaxes tcheck data limit 
	-EXTEND_TCHECK_REFERENCE_LIMIT <arg>  -- Relaxes tcheck reference limit 
	-EXTENDSNAP <arg>                     -- Name to use for the extended simulation snapshot
	-FACCESS <arg>                        -- Overrides any -access option.
	-FAULT_FILE <arg>                     -- Specify fault specification file
	-FAULT_HIER_ISO                       -- enable RTL hierarchial isolation
	-FAULT_LIB_MFILE <arg>                -- Specify Liberty file list for cell area calculation
	-FAULT_LOGFILE <arg>                  -- Specify a log file for fault instrument
	-FAULT_NET_JG                         -- Enable net info dump to UCM for JG
	-FAULT_NOISO_OPTS                     -- disable fault isolation optimizations
	-FAULT_OVERWRITE                      -- Overwrites the existing fault work directory
	-FAULT_TOP <arg>                      -- specify top for fault injection
	-FAULT_WORK <arg>                     -- Specify directory to save fault run results
	-FAULT_XML_FF                         -- Include sequential elements in the XML file
	-FAULT_XML_FILE <arg>                 -- Specify an xml file name for extracted information
	-FAULT_XML_GEN <arg>                  -- Specify design version and enable xml generation
	-FAULT_XML_OVERWRITE                  -- Overwrite existing XML file
	-FILE <arg>                           -- Load command line arguments from <arg>
	-FSMDEBUG                             -- Extract FSM
	-GATELOOPWARN                         -- Enable potential zero-delay gate loop warning
	-GCC_VERS <arg>                       -- Pass gcc_vers switch for DPI file compilation
	-GENAFILE <arg>                       -- Generate an access file for PLI and TCL.
	-GENERIC <arg>                        -- Associates values with top level generics
	-GENHREF <arg>                        -- Generate an href permissions file
	-GENMODAFILE <arg>                    -- Generate a module based access file for PLI and TCL.
	-GENPARTITION <arg>                   -- Generate a partition file for MSIE
	-GNOFORCE                             -- Assigns the value if default value not found
	-GPG <arg>                            -- Assigns to all generics/params of this name
	-GVERBOSE                             -- Logs the gpg activity to the xmelab logfile
	-HDLVAR <arg>                         -- Specifies the hdl.var file to be used
	-HELP                                 -- Prints this message
	-HIER_DVS                             -- Enable hierarchical dynamic voltage supply
	-HREF <arg>                           -- Href permissions file for primary snapshot
	-HWPERF_ESTIMATE                      -- Enable instrumentation for detailed -dut_prof profiling for IXCOM speedup estimation
	-ICIR_WARN                            -- enable run time warning for case inside  ranges
	-IEDEBUG_INFO                         -- generate Interface Element info report in debug mode
	-IEEE1364                             -- IEEE 1364 lint checker
	-IEINFO                               -- generate Interface Element info report
	-IEINFO_DB                            -- generate Interface Element SQLite database file
	-IEINFO_DRIVERLOAD                    -- generate IE/CE driver load probe file
	-IEINFO_DRIVERLOAD_TCL <arg>          -- redirect IE/CE driver load probe file into a specified file
	-IEINFO_LOG <arg>                     -- redirect ieinfo log into a specified file
	-IEINFO_PROBE                         -- generate Interface Element probe file
	-IEINFO_PROBE_TCL <arg>               -- redirect probe tcl file into a specified file
	-IEINFO_SUMMARY                       -- generate ieinfo log in summary mode
	-IEREPORT                             -- generate Interface Element report
	-IGNORE_SPICE_OOMR                    -- ignore spice oomrs
	-IGNR_WARNMAX <arg>                   -- Warning for which maximum warn count will be ignored
	-II_RWARN                             -- Issue a simulation-time warning when an object is read using an invalid or out-of-bound index.
	-II_VAL                               -- Issue correct value when a vector object is accessed using an invalid or out-of-bound index.
	-II_WARN                              -- Issue a simulation-time warning when an object is accessed using an invalid or out-of-bound index.
	-II_WWARN                             -- Issue a simulation-time warning when an object is written using an invalid or out-of-bound index.
	-INCRBIND <arg>                       -- Make a primary snaphsot with the given unit as a top of the incremental partition
	-INCRHASVHDL                          -- Prepare primary snapshot for VHDL in incremental
	-INCRPATH <arg>                       -- path of the primary's instance in incremental partition
	-INCRTOP <arg>                        -- Specify incremental top-level when using -GENHREF
	-INITBIOPZ                            -- Initialize boundary inout port to 'Z'
	-INITBPX                              -- Initialize VHDL boundary port to 'X'
	-INITMEM0                             -- Initialize all array variables to zero instead of x
	-INITMEM1                             -- Initialize all bits of array variables to one instead of x
	-INITREG0                             -- Initialize all non-array variables to zero instead of x
	-INITREG1                             -- Initialize all bits of non-array variables to one instead of x
	-INSERT <arg>                         -- (requires -CONFFILE & -MATCHINST) Specify the string to be inserted after the matching component instance
	-INTERMOD_PATH                        -- Make all interconnect be fully multi-source capable with programmable pulse limits
	-IO_PORT_RELAX                        -- Enable relaxed INOUT port connection 
	-LIB_BINDING                          -- Defaults back to the IUS5.4 binding search order
	-LIBMAP <arg>                         -- Specify the Verilog library mapping file
	-LIBNAME <arg>                        -- Specify the name of a library to search
	-LIBVERBOSE                           -- Print messages about resolving instances
	-LICINFO                              -- Dump out the license requirements for this design
	-LICQUEUE                             -- Use license queue mechanism
	-LOADPLI1 <arg>                       -- Specify the library_name:boot_routine(s) to dynamically load a PLI1.0 application
	-LOADSC <arg>                         -- Specify the SystemC libraries to be dynamically loaded
	-LOADVHPI <arg>                       -- Dynamically load a VHPI application 
	-LOADVPI <arg>                        -- Specify the library_name:boot_routine(s) to dynamically load a VPI application
	-LOGFILE <arg>                        -- Specifies the file to contain log information
	-LPS_1801 <arg>                       -- Specify a IEEE 1801 file for low power simulation
	-LPS_ACK_OVERRIDE                     -- Enable power switch ack port override HDL drivers  
	-LPS_ALT_LP                           -- Alternative Low Power Simulation Sematics
	-LPS_AMS_AVREF                        -- Enable supply voltage of power smart IE reference to analog domain
	-LPS_AMS_CONNECT_SUPPLY               -- Enable 1801 power supply net connection in AMS
	-LPS_AMS_LSR                          -- Enable level shifter rules in mixed-signal low power simulation
	-LPS_AMS_RELAX_PDCHK                  -- Relax power domain conflict check in mixed-signal low power simulation
	-LPS_AMS_SIM                          -- Enable power aware analog simulation in AMS
	-LPS_AMS_UCA                          -- Enable 1801 power supply net driving AMS block
	-LPS_ANALYZE                          -- Enable functionality for Power Estimation feature
	-LPS_ASSIGN_FT_BUF                    -- Disable treating continuous assignment as pass through net
	-LPS_AUX_FLOATING_PGAON               -- Consider floating pg pins as always on
	-LPS_BLACKBOXMM                       -- Treat all macro models as a black box (no corurption, no retention, no isolation).
	-LPS_CELLRTN_OFF                      -- IGNORE modules in `celldefine for SRPG
	-LPS_CONST_AON                        -- Consider constant driver as always on 
	-LPS_COV                              -- Enables automatic low power coverage
	-LPS_CPF <arg>                        -- Specify a CPF file for low power simulation
	-LPS_DBC                              -- Low Power Driver Based Corruption mode
	-LPS_DELAYVAR_CORRUPT                 -- Enable corruption of delay variables
	-LPS_DTRN_MIN                         -- Use min slope for domain transition
	-LPS_DUT_TOP <arg>                    -- Specify a top level scope for low power simulation
	-LPS_FIND_IN_CELL                     -- traverse inside the implicitly defined cells for find_objects
	-LPS_FORCE_REAPPLY                    -- Reapply user forces after domain power up
	-LPS_GEN_WILDCARD_STYLE               -- Allow to search for match across generate hierarchies
	-LPS_ICDB                             -- Use icdb as the legal extension for the precompiled liberty database
	-LPS_IMPLICITPSO_CHAR <arg>           -- User defined VHDL character ENUM
	-LPS_IMPLICITPSO_NONCHAR <arg>        -- User defined VHDL non character ENUM
	-LPS_INT_INDEX_NOCORRUPT              -- Don't corrupt VHDL integers used as array index
	-LPS_INT_NOCORRUPT                    -- Disable corruption of VHDL integer signals.
	-LPS_ISO_CHECK_ONLY                   -- Enable simulation of isolation fully inserted 
	-LPS_ISO_HYBRID                       -- Enable hybrid mode of isolation insertion 
	-LPS_ISO_NCI                          -- Remove input corruption of isolated feed through nets.
	-LPS_ISO_OFF                          -- Turn off port isolation
	-LPS_ISO_SUPPLY_AON                   -- Enable isolation to not specify a supply set
	-LPS_ISO_VERBOSE                      -- Enable information reporting for isolation
	-LPS_ISOFILTER_VERBOSE                --Enable information reporting for isolation filtering
	-LPS_ISORULEOPT_WARN                  -- Print warning for optimized and ignored Isolation rule
	-LPS_ISOTGT_SOURCE                    -- Use the source supply as the default isolation target for isolation assertions.
	-LPS_LIB_MFILE <arg>                  -- Specify a file that includes a list of liberty files 
	-LPS_LIB_SUPPLY_DETAIL                -- Use full pathname for supply net when using LPS_LIB_VERBOSE
	-LPS_LIB_VERBOSE <arg>                -- Enable liberty verbose output
	-LPS_LIBINLIB_PGPIN_CHECK             -- Enable pg pin connection check for liberty inside liberty 
	-LPS_LIBRTL_NOCHECK                   -- Disables pin and port checks between liberty and RTL
	-LPS_LOG_VERBOSE <arg>                -- Specify a log file for low power simulation LPS_VERBOSE or LPS_PSN_VERBOSE output
	-LPS_LOGFILE <arg>                    -- Specify a log file for low power simulation
	-LPS_MODEL_VERBOSE <arg>              -- Enable model verbose output
	-LPS_MODULE_LOAD                      -- Power model module load mode
	-LPS_MODULES_WILDCARD                 -- Allow wildcarding in certain CPF module names
	-LPS_MTRN_MIN                         -- Use min latency for mode transition
	-LPS_MVS                              -- Enable multi-voltage scaling (MVS) simulation 
	-LPS_NO_XZSHUTOFF                     --Don't corrupt domain when shutoff condition is X/Z
	-LPS_NONSTD_1801                      -- Enable features designed for non 1801 standard
	-LPS_NOTLP                            -- Turn off special treatment for top level ports
	-LPS_PA_MODEL_ON                      -- Enable Power aware model checking for CPF
	-LPS_PACELL_DISABLE_IC                -- Disable input and output corruption on Power Aware Models
	-LPS_PMCHECK_ONLY                     -- Power mode is for checking only
	-LPS_PMODE                            -- Enable power mode simulation
	-LPS_PSN_VERBOSE <arg>                -- Specify a level of information for PSN
	-LPS_QUERY_CMD_ALT                    -- Alternative return values for IEEE 1801 query commands
	-LPS_QUERY_CMD_FILE <arg>             -- Specify a IEEE 1801 query command file
	-LPS_RELAX_1801                       -- Enable non-strict mode for 1801 reader
	-LPS_RELAX_HIERARCHY                  -- Enable non-strict mode for hierarchy specification
	-LPS_RESTORE_LEVEL                    -- Enable restoration started at active edge for balloon style retention
	-LPS_REVERT_ERRORS2WARNINGS           -- Treat old warnings as warnings again for backward compatibility
	-LPS_RPR_OFF                          -- Turn off repeaters on ports
	-LPS_RTN_CHECK_ONLY                   -- Enable simulation of retention fully inserted 
	-LPS_RTN_HYBRID                       -- Enable hybrid mode of retention insertion 
	-LPS_RTN_LOCK                         -- Lock the retained reg value
	-LPS_RTN_OFF                          -- Turn off state retention
	-LPS_RTN_PREC_RULE                    -- Enable rule based retention precedence (Disable element based)
	-LPS_RTN_SAVE_LOCK                    -- Lock the IEEE 1801 retained reg value for save
	-LPS_SDA_UPF_DONT_TOUCH_ON            -- Enable UPF_dont_touch SDA commands
	-LPS_SIMCTRL_ON                       -- Enable simulation time control over low power simulation
	-LPS_SNSTATE_HIERFIND                 -- Allow hierarchical search of a port state for a supply net 
	-LPS_SPA_OVERRIDE                     -- Allow set_port_attributes to override liberty
	-LPS_SRFILTER_VERBOSE                 -- Debug identifying sequential elements for state retention rules
	-LPS_SRRULEOPT_WARN                   -- Print warning for optimized and ignored Retention rule
	-LPS_SRSN_OVERRIDE                    -- Allow set_related_supply_net to override liberty and set_port_attributes
	-LPS_STDBY_NOWARN                     -- Turn off warning for standby mode input violation
	-LPS_STIME <arg>                      -- Specify a time to start low power simulation
	-LPS_STL_OFF                          -- Turn off state loss
	-LPS_SUPPLY_FULL_ON                   -- Initializing root supplies to FULL_ON state 
	-LPS_SYNTAX_CHECK                     -- Enable Quick Syntax Check for a CPF or 1801 file
	-LPS_TERMB_CHKPST_OFF                 -- Disable terminal boundary check for PST commands  
	-LPS_TERMB_CHKSCP_OFF                 -- Disable terminal boundary check for scoping commands  
	-LPS_TERMB_PMODEL                     -- Default all power models to terminal boundary
	-LPS_UPCASE                           -- Changes all identifiers to upper case in CPF file
	-LPS_V10_ACK                          -- Enable 1.0 style ack port specification 
	-LPS_V10ISO                           -- Allow V1.0 isolation for 1801.
	-LPS_VERBOSE <arg>                    -- Specify a level of information reporting
	-LPS_VERIFY                           -- Enables automatic Low Power verification 
	-LPS_VHDL_REG_OPT                     -- Low Power optimized algorithm to determine VHDL Reg
	-LPS_VPLAN <arg>                      -- Generate a vplan for power coverage
	-LPS_WREAL_BPORT_CORRUPTION           -- Enable power corruption on wreal boundary port of macro model.
	-LWDGEN                               -- Generate data to support post simulation debug.
	-MATCHINST <arg>                      -- (requires -CONFFILE) Specify the name of the instance to match for -INSERT
	-MAXDELAYS                            -- Selects maximum delays for simulation
	-MCCODEGEN                            -- Enable parallel code generation
	-MCE_QUALIFY <arg>                    -- Enable mce qualification 
	-MCMAXCORES <arg>                     -- Maximum number of cores that multi-core codegen can use
	-MEM_XPROF  [Deprecates: MEM_IPROF]   -- Enable instrumentation for memory profiling
	-MEMDETAIL                            -- Enable instrumentation for stream profiling in xmsim.
	-MESSAGES                             -- Specifies printing of informative messages
	-MINDELAYS                            -- Selects minimum delays for simulation
	-MIXED_BUS_OPT                        -- Prevent mixed bus on concats 
	-MIXESC                               -- Handle escaped identifiers in imported model
	-MKDBSSNAP                            -- Allow this snapshot to be used with -DBSSNAP
	-MKDYNAMICSNAP                        -- Deprecated option, use MKDBSSNAP instead
	-MKPRIMSNAP                           -- Make a primary snapshot
	-MODELINCDIR <arg>                    -- specify a list of directories/paths separated by ':'
	-MODELPATH <arg>                      -- to specify a list of source files/directories of source files [with/without section identifiers]
	-MS_PERF                              -- turn on a bunch of ms performance feature 
	-MSIE_VERBOSE                         -- Print messages about MSIE partition boundaries
	-MSIEPKGSOK                           -- Allow identically named (yet different) packages from primary snapshots
	-MSIETOPSOK                           -- Allow identically named tops from primary snapshots
	-MULTVIEW                             -- (requires -CONFFILE) Allows selection of architecture/configuration for binding of each component instance 
	-NAMEMAP_MIXGEN                       -- Do name mapping from VHDL generics to Verilog parameters
	-NBACOUNT                             -- Enables NBA counting to be accessed by VPI application.
	-NEG_VERBOSE                          -- Print detailed messages during negative delays adjustment
	-NEGDELAY                             -- Adjust for negative interconnect and module path delays
	-NETTYPE_PORT_RELAX                   -- Relax nettype port compatability checking
	-NEVERWARN                            -- Disables printing of all warning messages
	-NEWPERF                              -- Umbrella option for new performance optimizations
	-NO_CROSS_DEF_BIND                    -- Suppresses cross language default binding
	-NO_SDFA_HEADER                       -- Do not print the SDF annotation header
	-NO_TCHK_MSG                          -- Turn off timing check warnings
	-NO_TCHK_XGEN                         -- Turn off X-generation in VITAL timing checks
	-NO_TOP_LEVEL_INTERFACES              -- Stick to the SystemVerilog LRM strictly by disallowing interfaces as top-level design units
	-NO_VPD_MSG                           -- Turn off VITAL pathdelay warnings
	-NO_VPD_XGEN                          -- Turn off X-generation in VITAL pathdelays
	-NOASSERT                             -- Disable PSL and SystemVerilog assertions in the snapshot
	-NOAUTOSDF                            -- Automatic SDF Annotation is suppressed
	-NOBINDING <arg>                      -- Skip instances of unit given as argument
	-NOCOPYRIGHT                          -- Suppresses printing of copyright banner
	-NODEADCODE                           -- Turn off dead code optimization
	-NODEFBOPEN                           -- Disable default binding when explicit open binding indication is specified
	-NOESP                                -- Disable edge sensitive iopath delays
	-NOFORCESUPPLY                        -- Optimize the handling of supply net
	-NOFTWAITCHK                          -- disabled the indirect waited task call from function.
	-NOILGLMPCHK                          -- disabled the illegal modport check.
	-NOIPD                                -- Ignore interconnect delays
	-NOLICSUSPEND                         -- disable suspending licenses for SIGSTP
	-NOLOG                                -- Suppress generation of the default logfile
	-NOMXINDR                             -- Don't raise NOMXINDR error; split net instead
	-NONEG_TCHK                           -- Disallow negative values in SETUPHOLD & RECREM timing checks
	-NONOTIFIER                           -- Notifiers are ignored in timing checks.
	-NOPARAMERR                           -- don't flag setting of undefined parameters as an error
	-NORTIS                               -- Disable retain input sense	
	-NOSDFSTATS_LOG                       -- Disable SDF annotation statistics logging
	-NOSEARCH                             -- Skip library searching for instances in a partial design
	-NOSOURCE                             -- do not check source file timestamps in update
	-NOSPARSEDEFAULT                      -- Dont set any default size for sparsearray, Currently 1-D array > 100000 are set to be sparse by default
	-NOSPECIFY                            -- Don't execute timing checks, ignore path delays and skip SDF annotations.
	-NOSTDOUT                             -- Turn off output to screen
	-NOSUPTRAN                            -- Turn off new tran supply support
	-NOTARGET_SVBIND                      -- To allow design compilation having SV Bind constructs without target
	-NOTIMINGCHECKS                       -- Don't execute timing checks
	-NOVHDLXP                             -- Disable VHDL X-PROP
	-NOVITALACCL                          -- Turn off VITAL acceleration  
	-NOWARN <arg>                         -- Disables printing of the specified warning message
	-NOXILINXACCL                         -- Turn off Xilinx acceleration
	-NTC_ENHANCED                         -- Use improved algorithm for convergence to ntc_level 2 behavior.  
	-NTC_LEVEL <arg>                      -- Pick the behavior of the NTC algorithm 1-3.  Default is 2.
	-NTC_NEGLIM                           -- Adjust the negative limit for invalid ntc timing window
	-NTC_PATH                             -- Verify that a pathdelay containing an NTC delay is larger
	-NTC_POSLIM                           -- Adjust the positive limit for invalid ntc timing window
	-NTC_TOLERANCE <arg>                  -- Specify tolerance value for ntc timing window
	-NTC_VERBOSE                          -- Show limits changed by the NTC algorithm in order to  make a circuit converge
	-NTCNOTCHKS                           -- Generate NTC delays while removing timing checks
	-NXMBIND  [Deprecates: NNCBIND]       -- Turn on new SVBind. This implementation is now available as default, hence the switch need not be specified any longer.
	-OLDDEPOSIT                           -- This options will stop deposit from behaving like a force does with interconnects
	-OMICHECKINGLEVEL <arg>               -- Specify OMI checking level {Min, Std, Max}
	-OVERRIDE_PRECISION                   -- Override the timescale precision in Verilog modules with the timescale precision value provided in -timescale commandline arg
	-OVERRIDE_TIMESCALE                   -- Override the timescale directives in Verilog modules with the timescale value provided in -timescale commandline arg
	-OVERWRITE                            -- (requires -CONFFILE) Overwrite existing configuration file of the same name
	-OXMBIND                              -- Use old SV bind flow.
	-PARTIALDESIGN                        -- Allow elaboration of a partially defined design
	-PATHDELAY_SENSE                      -- Enable the pathdelay sense in the design
	-PATHPULSE                            -- Set pulse limits according to PATHPULSE$
	-PATHTRAN                             -- Kill pathdelays touching multiple tran gates
	-PERFLOG <arg>                        -- Writes performance statistics in the specified file
	-PERFSTAT                             -- Writes performance statistics in ncperfstat.out
	-PLI_EXPORT                           -- Export symbols from loadpli, loadvpi
	-PLINOOPTWARN                         -- Do not print pli messages caused by limited visibility
	-PLINOWARN                            -- Do not print pli warning and error messages
	-PLIVERBOSE                           -- Verbose information about PLI1.0 and VPI task and function registration
	-PLUSPERF                             -- Umbrella option for simulation perf optimizations
	-PRESERVE                             -- Preserves resolution of single driver sigs
	-PRIMBIND                             -- Search libraries for primary snapshots when binding
	-PRIMHREFUPDATE                       -- Enable the automatic re-elaboration of the primary snapshot when href file permissions are needed
	-PRIMINCRPATHOK                       -- Disable to INCRPATH check done in incremental elaboration
	-PRIMPARAMSOK                         -- No error if incremental tries to change primary params/generics
	-PRIMSNAP <arg>                       -- Create an incremental snaphot to be used with the given primary snapshot
	-PRIMTOP <arg>                        -- Specify primary top-level when using -GENHREF
	-PRIMVHDLCOMPAT                       -- Prepare primary snapshot to work with VHDL in another partition
	-PRINT_HDL_PRECISION                  -- Prints VHDL timescale.
	-PROCESS_SAVE                         -- Enables process-based save and restart
	-PROMPT                               -- (requires -CONFFILE) Prompts to select an architecture/configuration/view for an entity/module
	-PULSE_E <arg>                        -- Sets percentage of delay for pulse error limit for both specify paths and interconnect
	-PULSE_INT_E <arg>                    -- Sets percentage of delay for pulse error limit only for interconnect
	-PULSE_INT_R <arg>                    -- Sets percentage of delay for pulse reject limit only for interconnect
	-PULSE_R <arg>                        -- Sets percentage of delay for pulse reject limit for both specify paths and interconnect
	-QUIET                                -- No error/warning summary output
	-R2L_ELECTRICAL_INH                   -- modify ie selection to select DMS CMs with electrical supply
	-R2L_MSUP                             -- Enable R2L insertion with multiple supply
	-REDUCE_CLASSDEP                      -- Generate reduced dependency list for class based designs.
	-RELAX                                -- Enable relaxed VHDL interpretation
	-RNM_COERCE <arg>                     -- Specify the type of RNM coercion
	-RNM_INFO                             -- All RNM coercion infomation.
	-RNM_RES_NOWARN                       -- Disable runtime warnings on built-in wreal resolution functions
	-RNM_TECH                             -- Enable Real Number Modeling(RNM) elaboration mode
	-SAVECHOICE <arg>                     -- (requires -CONFFILE) Specify the name of the file in which to save user's selected bindings.
	-SC_MAIN_STACKSIZE <arg>              -- Set SystemC sc_main() stack size, default is 0x400000
	-SCCONFIG <arg>                       -- Specify SystemC parameter configuration file. Optional string ':gen' may be appended at the end of the file name for automatic generation of parameter configuration file from the design hierarchy.
	-SCCREATEVIEWABLES                    -- Create xmsc_viewable objects inserted by xmsc_wizard
	-SCDUMPSTATICTOP <arg>                -- Generate SystemC source code for a Dynamic Subsystem specified with -SCCONFIG option
	-SCOPE_DISCIPLINE <arg>               -- specify one scope based discipline
	-SCRELAXPARAM                         -- Allow xmsc_get_param call from end_of_construction
	-SCUPDATE                             -- update SystemC design units used in the design
	-SDF_CMD_FILE <arg>                   -- Specifies file of SDF annotation commands
	-SDF_FILE <arg>                       -- Specifies the SDF file to use
	-SDF_NO_WARNINGS                      -- Do not report SDF warnings
	-SDF_NOCHECK_CELLTYPE                 -- Don't check accuracy of CELLTYPE field
	-SDF_NOPATHEDGE                       -- Ignore edge specifier in SDF IOPATHS
	-SDF_NOPULSE                          -- Ignore SDF pulse information
	-SDF_ORIG_DIR                         -- Put Automatically compiled sdf binary file in same directory as original sdf file
	-SDF_PRECISION <arg>                  -- The precision the SDF data will be modified to
	-SDF_SIMTIME                          -- Allow SDF annotation to happen during simulation
	-SDF_SPECPP                           -- Use PATHPULSE parameters in specify block for pathpulse calculation 
	-SDF_VERBOSE                          -- Include detailed information in SDF log file
	-SDF_WORSTCASE_ROUNDING               -- For SDF annotation, truncate min delays, round max delays up
	-SDFDIR <arg>                         -- Directory where the Automatically compiled SDF file will written to and read from
	-SDFSTATS <arg>                       -- Write SDF annotation statistics to the given file
	-SEM2009                              -- use 2009 LRM semantics for scheduling
	-SEQ_UDP_DELAY <arg>                  -- Specify a constant delay for sequential UDPs
	-SEQUDP_NBA_DELAY                     -- Add nba delay to zero-delay sequential UDP's
	-SET_ETO_PULSE                        -- Set ETO pulse value to non-X
	-SETDISCIPLINE <arg>                  -- set discipline for a specified scope.
	-SHOW_FORCES                          -- Turn on support for force -show of Verilog Code forces
	-SHOW_RNM_COVER                       -- option to show all RNM informations with coverage
	-SHOW_RNM_RAND                        --option to show all RNM random variables
	-SNAPSHOT <arg>                       -- Name to use for the simulation snapshot
	-SPARSEARRAY <arg>                    -- Make all 1-D arrays with more than <N> elements sparse, this option override any default value set by tool itself
	-SPECTRE_ARGFILE_SPP <arg>            -- run spectre parser with '-SPP' option (spp on) when parsing files specified by -MODELPATH;  additionally configure spp using options defined in the file
	-SPECTRE_E                            -- run spectre parser with '-E' option (cpp on) when parsing files specified by -MODELPATH
	-SPECTRE_SPP                          -- run spectre parser with '-SPP' option (spp on) when parsing files specified by -MODELPATH
	-SPICETOP                             -- Indicate spice on top flow.
	-STATUS                               -- Print out the runtime status at the end
	-STPCHECK                             -- Enables printing of warning message
	-SV_MS                                -- turn on a bunch of sv+ms feature
	-SV_UDNWCARD                          -- Enable SV UDN wildcard 
	-SVPERF <arg>                         -- Set SystemVerilog Performance Mode. {+up} enhance performance for unique/priority.
	-SVUDN_COMPLEX_PORT                   -- Support complex port for SV UDN
	-SYNCINITVAL                          --- propagate initial value of VHDL ports of type integer and enum to SV ports.
	-TFILE <arg>                          -- Timing file.
	-TFVERBOSE                            -- Enables verbose mode for timing file matching.
	-TIMESCALE <arg>                      -- Set default timescale on Verilog modules.
	-TRANMIN                              -- To choose the minimum delay if multiple iopath arc collapse
	-TYPDELAYS                            -- Selects typical delays for simulation
	-UNIPRI_OLD                           -- Violation reports for unique-priority printed as per old behavior
	-UPDATE                               -- update design units used in the design
	-UPTODATE_MESSAGES                    -- Verbose messages displayed during update
	-USE5X4VHDL                           -- Use 5.X configurations for elaborating VHDL hierarchies
	-USE5X4VLOG                           -- Use 5.X configurations for elaborating Verilog hierarchies
	-USE_CM                               -- Use Verilog-AMS connectmodule for VHDL-Spice connection
	-USE_LAST_IE                          -- For wildcard scope match confilct, make last ie config win 
	-USEARCH <arg>                        -- (requires -CONFFILE) Specify the priority list of VHDL architectures
	-USECHOICE <arg>                      -- (requires -CONFFILE) Specify the name of the file from which to read user's selected bindings.
	-USECONF <arg>                        -- (requires -CONFFILE) Specify the priority list of VHDL configurations
	-USEVIEW <arg>                        -- (requires -CONFFILE) Specify the priority list of Verilog views
	-V200X                                -- Enable VHDL 200X features
	-V93                                  -- Enable VHDL 93 features
	-VCFG_AOI_INDEX                       -- Allows specifying index for an AOI instance in a Verilog configuration rule
	-VCFG_INST_PRECEDENCE                 -- Option to give precedence to instance rule over cell rule in verilog config
	-VERSION                              -- Prints the version number
	-VHDL_NBA                             -- Schedule all VHDL updates in the NBA region.
	-VHDL_SEQ_NBA                         -- Schedule all updates happening in a sequential block to the nba queue
	-VHDL_TIME_PRECISION <arg>            -- Set default time precision for VHDL.
	-VHDLSPARSEARRAY <arg>                -- Make all 1-D arrays in VHDL with more than <N> elements sparse
	-VHDLSYNC                             -- Enable mixed language synchronization for VHDL and Verilog simulation
	-VIPDMAX                              -- Select the Max. delay value for VitalInterconnectDelays
	-VIPDMIN                              -- Select the Min. delay value for VitalInterconnectDelays
	-VLOG_STRONG_TYPE_CHECK               -- Warn when incorrect string/integral conversion occurs.
	-VPICOMPAT <arg>                      -- Specify the VPI compatibility mode (IEEE Standard version) default
	-VTWVERBOSE                           -- Prints logs of VTWfile activity
	-WARNMAX <arg>                        -- Specifies the maximum number of warnings instances per message
	-WORK <arg>                           -- Specifies the WORK library
	-WREAL2VHD_PROBE                      -- To generate probe file wreal2vhd_probe.tcl for -WREAL2VHDLMAP
	-WREAL2VHDLMAP <arg>                  -- To set Verilog AMS wreal X/Z state to VHDL real state map
	-WREAL_COERCE <arg>                   -- Turn on/off wreal coercion
	-WREAL_RESOLUTION <arg>               -- Specifies the Wreal Resolution Function to be used	
	-XFILE <arg>                          -- X-Propogation configuration file
	-XLIFNONE                             -- Emulate XL's ifnone SDF annotation implementation.
	-XLOG_ELAB <arg>                      -- Logs X-Prop activity in specified log file
	-XM_NO_SOFT_ERR                       -- Treat all soft errors as warnings for backwards compatibility
	-XMALLERROR                           -- Increases the severity of all warnings to error.
	-XMERROR <arg> [Deprecates: NCERROR]  -- Increases the severity of a warning to an error
	-XMFATAL <arg> [Deprecates: NCFATAL]  -- Increases the severity of a warn/error to a fatal
	-XMINITIALIZE  [Deprecates: NCINITIALIZE] -- Allow variables to be initialized at simulation time to something other than x
	-XMNOTE <arg> [Deprecates: NCNOTE]    -- Decrease severity level of a warning to a note
	-XMSIE_VERBOSE                        -- Print messages about Automatic partitioner
	-XMSIENUMCLONEPARTITIONS <arg>        -- Override the partitioner's cloning limit that defaults to 12 
	-XMSIENUMPARTITIONS <arg>             -- Generate a partition file for MSIE with N partitions
	-XMSIEPARTITIONTOP <arg>              -- Specify the module that needs to be partitioned.
	-XMSIEPERFSTAT                        -- Print performance status of the AutoMSIE
	-XMWARN <arg>                         -- Decreases the severity of a soft error to a warning
	-XPROF  [Deprecates: IPROF]           -- Enable instrumentation for profiling
	-XPROP <arg>                          -- Enable X-Propogation (F/C)
	-XVERBOSE                             -- Logs X-Prop activity in xp_elab.log
	-XZLIB                                -- Enable X-prop log activity in gzip format in xp_elab.log.gz if -xverbose option is provided
	-ZLIB <arg>                           -- Compress PAK file using level 1 to 9, with 1 being the default value

  Examples:
	-- To elaborate my_lib.top:behav
	   % xmelab my_lib.top:behav
	   % xmelab my_lib.top
	   % xmelab top
	
	-- To elaborate with informative messages
	   % xmelab -messages my_lib.top:behav


xmsim(64): 19.09-s001: (c) Copyright 1995-2019 Cadence Design Systems, Inc.
  Usage:
	xmsim [options] [lib.]cell[:view]

  Options:
	-64BIT                             -- Invoke 64 bit executable
	-ABVCOVERON                        -- Enable cover directives
	-ABVFAILURELIMIT <arg>             -- Limit failure count for assert/assume directives
	-ABVFINISHLIMIT <arg>              -- Limit finish count for cover directives
	-ABVGLOBALFAILURELIMIT <arg>       -- Limit global failure count
	-ABVNORANGEOPT                     -- Disable performance optimization on assertions with ranges in their expression
	-ABVNOSTATECHANGE <arg>            -- Suppress consecutive assertion state changes
	-ABVOFF <arg>                      -- Completely stop specified assertions
	-ABVOPTREPORTING                   -- Disable counter details for assertions.
	-ABVRANGELIMIT <arg>               -- Treat range as unbounded above specified limit
	-ABVRECORDCOVERALL                 -- Record all finishes for cover directives
	-AMS_FLEX_RELEASE                  -- Enable AMS Flexible Release Matrix flow
	-AMS_LORDER <arg>                  -- Specifies the promotion order for AMS license checkout (SAMSD:MMSIM:SAMSC)
	-AMSDEBUG                          -- Generate readable call stack for AMS # Generate readable call stack for AMS
	-AMSDIR <arg>                      -- Raw results directory for AMS
	-AMSFORMAT <arg>                   --Set the waveform format used for TCL databases
	-AMSOUTDIR <arg>                   -- Raw result directory for AMS and simulation output
	-AMSVIVALOG                        -- To generate runObjFile 
	-ANALOGCONTROL <arg>               -- Analog Simulation control file
	-APPEND_KEY                        -- Append keystrokes to an existing keyfile
	-APPEND_LOG                        -- Append the log to an existing logfile
	-APS_ARGS <arg>                    -- arguments for the Aps solver
	-ARMFM <arg>                       -- Allow simulation of given Fast Model from ARM (e.g. ARM926CT, ARMCortexM3CT, etc.) or invoke ARM model-specific capability (e.g. modeldebugger, rvdebug, debug, trace, image)
	-ASSERT_COUNT_TRACES               -- Use trace-based counting for assertions
	-ASSERT_LOGGING_ERROR_OFF          -- Change default severity from "Error" to "Note" for logging assertion failures
	-BATCH                             -- Run simulation in batch mode (this is the default)
	-BBOX_LINK
	-CCIPARAM <arg>                    -- Associate values with SystemC cci parameters
	-CDS_ALTERNATE_TMPDIR <arg>        -- Specify alternate directory for design data
	-CDS_IMPLICIT_TMPDIR <arg>         -- Specify location for snapshot access
	-CDSLIB <arg>                      -- Specifies the cds.lib file to be used
	-CHECKPOINT_ENABLE                 -- Enables process-based checkpointing
	-CMDFILE <arg>                     -- Search-path support
	-COUNTDRIVERTRANS                  -- $countdrivers only counts connected tran gates with contributing drivers
	-COV_DEBUGLOG                      -- To print coverage related information during different phases of simulation
	-COV_UCISXML_INFO                  -- Generate coverage database with information required for UCIS-XML
	-COVBASERUN <arg>                  -- Base run name for coverage results databases <covwork>/<covscope>/<<base_run>_sv<seed>>
	-COVCLEANWORKDIR                   -- Remove the entire coverage directory including the coverage model and data files
	-COVDESIGN <arg>                   -- Design Name for coverage results databases (see COVWORK and COVTEST) <covwork>/<covdesign>/<covtest>
	-COVFIRSTBINMATCH                  -- To sample the first hit for a coverpoint/cross bin during a sampling event
	-COVMODELDIR <arg>                 -- Path to coverage model/scope directory to use instead of the default model/scope directory 
	-COVNOMODELDUMP                    -- Disable coverage design database (model) dumping
	-COVOVERWRITE                      -- Enable overwriting of coverage output files and directories
	-COVSCOPE <arg>                    -- Scope Name for coverage results databases (see COVWORK and COVTEST) <covwork>/<covscope>/<covtest>
	-COVTEST <arg>                     -- Test Name for coverage results databases (see COVWORK and COVSCOPE) <covwork>/<covscope>/<covtest>
	-COVWORKDIR <arg>                  -- Base Name for coverage results databases (see COVSCOPE and COVTEST) <covwork>/<covscope>/<covtest>
	-DELAY_UDP_XMINITIALIZE  [Deprecates: DELAY_UDP_NCINITIALIZE] -- Delay effect of INITIALIZE on UDP by one delta cycle
	-DISABLE_EXTEND_SELF               -- Disallow process::self() call from nonprocesses
	-DISABLE_SV_TCL_DRIVER_FIXES       -- disable tcl drivers command fixes for certain expressions
	-DPI_STACK_INT_C                   -- Lists internal C stack frames called from import function
	-DUMPPORTS_FORMAT <arg>            -- Specify EVCD format flag for $dumpports
	-DUMPSTACK                         -- Dump the stack on any internal error
	-DUT_PROF <arg>                    -- generate profiler report with design unit summary.
	-EMHIER_DVS                        -- Enable embedded hierarchical dynamic voltage supply
	-ENABLE_PS_AP                      -- Correct datatype for part select for assignment pattern
	-ENABLE_SVAOPSFIXES                -- Fix the behavior of SVA operators like EVENTUALLY/ALWAYS/IMPLIES/FOLLOWED-BY to algin with their LRM semantics.
	-EPULSE_NO_MSG                     -- Suppress e-pulse error message
	-ERRORMAX <arg>                    -- Specifies the maximum number of errors processed
	-ERRTCL_VERBOSE                    -- Output Tcl command that produced the error
	-ESW <arg>                         -- Associate a core for ESW debugging (<core>:<client>)
	-EXCLUDE_FILE <arg>                -- Specify a list of instances to be excluded for initialization
	-EXIT                              -- Always exit the simulator instead of issuing a TCL prompt
	-EXTASSERTMSG                      -- Prints Extended Assert message Information 
	-EXTEND_SELF                       -- Allow process::self() call from some nonprocesses
	-FAULT_CHECKER_ON                  -- Enable checker strobe detection feature
	-FAULT_CONC_MSGS <arg>             -- Max detection messages count for concurrent, max limit is 2^12
	-FAULT_CONCURRENT                  -- Enable concurrent fault simulation
	-FAULT_GEN_TEST_CONST              -- enable TB level-0 test based fault reduction optimization
	-FAULT_GOOD_RUN                    -- Enable good simulation run when elaborated for fault injection
	-FAULT_ID <arg>                    -- Specify unique node id to select fault node
	-FAULT_LOGSIM <arg>                -- Specify a log file for fault simulation
	-FAULT_MASTER_DB <arg>             -- Specify master fault work directory for creation of links
	-FAULT_MAX_MSGS <arg>              -- Specify max count of messages to be displayed, max limit is 2^12
	-FAULT_NUM_NODES <arg>             -- Specify number of faultable nodes affected by a fault
	-FAULT_OVERWRITE                   -- Overwrites the existing fault work directory
	-FAULT_RANDOM_ID <arg>             -- Specify random sequence id to select fault node(s)
	-FAULT_SEED <arg>                  -- Specify random seed to randomize fault selection
	-FAULT_SIM_RUN                     -- Enable fault simulation run when elaborated for fault injection
	-FAULT_TEST <arg>                  -- Specify the test name for fault simulation run
	-FAULT_TIMEOUT <arg>               -- Specify timeout to terminate a simulation run
	-FAULT_TW <arg>                    -- Specify time window to apply fault
	-FAULT_TYPE <arg>                  -- Specify fault model type for simulation
	-FAULT_WORK <arg>                  -- Specify directory to save fault run results
	-FILE <arg>                        -- Load command line arguments from <arg>
	-GPROFILER                         -- Enable gperftool's CPU profiling
	-GPROFOUT <arg>                    -- gperftool profiler data to be dumped to
	-GUI                               -- Enter window mode before running simulation
	-HDLVAR <arg>                      -- Specifies the hdl.var file to be used
	-HELP                              -- Prints this message
	-HIER_DVS                          -- Enable hierarchical dynamic voltage supply
	-INPUT <arg>                       -- Script to be executed during initialization
	-KEYFILE <arg>                     -- Specifies the file to capture keyboard input
	-LAYOUT <arg>                      -- Launch GUI with a built-in window layout   
	-LIC_USED                          -- Dump out the licenses checked out 
	-LICENSE_ORDER <arg>               -- Specifies the promotion order NO_TOP or TOP_ONLY
	-LICINFO                           -- Dump out the license requirements for this design
	-LICQUEUE                          -- Use license queue mechanism
	-LOADCFC <arg>                     -- Dynamically load a CFC application
	-LOADFMI <arg>                     -- Dynamically load an FMI Library
	-LOADPLI1 <arg>                    -- Specify the library_name:boot_routine(s) to dynamically load a PLI1.0 application
	-LOADVHPI <arg>                    -- Dynamically load a VHPI application 
	-LOADVPI <arg>                     -- Specify the library_name:boot_routine(s) to dynamically load a VPI application
	-LOGFILE <arg>                     -- Specifies the file to contain log information
	-LPS_1801_MSG <arg>                -- Specify a file for 1801 simulation messages
	-LPS_ALT_SRR                       -- Enables alternate behavior for save/restore pre-conditions
	-LPS_ATIME <arg>                   -- Specify a time to activate low power assertions
	-LPS_CORRUPT_TIME0                 -- Enable 1801 corruption at time 0
	-LPS_ENABLE_ASSERTION_CTRL         -- Enable assertion controls in low power suspend mode
	-LPS_ENUM_RAND_CORRUPT <arg>       -- Corrupt VHDL enums with random values based on specified seed
	-LPS_ENUM_RIGHT                    -- Corrupt VHDL enums with 'right values
	-LPS_EXPR_FORCE_REAPPLY            -- Reapply HDL expression forces
	-LPS_ISO_OFF                       -- Turn off port isolation
	-LPS_ISO_VERBOSE                   -- Enable information reporting for isolation
	-LPS_LOG_VERBOSE <arg>             -- Specify a log file for low power simulation LPS_VERBOSE or LPS_PSN_VERBOSE output 
	-LPS_LOGFILE <arg>                 -- Specify a log file for low power simulation 
	-LPS_OFF                           -- Turn off low power simulation
	-LPS_PSN_VERBOSE <arg>             -- Specify a level of PSN information reporting
	-LPS_PSO_FORCE_CHECK               -- Enable check when applying user force while power domain is OFF
	-LPS_PST_VERBOSE                   -- Enable reporting additional PST info  
	-LPS_REAL_NOCORRUPT                -- Disables corrupting REAL variables.
	-LPS_RESOLUTION_NO_MESSAGE         -- Supress the run time custom supply net resolution debug info
	-LPS_RESTORE_LEVEL                 -- Enable restoration started  at active edge for balloon style retention 
	-LPS_REVERT_ERRORS2WARNINGS        -- Treat old warnings as warnings again for backward compatibility
	-LPS_RTN_FULL_LOCK                 -- New model for retention lock
	-LPS_RTN_LOCK                      -- Lock the retained reg value
	-LPS_RTN_OFF                       -- Turn off state retention 
	-LPS_SIM_VERBOSE <arg>             -- Specify a level of information reporting during simulation 
	-LPS_SMARTLOG_DB <arg>             -- Specify a database name for IDA Smartlog
	-LPS_SMARTLOG_ENABLE               -- Enable LP writing into IDA SMartlog DB
	-LPS_STDBY_NOWARN                  -- Turn off warning for standby mode input violation
	-LPS_STIME <arg>                   -- Specify a time to start low power simulation
	-LPS_STL_OFF                       -- Turn off state loss 
	-LPS_VERBOSE <arg>                 -- Specify a level of information reporting
	-LPS_WREAL_CORRUPT_VALUE <arg>     -- Specify corrupt value of WREAL signals
	-LPS_WREAL_NOCORRUPT               -- Disables corrupting WREAL signals
	-MAX_TCHK_ERRORS <arg>             -- Specifies maximum number of timing violations
	-MCDUMP                            -- Do SHM dumping on separate process
	-MCE_QUALIFY <arg>                 -- Enable mce qualification.
	-MEMDETAIL                         -- Add information about memory usage to profiler report
	-MEMOPT                            -- Use reduced memory image size
	-MERGE_DATABASE                    -- Merge sst2/psfxl_all database in save/restart.
	-MESSAGES                          -- Specifies printing of informative messages
	-MODELPATH <arg>                   -- to specify a list of source files/directories of source files [with/without section identifiers]
	-MTD_OPTIONS <arg>                 -- Quoted string of options for MTD
	-NEVERWARN                         -- Disables printing of all warning messages
	-NEWPERF                           -- Umbrella option for new performance optimizations
	-NO_SDFA_HEADER                    -- Do not print the SDF annotation header
	-NOCIFCHECK                        -- Disables constraint checking in VDA functions for increased performance
	-NOCOPYRIGHT                       -- Suppresses printing of copyright banner
	-NOIEVLIC                          -- Specifies that IEV license must not be added in the promotion order
	-NOKEY                             -- Suppress generation of the default keyfile
	-NOLICPROMOTE                      -- Deprecated Switch- Does not affect Xcelium licensing 
	-NOLICSUSPEND                      -- disable suspending licenses for SIGTSTP
	-NOLOG                             -- Suppress generation of the default logfile
	-NOMTDUMP                          -- Disable multi-threaded SHM dumping.
	-NONTCGLITCH                       -- Suppress delayed net glitch suppression messages
	-NOSOURCE                          -- Do not check source file timestamps (with -UPDATE)
	-NOSTDOUT                          -- Turn off output to screen
	-NOTIMEZEROASRTMSG                 -- Suppress printing of time zero assert messages from all built in functions
	-NOWARN <arg>                      -- Disables printing of the specified warning message
	-NTC_SIM_VERBOSE                   -- Show additional NTC verbose messages during simulation
	-NTC_VERBOSE                       -- Show limits changed by the NTC algorithm in order to  make a circuit converge
	-OMICHECKINGLEVEL <arg>            -- Specify OMI checking level {Min, Std, Max}
	-OVP <arg>                         -- Allow simulation of given OVP model
	-PASSWORD                          -- Prompt for simulation password for SimVision walk-up connections
	-PERFLOG <arg>                     --     Writes performance statistics in the specified file
	-PERFSTAT                          -- Writes performance statistics in xmperfstat.out
	-PLI_EXPORT                        -- Export symbols from loadpli, loadvpi
	-PLIDEBUG                          -- enable PLI debugging mode for -profile
	-PLIERR_VERBOSE                    -- Expand handle info in PLI/VPI/VHPI messages
	-PLIMAPFILE <arg>                  -- Specify the mapping (Table) file to load 
	-PLINOOPTWARN                      -- Do not print pli messages caused by limited visibility
	-PLINOWARN                         -- Do not print pli warning and error messages
	-PLIVERBOSE                        -- Verbose information about PLI1.0 and VPI task and function registration
	-PLUSPERF                          -- Umbrella option for simulation perf optimizations
	-PMR                               -- Switch on partition and multi-rate simulation in analog kernel (This option is no longer supported)
	-PPDB <arg>                        -- Enter PPE mode with the specified database open
	-PPE                               -- Enter PPE mode which means no active simulation just a gui
	-PROCESS_SAVE                      -- Enables process-based save and restart
	-PROF_DUMP_INTERVAL <arg>          -- dump profiler report after every x seconds
	-PROF_DUMP_ONCE <arg>              -- dump profiler report in one shot after x seconds
	-PROF_INTERVAL <arg>               -- Set cpu (unit: microsecond, 2000 default) / memory(unit: KB, 10KB default) profiling interval.
	-PROF_MEM_CALLGRAPH                -- Enable the callgraph in memory profiler
	-PROF_MEM_DUMP_BEFORE_MEM_EXHAUST  -- dump db before virtual memory exhaustion in memory profiler
	-PROF_WORK <arg>                   -- Change root xprof database folder name from default (xprof_report_dir)
	-PROFILE                           -- generate a run time profile of the design
	-PROFOUTPUT <arg>                  -- Specifies the file to contain profiling information
	-PROFSOFILTER <arg>                -- filter out profiler hits on .so
	-PROFTHREAD                        -- Allow Threaded processes to profile
	-QUIET                             -- No error/warning summary output
	-RANDWARN                          -- Enable all SV randomize failure warnings
	-REDMEM                            -- Deprecated option - no impact
	-RUN                               -- Begin simulation automatically with interactive or window mode
	-SAVEVPCONFIG <arg>                -- Save current virtual platform design configuration
	-SC_MAIN_STACKSIZE <arg>           -- Set SystemC sc_main() stack size, default is 0x400000
	-SC_THREAD_STACKSIZE <arg>         -- Set SystemC SC_THREAD stack size, default is 0x16000
	-SCCONFIG <arg>                    -- Specify SystemC parameter configuration file 
	-SCDEPENDENCY <arg>                -- Specify link dependency information
	-SCDUMPSTATICTOP <arg>             -- Generate SystemC source code for a Dynamic Subsystem specified with -SCCONFIG option
	-SCIDA                             -- Enable Indago flow for pure SystemC design
	-SCINITBIDIRTOZ                    -- Initialize SystemC bidir ports to 'Z' when connected to HDL parent scope
	-SCPROCESSCB                       -- Enable SystemC Process callbacks feature
	-SCPROCESSORDER <arg>              -- Allow SystemC process order to vary to help detect race conditions
	-SCPROFCOUNT                       -- Enable SystemC dynamic activity count
	-SCREGISTERPROBERECORDALL <arg>    -- Turn recording all sc_register value changes in probe on/off
	-SCSYNCEVERYDELTA <arg>            -- Turn Delta cycle accuracy on/off
	-SCTLMCHECK                        -- Enable TLM2 Checks and Information messages
	-SCTLMDBNAME <arg>                 -- Specify a database name for the TLM transaction recording
	-SCTLMMMAP <arg>                   -- Specify a memory map file for sctlmperf
	-SCTLMNODATA                       -- Exclude the data attribute when tracing TLM to save space and speed simulation
	-SCTLMPERF                         -- Enable SystemC TLM performance analysis 
	-SCTLMPROBE                        -- Enable SystemC TLM sockets for extensible debugging via tcl command line 
	-SCTLMRECORD                       -- Enable SystemC TLM tracing mode 
	-SCVERBOSITY <arg>                 -- Specify SystemC reporting verbosity
	-SDF_NO_WARNINGS                   -- Do not report SDF warnings
	-SDF_VERBOSE                       -- Include detailed information in SDF log file
	-SHM_FILTER_GROUP <arg>            --  Defines global filter group for real value probe filtering.  
	-SIMCOMPATIBLE_AMS <arg>           -- Specify compatibility language hspice or spectre. Default is spectre for AMSSpectre simulator and hspice for AMSUltra simulator
	-SIMINCFILE <arg>                  -- Number of files after which overwriting begins
	-SIMLOGSIZE <arg>                  -- Specifies the simulation file size limit in Megabytes
	-SIMTFILE <arg>                    -- To control the delay on port at runtime
	-SIMVISARGS <arg>                  -- Quoted string of SimVision cmdline arguments 
	-SNDYNNOW                          -- Flag to let specman know that it needs to load libraries with RTLD_NOW
	-SNLOGAPPEND                       -- Append the log files from previously saved snapshot to the current log files 
	-SNPROFILEARGS <arg>               -- Arguments for the specman profiler
	-SNPROFILECPU                      -- Tell specman to run its profiler
	-SNPROFILEMEM                      -- Tell specman memory profiler to run
	-SOLVER <arg>                      -- to pass in solver to be used for the user
	-SPECTRE_ARGS <arg>                -- arguments for the Spectre solver
	-SPICETOP                          -- Indicate spice on top flow.
	-SPROFILE                          -- Generate a VHDL Source Profile
	-STACKSIZE <arg>                   -- maximum size for the pli stack
	-STATUS                            -- print out the runtime status at the end
	-SV_LIB <arg>                      -- Dynamically load a DPI Library
	-SV_ROOT <arg>                     -- Specify root path for -sv_lib switch
	-SVRNC <arg>                       -- Set SystemVerilog randomization and constraints options
	-SVSEED <arg>                      -- Set SystemVerilog default RNG seed
	-SWDEVELOPER                       -- Use VSP Software Developer license
	-SYNCALL <arg>                     -- Synchronize all compatible signals and transactions
	-TCL                               -- Enter interactive mode before running simulation
	-TIMEUNIT_CASE                     -- Prints the time units from std.textio write procedure in upper case characters
	-TLMCPU <arg>                      -- Register given TLM CPU to allow software/hardware co-debug or associate software image with given TLM CPU
	-ULTRASIM_ARGS <arg>               -- arguments for the Ultrasim solver
	-UNBUFFERED                        -- Do not buffer output
	-UPDATE                            -- Verify snapshot and update if necessary
	-UPTODATE_MESSAGES                 -- print out modules that are up-to-date (with -UPDATE)
	-USE_IEEE_DUMPPORT_IDS             -- Dump $dumpports port ids as per IEEE format
	-USE_NEW_DUMPPORTS                 -- IUS 14.2: deprecated
	-USE_OLD_DUMPPORTS                 -- IUS 14.2: enable old $dumpports implementation
	-USELICENSE <arg>                  -- Deprecated Switch- Does not affect Xcelium licensing
	-USESCTIMEUNIT <arg>               -- Turn SystemC time resolution mode on/off
	-UVMPACKAGENAME <arg>              -- Provide UVM package name
	-VCDEXTEND                         -- Left-extend all vectors in VCD files
	-VCLASS_EXT                        -- Display derived class instead of base class 
	-VERSION                           -- Prints the version number
	-VPICOMPAT <arg>                   -- Specify the VPI compatibility mode (IEEE Standard version) default
	-VSOF_DIR <arg>                    -- To write the vsof file at the specified directory.
	-VSPDEBUG <arg>                    -- VSP Virtual Platform Debug and Analysis mode <off|all|fast>
	-WRITE_METRICS                     -- To dump the vsof (verification session output) file which is an input for emanager.
	-XCELIGEN <arg>                    -- Set SystemVerilog randomization and constraints options
	-XEDEBUG                           -- xeDebug mode in IXCOM flow
	-XLOG <arg>                        -- Logs X-Prop activity in specified log file
	-XLSTYLE_UNITS                     -- XL style display of time values, same as tcl set display_unit xlstyle
	-XM_NO_SOFT_ERR                    -- Treat all soft errors as warnings for backwards compatibility
	-XMALLERROR                        -- Increases the severity of all warnings to error
	-XMERROR <arg> [Deprecates: NCERROR] -- Increases the severity of a warning to an error
	-XMFATAL <arg> [Deprecates: NCFATAL] -- Increases the severity of a warn/error to a fatal
	-XMHIERARCHY <arg> [Deprecates: NCHIERARCHY] -- Specify the hierarchy level from which to start initiallizing the values of the variables.
	-XMINIT_FILE <arg>                 -- Specify a file name for custom initialization commands
	-XMINIT_LOG <arg>                  -- Specify a file name to record the initialized variables 
	-XMINITIALIZE <arg> [Deprecates: NCINITIALIZE] -- Specify the value to which all the variables will be initialized
	-XMNOTE <arg> [Deprecates: NCNOTE] -- Decreases the severity of a warning to a note
	-XMREPLAY_FILE <arg>               -- This option specifies a file that contains the list of options to replay model
	-XMWARN <arg> [Deprecates: NCWARN] -- Decreases the severity of a soft error to a warning
	-XVERBOSE                          -- Logs X-Prop activity in simulation log file
	-ZLIB <arg>                        -- Compress PAK file using level 1 to 9, with 1 being the default value

  Examples:
	-- To simulate the snapshot my_lib.top:snap
	   % xmsim my_lib.top:snap
	   % xmsim my_lib.top
	   % xmsim top
	
	-- To simulate while writing to the log file ./xmsim.log
	   % xmsim -log ./xmsim.log my_lib.top:snap
	
	-- To update the snapshot my_lib.top:snap and simulate
	   % xmsim -update my_lib.top:snap


endef


