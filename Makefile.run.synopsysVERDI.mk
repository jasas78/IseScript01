all: 

VERDIhdlSearch:=$(foreach aa1,\
	$(sort $(wildcard srcSIM/srcSYN/src?)),\
    +incdir+$(aa1))
export VERDIhdlSearch


VERDIhdlList:=$(filter-out $(VERDIfilterOutList),$(sort \
	$(wildcard srcSIM/srcSYN/src?/*.v) \
	$(wildcard srcSIM/srcSYN/tbSrc?/*.v) \
	))\
	$(VERDIextSrcList)
export VERDIhdlList

$(call genVimWithFileList,showSourceCodeTEXT0,$(VERDIhdlList),vv)





CFGrunSynopsysVerdiINCset1:=\
	Makefile.4010.synopsys.path 	\
	Makefile.4021.synopsys.verdi		\


CFGrunSynopsysVerdiINCset2:=$(foreach aa1,$(CFGrunSynopsysVerdiINCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunSynopsysVerdiINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(synopsysVerdi_OpList)


