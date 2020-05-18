
all:

$(eval $(call tryINCmustExist,$(TM)/Makefile.1011.git.mk,db9100001))
$(eval $(call tryINCmustExist,$(TM)/Makefile.1010.proxy.mk,db9100002))
$(eval $(call tryINCmustExist,$(TM)/Makefile.1012.ftp.mk,db9100003))
$(eval $(call tryINCmustExist,$(TM)/Makefile.1013.vim.mk,db9100004))

m:=vim_Makefile
m : $(TT)/Makefile
	$(vim) $^


e:=vim_Makefile_env
e : Makefile.env.mk
	$(vim) $^


