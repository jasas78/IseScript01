all:

vpc:=vim_prepare_clean
vpc :
	@mkdir -p _vim/
	@rm -f _vim/cscope.out       _vim/cscope.in?     _vim/tags


vFFset01:=\
	*.c  *.s  *.S  *.h  *.cpp  *.hpp \
	*.sh  Makefile*  \
	Kconfig* *config.mk *.conf \
	*.v  *.ucf scr*.scr *.ncd \
	*.go \

vp:=vim_prepare1
vp: vpc
	@#mkdir -p _vim src1 src2 src3 src9
	@[ -d src9 ] || mkdir src9
	@ls $(wildcard $(TM)/Makefile*)    > _vim/cscope.in0
	@touch _vim/vim_file01.txt _vim/dir_01.txt 
	@
	@echo -n > _vim/cscope.in1
	@$(foreach ff1,$(strip $(shell cat   _vim/vim_file01.txt)),\
		echo $(ff1)|sed -e 's/^ *//g' |sed -e '/^#.*$$/d' |sed -e 's/ *$$//g' |sed -e '/^$$/d' >> _vim/cscope.in1 $(EOL))
	@
	@echo -n > _vim/cscope.in2
	@echo $(wildcard \
		$(foreach ff1,$(strip $(shell cat _vim/dir_01.txt |sed -e 's/^ *//g' |sed -e '/^#.*$$/d' |sed -e 's/ *$$//g' |sed -e '/^$$/d' |sort -u )),\
		$(foreach ff2,$(vFFset01),$(ff1)/$(ff2)))\
		)\
		|tr ' ' '\n' \
		|grep -v mod\\.c$$  \
		|grep -v '^ *$$' \
		|sort -u \
		>> _vim/cscope.in2
	@
	@cat _vim/cscope.in? \
		|sort -u \
		|xargs -n 10 realpath \
		>_vim/cscope.files
	@
	@#rm -f _vim/cscope.in? cscope.out tags
	@ctags -L _vim/cscope.files
	@cscope -Rbu  -k -i _vim/cscope.files 
	@wc _vim/cscope.files 
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
$(sml):=show_all_makefiles_in_script_dir_for_vim_______script_dir
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

