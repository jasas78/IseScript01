all: 

XD1:=$(wildcard $(shell realpath $(TM)/settings64.sh))
$(info XD1:$(XD1))
XD2:=$(shell dirname  $(if $(XD1),$(XD1),/))
XD3:=$(XD2)/ISE/bin/lin64
Xilinx_lic_path2:=$(firstword $(wildcard \
	$(XD2)/../../../Xilinx_ise.lic \
	$(XD2)/../../Xilinx_ise.lic \
	$(XD2)/../Xilinx_ise.lic \
	$(XD2)/Xilinx_ise.lic \
	))
Xilinx_lic_path:=$(shell realpath $(if $(Xilinx_lic_path2),$(Xilinx_lic_path2),./Xilinx_ise.lic))

XILINXD_LICENSE_FILE:=$(Xilinx_lic_path)
export XILINXD_LICENSE_FILE

### you can pre-define the following envVARs
LDso641?=LD_PRELOAD=/home/bootH/Xilinx/usb-driver/libusb-driver.so.64.so 
#ISEbin?=/e/eda2544/ise14.7xinlinx/14.7/ISE_DS/ISE/bin/lin64
ISEbin?=$(XD3)
export LDso641
export ISEbin





define known_xilinxFpga_list
spartan3adsp : xc3sd3400a-fg676-4
spartan3e    : xc3s500e-pq208-4

endef
export known_xilinxFpga_list


DEV01?=xc3s500e-pq208-4
DEV02?=$(shell echo $(DEV01)|sed -e 's;[-_].*$$;;g')
DEV11:=
ifeq ($(DEV02),xc3s500e)
DEV11:=spartan3e
DEV21:=xcf04s
endif
ifeq ($(DEV02),xc3sd3400a)
DEV11:=spartan3adsp
DEV21:=xcf04s
endif
ifeq ($(strip $(DEV11)),)
$(info )
$(info $(known_xilinxFpga_list) )
$(info )
$(error )
endif

export DEV01
export DEV02
export DEV11
export DEV21

JtagPart1?=$(DEV02)
JtagPart2?=$(DEV21)
#addDevice -p 1 -part xc3s500e
#addDevice -p 2 -part xcf04s

