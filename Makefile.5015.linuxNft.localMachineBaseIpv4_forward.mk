all:

#$(NFTbin)     
# NFtext_blockIpv6
# Makefile.5000.mk
# Makefile.5001.mk
# Makefile.5011.mk
# Makefile.5013.mk

# NFTdebug:=


NFTnowTable:=tbLocalIpv4forward
NFTruleNO:=3001

my_tbLocalIpv4_FFchainALL :=   \
_61_FFcheckSrcIp               \
_63_FFcheckDstIp               \
_65_FFcheckProtocol_tcp        \
_67_FFcheckTcpDstPortNew       \
_71_FFcheckProtocol_udp        \
_73_FFcheckUdpDstPort          \
_75_FFcheckProtocol_icmp       \
_77_FFcheckProtocol_igmp       \
_79_FFunknown                  \

define NFTtext_15_ipv4_forward

# NFTtext_15_ipv4_forward begin
add table ip $(NFTnowTable)         


# add my_tbLocalIpv4_FFchainALL : begin
$(foreach aa1,$(NFTgroupCard_x_ALL),\
$(foreach aa2,$(my_tbLocalIpv4_FFchainALL),\
$(EOL)add chain ip $(NFTnowTable) chLocalIp4Card_$(aa1)$(aa2)\
))

# add my_tbLocalIpv4_FFchainALL : end

add chain ip $(NFTnowTable) chLocalIp4forward   { type filter hook forward  priority 220 ; policy accept ; }



### chLocalIp4forward : begin 

$(if 1,
  $(call ip4inRule111,chLocalIp4forward, ip protocol == icmp ip daddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4forward, ip protocol == icmp ip saddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4forward, ip daddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4forward, ip saddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
)
$(if  ,
  $(call ip4inRule111,chLocalIp4forward, ip protocol == icmp ip daddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4forward, ip daddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4forward, ip protocol == icmp ip saddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4forward, ip saddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
)

$(foreach aa1,$(NFTgroupCard_x_ALL),$(foreach aa2,$(NFTgroupCard_x_$(aa1)),$(foreach aa3,$(NFTcardS_$(aa2)),\
$(call ip4inRule111,chLocalIp4forward, oif $(aa3) $(NFTcnt) goto chLocalIp4Card_$(aa1)_61_FFcheckSrcIp) \
)))
$(call ip4inRule111,chLocalIp4forward, $(NFTcnt) drop)
### chLocalIp4forward : end


### _61_FFcheckSrcIp
$(foreach aa1,$(NFTgroupCard_x_ALL)  , \
  $(foreach aa2, $(foreach aa3,$(NFTgroupCard_x_ALL)  , $(NFTgroupCard_y5_$(aa3))) ,\
      $(call ip4inRuleAA1,_61_FFcheckSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_63_FFcheckDstIp, myIP ) \
  )\
)

$(foreach aa1, lan, \
  $(foreach aa2,$(NFTgroupCard_y5_$(aa1)),\
    $(call ip4inRuleAA1,_61_FFcheckSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_63_FFcheckDstIp, allow Nat packages ) \
    $(call ip4inRuleAA1,_61_FFcheckSrcIp, ip daddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_63_FFcheckDstIp, allow Nat packages ) \
))

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(if $(NFTdebug),$(call ip4inRuleAA1,_61_FFcheckSrcIp, $(NFTset_1),1) )\
\
  $(call ip4inRuleAA1,_61_FFcheckSrcIp, $(NFTcnt) drop) \
)


### _63_FFcheckDstIp
$(foreach aa1,$(NFTgroupCard_x_ALL)  , \
  $(foreach aa2, $(foreach aa3,$(NFTgroupCard_x_ALL)  , $(NFTgroupCard_y5_$(aa3))) ,\
      $(call ip4inRuleAA1,_63_FFcheckDstIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_65_FFcheckProtocol_tcp, myIP ) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,$(foreach aa2,$(NFTgroupCard_y5_$(aa1)),\
$(call ip4inRuleAA1,_63_FFcheckDstIp, ip daddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_65_FFcheckProtocol_tcp) \
))

$(foreach aa1,lan  ,$(foreach aa2,$(NFTblackHoleIP),\
$(call ip4inRuleAA1,_63_FFcheckDstIp, ip daddr $(aa2) $(NFTcnt) drop) \
)\
$(call ip4inRuleAA1,_63_FFcheckDstIp, $(NFTcnt) goto chLocalIp4Card_$(aa1)_65_FFcheckProtocol_tcp) \
)

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(call ip4inRuleAA1,_63_FFcheckDstIp, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__8 )  \
  $(call ip4inRuleAA1,_63_FFcheckDstIp, ip daddr 224.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__9 )  \
  $(call ip4inRuleAA1,_63_FFcheckDstIp, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_63_FFcheckDstIp, $(NFTcnt) drop) \
)

# _65_FFcheckProtocol_tcp --> _67_FFcheckTcpDstPortNew , _71_FFcheckProtocol_udp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_65_FFcheckProtocol_tcp, ip protocol != tcp $(NFTcnt) goto chLocalIp4Card_$(aa1)_71_FFcheckProtocol_udp) \
$(call ip4inRuleAA1,_65_FFcheckProtocol_tcp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_65_FFcheckProtocol_tcp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_65_FFcheckProtocol_tcp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_67_FFcheckTcpDstPortNew) \
$(call ip4inRuleAA1,_65_FFcheckProtocol_tcp, $(NFTcnt) drop) \
)

# _67_FFcheckTcpDstPortNew
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(if $(filter lo,$(aa1)),\
    $(call ip4inRuleAA1,_67_FFcheckTcpDstPortNew, $(NFTcnt) accept) ,\
    $(foreach aa2,$(call sortUN, $(NFTtcpOUT_allow) $(NFTtcpIN_$(aa1))), \
      $(call ip4inRuleAA1,_67_FFcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) accept)  \
    )\
  )\
  $(if $(filter lan,$(aa1)), \
    $(foreach aa2,$(call sortUU, $(NFTgroupCard_y5_lan) ), \
      $(call ip4inRuleAA1,_67_FFcheckTcpDstPortNew, ip daddr $(aa2) $(NFTcnt) accept) ))\
  $(call ip4inRuleAA1,_67_FFcheckTcpDstPortNew, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_67_FFcheckTcpDstPortNew, $(NFTcnt) drop) \
)

# _71_FFcheckProtocol_udp -> _73_FFcheckUdpDstPort , _75_FFcheckProtocol_icmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_71_FFcheckProtocol_udp, ip protocol != udp $(NFTcnt) goto chLocalIp4Card_$(aa1)_75_FFcheckProtocol_icmp) \
$(call ip4inRuleAA1,_71_FFcheckProtocol_udp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_71_FFcheckProtocol_udp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_71_FFcheckProtocol_udp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_73_FFcheckUdpDstPort) \
$(call ip4inRuleAA1,_71_FFcheckProtocol_udp, $(NFTcnt) drop) \
)

# _73_FFcheckUdpDstPort
$(foreach aa1,lan,\
  $(call ip4inRuleAA1,_73_FFcheckUdpDstPort, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__0 )  \
)
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(call sortUN,$(NFTudpOUT_allow) $(NFTudpIN_$(aa1)) ),\
    $(call ip4inRuleAA1,_73_FFcheckUdpDstPort, udp dport $(aa2) $(NFTcnt) accept #__$(aa1)__$(aa2)__1 )  \
  )\
)

$(foreach aa1,lo ,\
    $(call ip4inRuleAA1,_73_FFcheckUdpDstPort, $(NFTcnt) accept #__$(aa1)__$(aa2)__2 )  \
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_73_FFcheckUdpDstPort, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_73_FFcheckUdpDstPort, $(NFTcnt) drop) \
)

# _75_FFcheckProtocol_icmp -> _77_FFcheckProtocol_igmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_75_FFcheckProtocol_icmp, ip protocol != icmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_77_FFcheckProtocol_igmp) \
$(call ip4inRuleAA1,_75_FFcheckProtocol_icmp, icmp type { echo-reply   } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_75_FFcheckProtocol_icmp, icmp type { echo-request } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_75_FFcheckProtocol_icmp, icmp type { destination-unreachable } $(NFTcnt) drop) \
$(call ip4inRuleAA1,_75_FFcheckProtocol_icmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_75_FFcheckProtocol_icmp, $(NFTcnt) drop) \
)

# _77_FFcheckProtocol_igmp -> _79_FFunknown 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_77_FFcheckProtocol_igmp, ip protocol != igmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_79_FFunknown) \
$(call ip4inRuleAA1,_77_FFcheckProtocol_igmp, ip daddr 224.0.0.22 $(NFTcnt) drop) \
$(call ip4inRuleAA1,_77_FFcheckProtocol_igmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_77_FFcheckProtocol_igmp, $(NFTcnt) drop) \
)

# _79_FFunknown  ->
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_79_FFunknown, $(NFTset_1),1 ) \
$(call ip4inRuleAA1,_79_FFunknown, $(NFTcnt) accept ) \
)

# NFTtext_15_ipv4_forward end
endef
export NFTtext_15_ipv4_forward:=$(NFTtext_15_ipv4_forward)


