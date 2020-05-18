all: 

VERDIhdlSearch:=$(foreach aa1,\
	$(sort $(wildcard srcSIM/srcSYN/src?)),\
    +incdir+$(shell realpath $(aa1)))
export VERDIhdlSearch


VERDIhdlList:=$(filter-out $(VERDIfilterOutList),$(sort \
	$(foreach aa2,$(wildcard srcSIM/srcSYN/src?/*.v) \
	$(wildcard srcSIM/srcSYN/tbSrc?/*.v),$(shell realpath $(aa2))) \
	))\
	$(VERDIextSrcList)
export VERDIhdlList

$(call genVimWithFileList,showSourceCodeTEXT0,$(VERDIhdlList),vv)





CFGrunSynopsysVerdiINCset1:=\
	Makefile.4010.synopsys.path.mk 	\
	Makefile.4021.synopsys.verdi.mk		\


CFGrunSynopsysVerdiINCset2:=$(foreach aa1,$(CFGrunSynopsysVerdiINCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunSynopsysVerdiINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(synopsysVerdi_OpList)


