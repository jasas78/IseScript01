all:

ERRmsgAnalyzeIseTEXT:= analyze need those VARS.
$(eval $(call testVARmustExist,AnalyzeIseTopXise,ERRmsgAnalyzeIseTEXT))

$(shell [ -d ana ] || mkdir ana)

set_ftp_pass:= set ftp:passive-mode false ;
set_ftp_pass:= echo use_no_passive-mode ;
anaTopIse:=$(AnalyzeIseTopDir)/$(AnalyzeIseTopXise)

iseAnalyzeFileset00:=ana/ana.ise.fileset00.resort.$(AnalyzeIseTopXise).txt
iseAnalyzeFileset01:=ana/ana.ise.fileset01.all.$(AnalyzeIseTopXise).txt
iseAnalyzeFileset02:=ana/ana.ise.fileset02.verilog.$(AnalyzeIseTopXise).txt
iseAnalyzeFileset03:=ana/ana.ise.fileset03.testbenchVerilog.$(AnalyzeIseTopXise).txt
iseAnalyzeFileset04:=ana/ana.ise.fileset04.config.$(AnalyzeIseTopXise).txt
iseAnalyzeFileset05:=ana/ana.ise.fileset05.rtlTopModuleName.$(AnalyzeIseTopXise).txt
iseAnalyzeFileset06:=ana/ana.ise.fileset06.ucf.$(AnalyzeIseTopXise).txt
iseAnalyzeFileset07:=ana/ana.ise.fileset07.xaw.$(AnalyzeIseTopXise).txt
iseAnalyzeFileset08:=ana/ana.ise.fileset08.xise.$(AnalyzeIseTopXise).txt

iseSED000:=\
		|dos2unix \
		|tr -d '\r\n' \
		|sed \
		-e 's;  *; ;g' \
		-e 's;> <association;><association;g' \
		-e 's;> </file;></file;g' \
		-e 's;> <;>\n<;g' \
		|dos2unix 
iseSED010:= |grep 'file xil_pn:name=' 
iseSED020:= |grep    '"FILE_VERILOG"' |grep -v '"PostMapSimulation"'
iseSED040:= |grep -v '"FILE_VERILOG"' 
iseSED030:= |grep '"PostMapSimulation"'
iseSED100:= \
		|sed \
		-e 's;^.*file xil_pn:name=\";;g' 		\
		-e 's;\".*$$;;g' 
iseSED105:= \
		|sed \
		-e 's;^.*|;;g' 		\
		-e 's;\".*$$;;g' 

iseSED050:= |grep '"Implementation Top"'
iseSED060:= |grep '"FILE_UCF"'
iseSED070:= |grep '"FILE_XAW"'
iseSED080:= |grep '"FILE_COREGENISE"'

an1:=iseAnalyzeFileset01
an1:
	cat $(anaTopIse) \
		$(iseSED000) \
		> $(iseAnalyzeFileset00)
	cat $(iseAnalyzeFileset00) \
		$(iseSED010) \
		> $(iseAnalyzeFileset01)
	@
	cat $(iseAnalyzeFileset01) \
		$(iseSED020) \
		> $(iseAnalyzeFileset02)
	cat $(iseAnalyzeFileset01) \
		$(iseSED040) \
		> $(iseAnalyzeFileset04)
	cat $(iseAnalyzeFileset01) \
		$(iseSED030) \
		> $(iseAnalyzeFileset03) || echo "no simulation file Exist."
	cat $(iseAnalyzeFileset00) \
		$(iseSED050) \
		> $(iseAnalyzeFileset05)
	cat $(iseAnalyzeFileset00) \
		$(iseSED060) \
		> $(iseAnalyzeFileset06)
	cat $(iseAnalyzeFileset00) \
		$(iseSED070) \
		> $(iseAnalyzeFileset07) || echo "no XAW file Exist."
	cat $(iseAnalyzeFileset00) \
		$(iseSED080) \
		> $(iseAnalyzeFileset08) || echo "no coreGen file Exist."
	@
	$(foreach aa1,\
		iseAnalyzeFileset02 \
		iseAnalyzeFileset03 \
		iseAnalyzeFileset04 \
		iseAnalyzeFileset06 \
		iseAnalyzeFileset07 \
		iseAnalyzeFileset08 \
		,cat $($(aa1)) \
		$(iseSED100) \
		> $($(aa1)).2 $(EOL))
	cat $(iseAnalyzeFileset05) \
		$(iseSED105) \
		> $(iseAnalyzeFileset05).2
	@
	@wc ana/ana.ise.*.txt*

RTLtopName:=$(strip $(shell [ -f $(iseAnalyzeFileset05).2 ] && cat $(iseAnalyzeFileset05).2))
ifdef RTLtopName
ifneq ($(topModule),$(RTLtopName))
$(info )$(info 'not equal topModule<$(topModule)>, RTLtopName<$(RTLtopName)>')$(info )$(error )
endif
endif

iseRTLverilogListFile=$(iseAnalyzeFileset02).2
$(iseRTLverilogListFile):
	make an1

an2:=link_the_origin_verilog_to_src8_ipcore_to_src2
$(an2):=verilog_RTL
an2: $(iseRTLverilogListFile)
	@cd src8/ && ln -s $(foreach aa1,$(filter-out $(AnalyzeIseExcludeVerilog),$(shell cat $(iseRTLverilogListFile))),../$(AnalyzeIseTopDir)/$(aa1)) ./
	@ls src8/*.v|wc
	@wc ana/ana.ise.*.txt

an3:=link_the_origin_UCF_to_src8_ipcore_to_src2
$(an3):= UCF
an3: $(iseRTLverilogListFile)
	@cd src3/ && ln -s $(foreach aa1,$(shell cat $(iseAnalyzeFileset06).2 ),../$(AnalyzeIseTopDir)/$(aa1)) ./

an4:=link_the_origin_XAW_to_src8_ipcore_to_src2
$(an4):= XAW
an4: $(iseRTLverilogListFile)
an4: 
	cd src4/ && ln -s $(foreach aa1,$(shell cat $(iseAnalyzeFileset07).2 ), \
	$(patsubst %.xaw,%.v,../$(AnalyzeIseTopDir)/$(aa1)) ../$(AnalyzeIseTopDir)/$(aa1)) ./ \
	|| echo "============ no XAW file exist."

an5:=link_the_origin_XISE_to_src8_ipcore_to_src2
$(an5):= XISE
an5: $(iseRTLverilogListFile)
ifdef coreGenRomList
	$(foreach aa1,$(coreGenRomList),\
		@echo;echo '$(aa1) -> $($(aa1))  <<< === $@ parameter , from Makefile.env.mk : you may do : make an5 ipcore_dir/ROM.xise=XXXyyy ' ;echo; \
		$(EOL)\
		$(eval aa2:=$(shell basename $(aa1)))\
		$(eval aa3:=$(shell realpath src5/$(aa2)_cDIR))\
		mkdir -p $(aa3) ;$(EOL) \
		make \
		coreGen \
		-f $(TM)/Makefile.3801.runAlone.coreGen.mk \
		-C $(aa3) \
		cgROMname=$$(realpath nowX/$(aa1)) \
		cgROMcontent=$$(realpath $($(aa1))) \
		TM=$(TM) \
		ISEbin=$(ISEbin) \
		|| exit 45 \
		$(EOL)\
		echo; echo 'make coreGen end' ; \
		md5sum $$(realpath $($(aa1))) ; echo \
		$(EOL)\
		)
	@echo
endif
	$(foreach aa1,$(filter-out $(coreGenRomList),$(shell cat $(iseAnalyzeFileset08).2 )), \
		cd src5/ && ln -s \
		$(patsubst %.xise,%.v 	, ../$(AnalyzeIseTopDir)/$(aa1))  ./ || exit 42 ) 
	$(foreach aa1,$(filter-out $(coreGenRomList),$(shell cat $(iseAnalyzeFileset08).2 )), \
		cd src5/ && ln -s \
		$(patsubst %.xise,%.ngc , ../$(AnalyzeIseTopDir)/$(aa1))  ./ || exit 42 $(EOL)) 
ifdef OptionNoXiseThenUseNGC
	$(foreach aa1,$(OptionNoXiseThenUseNGC), \
		cd src5 && test -e $(shell basename $(aa1)).ngc || ln -s ../nowX/$(aa1).ngc ./ $(EOL) \
		cd src5 && test -e $(shell basename $(aa1)).veo || ln -s ../nowX/$(aa1).veo ./ $(EOL) \
		cd src5 && test -e $(shell basename $(aa1)).v   || ln -s ../nowX/$(aa1).v   ./ $(EOL) \
		)
endif


cannEXT:=\
	v \
	xaw \
	ucf \
	ngc \
	coe \
	asy \
	gise \
	ncf \
	sym \
	veo \
	xco \
	xise \

cann:=clean_analyze_results
cann:
	$(foreach aa1,ana \
		src2 src3 src4 src5 src8, \
		[ -d $(aa1) ] || mkdir $(aa1) $(EOL) )
	rm -f ana/ana.ise.*.txt*
	rm -f $(foreach aa1,\
		src2 src3 src4 src5 src8, \
		$(foreach aa2,\
		\
		$(foreach aa3,$(cannEXT), *.$(aa3)) \
		,\
		$(aa1)/$(aa2)) )
	rm -fr src?/*.xise_cDIR

ann:=analyze_ise_all
$(ann):= cann an1 an2 an3 an4 an5
ann: $($(ann))

tt0:=gen_coe_for_temp_cds
$(tt0):=make tcds -C bkCDS/ && rm -f cds.now.cds coe.now.coe && ln -s bkCDS/cds.now.cds ./ && ln -s bkCDS/coe.now.coe ./ 
tt0:
	$($(tt0))

tt1:=gen_coe_and_burn_only
$(tt1):=make ann && make aaa && make uf

tt2x:=gen_coe_and_burn_form_temp_cds
$(tt2x):= make tt0 && make tt1 && make bk2

tt211:=loop_the_tt2_by_ftp_automaticly_single_step

tt22:=loop_the_tt2_by_ftp_automaticly_loop

tt1:
	$($(tt1))
tt2x:
	$($(tt2x))

t1wFname1:=start.tt22_genAndBurn.txt
t1wFname2:=start.tt23_genCoeOnly.txt
t1wRM1:=/cds/$(t1wFname1)
t1wRM2:=/cds/$(t1wFname2)
ftpt1r:=ftp://t1:t1@192.168.1.93/
ftpt1w:=ftp://t1w:t1w@192.168.1.93/
ftpTT221:=$(ftpt1r)/$(t1wRM1)
ftpTT222:=$(ftpt1r)/$(t1wRM2)
cdsTT22oo:=elan_tran01.cds
cdsTT22:=$(ftpt1r)/cds/$(cdsTT22oo)
startTT221:=tt21tmp/$(t1wFname1)
startTT222:=tt21tmp/$(t1wFname2)
errTT22:=tt21tmp/100_error_reason.txt 
cdsTT22in:=tt21tmp/$(cdsTT22oo)

MD5cds6=$(call M6,cds.now.cds)
MD5cds8=$(call M8,cds.now.cds)
MD5coe6=$(call M6,coe.now.coe)
MD5coe8=$(call M8,coe.now.coe)
MD5mcs6=$(call M6,mcs.now.mcs)
MD5mcs8=$(call M8,mcs.now.mcs)

tt215:
	echo cds.now.cds_$(call M6,cds.now.cds)
	echo cds.now.cds_$(call M8,cds.now.cds)
	echo mcs.now.mcs_$(call M6,mcs.now.mcs)
	echo mcs.now.mcs_$(call M8,mcs.now.mcs)
	echo cds.$(MD5cds6)
	echo cds.$(MD5cds8)
	echo mcs.$(MD5mcs6)
	echo mcs.$(MD5mcs8)

tt211:
	rm -fr tt21tmp.bak9
	-mv tt21tmp.bak8 tt21tmp.bak9
	-mv tt21tmp.bak7 tt21tmp.bak8
	-mv tt21tmp.bak6 tt21tmp.bak7
	-mv tt21tmp.bak5 tt21tmp.bak6
	-mv tt21tmp.bak4 tt21tmp.bak5
	-mv tt21tmp.bak3 tt21tmp.bak4
	-mv tt21tmp.bak2 tt21tmp.bak3
	-mv tt21tmp.bak1 tt21tmp.bak2
	-mv tt21tmp tt21tmp.bak1
	mkdir tt21tmp
	# ' no no_tmp_md5_file_exist . exit.'
	@while [ 1 ] ; do \
		rm -f tt21tmp/* ; \
		( cd tt21tmp && wget -q $(ftpTT221) &>/dev/null ; sleep 1 ) ; \
		( cd tt21tmp && wget -q $(ftpTT222) &>/dev/null ; sleep 1 ) ; \
		test -f $(startTT221)  && grep -q ^tt22 $(startTT221) && echo "$(startTT221) found " && break ; \
		test -f $(startTT222)  && grep -q ^tt22 $(startTT222) && echo "$(startTT222) found " && break ; \
		echo "`date ` : makeing tt211 , no $(ftpTT221) or $(ftpTT222) exist. wait 10 second... " ; \
		sleep 10 ; \
		done || echo -n 
	LD_LIBRARY_PATH=/lib64:/usr/lib64 lftp -e "$(set_ftp_pass) rm -r /tt21tmp/ ; rm $(t1wRM1) $(t1wRM2) ; quit" $(ftpt1w) || echo -n
	[ -f tt21tmp/$(t1wFname1) ] && make tt2121 || echo -n
	[ -f tt21tmp/$(t1wFname2) ] && make tt2122 || echo -n

tt2121 : tt21tmp/$(t1wFname1) 
	rm -f  $<
	@echo "`date ` : $< found --==>  makeing $@ , start ...." ; 
	cd tt21tmp && wget -q $(cdsTT22) 
	make tt214 \
		|| (echo ' 99 : during the process , some error found .' >> $(errTT22) )
	sleep 1
	wput tt21tmp/ $(ftpt1w)

tt2122 : tt21tmp/$(t1wFname2) 
	rm -f  $<
	@echo "`date ` : $< found --==>  makeing $@ , start ...." ; 
	cd tt21tmp && wget -q $(cdsTT22) 
	rm -f bkCDS/tmp.cds
	cp tt21tmp/$(cdsTT22oo) bkCDS/tmp.cds
	make tt0
	sleep 1
	wput tt21tmp/ $(ftpt1w)

tt214:
	sleep 1
	echo "`date +%s` `date`"      >  tt21tmp/100_start_time.txt
	[ -n "$(cdsTT22in)" -a -f "$(cdsTT22in)" ] || ( \
		echo ' 101 : not found $(cdsTT22in) ' >> $(errTT22) \
		; exit 23 )
	[ $$(cat $(cdsTT22in)|wc -c ) = 8268 ] || ( \
		echo ' 102 : size error $(cdsTT22in) ' >> $(errTT22) \
		; wc $(cdsTT22in) >> $(errTT22) \
		; exit 23 )
	md5sum $(cdsTT22in) >> tt21tmp/201_cds_md5_$(MD5cds8).txt
	wc     $(cdsTT22in) >> tt21tmp/202_cds_size.txt
	rm -f bkCDS/tmp.cds
	cp     $(cdsTT22in)     bkCDS/tmp.cds
	realpath nowX/               >  tt21tmp/301_building_log.txt
	basename `realpath nowX/`   >>  tt21tmp/301_building_log.txt
	echo                        >>  tt21tmp/301_building_log.txt
	nohup make tt2x             >>  tt21tmp/301_building_log.txt
	cp mcs.now.mcs    tt21tmp/
	cp cds.now.cds    tt21tmp/cds.$(MD5cds8).cds
	cp coe.now.coe    tt21tmp/coe.$(MD5cds8)_$(MD5coe8).coe
	cp mcs.now.mcs    tt21tmp/mcs.$(MD5cds8)_$(MD5mcs8).mcs
	realpath nowX/  > tt21tmp/fpga_netlist_version_`realpath  nowX/|awk -F/ '{printf $$NF}'`.txt
	cat tt21tmp/301_building_log.txt > 111/301_building_log.txt
	cat tt21tmp/301_building_log.txt \
		|sed \
		-e '1,/^Evaluation copy. Please register./ d' \
		-e '1,/^Evaluation copy. Please register./ d' \
		-e '1,/^Evaluation copy. Please register./ d' \
		-e '1,/^Evaluation copy. Please register./ d' \
		-e '1,/^Evaluation copy. Please register./ d' \
		> tt21tmp/302_building_check.txt 
	wc tt21tmp/302_building_check.txt  \
		> tt21tmp/303_result.txt  
	cat tt21tmp/301_building_log.txt \
		| grep ^'Evaluation copy. Please register' \
		|wc \
		> tt21tmp/304_result.txt  
	cnt1=$$(cat tt21tmp/304_result.txt  |$(awk) '{printf $$1}') ; \
		 [ $${cnt1} = 3 ] \
		 && (echo $${cnt1} > tt21tmp/305_result.txt)  \
		 || ( \
		 echo ' 101 : not found $(cdsTT22in) ' >> $(errTT22) \
		 ; exit 35 )
	echo "`date +%s` `date`"      >  tt21tmp/999_all_ok.txt
	$(RAR9) tt22.ok.$(time_called).rar tt21tmp/
	mv      tt22.ok.$(time_called).rar tt21tmp/


tt22:
	while [ 1 ] ; do make tt211 || exit 32 ; sleep 5 ; done

tt3File:=111/nowFPGA.txt 
mcsDIR:=$(strip $(shell test -f $(tt3File) && (cat $(tt3File) |head -n 1|$(awk) '{print $$1}')))
coeDIR:=$(mcsDIR)/ipcore_dir/rom_code/
mcsPATH:=/now.mcs
coePATH:=$(coeDIR)/now.coe
ftpPATH:=ftp://coe:coe@192.168.1.93/
bitPATH:=$(mcsDIR)/fpga_top.bit

tt3check:=[ -n "$(mcsDIR)" ] || ( echo ; echo 'you should put the fpga dir in the $(tt3File)' ; echo ; exit 22 )
tt31:=upload_the_coe_to_windows
tt31:
	$(tt3check)
	wput -u -nc coe.now.coe $(ftpPATH)/$(coePATH)
	@echo "the old now.bit md5sum is `md5sum now.bit`"
	-LD_LIBRARY_PATH=/lib64:/usr/lib64 lftp -e "$(set_ftp_pass)rm /$(mcsDIR)/fpga_top.bit;quit" ftp://coe:coe@192.168.1.93/
	@md5sum      coe.now.coe
	cat coe.now.coe > 111/coe.now.coe

tt32:=download_the_bit_file_from_windows
tt32:
	$(tt3check)
	wget $(ftpPATH)/$(bitPATH) -O - > now.bit
	[ "$$(cat now.bit|wc -c)" = 283886 ] 
	@ls -l                            now.bit
	@md5sum                           now.bit

cdsNOWmd5:=$(shell md5sum cds.now.cds |$(awk) '{printf $$1}'|sed -e 's;^.*\(......\)$$;\1;g')
tt33:=gen_another_mcs_from_now.bit
tt33:
	make rs anotherBIT=now.bit
	cat now.bit.mcs >            mcs.another.mcs
	@md5sum                      mcs.another.mcs
	cat now.bit.mcs >            111/1_$(cdsNOWmd5).mcs
	@ls -l                       111/1_$(cdsNOWmd5).mcs
	[ '780476' = `cat mcs.another.mcs|wc -c` ] && echo size ok.

tt41:=gen_coe_and_upload_to_win
$(tt41):= make tt0 && make tt31
tt41:
	$($(tt41))
tt42:=down_bit_and_gen_mcs_and_upload_to_flash
$(tt42):= make tt32 && make tt33 && make nf
tt42:
	$($(tt42))

showRunHelpList +=  $($(ann)) ann tt0 tt1 tt2x tt22 tt31 tt32 tt33 tt41 tt42

