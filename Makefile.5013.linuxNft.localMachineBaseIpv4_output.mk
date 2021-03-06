all:

#$(NFTbin)     
# NFtext_blockIpv6
# Makefile.5000.mk
# Makefile.5001.mk
# Makefile.5011.mk

# NFTdebug:=

NFTnowTable:=tbLocalIpv4_output
NFTruleNO:=2001

my_tbLocalIpv4_OOchainALL :=   \
_41_OOcheckSrcIp               \
_43_OOcheckDstIp               \
_45_OOcheckProtocol_tcp        \
_47_OOcheckTcpDstPortNew       \
_48_OOcheckTcpNew_ipHttpS      \
_49_OOcheckTcpNew_ipDNS        \
_51_OOcheckProtocol_udp        \
_53_OOcheckUdpDstPort          \
_54_OOcheckUdp_ipDNS           \
_55_OOcheckProtocol_icmp       \
_57_OOcheckProtocol_igmp       \
_59_OOunknown                  \

define NFTtext_13_ipv4_output

# NFTtext_13_ipv4_output begin
add table ip $(NFTnowTable)         


# add my_tbLocalIpv4_OOchainALL : begin
$(foreach aa1,$(NFTgroupCard_x_ALL),\
$(foreach aa2,$(my_tbLocalIpv4_OOchainALL),\
$(EOL)add chain ip $(NFTnowTable) chLocalIp4Card_$(aa1)$(aa2)\
))

# add my_tbLocalIpv4_OOchainALL : end

add chain ip $(NFTnowTable) chLocalIp4output   { type filter hook output  priority 231 ; policy accept ; }



### chLocalIp4output : begin 

$(if 1,
  $(call ip4inRule111,chLocalIp4output, ip protocol == icmp ip daddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4output, ip protocol == icmp ip saddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4output, ip protocol == icmp ip daddr 192.168.1.1     $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4output, ip daddr 114.114.114.114 udp dport 53        $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4output, ip saddr 114.114.114.114 udp dport 53        $(NFTset_1), testICMP31) 
)
$(if  ,
  $(call ip4inRule111,chLocalIp4output, ip protocol == icmp ip daddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4output, ip daddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4output, ip protocol == icmp ip saddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4output, ip saddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
)

$(foreach aa1,$(NFTgroupCard_x_ALL),$(foreach aa2,$(NFTgroupCard_x_$(aa1)),$(foreach aa3,$(NFTcardS_$(aa2)),\
      $(call ip4inRule111,chLocalIp4output, oif $(aa3) $(NFTcnt) goto chLocalIp4Card_$(aa1)_41_OOcheckSrcIp) \
)))

$(call ip4inRule111,chLocalIp4output, $(NFTset_1),1)
$(call ip4inRule111,chLocalIp4output, $(NFTcnt) drop)
### chLocalIp4output : end


### _41_OOcheckSrcIp
$(foreach aa1,$(NFTgroupCard_x_ALL)  , \
  $(foreach aa2, $(foreach aa3,$(NFTgroupCard_x_ALL)  , $(NFTgroupCard_y2_$(aa3))) ,\
      $(call ip4inRuleAA1,_41_OOcheckSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_43_OOcheckDstIp, SrcFromMySelfIP ) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL), $(foreach aa2,$(NFTgroupCard_y2_$(aa1)),\
    $(call ip4inRuleAA1,_41_OOcheckSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_43_OOcheckDstIp) \
))

$(foreach aa1,lo, $(foreach aa2,$(NFTgroupCard_y2_lan) $(NFTgroupCard_y2_vpn),\
    $(call ip4inRuleAA1,_41_OOcheckSrcIp, ip saddr $(aa2) ip daddr $(aa2) $(NFTcnt) accept) \
))

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(if $(NFTdebug),$(call ip4inRuleAA1,_41_OOcheckSrcIp, $(NFTset_1),1) )\
  $(call ip4inRuleAA1,_41_OOcheckSrcIp, $(NFTcnt) drop) \
)


### _43_OOcheckDstIp

$(foreach aa1,$(NFTgroupCard_x_ALL)  , $(foreach aa2,$(NFTblackHoleIP),\
    $(call ip4inRuleAA1,_43_OOcheckDstIp, ip daddr $(aa2) $(NFTcnt) drop) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,$(foreach aa2,$(NFTgroupCard_y5_$(aa1)),\
    $(call ip4inRuleAA1,_43_OOcheckDstIp, ip daddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_45_OOcheckProtocol_tcp) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  , $(foreach aa2,$(NFTprivateNetIP),\
    $(call ip4inRuleAA1,_43_OOcheckDstIp, ip daddr $(aa2) $(NFTcnt) drop) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_43_OOcheckDstIp, $(NFTcnt) goto chLocalIp4Card_$(aa1)_45_OOcheckProtocol_tcp, to_normal_IP ) \
)

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(call ip4inRuleAA1,_43_OOcheckDstIp, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_43_OOcheckDstIp, $(NFTcnt) drop) \
)

# _45_OOcheckProtocol_tcp --> _47_OOcheckTcpDstPortNew , _51_OOcheckProtocol_udp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_45_OOcheckProtocol_tcp, ip protocol != tcp $(NFTcnt) goto chLocalIp4Card_$(aa1)_51_OOcheckProtocol_udp) \
$(call ip4inRuleAA1,_45_OOcheckProtocol_tcp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_45_OOcheckProtocol_tcp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_45_OOcheckProtocol_tcp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_47_OOcheckTcpDstPortNew) \
$(call ip4inRuleAA1,_45_OOcheckProtocol_tcp, $(NFTcnt) drop) \
)

# _47_OOcheckTcpDstPortNew
$(foreach aa1,lo  ,\
    $(call ip4inRuleAA1,_47_OOcheckTcpDstPortNew, $(NFTcnt) accept) 
)
$(foreach aa1,vpn  ,\
    $(foreach aa2,$(call sortUN, $(NFTtcpOUT_allow_port__ALL) $(NFTtcpIN_$(aa1)) ), \
      $(call ip4inRuleAA1,_47_OOcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) accept)  \
    )\
)
$(foreach aa1,lan  ,\
    $(foreach aa2,$(call sortUN, $(NFTtcpOUT_allow_port__httpS) ), \
      $(call ip4inRuleAA1,_47_OOcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_48_OOcheckTcpNew_ipHttpS )  \
    )\
    $(foreach aa2,$(call sortUN, $(NFTtcpOUT_allow_port__dns) ), \
      $(call ip4inRuleAA1,_47_OOcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_49_OOcheckTcpNew_ipDNS )  \
    )\
    $(foreach aa2,$(call sortUN, $(filter-out  $(NFTtcpOUT_allow_port__httpS) $(NFTtcpOUT_allow_port__dns) , $(NFTtcpOUT_allow_port__ALL)) ), \
      $(call ip4inRuleAA1,_47_OOcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) accept)  \
    )\
    $(foreach aa2,$(call sortUU, $(NFTgroupCard_y5_lan) ), \
      $(call ip4inRuleAA1,_47_OOcheckTcpDstPortNew, ip daddr $(aa2) $(NFTcnt) accept)  \
    )\
)
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_47_OOcheckTcpDstPortNew, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_47_OOcheckTcpDstPortNew, $(NFTcnt) drop) \
)

# _48_OOcheckTcpNew_ipHttpS
$(foreach aa1,lan  ,\
  $(foreach aa2,$(NFTtcpOUT_block_ip__httpS)  ,\
    $(call ip4inRuleAA1,_48_OOcheckTcpNew_ipHttpS, ip daddr $(aa2) $(NFTcnt) drop ) \
  )\
  $(foreach aa2,$(NFTtcpOUT_allow_ip__httpS)  ,\
    $(call ip4inRuleAA1,_48_OOcheckTcpNew_ipHttpS, ip daddr $(aa2) $(NFTcnt) accept ) \
  )\
  $(foreach aa2,$(call sortUU, $(NFTgroupCard_y5_$(aa1)) ), \
    $(call ip4inRuleAA1,_48_OOcheckTcpNew_ipHttpS, ip daddr $(aa2) $(NFTcnt) accept ) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
    $(call ip4inRuleAA1,_48_OOcheckTcpNew_ipHttpS, $(NFTset_1),1) \
    $(call ip4inRuleAA1,_48_OOcheckTcpNew_ipHttpS, $(NFTcnt) drop) \
)

# _49_OOcheckTcpNew_ipDNS
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
    $(call ip4inRuleAA1,_48_OOcheckTcpNew_ipHttpS, $(NFTset_1),1) \
    $(call ip4inRuleAA1,_48_OOcheckTcpNew_ipHttpS, $(NFTcnt) drop) \
)

# _51_OOcheckProtocol_udp -> _53_OOcheckUdpDstPort , _55_OOcheckProtocol_icmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_51_OOcheckProtocol_udp, ip protocol != udp $(NFTcnt) goto chLocalIp4Card_$(aa1)_55_OOcheckProtocol_icmp) \
$(call ip4inRuleAA1,_51_OOcheckProtocol_udp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_51_OOcheckProtocol_udp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_51_OOcheckProtocol_udp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_53_OOcheckUdpDstPort) \
$(call ip4inRuleAA1,_51_OOcheckProtocol_udp, $(NFTcnt) drop) \
)

# _53_OOcheckUdpDstPort
$(foreach aa1,lan,\
  $(call ip4inRuleAA1,_53_OOcheckUdpDstPort, ip daddr 239.0.0.0/8 $(NFTcnt) drop #__$(aa1)__$(aa2)__0 )  \
)
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(call sortUN,$(NFTudpOUT_allow) $(NFTudpIN_$(aa1)) ),\
    $(call ip4inRuleAA1,_53_OOcheckUdpDstPort, udp dport $(aa2) $(NFTcnt) accept #__$(aa1)__$(aa2)__1 )  \
  )\
)

$(foreach aa1,lo ,\
    $(call ip4inRuleAA1,_53_OOcheckUdpDstPort, $(NFTcnt) accept #__$(aa1)__$(aa2)__2 )  \
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_53_OOcheckUdpDstPort, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_53_OOcheckUdpDstPort, $(NFTcnt) drop) \
)

# _55_OOcheckProtocol_icmp -> _57_OOcheckProtocol_igmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_55_OOcheckProtocol_icmp, ip protocol != icmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_57_OOcheckProtocol_igmp) \
$(call ip4inRuleAA1,_55_OOcheckProtocol_icmp, icmp type { echo-reply   } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_55_OOcheckProtocol_icmp, icmp type { echo-request } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_55_OOcheckProtocol_icmp, icmp type { redirect } icmp code 1 $(NFTcnt) accept) \
$(call ip4inRuleAA1,_55_OOcheckProtocol_icmp, icmp type { destination-unreachable } $(NFTcnt) drop) \
$(call ip4inRuleAA1,_55_OOcheckProtocol_icmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_55_OOcheckProtocol_icmp, $(NFTcnt) drop) \
)

# _57_OOcheckProtocol_igmp -> _59_OOunknown 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_57_OOcheckProtocol_igmp, ip protocol != igmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_59_OOunknown) \
$(call ip4inRuleAA1,_57_OOcheckProtocol_igmp, ip daddr 224.0.0.22 $(NFTcnt) drop) \
$(call ip4inRuleAA1,_57_OOcheckProtocol_igmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_57_OOcheckProtocol_igmp, $(NFTcnt) drop) \
)

# _59_OOunknown  ->
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_59_OOunknown, $(NFTset_1),1) \
$(call ip4inRuleAA1,_59_OOunknown, $(NFTcnt) accept) \
)

# NFTtext_13_ipv4_output end
endef
export NFTtext_13_ipv4_output:=$(NFTtext_13_ipv4_output)

