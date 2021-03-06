all: 

#NFTruleSearch:=$(foreach aa1,\
#	$(sort $(wildcard srcSIM/srcSYN/src?)),\
#    +incdir+$(aa1))
#export NFTruleSearch


NFTruleList:=$(filter-out $(NFTfilterOutList),$(sort \
	$(wildcard src?/*.rule) \
	))\
	$(NFTextSrcList)
export NFTruleList

$(call genVimWithFileList,showSourceCodeTEXT0,$(NFTruleList),vn)





CFGrunLinuxNftINCset1:=\
	Makefile.5000.linuxNft.base.mk \
	Makefile.5001.linuxNft.blockIpv6.mk \
	Makefile.5011.linuxNft.localMachineBaseIpv4_input.mk \
	Makefile.5013.linuxNft.localMachineBaseIpv4_output.mk \
    Makefile.5015.linuxNft.localMachineBaseIpv4_forward.mk \
    Makefile.5021.linuxNft.localMachineBaseIpv4_natPre.mk \
	Makefile.5023.linuxNft.localMachineBaseIpv4_natPost.mk \
	Makefile.5025.linuxNft.localMachineBaseIpv4_natInput.mk \
	Makefile.5027.linuxNft.localMachineBaseIpv4_natOutput.mk \
	Makefile.5029.linuxNft.localMachineBaseIpv4_natForward.mk \
    Makefile.5039.linuxNft.localMachineBaseIpv4_end.mk \
	Makefile.5099.linuxNft.groupS.mk \

#	Makefile.4010.synopsys.path.mk 	\
#	Makefile.4021.synopsys.verdi.mk		\


CFGrunLinuxNftINCset2:=$(foreach aa1,$(CFGrunLinuxNftINCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunLinuxNftINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(linuxNft_OpList)


ifdef rootShowTEXT
$(info )
$(info why rootShowTEXT being redefined ? )
$(info )
$(error )
endif

define rootShowTEXT

as root , you can run the following command manually ONLY.

nft     list      ruleset
nft     list      ruleset -s/--stateless ## Omit stateful information of ruleset.
nft     list      ruleset -a/--handle    ## Output rule handle
nft     list      ruleset -a -s 
nft     flush     ruleset
nft               -i/--interactive       ## Read input from interactive CLI
nft               -c/--check             ## Check commands validity without actually applying the changes

touch        /tmp/nft.rule
chmod  777   /tmp/nft.rule

nft    -f    /tmp/nft.rule
nft    -f -c /tmp/nft.rule

nft    -f    /tmp/nft.rule && nft     list      ruleset
nft    -f    /tmp/nft.rule && rm -f b2.txt && (nft     list      ruleset -a -s > b2.txt) && cat b2.txt
nft    -f    /tmp/nft.rule && rm -f c2.txt && (nft     list      ruleset    -s > c2.txt) && cat c2.txt

nft     list      ruleset       |less
nft     list      ruleset -s -a |less
nft     list      ruleset       > 1.txt ; vim 1.txt
nft     list      ruleset       > 1.txt 

cat 1.txt|grep -n drop      |sed -e '/policy / d' -e '/counter packets 0 bytes 0\b/ d'
cat 1.txt|grep -n accept    |sed -e '/policy / d' -e '/counter packets 0 bytes 0\b/ d'
cat 1.txt|grep -n accept    |sed -e '/counter packets 0 bytes 0\b/ d'|grep ':\s*counter'
cat 1.txt|grep -n '\biif\b' |sed -e '/counter packets 0 bytes 0\b/ d'
cat 1.txt|grep -n '\boif\b' |sed -e '/counter packets 0 bytes 0\b/ d'

cat 1.txt|grep -n comment  |grep counter |grep -v ' packets 0 bytes 0 '|grep ' goto '
cat 1.txt|grep -n comment  |grep counter |grep -v ' packets 0 bytes 0 '|grep ' accept '
cat 1.txt|grep -n comment  |grep counter |grep -v ' packets 0 bytes 0 '|grep ' drop '

echo 0 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/ip_forward


cat /tmp/l1.txt |tail -n 60 |sed -e 's; rule ;\n  &;g' -e 's; counter ;\n  &;g' -e 's; comment ;\n  &;g' -e 's; packet: ;\n  &;g' -e 's; ip saddr ;\n  &;g' -e 's; ip id ;\n  &;g'

(ns|grep ^tcp)|grep LISTEN |sort -k4

nft monitor trac

endef

