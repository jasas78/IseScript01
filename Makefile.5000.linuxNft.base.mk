all:

HOSTNAME?=$(shell hostname)
export HOSTNAME

# "$(aa1) $(1) $(3)$(4):$(NFTnowTable) $(NFTruleNO)"
ip4inRuleAA1=$(EOL)add rule ip $(NFTnowTable) chLocalIp4Card_$(aa1)$(1) $(2) comment \
"$(aa1) $(1) $(3)$(4):$(NFTnowTable)_$(NFTruleNO) $(eval NFTruleNO=$(strip $(shell echo -n $$(( $(NFTruleNO) + 1 )))))"
ip4inRule111=$(EOL)add rule ip $(NFTnowTable)                      $(1) $(2) comment \
"$(aa1) $(1) $(3)$(4):$(NFTnowTable)_$(NFTruleNO) $(eval NFTruleNO=$(strip $(shell echo -n $$(( $(NFTruleNO) + 1 )))))"


sortUN=$(strip $(shell echo $1 $2 $3 $4 $5 $6 $7 $8 $9 |xargs -n 1|sort -u -n))
sortUU=$(strip $(shell echo $1 $2 $3 $4 $5 $6 $7 $8 $9 |xargs -n 1|sort -u))
sortNN=$(strip $(shell echo $1 $2 $3 $4 $5 $6 $7 $8 $9 |xargs -n 1|sort -n))

NFTbin:=$(shell which nft)
NFTbin?=/usr/sbin/nft

NFTfile:=/tmp/nft.rule

NFTsed1:=|sed -e 's;^ *;;g' -e 's; *$$;;g' -e 's;\s\s\+; ;g'

NFTkeyworD_lo     := lo 
NFTkeyworD_eth    := eth 
NFTkeyworD_wlan   := wlan  wan 
NFTkeyworD_br     := br 
NFTkeyworD_tun    := tun 
NFTkeyworD_tap    := tap 

NFTkeyworD_ALL:=$(strip lo eth wlan br tun tap )

NFTcardS_ALL   :=$(strip $(sort $(shell ls /sys/class/net/)))
$(foreach aa1,$(NFTkeyworD_ALL),$(eval NFTcardS_$(aa1):=$(strip $(filter $(foreach bb1,$(NFTkeyworD_$(aa1)),$(bb1)%),$(NFTcardS_ALL)))))

NFTcardSETs:=$(foreach aa1,ALL $(NFTkeyworD_ALL),NFTcardS_$(aa1))
$(foreach aa1,$(NFTcardS_ALL),$(eval NetCard_ip0_$(aa1):=$$(strip $$(shell ip a show $(aa1)|grep inet))))
$(foreach aa1,$(NFTcardS_ALL),$(eval NetCard_ip1_$(aa1):=$$(strip $$(shell ip a show $(aa1)|grep inet|awk \
	'{print $$$$2}'))))
$(foreach aa1,$(NFTcardS_ALL),$(eval NetCard_ip2_$(aa1):=$$(strip $$(shell ip a show $(aa1)|grep inet|awk \
	'{print $$$$2}'|awk -F/ '{print $$$$1}'))))
$(foreach aa1,$(NFTcardS_ALL),$(eval NetCard_ip3_$(aa1):=$$(strip $$(shell ip a show $(aa1)|grep inet|awk \
	'{print $$$$2}'|awk -F/ '{print $$$$2}'))))
#$(foreach aa1,$(NFTcardS_ALL),$(eval NetCard_ip4_$(aa1):=$$(strip $$(shell ip a show $(aa1)|grep inet|awk \
	'{print $$$$4}'))))
$(foreach aa1,$(NFTcardS_ALL),$(eval NetCard_ip4_$(aa1):=$$(strip $$(shell ip a show $(aa1)|grep inet|awk \
	'{print $$$$2 " " $$$$4}'|sed -e 's;[/\\.]; ;g'|awk \
	'{if ($$$$6=="global"||$$$$6=="host") \
    if ($$$$5==24) print  $$$$1 "." $$$$2 "." $$$$3 ".255" ; \
	else print  $$$$1 ".255.255.255" ; else print $$$$6 "." $$$$7 "." $$$$8 "." $$$$9;}' \
))))

ifeq (host,$(NetCard_ip4_lo))
NetCard_ip4_lo:=127.255.255.255
endif

$(foreach aa1,$(NFTcardS_ALL),$(eval \
	NetCard_ip_textALL+=\
$$(EOL)NetCard_ip0_$(aa1) 2,3,4 --- 1,0 = \
 $(NetCard_ip2_$(aa1)),\
 $(NetCard_ip3_$(aa1)),\
 $(NetCard_ip4_$(aa1))\
 _=_ $(NetCard_ip1_$(aa1)),\
 _=_ $(strip $(NetCard_ip0_$(aa1)))\
	))

NetCard_ip_textALL+=$(EOL)NetCard_ip4_br0,eth0,lo0:=$(NetCard_ip4_br0),$(NetCard_ip4_eth0),$(NetCard_ip4_lo)

NFTgroupCard_x_lo:= lo
NFTgroupCard_x_lan:= eth wlan br
NFTgroupCard_x_vpn:= tun tap
NFTgroupCard_x_ALL:= lo lan vpn
NFTgroupCard_x_Src:= lo vpn
NFTgroupCard_x_Dst:= lo vpn
NFTgroupCard_x_Block:= lan

$(foreach aa1,$(NFTgroupCard_x_ALL),\
	$(eval NFTgroupCard_y2_$(aa1):=$(strip $(foreach bb1,$(NFTgroupCard_x_$(aa1)),$(foreach bb2,$(NFTcardS_$(bb1)),$(NetCard_ip2_$(bb2))))))\
	$(eval NFTgroupCard_y3_$(aa1):=$(strip $(foreach bb1,$(NFTgroupCard_x_$(aa1)),$(foreach bb2,$(NFTcardS_$(bb1)),$(NetCard_ip3_$(bb2))))))\
	$(eval NFTgroupCard_y4_$(aa1):=$(strip $(foreach bb1,$(NFTgroupCard_x_$(aa1)),$(foreach bb2,$(NFTcardS_$(bb1)),$(NetCard_ip4_$(bb2))))))\
	$(eval NFTgroupCard_y5_$(aa1):=$(strip $(foreach bb1,$(NFTgroupCard_x_$(aa1)),$(foreach bb2,$(NFTcardS_$(bb1)),$(NetCard_ip1_$(bb2))))))\
	)

NetCard_ip_textALL+=$(EOL)NFTgroupCard_x_ALL:=$(NFTgroupCard_x_ALL)
NetCard_ip_textALL+=$(foreach aa1,$(NFTgroupCard_x_ALL),$(EOL)NFTgroupCard_y5_$(aa1):=$(NFTgroupCard_y5_$(aa1)))



NFTblackHoleIP:=$(strip 224.0.0.251/24 239.0.0.0/8 )
NFTprivateNetIP:=$(strip 127.0.0.0/8 192.168.0.0/16 10.0.0.0/8 )

NFTnat_block_udpPort__tvbox1:= 3478 11711 134-140 5001 7534
NFTnat_block_udpPort__ALL:=$(strip $(sort  $(NFTnat_block_udpPort__tvbox1) ))
NFTnat_block_tcpPort__tvbox1:= 7534
NFTnat_block_tcpPort__ALL:=$(strip $(sort  $(NFTnat_block_tcpPort__tvbox1) ))

NFTnat_block_ip__tvbox1:= 106.11.61.137 203.119.205.0 203.119.205.153 106.11.61.135  120.221.8.182 203.119.205.0 58.56.65.209 \
    115.182.222.248 222.173.57.21 58.56.65.206 211.151.156.173 211.151.156.170 211.151.156.172 116.211.186.208 \
	106.38.219.49 116.211.186.209 116.211.189.139 119.29.123.63 121.12.108.100 121.12.108.101 121.12.108.104 \
	121.12.108.28 121.12.108.29 121.12.108.30 121.12.108.31 121.12.108.95 121.12.108.96 121.12.108.97 121.12.108.98 \
	121.12.108.99 203.119.216.254 220.181.184.60 222.173.56.16 203.119.217.116 203.119.128.4 203.119.217.126 \
	203.119.214.17 203.119.205.127 203.208.40.103 203.208.40.101 203.208.40.98 203.208.40.100 203.208.40.104 203.208.40.110 \
	203.119.217.127 203.208.40.102 203.208.40.105 203.208.40.96 203.208.40.97 203.208.40.99 203.119.205.154 \
	121.12.108.11 121.12.108.14 121.12.108.7 121.12.108.8 121.9.221.100 121.9.221.81 121.9.221.82 121.9.221.96 \
    203.119.216.255 59.38.101.91 140.205.248.8 106.11.61.141 106.11.248.2 140.205.61.87







NFTnat_block_ip__blackHole:=$(strip 192.168.0.0/16 10.0.0.0/8 224.0.0.0/8 255.255.255.255 0.0.0.0 )
NFTnat_block_ip__ALL:=$(strip $(sort $(NFTnat_block_ip__tvbox1) $(NFTnat_block_ip__blackHole)))

NFTtcpOUT_allow_port__jg1:= 55044 55052
NFTtcpOUT_allow_port__ssh:=20 21 22 23
NFTtcpOUT_allow_port__httpS:=80 443 
NFTtcpOUT_allow_port__dns:=53

NFTtcpOUT_allow_ip__httpS:= 91.189.91.26 91.189.91.23 # us.archive.ubuntu.com cn.archive.ubuntu.com
NFTtcpOUT_allow_ip__httpS+= 91.189.91.23 91.189.88.149 91.189.88.161 91.189.88.152 91.189.91.26 91.189.88.162 # security.ubuntu.com      
NFTtcpOUT_allow_ip__httpS+= 183.36.114.44 183.36.114.45 # www.sogou.com ns1.sogou.com ns2.sogou.com
NFTtcpOUT_allow_ip__httpS+= 14.215.177.39 14.215.177.38 # www.baidu.com www.a.shifen.com


NFTtcpOUT_block_ip__httpS:= 104.225.98.131 104.225.98.129 13.35.94.61 144.2.3.1 54.148.43.57 23.222.28.98 #a.root-servers.net.
NFTtcpOUT_block_ip__httpS+= 23.215.100.147 23.222.28.57 192.204.26.83 192.204.26.123 52.10.55.151 54.191.241.246 218.30.103.50 # nstld.verisign-grs.com.
NFTtcpOUT_block_ip__httpS+= 34.209.108.219 65.200.22.129 23.222.28.152 23.222.28.129 52.37.53.20 # pb.sogou.com
NFTtcpOUT_block_ip__httpS+= 54.68.141.132 34.217.184.213
NFTtcpOUT_block_ip__httpS+= 52.36.71.24 52.11.162.210 35.167.70.180 34.212.55.103 52.25.195.204 23.222.29.38 52.39.131.77 23.193.44.107
NFTtcpOUT_block_ip__httpS+= 23.193.44.16 23.193.44.133 52.24.130.228 106.39.246.42 52.38.149.111
NFTtcpOUT_block_ip__httpS+= 54.149.52.189 52.89.179.237 23.222.28.171 59.38.112.32 23.222.29.94 23.222.29.104
NFTtcpOUT_block_ip__httpS+= 52.25.175.166 36.110.170.48 23.222.29.190 183.2.192.112 61.140.13.201 23.222.29.175 113.107.216.105
NFTtcpOUT_block_ip__httpS+= 113.96.98.102 14.215.166.109 119.146.74.33 183.2.192.198 113.107.216.121 113.96.154.108
NFTtcpOUT_block_ip__httpS+= 121.12.122.120 14.215.167.197 183.61.13.198 113.105.155.198 113.105.165.44 113.107.216.119 61.142.166.245
NFTtcpOUT_block_ip__httpS+= 59.153.63.67 35.160.58.123 34.210.116.46 23.222.29.231 23.222.29.216 54.71.202.253 59.38.112.31 52.34.107.172 
NFTtcpOUT_block_ip__httpS+= 35.164.143.45 203.208.40.105 52.11.194.43 54.191.46.28
NFTtcpOUT_block_ip__httpS+= 203.208.40.73 203.208.40.68 52.10.127.251 104.91.166.178 104.91.166.179
NFTtcpOUT_block_ip__httpS+= 64.13.232.149 13.32.207.133 65.200.22.232 130.89.148.14 128.31.0.62 5.153.231.4 149.20.4.15 

NFTtcpOUT_allow_ip__dns:=114.114.114.114

NFTtcpOUT_allow_port__ALL:=$(strip $(sort $(foreach aa1,$(HOSTNAME) ssh httpS dns, $(NFTtcpOUT_allow_port__$(aa1)))))

NFTudpOUT_allow_jg1:= 51044 51028 51052
NFTudpOUT_allow:=53 67 68 69 123 5353 $(NFTudpOUT_allow_$(HOSTNAME))

NFTtcpIN_ssh:=55522 33221 22225 20022

# go_ginuerzh__g
NFTtcpIN_vpn_acceptPort:=55050 55028    

NFTtcpIN_vpn_dns:=53 953
NFTtcpIN_vpn_squid_jg1:= 20014 20022 20025 20026 20061 30014 30022 30025 30026 30061
NFTtcpIN_vpn_squid__:=$(NFTtcpIN_vpn_squid_$(HOSTNAME))

NFTtcpIN_lan:=$(strip $(shell echo $(NFTtcpIN_vpn_acceptPort) $(NFTtcpIN_ssh)|xargs -n 1|sort -u -n ))
NFTtcpIN_vpn:=$(strip $(shell echo $(NFTtcpIN_lan) $(NFTtcpIN_vpn_dns) $(NFTtcpIN_vpn_squid__)|xargs -n 1|sort -u -n ))
NFTtcpIN_lo:=5037 # android adb

NFTudpIN_vpn_acceptPort:=38034 40948 40956 40972

NFTudpIN_dhcpclient:=68
NFTudpIN_dns:=53

NFTudpIN_lan:=$(strip $(shell echo $(NFTudpIN_dns) $(NFTudpIN_vpn_acceptPort) $(NFTudpIN_dhcpclient)|xargs -n 1|sort -u -n ))
NFTudpIN_vpn:=$(NFTudpIN_lan)
NFTudpIN_lo:=$(strip $(shell echo $(NFTudpIN_dns) |xargs -n 1|sort -u -n))



NetCard_ip_textALL+=$(foreach aa1,$(NFTgroupCard_x_ALL),$(EOL)NFTtcpIN_$(aa1):=$(NFTtcpIN_$(aa1)))
NetCard_ip_textALL+=$(foreach aa1,$(NFTgroupCard_x_ALL),$(EOL)NFTudpIN_$(aa1):=$(NFTudpIN_$(aa1)))
NetCard_ip_textALL+=$(EOL) HOSTNAME=$(HOSTNAME)

NFTnatIP:=192.168.1.147
#NFTnatIP:=10.22.22.25


define NFTcardINFO
$(foreach aa1,$(NFTcardSETs),$(EOL)$(aa1)    : $($(aa1)))
NetCard_ip_textALL:$(NetCard_ip_textALL)

endef
export NFTcardINFO
showRunHelpTEXText5 += $(NFTcardINFO)

define nh1_TEXT

nft     list      ruleset
nft     flush     ruleset

touch        /tmp/nft.rule
chmod  777   /tmp/nft.rule

nft    -f    /tmp/nft.rule

endef
export nh1_TEXT

define nc1_TEXT
#$(NFTbin) -f

flush     ruleset

endef
export nc1_TEXT





#$(nh1):=ws2 wv1
#nh1: $($(nh1))

nh1:=nft_base_usage
nh1: 
	@echo "$${nh1_TEXT}"       $(NFTsed1)              

nc1:=nft_step_1_clean_all_old_ruleS
nc1: 
	@echo "$${nc1_TEXT}"       $(NFTsed1)    > $(NFTfile)
	@wc                                        $(NFTfile)

ss1:=nft_show_ruleset_with_less
ss1: 
	nft     list      ruleset | less

linuxNft_OpList+=		\
	nh1						\
	nc1						\
	ss1						\


