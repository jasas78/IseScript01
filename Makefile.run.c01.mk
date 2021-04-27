all: 


#GccCccfilterOutList:=
#GccCccextSrcList:=

GccSrcList:=$(filter-out $(GccCccfilterOutList),$(sort \
	$(foreach aa2,$(wildcard src*/*.c) \
	,$(shell realpath $(aa2))) \
	))\
	$(GccCccextSrcList)
export GccSrcList

$(call genVimWithFileList,showSourceCodeTEXT0,$(GccSrcList),vv)





CFGrunGcc01INCset1:=\
	Makefile.6010.gcc.path.mk 	\


CFGrunGccSrcINCset2:=$(foreach aa1,$(CFGrunGcc01INCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunGccSrcINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(GccSrc_OpList)


