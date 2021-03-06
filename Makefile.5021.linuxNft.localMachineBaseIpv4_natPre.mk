all:

#$(NFTbin)     
# NFtext_blockIpv6
# Makefile.5000.mk
# Makefile.5001.mk
# Makefile.5011.mk
# Makefile.5013.mk
# Makefile.5015.mk

# NFTdebug:=

NFTnowTable:=tbLocalIpv4natPre
NFTruleNO:=4001

my_tbLocalIpv4_N1chainALL :=   \
_c1_N1checkSrcIp               \
_c3_N1checkDstIp               \
_c5_N1checkProtocol_tcp        \
_c7_N1checkTcpDstPortNew       \
_d1_N1checkProtocol_udp        \
_d3_N1checkUdpDstPort          \
_d5_N1checkProtocol_icmp       \
_d7_N1checkProtocol_igmp       \
_d9_N1unknown                  \
_da_N1snat01fakeAsFromVPN      \
_db_N1snat02toSquid            \

define NFTtext_21_ipv4_natPre

# NFTtext_21_ipv4_natPre begin
add table ip $(NFTnowTable)         


# add my_tbLocalIpv4_N1chainALL : begin
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(my_tbLocalIpv4_N1chainALL),\
    $(EOL)add chain ip $(NFTnowTable) chLocalIp4Card_$(aa1)$(aa2)\
  )\
)

# add my_tbLocalIpv4_N1chainALL : end

add chain ip $(NFTnowTable) chLocalIp4natPre   { type nat hook prerouting  priority 50 ; policy accept ; }


$(if 1,
  $(call ip4inRule111,chLocalIp4natPre, ip protocol == icmp ip daddr 114.114.114.114 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPre, ip protocol == icmp ip saddr 114.114.114.114 $(NFTset_1), testICMP31) 

  $(Call ip4inRule111,chLocalIp4natPre, ip protocol == icmp ip daddr 192.168.1.1     $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPre, ip protocol == icmp ip daddr 10.22.22.1      $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPre, ip protocol == icmp ip daddr 10.22.22.25     $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPre, ip daddr 114.114.114.114 udp dport 53        $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPre, ip saddr 114.114.114.114 udp dport 53        $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPre, tcp dport 20022 $(NFTset_1), testICMP31) 
  $(call ip4inRule111,chLocalIp4natPre, tcp sport 20022 $(NFTset_1), testICMP31) 
)
$(if  ,
  $(call ip4inRule111,chLocalIp4natPre, ip protocol == icmp ip daddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natPre, ip daddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natPre, ip protocol == icmp ip saddr 8.8.8.8         $(NFTset_1), testICMP32) 
  $(call ip4inRule111,chLocalIp4natPre, ip saddr 8.8.8.8         udp dport 53 $(NFTset_1), testICMP32) 
)

### chLocalIp4nat : begin 

$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(NFTgroupCard_x_$(aa1)),$(foreach aa3,$(NFTcardS_$(aa2)),\
    $(call ip4inRule111,chLocalIp4natPre   , iif $(aa3) $(NFTcnt) goto chLocalIp4Card_$(aa1)_c1_N1checkSrcIp ) \
  ))\
)
$(ccall ip4inRule111,chLocalIp4natPre  , $(NFTcnt) $(NFTset_1))
$(call ip4inRule111,chLocalIp4natPre  , $(NFTcnt) accept)
### chLocalIp4nat : end


### _c1_N1checkSrcIp
$(foreach aa1, lan , \
  $(foreach aa2, $(NFTgroupCard_y5_lan) $(NFTgroupCard_y5_vpn) ,\
    $(call ip4inRuleAA1,_c1_N1checkSrcIp, ip saddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_c3_N1checkDstIp) \
  )\
  $(foreach aa2, $(NFTnat_block_ip__blackHole) ,\
    $(call ip4inRuleAA1,_c1_N1checkSrcIp, ip saddr $(aa2) $(NFTcnt) drop, NFTnat_block_ip__blackHole )\
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(if $(NFTdebug),$(call ip4inRuleAA1,_c1_N1checkSrcIp, $(NFTset_1),1) )\
  $(call ip4inRuleAA1,_c1_N1checkSrcIp, $(NFTcnt) drop, end... ) \
)


### _c3_N1checkDstIp
$(foreach aa1, lan  ,\
  $(foreach aa2, $(NFTgroupCard_y5_lan) $(NFTgroupCard_y5_vpn) ,\
    $(call ip4inRuleAA1,_c3_N1checkDstIp, ip daddr $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_c5_N1checkProtocol_tcp) \
  )\
)
$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(foreach aa2,$(NFTnat_block_ip__ALL) ,\
    $(call ip4inRuleAA1,_c3_N1checkDstIp, ip daddr $(aa2) $(NFTcnt) drop, NFTnat_block_ip__ALL) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(foreach aa2, $(foreach aa3,$(NFTgroupCard_x_ALL),$(NFTgroupCard_y4_$(aa3))), \
    $(call ip4inRuleAA1,_c3_N1checkDstIp, ip daddr $(aa2) $(NFTcnt) drop, block local boardcast ) \
))


$(foreach aa1,$(NFTgroupCard_x_ALL), \
  $(call ip4inRuleAA1,_c3_N1checkDstIp, $(NFTcnt) goto chLocalIp4Card_$(aa1)_c5_N1checkProtocol_tcp) \
  $(call ip4inRuleAA1,_c3_N1checkDstIp, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_c3_N1checkDstIp, $(NFTcnt) drop,end...) \
)

# _c5_N1checkProtocol_tcp --> _c7_N1checkTcpDstPortNew , _d1_N1checkProtocol_udp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_c5_N1checkProtocol_tcp, ip protocol != tcp $(NFTcnt) goto chLocalIp4Card_$(aa1)_d1_N1checkProtocol_udp) \
$(call ip4inRuleAA1,_c5_N1checkProtocol_tcp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_c5_N1checkProtocol_tcp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_c5_N1checkProtocol_tcp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_c7_N1checkTcpDstPortNew) \
$(call ip4inRuleAA1,_c5_N1checkProtocol_tcp, $(NFTcnt) drop) \
)

# _c7_N1checkTcpDstPortNew

$(foreach aa1, $(NFTgroupCard_x_ALL) ,\
  $(foreach aa2,$(call sortUN, $(NFTnat_block_tcpPort__ALL) ),\
    $(call ip4inRuleAA1,_c7_N1checkTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) drop, NFTnat_block_tcpPort__ALL )  \
  )\
)

$(foreach aa1, $(NFTgroupCard_x_ALL) ,\
  $(foreach aa2, 80 443 ,\
    $(call ip4inRuleAA1,_c7_N1checkTcpDstPortNew, tcp dport $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_db_N1snat02toSquid) \
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_c7_N1checkTcpDstPortNew, $(NFTcnt) drop) \
  $(call ip4inRuleAA1,_c7_N1checkTcpDstPortNew, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_c7_N1checkTcpDstPortNew, $(NFTcnt) drop) \
)

# _d1_N1checkProtocol_udp -> _d3_N1checkUdpDstPort , _d5_N1checkProtocol_icmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_d1_N1checkProtocol_udp, ip protocol != udp $(NFTcnt) goto chLocalIp4Card_$(aa1)_d5_N1checkProtocol_icmp) \
$(call ip4inRuleAA1,_d1_N1checkProtocol_udp, ct state { established } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_d1_N1checkProtocol_udp, ct state { related     } $(NFTcnt) accept) \
$(call ip4inRuleAA1,_d1_N1checkProtocol_udp, ct state { new } $(NFTcnt) goto chLocalIp4Card_$(aa1)_d3_N1checkUdpDstPort) \
$(call ip4inRuleAA1,_d1_N1checkProtocol_udp, $(NFTcnt) drop) \
)

# _d3_N1checkUdpDstPort

$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(call sortUN, $(NFTnat_block_udpPort__ALL) ),\
    $(call ip4inRuleAA1,_d3_N1checkUdpDstPort, udp dport $(aa2) $(NFTcnt) drop , deny_port )\
  )\
)
$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2, $(NFTgroupCard_y4_$(aa1)),\
    $(call ip4inRuleAA1,_d3_N1checkUdpDstPort, ip daddr $(aa2) $(NFTcnt) drop , prevent boardcast )\
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL),\
  $(foreach aa2,$(call sortUN,$(NFTudpOUT_allow) $(NFTudpIN_$(aa1)) ),\
    $(call ip4inRuleAA1,_d3_N1checkUdpDstPort, udp dport $(aa2) $(NFTcnt) goto chLocalIp4Card_$(aa1)_da_N1snat01fakeAsFromVPN ,accept_port )\
  )\
)

$(Foreach aa1,lo ,\
    $(Call ip4inRuleAA1,_d3_N1checkUdpDstPort, $(NFTcnt) accept #__$(aa1)__$(aa2)__5 )  \
)


$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
  $(call ip4inRuleAA1,_d3_N1checkUdpDstPort, $(NFTset_1),1) \
  $(call ip4inRuleAA1,_d3_N1checkUdpDstPort, $(NFTcnt) drop) \
)

# _d5_N1checkProtocol_icmp -> _d7_N1checkProtocol_igmp 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_d5_N1checkProtocol_icmp, ip protocol != icmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_d7_N1checkProtocol_igmp) \
$(call ip4inRuleAA1,_d5_N1checkProtocol_icmp, icmp type { echo-reply   } $(NFTcnt) goto chLocalIp4Card_$(aa1)_da_N1snat01fakeAsFromVPN) \
$(call ip4inRuleAA1,_d5_N1checkProtocol_icmp, icmp type { echo-request } $(NFTcnt) goto chLocalIp4Card_$(aa1)_da_N1snat01fakeAsFromVPN) \
$(call ip4inRuleAA1,_d5_N1checkProtocol_icmp, icmp type { destination-unreachable } $(NFTcnt) drop) \
$(call ip4inRuleAA1,_d5_N1checkProtocol_icmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_d5_N1checkProtocol_icmp, $(NFTcnt) drop) \
)

# _d7_N1checkProtocol_igmp -> _d9_N1unknown 
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_d7_N1checkProtocol_igmp, ip protocol != igmp $(NFTcnt) goto chLocalIp4Card_$(aa1)_d9_N1unknown) \
$(call ip4inRuleAA1,_d7_N1checkProtocol_igmp, ip daddr 224.0.0.22 $(NFTcnt) drop) \
$(call ip4inRuleAA1,_d7_N1checkProtocol_igmp, $(NFTset_1),1) \
$(call ip4inRuleAA1,_d7_N1checkProtocol_igmp, $(NFTcnt) drop) \
)

# _d9_N1unknown  ->
$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_d9_N1unknown, $(NFTset_1),1) \
$(call ip4inRuleAA1,_d9_N1unknown, $(NFTcnt) accept) \
)

# _da_N1snat01fakeAsFromVPN  ->
$(foreach aa1,$(NFTgroupCard_x_ALL)  , \
  $(foreach aa2, $(NFTcardS_ALL) ,\
    $(foreach aa3, $(NetCard_ip1_$(aa2)) ,\
	$(eval aa4=$(shell echo -n $(aa3) | awk -F/ '{printf $$1}')) \
      $(call ip4inRuleAA1,_da_N1snat01fakeAsFromVPN, ip daddr $(aa3) $(NFTcnt) snat $(aa4) , snat to local )\
    )\
  )\
)

$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_da_N1snat01fakeAsFromVPN, $(NFTset_1), testSNAT12 ) \
$(call ip4inRuleAA1,_da_N1snat01fakeAsFromVPN, snat $(NFTnatIP), testSNAT13 ) \
$(call ip4inRuleAA1,_da_N1snat01fakeAsFromVPN, $(NFTcnt) accept) \
)

# _db_N1snat02toSquid  ->
#http://tldp.org/HOWTO/TransparentProxy-6.html
#  iptables -t nat -A PREROUTING -i eth0 -s ! squid-box -p tcp --dport 80 -j DNAT --to squid-box:3128
#  iptables -t nat -A POSTROUTING -o eth0 -s local-network -d squid-box -j SNAT --to iptables-box
#  iptables -A FORWARD -s local-network -d squid-box -i eth0 -o eth0 -p tcp --dport 3128 -j ACCEPT
# http://tldp.org/HOWTO/TransparentProxy-5.html
#  iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3128
# https://wiki.squid-cache.org/ConfigExamples/FullyTransparentWithTPROXY
# https://wiki.squid-cache.org/ConfigExamples/Intercept/LinuxDnat
#  # your proxy IP
#  SQUIDIP=192.168.0.2
#  # your proxy listening port
#  SQUIDPORT=3129
#  iptables -t nat -A PREROUTING -s $SQUIDIP -p tcp --dport 80 -j ACCEPT
#  iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $SQUIDIP:$SQUIDPORT
#  iptables -t nat -A POSTROUTING -j MASQUERADE
#  iptables -t mangle -A PREROUTING -p tcp --dport $SQUIDPORT -j DROP
#  /etc/sysctl.conf Configuration
#  # Controls IP packet forwarding
#  net.ipv4.ip_forward = 1
#  # Controls source route verification
#  net.ipv4.conf.default.rp_filter = 0
#  # Do not accept source routing
#  net.ipv4.conf.default.accept_source_route = 0
#  You will need to configure squid to know the IP is being intercepted like so:
#  http_port 3129 transparent
#  In Squid 3.1+ the transparent option has been split. Use 'intercept to catch DNAT packets.
#  http_port 3129 intercept
###### http://www.squid-cache.org/Doc/config/http_port/
#  intercept	: Support for IP-Layer NAT interception delivering traffic to this Squid port.
#                 NP: disables authentication on the port.


$(foreach aa1,$(NFTgroupCard_x_ALL)  ,\
$(call ip4inRuleAA1,_db_N1snat02toSquid, $(NFTset_1), testSNAT12 ) \
$(Call ip4inRuleAA1,_db_N1snat02toSquid, tcp dport 80  dnat 127.0.0.1:56080, testSNAT13 ) \
$(Call ip4inRuleAA1,_db_N1snat02toSquid, tcp dport 443 dnat 127.0.0.1:56443, testSNAT13 ) \
$(call ip4inRuleAA1,_db_N1snat02toSquid, tcp dport 80  dnat 127.0.0.1:20022, testSNAT13 ) \
$(call ip4inRuleAA1,_db_N1snat02toSquid, tcp dport 443 dnat 127.0.0.1:20022, testSNAT13 ) \
$(call ip4inRuleAA1,_db_N1snat02toSquid, $(NFTcnt) drop) \
)

# NFTtext_21_ipv4_natPre end
endef
export NFTtext_21_ipv4_natPre:=$(NFTtext_21_ipv4_natPre)


