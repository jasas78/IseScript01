all:

#$(NFTbin)     
# NFtext_blockIpv6
# Makefile.5000.mk
# Makefile.5001.mk
# Makefile.5011.mk
# Makefile.5013.mk
# Makefile.5015.mk

# NFTdebug:=

NFTnowTable:=tbLocalIpv4natPost
NFTruleNO:=5001

my_tbLocalIpv4_N3chainALL :=   \
_a1_N3checkSrcIp               \
_a3_N3checkDstIp               \
_a5_N3checkProtocol_tcp        \
_a7_N3checkTcpDstPortNew       \
_b1_N3checkProtocol_udp        \
_b3_N3checkUdpDstPort          \
_b5_N3checkProtocol_icmp       \
_b7_N3checkProtocol_igmp       \
_b9_N3unknown                  \

define NFTtext_23_ipv4_natPost

# NFTtext_23_ipv4_natPost begin
add table ip $(NFTnowTable)         


# add my_tbLocalIpv4_N3chainALL : begin
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(my_tbLocalIpv4_N3chainALL),\
    $(EOL)add chain ip $(NFTnowTable) chLocalIp4Card_$(aa1)$(aa2)\
  )\
)

# add my_tbLocalIpv4_N3chainALL : end

add chain ip $(NFTnowTable) chLocalIp4natPost   { type nat hook postrouting  priority 110 ; policy accept ; }

$(if 1,
  $(call ip4inRule111,chLocalIp4natPost, ip protocol == icmp ip daddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPost, ip protocol == icmp ip saddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPost, ip daddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPost, ip saddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
)
$(if  ,
  $(call ip4inRule111,chLocalIp4natPost, ip protocol == icmp ip daddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natPost, ip daddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natPost, ip protocol == icmp ip saddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natPost, ip saddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
)


### chLocalIp4nat : begin 


$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(NFTgroupCard_x_$(aa1)),$(foreach aa3,$(NFTcardS_$(aa2)),\
    $(call ip4inRule111,chLocalIp4natPost   , oif $(aa3) $(NFTcnt) accept) \
  ))\
)
$(call ip4inRule111,chLocalIp4natPost  , $(NFTcnt) $(NFTset_1))
$(call ip4inRule111,chLocalIp4natPost  , $(NFTcnt) accept)
### chLocalIp4nat : end


### _a1_N3checkSrcIp
$(foreach aa1,$(NFTgroupCard_x_ALL), $(foreach aa2,$(NFTgroupCard_y2_$(aa1)),\
$(call ip4inRuleAA1,_a1_N3checkSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_a3_N3checkDstIp) \
))

$(foreach aa1,lo, $(foreach aa2,$(NFTgroupCard_y2_lan) $(NFTgroupCard_y2_vpn),\
$(call ip4inRuleAA1,_a1_N3checkSrcIp, ip saddr $(aa2) ip daddr $(aa2) $(NFTcnt) accept) \
))

$(foreach aa1,$(NFTgroupCard_x_ALL), \
	$(if $(NFTdebug),$(call ip4inRuleAA1,_a1_N3checkSrcIp, $(NFTset_1),1) )\
	$(call ip4inRuleAA1,_a1_N3checkSrcIp, $(NFTcnt) drop) \
	)


### _a3_N3checkDstIp
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,$(foreach aa2,$(NFTgroupCard_y5_$(aa1)),\
$(call ip4inRuleAA1,_a3_N3checkDstIp, ip daddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_a5_N3checkProtocol_tcp) \
))

$(foreach aa1,lan  ,$(foreach aa2,$(NFTblackHoleIP),\
$(call ip4inRuleAA1,_a3_N3checkDstIp, ip daddr $(aa2) $(NFTcnt) drop) \
)\
$(call ip4inRuleAA1,_a3_N3checkDstIp, $(NFTcnt) goto chLocalIp4Card_$(aa1)_a5_N3checkProtocol_tcp) \
)

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(call ip4inRuleAA1,_a3_N3checkDstIp, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__8 )  \
  $(call ip4inRuleAA1,_a3_N3checkDstIp, ip daddr 224.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__9 )  \
  $(call ip4inRuleAA1,_a3_N3checkDstIp, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_a3_N3checkDstIp, $(NFTcnt) drop) \
)

# _a5_N3checkProtocol_tcp --> _a7_N3checkTcpDstPortNew , _b1_N3checkProtocol_udp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_a5_N3checkProtocol_tcp, ip protocol != tcp $(NFTcnt) goto chLocalIp4Card_$(aa1)_b1_N3checkProtocol_udp) \
$(call ip4inRuleAA1,_a5_N3checkProtocol_tcp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_a5_N3checkProtocol_tcp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_a5_N3checkProtocol_tcp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_a7_N3checkTcpDstPortNew) \
$(call ip4inRuleAA1,_a5_N3checkProtocol_tcp, $(NFTcnt) drop) \
)

# _a7_N3checkTcpDstPortNew
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(if $(filter lo,$(aa1)),\
    $(call ip4inRuleAA1,_a7_N3checkTcpDstPortNew, $(NFTcnt) accept) ,\
    $(foreach aa2,$(call sortUN, $(NFTtcpOUT_allow) $(NFTtcpIN_$(aa1))), \
      $(call ip4inRuleAA1,_a7_N3checkTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) accept)  \
    )\
  )\
  $(if $(filter lan,$(aa1)), \
    $(foreach aa2,$(call sortUU, $(NFTgroupCard_y5_lan) ), \
      $(call ip4inRuleAA1,_a7_N3checkTcpDstPortNew, ip daddr $(aa2) $(NFTcnt) accept) ))\
  $(call ip4inRuleAA1,_a7_N3checkTcpDstPortNew, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_a7_N3checkTcpDstPortNew, $(NFTcnt) drop) \
)

# _b1_N3checkProtocol_udp -> _b3_N3checkUdpDstPort , _b5_N3checkProtocol_icmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_b1_N3checkProtocol_udp, ip protocol != udp $(NFTcnt) goto chLocalIp4Card_$(aa1)_b5_N3checkProtocol_icmp) \
$(call ip4inRuleAA1,_b1_N3checkProtocol_udp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_b1_N3checkProtocol_udp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_b1_N3checkProtocol_udp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_b3_N3checkUdpDstPort) \
$(call ip4inRuleAA1,_b1_N3checkProtocol_udp, $(NFTcnt) drop) \
)

# _b3_N3checkUdpDstPort
$(foreach aa1,lan,\
  $(call ip4inRuleAA1,_b3_N3checkUdpDstPort, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__0 )  \
)
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(call sortUN,$(NFTudpOUT_allow) $(NFTudpIN_$(aa1)) ),\
    $(call ip4inRuleAA1,_b3_N3checkUdpDstPort, udp dport $(aa2) $(NFTcnt) accept #__$(aa1)__$(aa2)__1 )  \
  )\
)

$(foreach aa1,lo ,\
    $(call ip4inRuleAA1,_b3_N3checkUdpDstPort, $(NFTcnt) accept #__$(aa1)__$(aa2)__2 )  \
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_b3_N3checkUdpDstPort, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_b3_N3checkUdpDstPort, $(NFTcnt) drop) \
)

# _b5_N3checkProtocol_icmp -> _b7_N3checkProtocol_igmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_b5_N3checkProtocol_icmp, ip protocol != icmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_b7_N3checkProtocol_igmp) \
$(call ip4inRuleAA1,_b5_N3checkProtocol_icmp, icmp type { echo-reply   } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_b5_N3checkProtocol_icmp, icmp type { echo-request } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_b5_N3checkProtocol_icmp, icmp type { destination-unreachable } $(NFTcnt) drop) \
$(call ip4inRuleAA1,_b5_N3checkProtocol_icmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_b5_N3checkProtocol_icmp, $(NFTcnt) drop) \
)

# _b7_N3checkProtocol_igmp -> _b9_N3unknown 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_b7_N3checkProtocol_igmp, ip protocol != igmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_b9_N3unknown) \
$(call ip4inRuleAA1,_b7_N3checkProtocol_igmp, ip daddr 224.0.0.22 $(NFTcnt) drop) \
$(call ip4inRuleAA1,_b7_N3checkProtocol_igmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_b7_N3checkProtocol_igmp, $(NFTcnt) drop) \
)

# _b9_N3unknown  ->
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_b9_N3unknown, $(NFTset_1),1) \
$(call ip4inRuleAA1,_b9_N3unknown, $(NFTcnt) accept) \
)

# NFTtext_23_ipv4_natPost end
endef
export NFTtext_23_ipv4_natPost:=$(NFTtext_23_ipv4_natPost)


