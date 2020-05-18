

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

FNbinEXT0:=$(PROJname)_3a_7_bin
FNbinOut0:=obj_$(FNbinEXT0)
FNbinOut1:=$(FNbinOut0).bin
FNbinIn1:=$(FNbitOut1)
FNbinLog1:=log_$(FNbinEXT0).txt
FNbinCmd1:=cmd_$(FNbinEXT0).txt
FNbinScr1:=scr_$(FNbinEXT0).scr


define CMDbinLine1
$(ISEbin)/promgen                       \
	-w \
	-p bin \
	-o $(FNbinOut1)  \
	-u 0 \
	../out/$(FNbinIn1) \

endef
CMDbinLine2:= cd tmp/ && $(CMDbinLine1) > ../out/$(FNbinLog1)
export CMDbinLine2


rr:=run_promgen_to_gen_bin
$(rr):=Makefile.303a.promgen.bin.mk
rr :
	@echo out/$(FNbinLog1) > out/loging.txt
	@echo ;echo '---- $(rr) start --- out/$(FNbinLog1)'
	echo "$${SCRbin1}"     > out/$(FNbinScr1)
	       $(CMDbinLine2)
	@echo "$(CMDbinLine2)"   > out/$(FNbinCmd1)
	cp   tmp/$(FNbinOut1)       out/$(FNbinOut1).3a_2
	mv   tmp/$(FNbinOut1)       out/$(FNbinOut1)



showRunHelpList +=rr   


define promgenHelp
Release 14.7 - Promgen P.20131013 (lin64)
Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
Usage: promgen [-b] [-spi] [-p mcs|exo|tek|hex|bin|ieee1532|ufp] [-o <outfile>
{<outfile>}] [-s <size> {<size>}] [-x <xilinx_prom> {<xilinx_prom>}] [-c
[<hexbyte>]] [-l] [-w] [-bpi_dc serial|parallel] [-intstyle ise|xflow|silent]
[-t <templatefile[.pft]>] [-z [<version:0,3>]] [-i <version:0,3>] [-data_width
8|16|32] [-config_mode sElectmap8|sElectmap16|sElectmap32] {-ver <version:0,3>
<file> {<file>}} {-u <hexaddr> <file> {<file>}} {-d <hexaddr> <file> {<file>}}
{-n <file> {<file>}} {-bd <file> [start <hexaddr>] [tag <tagname> {<tagname>}]}
{-bm <file>} {-data_file up|down <hexaddr> <file> {<file>}} [-r <promfile>] 
 
Where:

 -b           Disable bit swapping.

 -l           Disable length count for daisychain.

 -w           Overwrite existing output file(s).

 -s <size>    PROM size in K bytes (must be power of 2), multiple sizes imply
              splitting the bitstream(s) into multiple PROMs.

 -x <xilinx_prom>
              Specific Xilinx PROM, multiple PROMs imply splitting the
              bitstream(s) into multiple PROMs.

 -p <format>  PROM format (mcs, exo, hex, tek, bin, ieee1532, or ufp)

 -t <templatefile[.pft]>
              Specify a template file for the User Format PROM (ufp).
              If not specified the file $XILINX/data/default.pft is used.
 
 -o <file>    Output PROM file name (default matches first .bit file),
              multiple names may be specified when splitting PROMs.

 -u <hexaddr> <file[.bit]> {<file[.bit]>}
              Load .bit file(s) up from address.  Multiple .bit files are
              daisychained to form a single PROM load.

 -ver <version> <hexaddr> <file[.bit]> {<file[.bit]>}
              Load .bit file(s) up from address.  Multiple .bit files are
              daisychained to form a single PROM load. The daisychain will be
              assigned to the specified version within the PROM. Only valid
              for Xilinx Multi-Bank PROMs. 

 -i <version>
              Select the initial version for a Xilinx Multi-Bank PROM.

 -z [<version>]
              Enable compression for a Xilinx Multi-Bank PROM. All versions
              will be compressed if a specific version is not specified.

 -d <hexaddr> <file[.bit]> {<file[.bit]>}
              Load .bit file(s) down from address.  Multiple .bit files are
              daisychained to form a single PROM load.

 -n <file[.bit]> {<file[.bit]>}
              Load .bit file(s) up or down starting from the next address
              following previous load.  Multiple .bit files are daisychained
              to form a single PROM load.  Must follow a -u, -d, or -n option.

 -r <promfile>
              Load the PROM file.  The -r and the -u, -d and -n options are 
              mutually exclusive.

 -c [<hexbyte>]
              Calculate a 32 bit checksum for each PROM file. The PROM will
              be pre-filled with the value 0xff unless <hexbyte> (a 2 digit
              hexadecimal value) is specified.

 -f <cmdfile>
              Read command line arguments from file <cmdfile>.

 -data_width <8|16|32>
              Change bit/byte ordering in device bitstream depending on the
              device architecture. This option is not valid for all
              architectures, check device data-sheet.

 -bd <file[.elf]> [start <hexaddr>]
              Load .elf or .mem data file up from starting address if specified.
              If start address is not specified, the file will be loaded up from
              end of previous data file.

 -bm <file[.bmm]>
              Load .bmm file to describe formatting of data files.

 -spi
              Disables bit swapping for compatibility with SPI flash devices.

 -bpi_dc <serial|parallel>
              Selects serial or parallel daisy-chain output from first FPGA
              connected in either BPI or SelectMAP modes. Serial daisy-chain is
              only supported for certain families, check device data-sheet.

 -data_file <up|down> <hexaddr> <file> {<file>}
              Specify the starting address, direction and data filenames to add
              into the PROM file. No further formatting will be done on these
              file, they will be added as-is.

At least one -r, -u, -d, or -ver option must appear in the command line.

PROMGEN: Creates memory (PROM) file(s) from configuration (BIT) file(s) for
use in programming a PROM.  The PROM may then be used to configure one or
more FPGAs.
endef

