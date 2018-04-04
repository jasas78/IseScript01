
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

vs:=vim_show_file_list 
vsList:=$(shell cat _vim/cscope.files |grep -v /Makefile|sort -u )

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
vs $(vs) : 
	@[ -f _vim/cscope.files ] || make vp
	@echo;echo "   $${vsHelpTEXT}"

bt111:= astyle --suffix=none 
bt111:= /usr/bin/vim -n -E -c ':argdo normal gg=G' -c ':retab' -c ':wq' 
bt:= beautified format the text by :  $(bt111) 
bt:
	@echo 
	$(foreach aa1,$(vsList), $(bt111) $(aa1) $(EOL))
	@echo 

an:
	 @echo
	 @cd out && \
		 grep ' out  *of ' log_* \
		 |sed \
		 -e 's; \+\([0-9]\+ \+out \+of\) \+;: \1;g' \
		 -e 's;:\+;:;g' \
		 -e 's; \+; ;g' \
		 |awk -F: '{printf "%25s _ %50s _ %s \n\r" , $$1 , $$2, $$3}' 
	 @echo

RAR0:=/home/bootH/bin/rar
RAR1:=$(wildcard $(RAR0))
ifeq (,$(strip $(RAR1)))
RAR1:=$(wildcard $(shell which rar))
endif
ifeq (,$(strip $(RAR1)))
$(error 'why RAR not found ? $(RAR0)' )
endif

bk:= backup_the_bit_and_mcs_by_date
bkOBJs=$(strip $(wildcard out/$(FNbitOut1) out/$(FNmcsOut1)))
bk $(bk):
	for aa1 in $(bkOBJs) ; do \
		cp $${aa1}    bkOBJsDIR/$$(basename $${aa1}).$(time_called) || exit 32 ; \
		ls -l bkOBJsDIR/$$(basename $${aa1}).$(time_called) ; \
		done
	/home/bootH/bin/rar a -m5 -s -hp1 -r- \
		bkOBJsDIR/$$(basename $${PWD}).$(time_called).rar \
		src/*.v   src?/*.v   \
		bkOBJsDIR/*.$(time_called)
	ls -l \
		bkOBJsDIR/$$(basename $${PWD}).$(time_called).rar 

#$(error 'RAR1 now <$(RAR1)>')



