

vim_prepare_clean :
	@mkdir -p _vim/
	@rm -f _vim/cscope.out       _vim/cscope.in?     _vim/tags
vp vim_prepare1 : vim_prepare_clean
	@ls Makefile 		 > _vim/cscope.in0
	@ls $(CFGmakeXST) 	>> _vim/cscope.in0
	@ [ -f _vim/vim_file01.txt ] 	|| touch _vim/vim_file01.txt 
	@ [ -f _vim/dir_01.txt ] 		|| touch _vim/dir_01.txt 
	@cat _vim/vim_file01.txt |sed -e 's/^ *//g' |sed -e '/^#.*$$/d' |sed -e 's/ *$$//g' |sed -e '/^$$/d' >> _vim/cscope.in1 
	cat _vim/dir_01.txt |sed -e 's/^ *//g' |sed -e '/^#.*$$/d' |sed -e 's/ *$$//g' |sed -e '/^$$/d' |sort -u \
		|xargs -n 1 -I '{}' find '{}' -maxdepth 1 -type f \
		-name "*.v" -o -name "*.V" \
		-o -name "*.sh" -o -name "Makefile*" \
		|sort -u >> _vim/cscope.in2
	@cat _vim/cscope.in? |xargs -n 1 readlink -m > _vim/cscope.tmp
	@cat _vim/cscope.tmp |sort -u > _vim/cscope.files
	@rm -f _vim/cscope.in? cscope.out tags
	@ctags -L _vim/cscope.files
	@cscope -Rbu  -k -i_vim/cscope.files 
	sync

