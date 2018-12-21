all:


proxy01?=        http_proxy=127.0.0.1:20022          https_proxy=127.0.0.1:20022 
proxy02?= http_proxy=http://127.0.0.1:20022  https_proxy=https://127.0.0.1:20022 

$(if $(proxyNO),$(eval proxyX1:=),$(eval proxyX1:=$(proxy01)))
$(if $(proxyNO),$(eval proxyX2:=),$(eval proxyX2:=$(proxy02)))

# note : you can ovride the proxy01 and proxy02 in the Makefile.env

