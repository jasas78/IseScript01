all: 


ifeq (,$(GccTOP))
$(info )
$(info ' c lang project , should has a VAR named GccTOP being defined in Makefile.env.mk')
$(info '                   as the end target name; ')
$(info ' and the src files being put into the src?/*.go' )
$(info )
$(error )
else
#$(info )
#$(info ' c lang project : $(GccTOP)')
#$(info )
endif


#GccCccfilterOutList:=
#GccCccextSrcList:=

GccSrcList:=$(filter-out $(GccCccfilterOutList),$(sort \
	$(foreach aa2,$(wildcard src*/*.c) \
	,$(shell realpath $(aa2))) \
	))\
	$(GccCccextSrcList)
export GccSrcList

$(call genVimWithFileList,showSourceCodeTEXT0,$(GccSrcList),vv)

GccIncPath:=$(foreach aa1,$(sort $(wildcard incH?/)), -I $(aa1))

GccPara01:= -static -Werror 

define FUNCgccCompile
bin/$1.bin : $(foreach bb1,$($1), src*/$(bb1).c )
	@echo "build : $$@ <-- $$^"
#	@echo "build : $@ <-- $^"
	gcc $(GccIncPath)      \
		$(GccPara01)   \
		$$^    \
		-o    $$@

endef

$(foreach aa1,$(GccTOP),$(eval $(call FUNCgccCompile,$(aa1))))


b : build_bin
build_bin:=$(foreach aa1,$(GccTOP),bin/$(aa1).bin)
build_bin:$(build_bin)



CFGrunGcc01INCset1:=\
	Makefile.6010.gcc.path.mk 	\


CFGrunGccSrcINCset2:=$(foreach aa1,$(CFGrunGcc01INCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunGccSrcINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(GccSrc_OpList)


