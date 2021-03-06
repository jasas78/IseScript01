all:



ftpACCd_default:=ftp://cap:cap@192.168.1.93
ftpACC2_default:=ftp://dd:dd@192.168.1.93
ftpACCu_default:=ftp://capw:capw@192.168.1.93

wgetX1:=wget -k -nc -r --no-parent --adjust-extension -olog01d.txt --remote-encoding=cp936
wgetX2:=wget -k -nc -r --no-parent --adjust-extension -olog01d.txt --remote-encoding=utf8
wgetY1:=wget -olog01d.txt --remote-encoding=cp936 -O -
wgetY2:=wget -olog01d.txt --remote-encoding=utf8  -O -
wputX1:=wput -olog01u.txt --binary --reupload --dont-continue 

## ifneq (,$(strip $(ftpACCd)))

ftpACCd?=$(ftpACCd_default)
ftpACCu?=$(ftpACCu_default)
ftpACC2?=$(ftpACC2_default)


lftpUP1=lftp -e ' rm -f $(1) ; put $(2) -o $(1)  ;exit' $(ftpACCu) 
# Example : 
#	lftp -e '$(u1Script) ;exit' $(ftpACCu) 
#	$(call lftpUP1, /test01/test01/main.c , src6/main.c )
#

define ftpTEMPdown
$1:
	$(wgetY1)     $(ftpServerPathUP)/$(2)    > $(3)
	@md5sum                            $(3)
	$(if $(filter $(3),$(download_need_cp936_to_utf8)),cat $(3) |dos2unix|iconv -f cp936 -t utf8 -c > $(3).utf8.txt)
	$(if $(filter $(3),$(download_need_hexdump)),cat $(3) |hexdump -C > $(3).hexdump.txt)
	@echo $$$$(ls -l $(3))     $$$$(ls -lh $(3)|awk '{print $$$$5}')
	@echo
endef

#dl1:=download_log_01
#$(dl1):=case/fwpkg/buildlist.log    src3/207__buildlist.log
define ftpTEMPup
$1:
	echo $1,$2,$3,$4
	$(wputX1)     $(2)    $(ftpServerPathUP)/$(3)
	@md5sum       $(2)
endef


upIdx1:=1
downIdx1:=1

define CallExpandFtpTOP3
$(iinfo "================top3===$1 , $2 , $3 : $4 , $5 , $6 ")
$(eeval export showFtpHelpTEXT$(1)+=$1 , $2 , $3 : $4 , $5 , $6 $$(EOL))
$(eval export showFtpHelpTEXT$(1)+=     $(3)$(4)      => file_by_ftp_$(1)$(4) => $5  -> $6$$(EOL)    )
$(eval $(3)$(4)=file_by_ftp_$(1)$(4))
$(eval $($(3)$(4))=$5  -> $6)
$(eval $(call ftpTEMP$(1),$(3)$(4),$5,$6))
$(eval $(3)a+=$(3)$(4))
endef

wList3toend:=3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
define CallExpandFtpTOP2
$(eval list=$($($(3))))
$(eval add1=$($(1)Idx3))
$(eval add2=$(shell expr $($(1)Idx3) + 1 ))

$(eval p1=$(word $(add1),$(list)))
$(eval p2=$(word $(add2),$(list)))

$(iinfo "================top2===$1 , $2 , $3, $4 : $(upIdx1),$(downIdx1),$(upIdx2),$(downIdx2): $(p1), $(p2) : $(list) ")
$(iinfo "================top2===$1 , $2 , $3 : $(p1), $(p2) , $($(1)Idx2) $($(1)Idx3) : $(add1) , $(add2) ")
$(if $(p2),$(eval $(call CallExpandFtpTOP3,$1,$2,$3,$($(1)Idx2),$(p1),$(p2))))

$(if $(p2),,$(eval export showFtpHelpTEXT$(1)+=     $(3)a      =>   $($(3)a) $$(EOL)   ))
$(if $(p2),,$(eval $(3)a                                       :    $($(3)a)           ))

$(eval $(1)Idx3=$(shell expr $($(1)Idx3) + 2 ))
$(eval $(1)Idx2=$(shell expr $($(1)Idx2) + 1 ))
$(if $(p1)$(p2),$(eval $(call CallExpandFtpTOP2,$1,$2,$3)))
endef

define CallExpandFtpTOP1
$(eval $$(1)Idx2:=1)
$(eval $$(1)Idx3:=1)
$(iinfo "================top1===$1 , $2 , $3, $4 : $(upIdx1),$(downIdx1),$(upIdx2),$(downIdx2): $(p1), $(p2) : $(list) ")
$(eval $(foreach aa1,$($(3)),$(call CallExpandFtpTOP2,$(1),$(2),$(aa1))))
endef

CallExpandFtpALLup=$(eval   $(call CallExpandFtpTOP1,up,$(strip   $1),$(strip $2)))
CallExpandFtpALLdown=$(eval $(call CallExpandFtpTOP1,down,$(strip $1),$(strip $2)))

