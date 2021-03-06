

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

FNbitEXT0:=$(PROJname)_39_6_bit
FNbitOut0:=obj_$(FNbitEXT0)
FNbitOut1:=$(FNbitOut0).bit
FNbitIn1:=$(FNparOut1)
FNbitLog1:=log_$(FNbitEXT0).txt
FNbitCmd1:=cmd_$(FNbitEXT0).txt
FNbitScr1:=scr_$(FNbitEXT0).scr

# bitgen -intstyle ise -f LED4.ut LED4.ncd

define SCRbit1
-w
-g DebugBitstream:No
-g Binary:no
-g CRC:Enable
-g ConfigRate:1
-g ProgPin:PullUp
-g DonePin:PullUp
-g TckPin:PullUp
-g TdiPin:PullUp
-g TdoPin:PullUp
-g TmsPin:PullUp
-g UnusedPin:Pullnone
-g UserID:0xFFFFFFFF
-g DCMShutdown:Disable
-g StartUpClk:CClk
-g DONE_cycle:4
-g GTS_cycle:5
-g GWE_cycle:6
-g LCK_cycle:NoWait
-g Security:None
-g DonePipe:No
-g DriveDone:No

endef
export SCRbit1


define CMDbitLine1
$(ISEbin)/bitgen              			\
	-b									\
	-f ../out/$(FNbitScr1)          	\
	../out/$(FNbitIn1)					\
	$(FNbitOut1)						\
	../out/$(FNmapOut2pcf) 				\

endef

CMDbitLineF2:= cd tmp/ && $(CMDbitLine1) > ../out/$(FNbitLog1) 
export CMDbitLineF2


rb:=run_bitgen
$(rb):=Makefile.3039.bitgen.mk
rb :
	@echo out/$(FNbitLog1) > out/loging.txt
	@echo ;echo '---- $(rb) start --- out/$(FNbitLog1)'
	echo "$${SCRbit1}"     > out/$(FNbitScr1)
	       $(CMDbitLineF2)
	@echo "$(CMDbitLineF2)"   > out/$(FNbitCmd1)
	cp   tmp/$(FNbitOut1)		out/$(FNbitOut1).39_2
	mv   tmp/$(FNbitOut1)		out/$(FNbitOut1)
	rm -f                       bit.now.bit
	ln -s out/$(FNbitOut1)      bit.now.bit

showRunHelpList +=rb   


define bitgenHelp
Release 14.7 - Bitgen P.20131013 (lin64)
Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
Usage: bitgen [-d] [-j] [-b] [-w] [-l] [-m] [-t] [-n] [-u] [-a] [-r <bitFile>]
[-intstyle ise|xflow|silent|pa] [-ise <projectrepositoryfile>] {-bd
<BRAM_data_file> [tag <tagname>]} {-g <setting_value>} [-filter
<filter_file[.filter]>] <infile[.ncd]> [<outfile>] [<pcffile[.pcf]>]
 
Where:
  -d            = Don't Run DRC (Design Rules Checker)
  -j            = Don't create bit file
  -b            = Create rawbits file
  -w            = Overwrite existing output file
  -l            = Create logic allocation file
  -m            = Create mask file
  -t            = Tie down unused interconnect
  -n            = Save tied ncd as _<file>.ncd
  -u            = Use critical nets as last resort during tiedown
  -a            = Attempt "full" tiedown, allowing use of user signals
  -f <cmdfile>  = Read command line arguments from file <cmdfile>
  -r <bitfile>  = Create a partial bit file using <bitfile> as reference
  -bd <memfile> = Update BlockRAM contents with data from file <memfile>
  -g <opt:val>  = Set architecture specific option "opt" to value "val"

Use "bitgen -help <architecture>" to display architecture specific options.

BITGEN:  Creates the configuration (BIT) file based on the contents of a
physical implementation file (NCD).  The BIT file defines the behavior of
the programmed FPGA.

Valid architectures are:
   aartix7
   artix7l
   aspartan3
   aspartan3a
   aspartan3adsp
   aspartan3e
   aspartan6
   kintex7
   kintex7l
   qartix7
   qkintex7
   qkintex7l
   qrvirtex4
   qspartan6
   qspartan6l
   qvirtex4
   qvirtex5
   qvirtex6
   qvirtex6l
   qvirtex7
   spartan3
   spartan3a
   spartan3e
   spartan6
   spartan6l
   virtex4
   virtex5
   virtex6
   virtex6l
   virtex7

Release 14.7 - Bitgen P.20131013 (lin64)
Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
Usage: bitgen [-d] [-j] [-b] [-w] [-l] [-m] [-t] [-n] [-u] [-a] [-r <bitFile>]
[-intstyle ise|xflow|silent|pa] [-ise <projectrepositoryfile>] {-bd
<BRAM_data_file> [tag <tagname>]} {-g <setting_value>} [-filter
<filter_file[.filter]>] <infile[.ncd]> [<outfile>] [<pcffile[.pcf]>]
 
Where:
  -d            = Don't Run DRC (Design Rules Checker)
  -j            = Don't create bit file
  -b            = Create rawbits file
  -w            = Overwrite existing output file
  -l            = Create logic allocation file
  -m            = Create mask file
  -t            = Not supported for this architecture
  -n            = Not supported for this architecture
  -u            = Not supported for this architecture
  -a            = Not supported for this architecture
  -f <cmdfile>  = Read command line arguments from file <cmdfile>
  -r <bitfile>  = Create a partial bit file using <bitfile> as reference
  -bd <memfile> = Update BlockRAM contents with data from file <memfile>
  -g <opt:val>  = Set option to value, options are (1st is default):

  Compress
  Readback
  CRC             Enable, Disable
  DebugBitstream  No, Yes
  ConfigRate      1, 3, 6, 12, 25, 50
  StartupClk      Cclk, UserClk, JtagClk
  DCMShutdown     Disable, Enable
  DonePin         Pullup, Pullnone
  ProgPin         Pullup, Pullnone
  TckPin          Pullup, Pulldown, Pullnone
  TdiPin          Pullup, Pulldown, Pullnone
  TdoPin          Pullup, Pulldown, Pullnone
  TmsPin          Pullup, Pulldown, Pullnone
  UnusedPin       Pulldown, Pullup, Pullnone
  DONE_cycle      4, 1, 2, 3, 5, 6
  GWE_cycle       6, 1, 2, 3, 4, 5, Done, Keep
  GTS_cycle       5, 1, 2, 3, 4, 6, Done, Keep
  LCK_cycle       NoWait, 0, 1, 2, 3, 4, 5, 6
  Persist         No, Yes
  DriveDone       No, Yes
  DonePipe        No, Yes
  Security        None, Level1, Level2
  UserID          0xFFFFFFFF, <hex string>
  MultiBootMode   No, Yes
  ActivateGclk    No, Yes
  ActiveReconfig  No, Yes
  PartialMask0    <string>
  PartialMask1    <string>
  PartialMask2    <string>
  PartialGclk
  PartialLeft
  PartialRight
  TimeStamp       Default, Blank, <string>
  IEEE1532        No, Yes
  Binary          No, Yes

BITGEN:  Creates the configuration (BIT) file based on the contents of a
physical implementation file (NCD).  The BIT file defines the behavior of
the programmed FPGA.
endef

