all:

bk1:=backup_the_bit_and_mcs_by_date_with_source
bkMCS1=$(strip $(wildcard out/$(FNmcsOut1)))
bkMCS2=$(FNmcsOut1).$(time_called).bk1_mcs
bkBIT1=$(strip $(wildcard out/$(FNbitOut1)))
bkBIT2=$(FNbitOut1).$(time_called).bk1_bit
$(bk1):=Makefile.3060.backupBase.mk
bk1 :
	[ -d bkRAR ] || mkdir bkRAR 
	[ -d bkMCS ] || mkdir bkMCS
	[ -d bkBIT ] || mkdir bkBIT
	[ -z "$(bkMCS1)" ] || ( cp $(bkMCS1)    bkMCS/$(bkMCS2) && ls bkMCS/$(bkMCS2) )
	[ -z "$(bkBIT1)" ] || ( cp $(bkBIT1)    bkBIT/$(bkBIT2) && ls bkBIT/$(bkBIT2) )
	/home/bootH/bin/rar a -m5 -s -hp1 -r- \
		bkRAR/$$(basename $${PWD}).$(time_called).rar \
		$(wildcard bkMCS/$(bkMCS2) ) \
		$(wildcard bkBIT/$(bkBIT2) ) \
		$(foreach bb1, coe ucf v xaw ngc , $(wildcard src?/*.$(bb1) src/*.$(bb1) ))
	ls -l \
		bkRAR/$$(basename $${PWD}).$(time_called).rar 

bk2:=backup_the_bit_and_mcs_by_date_with_cds_coe_for_release_only
bkOBJs=$(strip $(wildcard out/$(FNbitOut1) out/$(FNmcsOut1)))
$(bk2):=Makefile.3060.backupBase.mk
bk2 :
	[ -d 111 ] || mkdir 111
	/home/bootH/bin/rar a -m5 -s -hp1 -r- \
		111/$$(basename $${PWD}).$(time_called).rar \
		$$(realpath cds.now.cds coe.now.coe bit.now.bit mcs.now.mcs) 
	md5sum \
		$$(realpath cds.now.cds coe.now.coe bit.now.bit mcs.now.mcs) \
		|sed -e 's;/.*/;;g'
	ls -l \
		111/*.$(time_called).rar 


#$(error 'RAR1 now <$(RAR1)>')


showRunHelpList += bk1 bk2

