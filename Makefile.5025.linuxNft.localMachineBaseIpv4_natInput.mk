all:

#$(NFTbin)     
# NFtext_blockIpv6
# Makefile.5000.mk
# Makefile.5001.mk
# Makefile.5011.mk
# Makefile.5013.mk
# Makefile.5015.mk

# NFTdebug:=

NFTnowTable:=tbLocalIpv4natInPut
NFTruleNO:=6001

my_tbLocalIpv4_N5IchainALL :=   \
_e1_N5IcheckSrcIp               \
_e3_N5IcheckDstIp               \
_e5_N5IcheckProtocol_tcp        \
_e7_N5IcheckTcpDstPortNew       \
_f1_N5IcheckProtocol_udp        \
_f3_N5IcheckUdpDstPort          \
_f5_N5IcheckProtocol_icmp       \
_f7_N5IcheckProtocol_igmp       \
_f9_N5Iunknown                  \

define NFTtext_25_ipv4_natInPut

# NFTtext_25_ipv4_natInPut begin
add table ip $(NFTnowTable)         


# add my_tbLocalIpv4_N5IchainALL : begin
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(my_tbLocalIpv4_N5IchainALL),\
    $(EOL)add chain ip $(NFTnowTable) chLocalIp4Card_$(aa1)$(aa2)\
  )\
)

# add my_tbLocalIpv4_N5IchainALL : end

add chain ip $(NFTnowTable) chLocalIp4natInput   { type nat hook input  priority 105 ; policy accept ; }

$(if 1,
  $(call ip4inRule111,chLocalIp4natInput, ip protocol == icmp ip daddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natInput, ip protocol == icmp ip saddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natInput, ip daddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natInput, ip saddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
)
$(if  ,
  $(call ip4inRule111,chLocalIp4natInput, ip protocol == icmp ip daddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natInput, ip daddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natInput, ip protocol == icmp ip saddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natInput, ip saddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
)


### chLocalIp4nat : begin 


$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(NFTgroupCard_x_$(aa1)),$(foreach aa3,$(NFTcardS_$(aa2)),\
    $(call ip4inRule111,chLocalIp4natInput   , iif $(aa3) $(NFTcnt) accept) \
  ))\
)
$(ccall ip4inRule111,chLocalIp4natInput  , $(NFTcnt) $(NFTset_1))
$(call ip4inRule111,chLocalIp4natInput  , $(NFTcnt) accept)
### chLocalIp4nat : end


### _e1_N5IcheckSrcIp
$(foreach aa1,$(NFTgroupCard_x_ALL), $(foreach aa2,$(NFTgroupCard_y2_$(aa1)),\
$(call ip4inRuleAA1,_e1_N5IcheckSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_e3_N5IcheckDstIp) \
))

$(foreach aa1,lo, $(foreach aa2,$(NFTgroupCard_y2_lan) $(NFTgroupCard_y2_vpn),\
$(call ip4inRuleAA1,_e1_N5IcheckSrcIp, ip saddr $(aa2) ip daddr $(aa2) $(NFTcnt) accept) \
))

$(foreach aa1,$(NFTgroupCard_x_ALL), \
	$(if $(NFTdebug),$(call ip4inRuleAA1,_e1_N5IcheckSrcIp, $(NFTset_1),1) )\
	$(call ip4inRuleAA1,_e1_N5IcheckSrcIp, $(NFTcnt) drop) \
	)


### _e3_N5IcheckDstIp
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,$(foreach aa2,$(NFTgroupCard_y5_$(aa1)),\
$(call ip4inRuleAA1,_e3_N5IcheckDstIp, ip daddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_e5_N5IcheckProtocol_tcp) \
))

$(foreach aa1,lan  ,$(foreach aa2,$(NFTblackHoleIP),\
$(call ip4inRuleAA1,_e3_N5IcheckDstIp, ip daddr $(aa2) $(NFTcnt) drop) \
)\
$(call ip4inRuleAA1,_e3_N5IcheckDstIp, $(NFTcnt) goto chLocalIp4Card_$(aa1)_e5_N5IcheckProtocol_tcp) \
)

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(call ip4inRuleAA1,_e3_N5IcheckDstIp, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__8 )  \
  $(call ip4inRuleAA1,_e3_N5IcheckDstIp, ip daddr 224.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__9 )  \
  $(call ip4inRuleAA1,_e3_N5IcheckDstIp, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_e3_N5IcheckDstIp, $(NFTcnt) drop) \
)

# _e5_N5IcheckProtocol_tcp --> _e7_N5IcheckTcpDstPortNew , _f1_N5IcheckProtocol_udp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_e5_N5IcheckProtocol_tcp, ip protocol != tcp $(NFTcnt) goto chLocalIp4Card_$(aa1)_f1_N5IcheckProtocol_udp) \
$(call ip4inRuleAA1,_e5_N5IcheckProtocol_tcp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_e5_N5IcheckProtocol_tcp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_e5_N5IcheckProtocol_tcp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_e7_N5IcheckTcpDstPortNew) \
$(call ip4inRuleAA1,_e5_N5IcheckProtocol_tcp, $(NFTcnt) drop) \
)

# _e7_N5IcheckTcpDstPortNew
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(if $(filter lo,$(aa1)),\
    $(call ip4inRuleAA1,_e7_N5IcheckTcpDstPortNew, $(NFTcnt) accept) ,\
    $(foreach aa2,$(call sortUN, $(NFTtcpOUT_allow) $(NFTtcpIN_$(aa1))), \
      $(call ip4inRuleAA1,_e7_N5IcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) accept)  \
    )\
  )\
  $(if $(filter lan,$(aa1)), \
    $(foreach aa2,$(call sortUU, $(NFTgroupCard_y5_lan) ), \
      $(call ip4inRuleAA1,_e7_N5IcheckTcpDstPortNew, ip daddr $(aa2) $(NFTcnt) accept) ))\
  $(call ip4inRuleAA1,_e7_N5IcheckTcpDstPortNew, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_e7_N5IcheckTcpDstPortNew, $(NFTcnt) drop) \
)

# _f1_N5IcheckProtocol_udp -> _f3_N5IcheckUdpDstPort , _f5_N5IcheckProtocol_icmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_f1_N5IcheckProtocol_udp, ip protocol != udp $(NFTcnt) goto chLocalIp4Card_$(aa1)_f5_N5IcheckProtocol_icmp) \
$(call ip4inRuleAA1,_f1_N5IcheckProtocol_udp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_f1_N5IcheckProtocol_udp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_f1_N5IcheckProtocol_udp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_f3_N5IcheckUdpDstPort) \
$(call ip4inRuleAA1,_f1_N5IcheckProtocol_udp, $(NFTcnt) drop) \
)

# _f3_N5IcheckUdpDstPort
$(foreach aa1,lan,\
  $(call ip4inRuleAA1,_f3_N5IcheckUdpDstPort, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__0 )  \
)
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(call sortUN,$(NFTudpOUT_allow) $(NFTudpIN_$(aa1)) ),\
    $(call ip4inRuleAA1,_f3_N5IcheckUdpDstPort, udp dport $(aa2) $(NFTcnt) accept #__$(aa1)__$(aa2)__1 )  \
  )\
)

$(foreach aa1,lo ,\
    $(call ip4inRuleAA1,_f3_N5IcheckUdpDstPort, $(NFTcnt) accept #__$(aa1)__$(aa2)__2 )  \
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_f3_N5IcheckUdpDstPort, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_f3_N5IcheckUdpDstPort, $(NFTcnt) drop) \
)

# _f5_N5IcheckProtocol_icmp -> _f7_N5IcheckProtocol_igmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_f5_N5IcheckProtocol_icmp, ip protocol != icmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_f7_N5IcheckProtocol_igmp) \
$(call ip4inRuleAA1,_f5_N5IcheckProtocol_icmp, icmp type { echo-reply   } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_f5_N5IcheckProtocol_icmp, icmp type { echo-request } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_f5_N5IcheckProtocol_icmp, icmp type { destination-unreachable } $(NFTcnt) drop) \
$(call ip4inRuleAA1,_f5_N5IcheckProtocol_icmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_f5_N5IcheckProtocol_icmp, $(NFTcnt) drop) \
)

# _f7_N5IcheckProtocol_igmp -> _f9_N5Iunknown 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_f7_N5IcheckProtocol_igmp, ip protocol != igmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_f9_N5Iunknown) \
$(call ip4inRuleAA1,_f7_N5IcheckProtocol_igmp, ip daddr 224.0.0.22 $(NFTcnt) drop) \
$(call ip4inRuleAA1,_f7_N5IcheckProtocol_igmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_f7_N5IcheckProtocol_igmp, $(NFTcnt) drop) \
)

# _f9_N5Iunknown  ->
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_f9_N5Iunknown, $(NFTset_1),1) \
$(call ip4inRuleAA1,_f9_N5Iunknown, $(NFTcnt) accept) \
)

# NFTtext_25_ipv4_natInPut end
endef
export NFTtext_25_ipv4_natInPut:=$(NFTtext_25_ipv4_natInPut)


