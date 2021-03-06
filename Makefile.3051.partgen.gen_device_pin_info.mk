

ifeq (,$(strip $(ISEbin)))
$(error "you should define ISEbin and run again" )
endif

define PartGenPara
	-v $(DEV01) \

endef
export PartGenPara

pg:=partgen_gen_device_info
$(pg):=Makefile.3051.partgen.gen_device_pin_info.mk
pg :
	@echo ;echo '---- $(pg) start --- out/$(FNpgLog1)'
	      cd tmp/ && $(ISEbin)/partgen $(PartGenPara) > 51.txt
	echo "cd tmp/ && $(ISEbin)/partgen $(PartGenPara) > 51.txt"     > out/cmd_51_partgen.txt
	@ls -l tmp/51.txt tmp/$(DEV02)*.pkg
	cp  tmp/51.txt                              out/log_51_partgen_$(PROJname).txt
	cat tmp/$(DEV02)*.pkg                     > out/$(DEV01).0.pkg
	cat tmp/$(DEV02)*.pkg |sed -ne '1,5p'     > out/$(DEV01).1.pkg
	cat tmp/$(DEV02)*.pkg |sed -ne '1,5p'     > out/$(DEV01).2.pkg
	cat tmp/$(DEV02)*.pkg |sed -e  '1,5d' \
		|sed -e 's;^pin\b;   pin;g' -e 's;\bP\([0-9]\+\)\b; \1;g' \
		>> out/$(DEV01).1.pkg
	cat tmp/$(DEV02)*.pkg |sed -e  '1,5d' \
		|sed -e 's;^pin\b;   pin;g' -e 's;\bP\([0-9]\+\)\b; \1;g' \
		|sort -k 3 -n                        \
		>> out/$(DEV01).2.pkg

showRunHelpList +=pg   


