all:

define if_met_error_libpng12
/e/eda2312/verdi_2016.06/platform/LINUXAMD64/bin/Novas: 
	error while loading shared libraries: libpng12.so.0: 
	cannot open shared object file: No such file or directory
1. https://forums.debian.net/viewtopic.php?f=30&t=143335
2. https://packages.debian.org/jessie/libpng12-0
3.  wget http://ftp.de.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb
4. apt install multiarch-support
5. ar x libpng12-0_1.2.50-2+deb8u3_amd64.deb
6. tar xf data.tar.xz
7. mv lib/x86_64-linux-gnu/libpng12.so.0* /lib/x86_64-linux-gnu/

endef

$(if $(synopsysPATH),,$(error 'you should define the synopsysPATH and run again'))

# srcDeseLectAll -win $$_nTrace1
# srcSelect -signal "rst" -win $$_nTrace1
# srcAddSelectedToWave -win $$_nTrace1
# srcDeseLectAll -win $$_nTrace1
# srcSelect -signal "clk" -win $$_nTrace1
# srcAddSelectedToWave -win $$_nTrace1
# srcDeseLectAll -win $$_nTrace1
# srcSelect -signal "c" -win $$_nTrace1
# srcAddSelectedToWave -win $$_nTrace1

waveAddLine?= wvAddAllSignals -win $$_nWave2

define veridiPlay01

verdiSetPrefEnv -bDisplayWelcome "off"

verdiWindowWorkMode -win $$_Verdi_1 -hardwareDebug
srcSignalView -on

verdiWindowBeWindow -win $$_nWave2
wvResizeWindow -win $$_nWave2 20 28 1500 800

$(waveAddLine)



wvZoomAll -win $$_nWave2


endef
export veridiPlay01


cvv:=clean_verdi_tmp_file
cvv:
	mkdir -p $(tmpRunDir2) 
	cd $(tmpRunDir2) && rm -f 					\
		opendatabase.log 	\
		*.vcd 				\
		*.vcd.vpd 			\
		inter.vpd 			\
		command.log 		\
		novas_dump.log		\
		novas.conf			\
		novas.rc			\
		filelist.verdi.txt	\
		verdi.play0?.txt	\
		Simv simv ucli.key 
	cd $(tmpRunDir2) && rm -fr 					\
		work.lib++			\
		vericomLog			\
		verdiLog    		\
		DVEfiles 			\
		simv.daidir/ 		\
		csrc/

bv1:=synopsys_compile_Verdi_FSDB_database
bv1:
	@echo
	cd $(tmpRunDir2) && VERDI_HOME=$(VERDI_HOME) 				\
			   $(VERDI_HOME)/bin/vericom 	\
			   $(VERICOMdefine)				\
			   $${VERDIhdlSearch}			\
			   $${VERDIhdlList}
	@echo


tv1:=run_the_test_of_Verdi_FSDB1
tv1:
	@echo
#	rm -f ./verdi.fsdb && cp srcSIM/verdi.fsdb ./
	cd $(tmpRunDir2) && echo "$${veridiPlay01}" > verdi.play01.txt 
	cd $(tmpRunDir2) && VERDI_HOME=$(VERDI_HOME) 			\
			   $(VERDI_HOME)/bin/verdi 	\
			   -ssf verdi.fsdb  		\
			   -ba						\
			   -play verdi.play01.txt	\
			   -top $(VERDItb)
	@echo

tv9:=run_the_test_of_Verdi_FSDB9
tv9:
	@echo
#	rm -f ./verdi.fsdb && cp srcSIM/verdi.fsdb ./
	echo "$${VERDIhdlSearch}" 	|xargs -n 1 >  filelist.verdi.txt 
	echo "$${VERDIhdlList}" 	|xargs -n 1 >> filelist.verdi.txt 
	VERDI_HOME=$(VERDI_HOME) 			\
			   $(VERDI_HOME)/bin/verdi 	\
			   -ssf verdi.fsdb  		\
			   -f filelist.verdi.txt 
	@echo

wv1:=group_run_the_verdi1
$(wv1):=cvv bv1 tv1
wv1: $($(wv1))

simTOP?=unknown88381811
ws2:=call_the_VCS_to_compile
ws2: 
	make -C ../topVCS $@
	mkdir -p                                   $(tmpRunDir2)
	cd $(tmpRunDir2) && rm -f verdi.fsdb && cp $(tmpRunDir3)topVCS/verdi.fsdb  ./

wn2:=call_the_NC_to_compile
wn2: 
	make -C ../topNC $@
	mkdir -p                                   $(tmpRunDir2)
	cd $(tmpRunDir2) && rm -f verdi.fsdb && cp $(tmpRunDir3)topNC/verdi.fsdb  ./

sv1:=VCS_and_VERDI01
$(sv1):=ws2 wv1
sv1: $($(sv1))

nv1:=NC_and_VERDI01
$(nv1):=wn2 wv1
nv1: $($(nv1))

synopsysVerdi_OpList:=		\
	cvv bv1 tv1 			\
	tv9 					\
	ws2						\
	wv1						\
	sv1						\
	nv1						\


define VERICOMhelp

logDir = /home/bootH/vm3/VMs/topVM/VM.jg1/virtFS.jg1/xilinx_elanCM100_core/ise601/topVERDI/vericomLog
vericom - A HDL Compiler, Release Verdi3_L-2016.06-1 (RH Linux x86_64/64bit) 07/10/2016
(C) 1996 - 2016 by Synopsys, Inc.
All Rights Reserved.
www.synopsys.com

This program is proprietary and confidential information of Synopsys, Inc. and 
may be used and disclosed only as authorized in a license agreement controlling 
such use and disclosure.


Usage: vericom [options] files

Options:
    -2001            Support Verilog IEEE 1364-2001 standard.
    -2001genblk      Use Verilog IEEE 1364-2001 naming style for generate
                     blocks(overrides other language options).
    -2005            Support Verilog IEEE 1364-2005 standard.
    -2009            Support Verilog IEEE 1800-2009 standard.
    -2012            Support Verilog IEEE 1800-2012 standard.
    -ams             Support Verilog-AMS syntax.
    -assert checker|svaext|svvunit
                     Specify the additional syntax to support.
                     checker: Support the checker construct of SystemVerilog IEEE 1800-2009 standard.
                     svaext: Support SystemVerilog Assertion features compliant to IEEE 1800-2009 standard.
                     svvunit: Support PSL vunit syntax. Files with the *.psl file extension will be treated as PSL files.
    -applog          Append the compile messages to log file (The 
                     default mode is overwriting).
    -autoendcelldef  Automatically appends `endcelldefine at the end of 
                     a file if a matching `endcelldefine can not be 
                     found for a declared `celldefine in the file.
    -chmod <numeric_mode>
                     Specify the access attribute for the generated files and directories.
    -comment_transoff_regions -suboption | +suboption
                     Skip source code between translate_off/on pragmas
                     The suboptions are vendor names e.g. cadence, ikos, 
                     mentor, novas, pragma, quickturn, synopsys, synthesis.
    -cuname <compilation-unit name>
                     Support compilation-based compilation-unit mode with specific name.
                     The global space will be modeled as a package named "compilation-unit
                     name". It will be disabled if specified with -cunit.
    -cunit           Support compilation-based compilation-unit mode with default name.
                     The global space will be modeled as a package named "novas_cunit_n"
    +define+<macro>  The +define option is used to specify macros.
                     If the macro is also defined in your source code,
                     it will be overridden by this option. 
    -define <macro>  Define a macro.
    +disable_message+<message_serial_numbers|error|warning>
                     Suppress the specified message(s), all error messages, or all warning
                     messages. Use '+' for different message type combinations.
    -disableVYDbg    Disable the knowledge database creation for -v -y files.
    -error=no<Error_ID>,...
                     Report the specified error messages as warning messages.
                     The following error type is supported:
                       MPD: Module <module_name> redefined
    -errormax <number>
                     Specify the maximum number of errors to report. If the
                     errors exceed the number, the parser will skip reporting
                     the remaining errors.
    -errorstop redefined_module
                     Stop parsing the remaining files when there is a redefined module.
    -extinclude      Compile the included files with the version specified by its extension.
                     When this option is not specified and a source file for one version of
                     Verilog contains the include compiler directive, vericom by default
                     compiles the included file for the same version of Verilog, even if
                     the included file has a different filename extension.
    -extractRTL      Automatically recognizes the RTL storage elements.
                     The extracted storage elements will be saved into 
                     the library.
    -f <filename>    Load an ASCII file containing design source files and
                     additional simulator options.
    -F <filename>    Load an ASCII file containing a specified path to source files and simulator
                     options. Relative path can be used to specify source files.
    -file <filename> Load an ASCII file containing design source files and
                     additional simulator options.
    +fixCellHier+<cell_name>+<library_name>
                     Fix the hierarchy resolving reference libraries for specific cell.
    -forceIncsaveVY  Force the knowledge database creation for -v -y files in each library module
                     resolution to decrease the compilation memory. This option is valid only when
                     "-incsave" is specified.
    -h               Display this help menu.
    -help            Display this help menu.
    -ignore <keyword_argument>
                     Suppress error messages associated with the specified keyword argument.
                     The following keywords are supported:
                       driver_checks
                         Suppress error messages about SystemVerilog driver checking.
    +ignorefileext+<extension_name>
                     Specify the file extension for ignore.
    -ignorekwd_config
                     Ignore the keyword of Verilog IEEE 1364-2001, "config".
    -ignore_macro_redef
                     Suppress warning messages for re-defined macro(s).
    +incdir+<directory_name>
                     Specify the search path for files used by the `include
                     statement.
    -incdir <directory>
                     Specify an include directory.
    -incsave         Specify to decrease the compilation memory.
    -L               Specify the library to search for packages.
    -lib <libName>   Specify the library to save your design to
                     (the default value is "work")
    +libext+<extension_name>
                     Used to specify the file extensions for Verilog library
                     files.
                     See also the -y option.
    -libmap <filename>
                     Specify the library mapping file.
    +liborder        Search for the module definitions of unresolved module
                     instances with the following order: 1. search the remainder
                     of the library where the unresolved module instances were found,
                     2. search through the rest of the libraries, 3. search again from
                     the first library.
    +librescan       Search for the module definitions of unresolved module
                     instances by always starting from the first library list
                     specified in the vericom command line.
    +libverbose      Print a message on the screen and in the compiler.log file to
                     indicate the library file where the instance is resolved when
                     a module is instantiated in the source file or library files.
                     The path of the generated lib++ will also be saved into the log file.
    -logdir <directory>
                     Specify the location of the log directory.
    -nclib           Use NC binding scheme. With this option, vericom
                     looks for libMap, workLibrary, viewMap and
                     defaultView in the [NC_Sim] section of the novas.rc
                     for compiling Verilog source files into Novas' KDB.
    +nlog <filename> Append the compile messages to the specified file.
    -nlog <filename> Output the compile messages to the specified file.
    -ntb_opts ovm[-<version>]
                     Load the OVM library for compilation. To compile an
                     external OVM library, the VCS_HOME or VCS_OVM_HOME
                     environment variable should be set first.
    -ntb_opts rvm|vmm
                     Load the VMM library for compilation. To compile an
                     external VMM library, the VCS_HOME environment variable
                     should be set first.
    -ntb_opts uvm[-<version>]
                     Load the UVM library for compilation. To compile an
                     external UVM library, the VCS_HOME or VCS_UVM_HOME
                     environment variable should be set first.
    -nv <filename>   Specify a library file to use. Modules in this 
                     library file will not be treated as library cells.
    -ny <directory>  Specify a library directory to use. Modules in this 
                     library directory will not be treated as library 
                     cells.
    -onlylog         Dump the compiler.log only without parsing the design.
    +optconfigfile+<cell_configuration_file>
                     Specify the cell information configuration file that describes
                     which module to potentially replace with which module.
    -ovm[-<version>] Load the default Verdi OVM library.
                     If -ovm and -ovmhome are specified at the same time, -ovm will be ignored.
    -ovmhome <path>  Specify the OVM installation directory.
    -P <filename>    Specify a PLI table file.
    +pkgdir+<pkg_name|pkg_full_path>
                     Load the specified DesignWare VIP package(s) as black box(es) by referring
                     to the headers located in the release package or in an absolute path.
                     For example, 
                     > vericom +pkgdir+amba <design> ...
                       -> Compile the amba.f package located in the default product directory.
                       -> Default product directory: "<NOVAS_INST_DIR>/etc/kdb/verilog/dwvip/AMBA_PKG"
                     > vericom +pkgdir+/home/mydwvip/packages/amba <design> ...
                       -> Compile all *.f files in "/home/mydwvip/packages/amba".
    -psl_inline <filename>
                     Extracts inline-PSL code and stores in specified file.
    -psl_inline_append <filename>
                     Extracts inline-PSL code and append to a specified file.
    -pslfile <filename>
                     Treat the specified file as a PSL file. This option will be ignored
                     if the "-assert svvunit" option is not specified.
    -q               Turn on quiet mode.
    -quiet           Disable minor(compile and load) messages. Only the 
                     total number of errors and warnings are reported.
    -rcFile          Specify novas.rc rcFile.
    -realport        Support only the "wreal" keyword in Verilog-AMS. This option
                     also supports the "`wrealXState" or "`wrealZState" macros for
                     the real x or z states respectively.
    -RegPort         When specified, a reg declaration before the output
                     declaration for the same signal will not generate an error.
    -rep[lace]       With this option, vericom removes previously saved Verilog modules
                     in the library before compiling. Without this option, vericom will
                     update existing modules in the library by default.
    +rmkeyword+<keyword(s)>
                     Downgrade the specified keyword(s) to identifier(s).
                     One or more keywords may be specified.
    -rmkeyword <keyword>
                     Downgrade the specified keyword to an identifier.
    -saveOpts        Save the compilation options.
    -silent          Prevent bells (ctrl-G) from being issued.
    +spiceext+<extension_name>
                     Specify the file extension for HSpice files.
    -sort_net_instance
                     Sort the signals and instances alphabetically.
    -stdout          Print compiler messages to stdout.
    -ssv             Library modules in the library file (-v) will not 
                     be tagged as library cells.
    -ssy             Library modules in the library directory (-y) will
                     not be tagged as library cells.
    -ssz             Ignore the `celldefine compiler directives.
    -sv              Support SystemVerilog IEEE 1800-2005 standard.
    -sverilog        Support SystemVerilog IEEE 1800-2005 standard.
    -sv_pragma       Compile the SystemVerilog assertions code that follows
                     the sv_pragma keyword in a comment.
    -syntaxerrormax <number>
                     Specify the maximum number of syntax errors to stop parsing.
                     If the syntax errors exceed the number,
                     the parser will stop parsing the remaining files.
    +systemverilogext+<extension_name>
                     Specify the file extension for SystemVerilog files.
    -timescale=<time_scale>
                      Set the default timescale for the modules without timescale definition.
    -u[ppercase]     Change all identifiers to uppercase.
    -useius          Use IUS style parsing/elaboration.
    -usemti          Use MTI style parsing/elaboration.
    -usevcs          Use VCS style parsing/elaboration.
    -uvm[-<version>] Load the default Verdi UVM library.
                     If -uvm and -uvmhome are specified at the same time, -uvm will be ignored.
    -uvmhome <path>  Specify the UVM installation directory.
    -v <filename>    Modules in the specified file will be treated as library
                     cells.
    -v95             Support Verilog IEEE 1364-1995 standard.
    +v2k             Support Verilog IEEE 1364-2001 standard.
    -vc              Support DirectC syntax.
    +verilog2001ext+<extension_name>
                     Specify the file extension for Verilog 2001 files.
    +v95ext+<extension_name>
                     Specify the file extension for Verilog 1995 files.
    +verilog1995ext+<extension_name>
                     Specify the file extension for Verilog 1995 files.
    -view <viewName> Specify NC viewName. This option is valid only when "-nclib" is specified.
                     This provides the same function as ncvlog 
                     -view view_name to use the specified view name
                     for the design units of the input Verilog source files.
                     For example: vericom -nclib -view novas ../src/novas.v
                     All design units in ../src/novas.v have a view
                     name novas. Note: Using the command line option,
                     -view, overrides defaultView and viewMap variables
                     in novas.rc.
    -wcFile          Support the wildcard file list in a run.f file. Note
                     that the /*...*/ comment syntax is not supported in the
                     run.f file.
    -work <libName>  Specify NC libName. This option is valid only when "-nclib" is specified.
                     This provides the same function as ncvlog 
                     -work library_name to use the specified library name
                     for the design units of the input Verilog source files.
                     For example:
                     vericom -nclib -work novas -view novas -f ../src/novas.f
                     All design units in ../src/novas.f are compiled into
                     the library novas and have a view name novas.
                     Note: Using the command line option,-work, overrides 
                     workLibrary and libMap variables in novas.rc.
    -y <directory_name>
                     Modules in the specified directory will be treated as
                     library cells.

endef

