all: 

$(if $(wildcard srcSYN),,$(shell ln -s ../ srcSYN))

RTLhdlSearch:=$(foreach aa1,\
	$(shell realpath $(wildcard srcSYN/src?)),\
	+incdir+$(aa1))

RTLhdlList:=$(filter-out $(VCSfilterOutList),$(sort \
	$(shell realpath $(wildcard srcSYN/src?/*.v)) \
	))\
	$(VCSextSrcList)


TBhdlList:=$(filter-out $(VCSfilterOutList),$(sort \
	$(shell realpath $(wildcard srcSYN/tbSrc?/*.v)) \
	))\
	$(VCSextSrcList)
$(call genVimWithFileList,showSourceCodeTEXT0,$(RTLhdlList) $(TBhdlList),vv)





CFGrunSynopsysVcsINCset1:=\
	Makefile.4010.synopsys.path.mk 	\
	Makefile.4024.synopsys.vcs.mk		\


CFGrunSynopsysVcsINCset2:=$(foreach aa1,$(CFGrunSynopsysVcsINCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunSynopsysVcsINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(synopsysVCS_OpList)


