
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


# https://medium.com/@mlowicki/http-s-proxy-in-golang-in-less-than-100-lines-of-code-6a51c2f2c38c
sslConfig:=/etc/ssl/openssl.cnf
genssl:
	[ -d ssl ] || mkdir ssl
	[ -f ssl/myOpenssl.conf ] \
		&& printf '\nAlread found : ssl/myOpenssl.conf , skip. \n\n' \
		|| ( \
		cat $(sslConfig)                              > ssl/myOpenssl.conf && \
		printf '[SAN]\nsubjectAltName=DNS:localhost' >> ssl/myOpenssl.conf \
		)
	[ -f ssl/myServer.key ] \
		&& printf '\nAlread found : ssl/myServer.key , skip. \n\n' \
		|| \
		openssl req \
		-newkey rsa:2048 \
		-x509 \
		-nodes \
		-keyout ssl/myServer.key \
		-new \
		-out ssl/myServer.pem \
		-subj /CN=localhost \
		-reqexts SAN \
		-extensions SAN \
		-config                 ssl/myOpenssl.conf    \
		-sha256 \
		-days 3650

