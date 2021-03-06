

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

FNuufEXT0:=$(PROJname)_42_11_uuf
FNuufIn1:=$(FNparOut1)
FNuufLog1:=log_$(FNuufEXT0).txt
FNuufCmd1:=cmd_$(FNuufEXT0).txt
FNuufScr1:=scr_$(FNuufEXT0).scr



ifeq (,$(ufufuf))
ufufufX:=out/$(FNmcsOut1)
FNuufIn1:=$(shell realpath $(ufufufX) )
else
ufufufX:=out/$(ufufuf) $(TM)/$(ufufuf)
ifeq (,$(firstword $(wildcard $(ufufufX))))
$(info )
$(info 'file not found :$(ufufufX)' )
$(info )
$(error )
endif
FNuufIn1:=$(shell realpath $(firstword $(wildcard $(ufufufX) )))
endif

ifdef AnotherDST
AnotherDSTuf:=$(shell realpath $(AnotherDST))
else
AnotherDSTuf:=$(shell realpath $(FNuufIn1))
endif

#setCable -port auto
#setCable -port usb21
#######
# ERROR:Portability:90 - Command line error: Switch "-port" has invalid value.
# Argument[2] "usb11" needs to match one of these keywords:
# "lpt1|lpt2|lpt3|com1|com2|com3|com4|usb0|usb1|usb2|usb21|usb22|usb23|usb24|us
# b25|usb26|usb27|usb28|usb29|usb210|parport0|parport1|parport2|parport3|ttya|t
# tyb|tty00|tty01|ttyS0|ttyS1|ttyS2|ttyS3|xsvf|svf|stapl|auto|null".


define SCRuuf1
setMode -bscan
setCable -port usb21
Identify -inferir 
identifyMPM 
assignFile -p 2 -file $(AnotherDSTuf)
setAttribute -position 2 -attr packageName -value ""
ReadIdcode -p 2 
Program -p 2 -e -v 
quit

endef
export SCRuuf1

ufo:=upload_to_flash_only
$(ufo):=Makefile.3042.impact.upload_to_flash.mk
ufo :
	@echo out/$(FNuufLog1) > out/loging.txt
	@echo ;echo '---- $(uf) start --- out/$(FNuufLog1) --- burn into flash --->> $(AnotherDSTuf) ' ; echo
	[ -f $(AnotherDSTuf) ]
	md5sum $(AnotherDSTuf) 
	@echo "$${SCRuuf1}" > out/$(FNuufScr1)
	       cd tmp/ && $(LDso641) $(ISEbin)/impact -batch < ../out/$(FNuufScr1)  > ../out/$(FNuufLog1)
	echo  "cd tmp/ && $(LDso641) $(ISEbin)/impact -batch < ../out/$(FNuufScr1)  > ../out/$(FNuufLog1)" > out/$(FNuufCmd1)
	@grep Programming out/$(FNuufLog1)
	md5sum $(AnotherDSTuf) 
	cp $(AnotherDSTuf) \
		bkMCS/mcs_$(time_called)_$(shell md5sum $(AnotherDSTuf)|$(awk) '{printf $$1}'||echo -n _noMD5_).mcs

uf:=impact_upload_to_flash_and_backup
$(uf):=ufo bk1
uf : $($(uf))
	(md5sum $$(realpath coe.now.coe cds.now.cds bit.now.bit) \
		|sed -e 's;/.*/;;g' )|| echo -n ''

## bk1 --> backup_the_bit_and_mcs_by_date_with_source -> see Makefile.3060.backupBase

showRunHelpList +=ufo uf

uf2:=$(uf)____use_the_$(FNmcsOut1).2.mcs
uf3:=$(uf)____use_the_$(FNmcsOut1).3.mcs
uf4:=$(uf)____use_the_$(FNmcsOut1).4.mcs
showRunHelpList +=uf2
showRunHelpList +=uf3
showRunHelpList +=uf4

uf2:
	make uf ufufuf=$(FNmcsOut1).2.mcs
uf3:
	make uf ufufuf=$(FNmcsOut1).3.mcs
uf4:
	make uf ufufuf=$(FNmcsOut1).4.mcs

