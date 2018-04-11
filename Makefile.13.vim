
vim_prepare_clean :
	@mkdir -p _vim/
	@rm -f _vim/cscope.out       _vim/cscope.in?     _vim/tags

vp vim_prepare1 : vim_prepare_clean
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

vsList:=$(shell test -f _vim/cscope.files && cat _vim/cscope.files |grep -v /Makefile|sort -u )

vsHelpTEXT:=
vsIdx:=0
define CallVimSrcS
$$(eval vsIdx:=$$(shell echo "$$$$(($$(vsIdx) + 1))") )
vsHelpTEXT+=    v$$(vsIdx)   : $(1)$$(EOL)   
v$$(vsIdx)   : vp
	@echo
	make vp
	vim $(1)$$(EOL)
	@echo
	$$(bt111)   $(1)
	make vp
	@echo

endef

$(foreach aa1,$(vsList),$(eval $(call CallVimSrcS,$(aa1))))
export vsHelpTEXT
vs:=vim_show_file_list 
vs $(vs) : 
	@[ -f _vim/cscope.files ] || make vp
	@echo;echo "   $${vsHelpTEXT}"





sml:=showVimMakefileList
sml $(sml):
	@echo "$${showVimMakefileList}"


