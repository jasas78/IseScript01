all: 

$(if $(wildcard srcSYN),,$(shell ln -s ../ srcSYN))

RTLhdlSearch:=$(foreach aa1,\
	$(wildcard srcSYN/src?),\
	+incdir+$(shell realpath $(aa1)))

RTLhdlList:=$(filter-out $(NCfilterOutList),$(sort \
	$(foreach aa2,$(wildcard srcSYN/src?/*.v),$(shell realpath $(aa2))) \
	))\
	$(NCextSrcList)


TBhdlList:=$(filter-out $(NCfilterOutList),$(sort \
	$(foreach aa2,$(wildcard srcSYN/tbSrc?/*.v),$(shell realpath $(aa2))) \
	))\
	$(NCextSrcList)
$(call genVimWithFileList,showSourceCodeTEXT0,$(RTLhdlList) $(TBhdlList),vv)





CFGrunCadenceNcINCset1:=\
	Makefile.4030.cadence.path.mk 	\
	Makefile.4033.cadence.nc.mk		\


CFGrunCadenceNcINCset2:=$(foreach aa1,$(CFGrunCadenceNcINCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunCadenceNcINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(cadenceNC_OpList)


