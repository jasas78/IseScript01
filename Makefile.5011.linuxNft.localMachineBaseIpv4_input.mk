all:

#$(NFTbin)     
# NFtext_blockIpv6
# Makefile.5000.mk
# Makefile.5001.mk


# NFTdebug:=

my_tbLocalIpv4_IIchainALL :=   \
_11_IIcheckDstIp               \
_13_IIcheckSrcIp               \
_15_IIcheckProtocol_tcp        \
_17_IIcheckTcpDstPortNew       \
_21_IIcheckProtocol_udp        \
_23_IIcheckUdpDstPort          \
_25_IIcheckProtocol_icmp       \
_27_IIcheckProtocol_igmp	   \
_29_IIunknown                  \

NFTnowTable:=tbLocalIpv4input
NFTruleNO:=1001


define NFTtext_11_ipv4_input

# NFTtext_11_ipv4_input : begin
add table ip $(NFTnowTable)         


# add my_tbLocalIpv4_IIchainALL : begin
$(foreach aa1,$(NFTgroupCard_x_ALL),\
$(foreach aa2,$(my_tbLocalIpv4_IIchainALL),\
$(EOL)add chain ip $(NFTnowTable) chLocalIp4Card_$(aa1)$(aa2)\
))

# add my_tbLocalIpv4_IIchainALL : end

add chain ip $(NFTnowTable) chLocalIp4input    { type filter hook input   priority 200 ; policy accept ; }



### chLocalIp4input : begin 

$(if 1,
  $(call ip4inRule111,chLocalIp4input, ip protocol == icmp ip daddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4input, ip protocol == icmp ip saddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4input, ip daddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4input, ip saddr 114.114.114.114 udp dport 53 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4input, ip daddr 192.168.1.1 ip protocol == icmp  $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4input, ip saddr 192.168.1.1 ip protocol == icmp  $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4input, tcp dport 20022 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4input, tcp sport 20022 $(NFTset_1), testICMP31) 
)
$(if  ,
  $(call ip4inRule111,chLocalIp4input, ip protocol == icmp ip daddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4input, ip daddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4input, ip protocol == icmp ip saddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4input, ip saddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
)

$(foreach aa1,$(NFTgroupCard_x_ALL),$(foreach aa2,$(NFTgroupCard_x_$(aa1)),$(foreach aa3,$(NFTcardS_$(aa2)),\
$(call ip4inRule111,chLocalIp4input, iif $(aa3) $(NFTcnt) goto chLocalIp4Card_$(aa1)_11_IIcheckDstIp) \
)))
$(call ip4inRule111,chLocalIp4input, $(NFTcnt) drop)

### chLocalIp4input : end 

### _11_IIcheckDstIp

$(foreach aa1,$(NFTgroupCard_x_ALL)  , \
  $(foreach aa2, $(foreach aa3,$(NFTgroupCard_x_ALL)  , $(NFTgroupCard_y2_$(aa3))) ,\
      $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_13_IIcheckSrcIp, DstToMySelfIP ) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_Src)  , \
  $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr 224.0.0.0/8 $(NFTcnt) drop)\
  $(foreach aa2,$(NFTgroupCard_x_$(aa1)),\
    $(foreach aa3,$(NFTcardS_$(aa2)),\
	  $(if $(NetCard_ip4_$(aa3)),\
        $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr $(NetCard_ip4_$(aa3)) $(NFTcnt) goto chLocalIp4Card_$(aa1)_13_IIcheckSrcIp)\
        $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr 255.255.255.255       $(NFTcnt) goto chLocalIp4Card_$(aa1)_13_IIcheckSrcIp)\
      )\
    )\
  )\
  $(if $(filter lo,$(aa1)),\
    $(foreach aa2,$(NFTgroupCard_y2_lan) $(NFTgroupCard_y2_vpn),\
      $(call ip4inRuleAA1,_11_IIcheckDstIp, iif lo ip saddr $(aa2) ip saddr $(aa2) $(NFTcnt) accept)\
    )\
  )\
  $(if $(filter lo,$(aa1)),,\
    $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr 255.255.255.255       $(NFTcnt) drop)\
  )\
  $(if $(NFTdebug),$(call ip4inRuleAA1,_11_IIcheckDstIp, $(NFTset_1),1) )\
  $(call ip4inRuleAA1,_11_IIcheckDstIp, $(NFTcnt) drop) \
)

$(foreach aa1,$(NFTgroupCard_x_Block), \
    $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr 224.0.0.0/8 $(NFTcnt) drop)\
    $(foreach aa2,$(NFTgroupCard_x_$(aa1)),\
	  $(foreach aa3,$(NFTcardS_$(aa2)),\
	    $(if $(NetCard_ip4_$(aa3)),\
	      $(foreach aa4,1 2 3 4,\
		    $(if $(word $(aa4),$(NetCard_ip4_$(aa3))),\
              $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr $(word $(aa4),$(NetCard_ip4_$(aa3)))          \
			    ip saddr $(word $(aa4),$(NetCard_ip1_$(aa3))) $(NFTcnt) goto chLocalIp4Card_$(aa1)_21_IIcheckProtocol_udp )\
              $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr 255.255.255.255 \
			    ip saddr $(word $(aa4),$(NetCard_ip1_$(aa3))) $(NFTcnt) goto chLocalIp4Card_$(aa1)_21_IIcheckProtocol_udp )\
		    )\
		  )\
        )\
	  )\
    )\
   $(call ip4inRuleAA1,_11_IIcheckDstIp, ip daddr 255.255.255.255       $(NFTcnt) drop)\
   $(if $(NFTdebug), $(call ip4inRuleAA1,_11_IIcheckDstIp, $(NFTset_1),1) )\
   $(call ip4inRuleAA1,_11_IIcheckDstIp, $(NFTcnt) drop) \
)

### _13_IIcheckSrcIp
$(foreach aa1,$(NFTgroupCard_x_ALL)  , \
  $(foreach aa2, $(foreach aa3,$(NFTgroupCard_x_ALL)  , $(NFTgroupCard_y5_$(aa3))) ,\
      $(call ip4inRuleAA1,_13_IIcheckSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_15_IIcheckProtocol_tcp, SrcFromMySelfIP ) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  , $(foreach aa2,$(NFTblackHoleIP),\
    $(call ip4inRuleAA1,_13_IIcheckSrcIp, ip saddr $(aa2) $(NFTcnt) drop, dropALLboardcastIPsrc ) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(call ip4inRuleAA1,_13_IIcheckSrcIp, $(NFTcnt) goto chLocalIp4Card_$(aa1)_15_IIcheckProtocol_tcp, accept_normal_srcIP ) \
  $(if $(NFTdebug), $(call ip4inRuleAA1,_13_IIcheckSrcIp, $(NFTset_1),1) )\
  $(call ip4inRuleAA1,_13_IIcheckSrcIp, $(NFTcnt) drop) \
)

# _15_IIcheckProtocol_tcp --> _17_IIcheckTcpDstPortNew , _21_IIcheckProtocol_udp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_15_IIcheckProtocol_tcp, ip protocol != tcp $(NFTcnt) goto chLocalIp4Card_$(aa1)_21_IIcheckProtocol_udp) \
$(call ip4inRuleAA1,_15_IIcheckProtocol_tcp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_15_IIcheckProtocol_tcp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_15_IIcheckProtocol_tcp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_17_IIcheckTcpDstPortNew) \
$(call ip4inRuleAA1,_15_IIcheckProtocol_tcp, $(NFTcnt) drop) \
)

# _17_IIcheckTcpDstPortNew
$(foreach aa1,$(NFTgroupCard_x_ALL)  , $(foreach aa2,$(NFTtcpIN_$(aa1))  ,\
    $(call ip4inRuleAA1,_17_IIcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) accept)  \
  )\
)

$(foreach aa1,lo ,\
  $(foreach aa2,$(call sortUN, $(NFTtcpIN_lan) $(NFTtcpIN_vpn) 5555-5585 $(NFTtcpOUT_allow_port__$(HOSTNAME)) ),\
    $(call ip4inRuleAA1,_17_IIcheckTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) accept)  \
  )\
  $(call ip4inRuleAA1,_17_IIcheckTcpDstPortNew, $(NFTcnt) $(NFTset_1),1) \
  $(call ip4inRuleAA1,_17_IIcheckTcpDstPortNew, $(NFTcnt) accept) \
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_17_IIcheckTcpDstPortNew, $(NFTcnt) $(NFTset_1),1) \
  $(call ip4inRuleAA1,_17_IIcheckTcpDstPortNew, $(NFTcnt) drop) \
)

# _21_IIcheckProtocol_udp -> _23_IIcheckUdpDstPort , _25_IIcheckProtocol_icmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_21_IIcheckProtocol_udp, ip protocol != udp $(NFTcnt) goto chLocalIp4Card_$(aa1)_25_IIcheckProtocol_icmp) \
$(call ip4inRuleAA1,_21_IIcheckProtocol_udp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_21_IIcheckProtocol_udp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_21_IIcheckProtocol_udp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_23_IIcheckUdpDstPort) \
$(call ip4inRuleAA1,_21_IIcheckProtocol_udp, $(NFTcnt) drop) \
)

# _23_IIcheckUdpDstPort
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
	$(foreach aa2,$(NFTudpIN_$(aa1))  ,\
	  $(call ip4inRuleAA1,_23_IIcheckUdpDstPort, udp dport $(aa2) $(NFTcnt) accept #__$(aa1)__$(aa2)__)  \
	)\
	$(if $(filter lo,$(aa1)),\
	  $(if $(NFTdebug),$(call ip4inRuleAA1,_23_IIcheckUdpDstPort, $(NFTset_1),1) )\
	  $(call ip4inRuleAA1,_23_IIcheckUdpDstPort, $(NFTcnt) accept #__$(aa1)__) ,\
      $(call ip4inRuleAA1,_23_IIcheckUdpDstPort, $(NFTcnt) drop) \
	)
)

# _25_IIcheckProtocol_icmp -> _27_IIcheckProtocol_igmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_25_IIcheckProtocol_icmp, ip protocol != icmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_27_IIcheckProtocol_igmp) \
$(call ip4inRuleAA1,_25_IIcheckProtocol_icmp, icmp type { echo-reply   } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_25_IIcheckProtocol_icmp, icmp type { echo-request } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_25_IIcheckProtocol_icmp, $(NFTcnt) drop) \
)

# _27_IIcheckProtocol_igmp -> _29_IIunknown 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_27_IIcheckProtocol_igmp, ip protocol != igmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_29_IIunknown) \
$(call ip4inRuleAA1,_25_IIcheckProtocol_icmp, $(NFTcnt) drop) \
)

# _29_IIunknown  ->
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(if $(NFTdebug),$(call ip4inRuleAA1,_29_IIunknown, $(NFTset_1),1) )\
  $(call ip4inRuleAA1,_29_IIunknown, $(NFTcnt) accept) \
)

# NFTtext_11_ipv4_input : end
endef
export NFTtext_11_ipv4_input:=$(NFTtext_11_ipv4_input)

