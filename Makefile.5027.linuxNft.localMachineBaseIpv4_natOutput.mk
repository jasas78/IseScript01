all:

#$(NFTbin)     
# NFtext_blockIpv6
# Makefile.5000.mk
# Makefile.5001.mk
# Makefile.5011.mk
# Makefile.5013.mk
# Makefile.5015.mk

# NFTdebug:=

NFTnowTable:=tbLocalIpv4natOutPut
NFTruleNO:=7001

my_tbLocalIpv4_N7OchainALL :=   \
_g1_N5OcheckSrcIp               \
_g3_N5OcheckDstIp               \
_g5_N5OcheckProtocol_tcp        \
_g7_N5OcheckTcpDstPortNew       \
_h1_N5OcheckProtocol_udp        \
_h3_N5OcheckUdpDstPort          \
_h5_N5OcheckProtocol_icmp       \
_h7_N5OcheckProtocol_igmp       \
_h9_N5Ounknown                  \

define NFTtext_27_ipv4_natOutPut

# NFTtext_27_ipv4_natOutPut begin
add table ip $(NFTnowTable)         


# add my_tbLocalIpv4_N7OchainALL : begin
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(my_tbLocalIpv4_N7OchainALL),\
    $(EOL)add chain ip $(NFTnowTable) chLocalIp4Card_$(aa1)$(aa2)\
  )\
)

# add my_tbLocalIpv4_N7OchainALL : end

add chain ip $(NFTnowTable) chLocalIp4natOutPut   { type nat hook output  priority 108 ; policy accept ; }


$(if 1,
  $(call ip4inRule111,chLocalIp4natOutPut, ip protocol == icmp ip daddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natOutPut, ip protocol == icmp ip saddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natOutPut, ip daddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natOutPut, ip saddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
)
$(if  ,
  $(call ip4inRule111,chLocalIp4natOutPut, ip protocol == icmp ip daddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natOutPut, ip daddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natOutPut, ip protocol == icmp ip saddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natOutPut, ip saddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
)

### chLocalIp4nat : begin 


$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(NFTgroupCard_x_$(aa1)),$(foreach aa3,$(NFTcardS_$(aa2)),\
    $(call ip4inRule111,chLocalIp4natOutPut   , iif $(aa3) $(NFTcnt) accept) \
  ))\
)
$(ccall ip4inRule111,chLocalIp4natOutPut  , $(NFTcnt) $(NFTset_1))
$(call ip4inRule111,chLocalIp4natOutPut  , $(NFTcnt) accept)
### chLocalIp4nat : end


### _g1_N5OcheckSrcIp
$(foreach aa1,$(NFTgroupCard_x_ALL), $(foreach aa2,$(NFTgroupCard_y2_$(aa1)),\
$(call ip4inRuleAA1,_g1_N5OcheckSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_g3_N5OcheckDstIp) \
))

$(foreach aa1,lo, $(foreach aa2,$(NFTgroupCard_y2_lan) $(NFTgroupCard_y2_vpn),\
$(call ip4inRuleAA1,_g1_N5OcheckSrcIp, ip saddr $(aa2) ip daddr $(aa2) $(NFTcnt) accept) \
))

$(foreach aa1,$(NFTgroupCard_x_ALL), \
	$(if $(NFTdebug),$(call ip4inRuleAA1,_g1_N5OcheckSrcIp, $(NFTset_1),1) )\
	$(call ip4inRuleAA1,_g1_N5OcheckSrcIp, $(NFTcnt) drop) \
	)


### _g3_N5OcheckDstIp
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,$(foreach aa2,$(NFTgroupCard_y5_$(aa1)),\
$(call ip4inRuleAA1,_g3_N5OcheckDstIp, ip daddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_g5_N5OcheckProtocol_tcp) \
))

$(foreach aa1,lan  ,$(foreach aa2,$(NFTblackHoleIP),\
$(call ip4inRuleAA1,_g3_N5OcheckDstIp, ip daddr $(aa2) $(NFTcnt) drop) \
)\
$(call ip4inRuleAA1,_g3_N5OcheckDstIp, $(NFTcnt) goto chLocalIp4Card_$(aa1)_g5_N5OcheckProtocol_tcp) \
)

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(call ip4inRuleAA1,_g3_N5OcheckDstIp, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__8 )  \
  $(call ip4inRuleAA1,_g3_N5OcheckDstIp, ip daddr 224.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__9 )  \
  $(call ip4inRuleAA1,_g3_N5OcheckDstIp, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_g3_N5OcheckDstIp, $(NFTcnt) drop) \
)

# _g5_N5OcheckProtocol_tcp --> _g7_N5OcheckTcpDstPortNew , _h1_N5OcheckProtocol_udp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_g5_N5OcheckProtocol_tcp, ip protocol != tcp $(NFTcnt) goto chLocalIp4Card_$(aa1)_h1_N5OcheckProtocol_udp) \
$(call ip4inRuleAA1,_g5_N5OcheckProtocol_tcp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_g5_N5OcheckProtocol_tcp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_g5_N5OcheckProtocol_tcp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_g7_N5OcheckTcpDstPortNew) \
$(call ip4inRuleAA1,_g5_N5OcheckProtocol_tcp, $(NFTcnt) drop) \
)

# _g7_N5OcheckTcpDstPortNew
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(if $(filter lo,$(aa1)),\
    $(call ip4inRuleAA1,_g7_N5OcheckTcpDstPortNew, $(NFTcnt) accept) ,\
    $(foreach aa2,$(call sortUN, $(NFTtcpOUT_allow) $(NFTtcpIN_$(aa1))), \
      $(call ip4inRuleAA1,_g7_N5OcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) accept)  \
    )\
  )\
  $(if $(filter lan,$(aa1)), \
    $(foreach aa2,$(call sortUU, $(NFTgroupCard_y5_lan) ), \
      $(call ip4inRuleAA1,_g7_N5OcheckTcpDstPortNew, ip daddr $(aa2) $(NFTcnt) accept) ))\
  $(call ip4inRuleAA1,_g7_N5OcheckTcpDstPortNew, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_g7_N5OcheckTcpDstPortNew, $(NFTcnt) drop) \
)

# _h1_N5OcheckProtocol_udp -> _h3_N5OcheckUdpDstPort , _h5_N5OcheckProtocol_icmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_h1_N5OcheckProtocol_udp, ip protocol != udp $(NFTcnt) goto chLocalIp4Card_$(aa1)_h5_N5OcheckProtocol_icmp) \
$(call ip4inRuleAA1,_h1_N5OcheckProtocol_udp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_h1_N5OcheckProtocol_udp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_h1_N5OcheckProtocol_udp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_h3_N5OcheckUdpDstPort) \
$(call ip4inRuleAA1,_h1_N5OcheckProtocol_udp, $(NFTcnt) drop) \
)

# _h3_N5OcheckUdpDstPort
$(foreach aa1,lan,\
  $(call ip4inRuleAA1,_h3_N5OcheckUdpDstPort, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__0 )  \
)
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(call sortUN,$(NFTudpOUT_allow) $(NFTudpIN_$(aa1)) ),\
    $(call ip4inRuleAA1,_h3_N5OcheckUdpDstPort, udp dport $(aa2) $(NFTcnt) accept #__$(aa1)__$(aa2)__1 )  \
  )\
)

$(foreach aa1,lo ,\
    $(call ip4inRuleAA1,_h3_N5OcheckUdpDstPort, $(NFTcnt) accept #__$(aa1)__$(aa2)__2 )  \
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_h3_N5OcheckUdpDstPort, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_h3_N5OcheckUdpDstPort, $(NFTcnt) drop) \
)

# _h5_N5OcheckProtocol_icmp -> _h7_N5OcheckProtocol_igmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_h5_N5OcheckProtocol_icmp, ip protocol != icmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_h7_N5OcheckProtocol_igmp) \
$(call ip4inRuleAA1,_h5_N5OcheckProtocol_icmp, icmp type { echo-reply   } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_h5_N5OcheckProtocol_icmp, icmp type { echo-request } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_h5_N5OcheckProtocol_icmp, icmp type { destination-unreachable } $(NFTcnt) drop) \
$(call ip4inRuleAA1,_h5_N5OcheckProtocol_icmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_h5_N5OcheckProtocol_icmp, $(NFTcnt) drop) \
)

# _h7_N5OcheckProtocol_igmp -> _h9_N5Ounknown 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_h7_N5OcheckProtocol_igmp, ip protocol != igmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_h9_N5Ounknown) \
$(call ip4inRuleAA1,_h7_N5OcheckProtocol_igmp, ip daddr 224.0.0.22 $(NFTcnt) drop) \
$(call ip4inRuleAA1,_h7_N5OcheckProtocol_igmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_h7_N5OcheckProtocol_igmp, $(NFTcnt) drop) \
)

# _h9_N5Ounknown  ->
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_h9_N5Ounknown, $(NFTset_1),1) \
$(call ip4inRuleAA1,_h9_N5Ounknown, $(NFTcnt) accept) \
)

# NFTtext_27_ipv4_natOutPut end
endef
export NFTtext_27_ipv4_natOutPut:=$(NFTtext_27_ipv4_natOutPut)


