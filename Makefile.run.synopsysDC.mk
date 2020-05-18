all: 

$(if $(wildcard srcSYN),,$(shell ln -s ../ srcSYN))

RTLhdlSearch:=$(foreach aa1,\
	$(sort $(wildcard srcSYN/src?)),\
	$(aa1))

RTLhdlList:=$(filter-out $(DCfilterOutList),$(sort \
	$(wildcard srcSYN/src?/*.v) \
	))\
	$(DCextSrcList)


#TBhdlList:=$(filter-out $(DCfilterOutList),$(sort \
#	$(wildcard srcSYN/tbSrc?/*.v) \
#	))\
#	$(DCextSrcList)
$(call genVimWithFileList,showSourceCodeTEXT0,$(RTLhdlList) $(TBhdlList),vv)





CFGrunSynopsysDcINCset1:=\
	Makefile.4010.synopsys.path.mk 	\
	Makefile.4025.synopsys.dc.mk		\


CFGrunSynopsysDcINCset2:=$(foreach aa1,$(CFGrunSynopsysDcINCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunSynopsysDcINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(synopsysDC_OpList)


