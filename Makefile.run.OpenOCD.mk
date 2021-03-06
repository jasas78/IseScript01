all: 

CFGrunOpenocdINCset1:=\
	Makefile.3031.ise.path.mk		\
	Makefile.3044.impact.gen_svf_for_run.mk		\
	Makefile.3045.impact.gen_svf_for_burn_flash.mk		\
	Makefile.3046.openocd.burn.svf.mk		\

CFGrunOpenocdINCset2:=$(foreach aa1,$(CFGrunOpenocdINCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunOpenocdINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


define burn_basic
	LD_LIBRARY_PATH=/home/bootH/LogicAnalyzer/cyusb/cyusb_linux_1.0.4_64bit/lib \
					/home/bootH/LogicAnalyzer/cyusb/cyusb_linux_1.0.4_64bit/src/download_fx2 \
					-i usbjtag-basic.hex.portD.0x16C0.0x06AD.iic -t LI2C

	 /home/bootH/LogicAnalyzer/cyusb/fxload-2008_10_13/fxload -v \
		 -t fx2lp  \
		 -I /lib/firmware/ixo-usb-jtag/usbjtag-saxo_l.hex -D /dev/bus/usb/001/123

endef


define showRunHelpTEXText2

 1st : load the ixo-usb-jtag : usbjtag-xpcu_x.hex for XILINX platform cable usb DLC9G with fpga(outside flash)   
                            or usbjtag-xpcu_i.hex for XILINX platform cable usb DLC9G with cpld(inside  flash)   
$(load_openOCD_firmware)
  
  
2nd : then , use the openocd  
  
$(cfgLine1xilinx)  
$(cfgLine2altera)  
  
3rd : telnet 127.0.0.1 4444  
      jtag init 
      scan_chain 

4th : or , you can add "init", "svf XXX.svf", and "exit" into a file named cmd01.txt, then ,

$(cfgLine2altera)  \
	-f cmd01.txt
  
endef

OCDcfgList:=$(sort $(wildcard $(cfgOpenOCD)/*.cfg))
$(call genVimWithFileList,showSourceCodeTEXT0,$(OCDcfgList),vv)

showRunHelpList +=gvrUSAGE gvfUSAGE


