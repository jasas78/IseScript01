all:

$(if $(wildcard openocd_run),,$(shell ln -s $(TM)/openocd_run))

OCDrunPATH?=openocd_run
OCDrunPATH:=$(shell realpath $(OCDrunPATH))
OCDbin:=$(OCDrunPATH)/bin
openocd:=$(OCDbin)/openocd

ifneq (11,$(shell [ -f $(openocd) ] && echo 11 || echo 22))
$(info )
$(info ' openocd , need a dir named "openocd_run" to place the openocd execute-program ')
$(info ' or , being defined in the Makefile.env.mk ')
$(info )
$(error )
endif



$(if $(wildcard cfgOpenOCD),,$(shell ln -s $(TM)/cfgOpenOCD))
cfgOpenOCD:=$(wildcard cfgOpenOCD)

cfgLine1xilinx:= \
				time \
				$(openocd)  \
				-f $(cfgOpenOCD)/ixo-usb-jtag-16c0-06ad.cfg \
				-f $(cfgOpenOCD)/promXCF04S.cfg \
				-f $(cfgOpenOCD)/xc3s500e.cfg

cfgLine2altera:= \
				time \
				$(openocd)  \
				-f $(cfgOpenOCD)/altera-usb-blaster.cfg \
				-f $(cfgOpenOCD)/promXCF04S.cfg \
				-f $(cfgOpenOCD)/xc3s500e.cfg

load_openOCD_firmware:= \
				/home/bootH/LogicAnalyzer/cyusb/fxload-2008_10_13/fxload \
				-v -t fx2lp      \
				-I /home/bootH/Xilinx/ixo-usb-jtag/usbjtag-xpcu_x.hex  \
				-D /dev/bus/usb/001/122


#exit
#jtag init
#reset_config srst_only
#jtag_reset 1 0
#scan_chain
#sleep 1000
#reset_config trst_and_srst
#sleep 100
#jtag_reset 0 0
#svf ../openOCD_x01/1/led4.01.FPGA.run.svf quiet
#svf cfgOpenOCD/led4.01.FPGA.run.svf
#sleep 100
############ obr # begin #######
obrPara1?=svf.FPGA.run.svf
define obrTEXT1 

init 
scan_chain
svf $(cfgOpenOCD)/led4.01.FPGA.run.svf quiet
sleep 100
svf $(obrPara1) quiet
sleep 100
shutdown  33

endef
export obrTEXT1 

obr:=openocd_burn_fpga_for_run_in_RAM ==>> using_Altera_burn_tool
obr:
	echo "$${obrTEXT1}" > tmp/obr01.txt
	echo ; aa1=1 ; while [ $${aa1} -lt 10 ] ; do nohup \
	$(cfgLine2altera)  -f tmp/obr01.txt \
	> \
	tmp/log_obr01.txt 2>&1 ; grep 'commands with 0 errors' \
	tmp/log_obr01.txt && break ; aa1=$$(($${aa1}+1)) ; done ; echo ; \
	[ $${aa1} -lt 10 ] && echo " trying $$((0+$${aa1})) time , then succceed." \
	|| (echo "10 try failed. you maybe need libusb-0.1.so.4 ; apt install libusb-0.1-4 " ;echo ; exit 44)
	@echo
	@grep 'svf'              tmp/obr01.txt
	@echo

showRunHelpList +=obr 
############ obr # end #######

############ obf # begin #######
obfPara1?=svf.FPGA.flash.svf
define obfTEXT1 

init 
svf $(obfPara1)
exit

endef
export obfTEXT1 

obf:=openocd_burn_fpga_for_flash
obf:
	echo "$${obfTEXT1}" > tmp/obf01.txt
	$(cfgLine2altera)  -f tmp/obf01.txt
	@echo
	@grep 'svf'              tmp/obf01.txt
	@echo

showRunHelpList +=obf 
############ obf # end #######

