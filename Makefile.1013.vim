all:

vpc:=vim_prepare_clean
vpc :
	@mkdir -p _vim/
	@rm -f _vim/cscope.out       _vim/cscope.in?     _vim/tags

vp:=vim_prepare1
vp: vpc
	mkdir -p _vim src1 src2 src3 src9
	@ls $(wildcard ../scriptX/Makefile*)    > _vim/cscope.in0
	@touch _vim/vim_file01.txt _vim/dir_01.txt 
	@cat   _vim/vim_file01.txt |sed -e 's/^ *//g' |sed -e '/^#.*$$/d' |sed -e 's/ *$$//g' |sed -e '/^$$/d' > _vim/cscope.in1
	cat _vim/dir_01.txt |sed -e 's/^ *//g' |sed -e '/^#.*$$/d' |sed -e 's/ *$$//g' |sed -e '/^$$/d' |sort -u \
		|xargs -n 1 -I '{}' find '{}' -maxdepth 1 -type f \
		-name "*.c" -o -name "*.s" -o -name "*.S" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" \
		-o -name "*.sh" -o -name "Makefile*" \
		-o -name "*.v" -o -name "*ucf" \
		-o -name "Kconfig*" \
		-o -name "*config.mk" \
		-o -name "*.conf" \
		|grep -v mod\\.c$$  \
		|sort -u > _vim/cscope.in2
	@cat _vim/cscope.in? |sort -u > _vim/cscope.files
	@rm -f _vim/cscope.in? cscope.out tags
	@ctags -L _vim/cscope.files
	@cscope -Rbu  -k -i_vim/cscope.files 
	sync

_vim/cscope.files : vp


define CallExpandHelpOne
$(1)         => $($(1))$(if $($($(1))),        =>> $($($(1))))

endef

CallExpandHelpDependance=$(if $($(1)), $(eval $($(1)) : $(1) ))

define CallExpandHelpAll
$(eval $(1)=$$(EOL) $(foreach aa1,$(2),   $$(call CallExpandHelpOne,$(aa1))))\
$(eval $(foreach aa1,$(2),$(call CallExpandHelpDependance,$(aa1))))\
$(eval export $(1))
endef









sml:=showVimMakefileList
sml :
	@echo "$${showVimMakefileListText}";echo

define genVimWithFile01
$(iinfo 123,$1,$2,$3)
$(eval gvList1+=$(3)$(gvIdx))

$(eval $(1)+=$$(EOL)    $(3)$(gvIdx)    =>   $(2) )
$(eval                  $(3)$(gvIdx)    :$(EOL)	vim $(2) )

$(eval gvMOD:=$$(shell echo "$$$$(($$(gvIdx) % 5))"))
$(eval ifeq (0,$(gvMOD))$(EOL)$(1)+=$$(EOL)$(EOL)endif)

$(eval gvIdx:=$$(shell echo "$$$$(($$(gvIdx) + 1))"))
endef

define genVimWithFileList
$(eval gvIdx:=1)\
$(eval gvList1:=)\
$(eval gvList2:=)\
$(eval $(1):=)\
$(eval $(foreach aa1,$(2),$(call genVimWithFile01,$(1),$(aa1),$(3))))\
$(iinfo gvList1=$(gvList1))\
$(iinfo gvList2=$(gvList2))\
$(eval export $(1))\

endef

MakefileList:=$(sort $(wildcard $(TM)/Makefile*))
$(call genVimWithFileList,showVimMakefileListText,$(MakefileList),vm)

