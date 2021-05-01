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

GccPara01:= -Wall -Werror 
GccPara02:= -Wall -Werror -static 

# define FUNCgccCompileC
# bin/$1.bin : $(foreach bb1,$($1), src*/$(bb1).c )
# 	@echo "build C: $$@ <-- $$^"
# 	test -d bin/ || mkdir bin/
# 	gcc $(GccIncPath)      \
# 		$(GccPara01)   \
# 		$$^    \
# 		-o    $$@
# 
# endef

define FUNCgccCompileO1
$(iinfo oooo1 : $1_$2)
clear_objs_c01 += obj/$1_$2.o 
obj/$1_$2.o : $(firstword $(wildcard src*/$2.c)) $(wildcard incH*/*.h)
	@echo "build O1: $$@ <-- $$^"
	@test -d obj/ || mkdir obj/
	gcc \
		-c \
		$(GccIncPath)      \
		$(GccPara01)   \
		$$<    \
		-o    $$@
endef


define FUNCgccCompileC
$(iinfo cccc1 : $1)

test_objs_List += bin/$1.bin

bin/$1.bin : $(foreach bb1,$($1), obj/$1_$(bb1).o )
	@echo "build Bin: $$@ <-- $$^"
	test -d bin/ || mkdir bin/
	gcc $(GccIncPath)      \
		$(GccPara02)   \
		$$^    \
		-o    $$@


endef

$(foreach aa1,$(GccTOP),$(foreach ee1,$($(aa1)),$(eval $(call FUNCgccCompileO1,$(aa1),$(ee1)))))
$(foreach aa1,$(GccTOP),$(eval $(call FUNCgccCompileC,$(aa1))))

c: clear_objs_c01
clear_objs_c01:
	rm -f $(clear_objs_c01)
	@echo

b : build
build : build_bin
build_bin:=$(foreach aa1,$(GccTOP),bin/$(aa1).bin)
build_bin:$(build_bin)

t:test
test : $(test_objs_List)
	echo $^
	for aa1 in $^ ; do \
		echo ; \
		echo run $${aa1} : start ---- ; \
		./$${aa1} || exit 31 ; \
		echo run $${aa1} : end ---- ; \
		echo ; \
		done


CFGrunGcc01INCset1:=\
	Makefile.6010.gcc.path.mk 	\


CFGrunGccSrcINCset2:=$(foreach aa1,$(CFGrunGcc01INCset1),$(TM)/$(aa1))

$(eval $(foreach aa2,$(CFGrunGccSrcINCset2),$(call tryINCmustExist,$(aa2),db8193912)))


showRunHelpList +=$(GccSrc_OpList)


