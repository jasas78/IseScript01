all:

#$(NFTbin)     
NFTcnt:= counter packets 0 bytes 0 
NFTset_1:=$(NFTcnt) meta nftrace set 1

define NFtext_blockIpv6

####### "ip6" is family : ip ip6 inet arp bridge inet netdev
add table ip6 tbBlockIp6         

####### "filter" is type : filter route nat 
####### "input"  is hook : 
################ hoo for ip / ip6 / inet : preroouting input forward output postrouting 
################ hoo for arp             : input output 
################ hoo for bridge          : ..... ( none ) 
################ hoo for netdev          : ingress
####### "policy"  can be : accept drop queue continue return
####### "priority_value" can be : 
############### NF_IP_PRI_CONNTRACK_DEFRAG           (-400)
############### NF_IP_PRI_RAW                        (-300)
############### NF_IP_PRI_SELINUX_FIRST              (-225)
############### NF_IP_PRI_CONNTRACK                  (-200)
############### NF_IP_PRI_MANGLE                     (-150)
############### NF_IP_PRI_NAT_DST                    (-100)
############### NF_IP_PRI_FILTER                     (0)
############### NF_IP_PRI_SECURITY                   (50)
############### NF_IP_PRI_NAT_SRC                    (100)
############### NF_IP_PRI_SELINUX_LAST               (225)
############### NF_IP_PRI_CONNTRACK_HELPER           (300)
# nft add rule [<family>] <table> <chain> <matches> <statements>
#### rule_match can be :
#### #### #### match ip      : dscp <dscpV> , length <lenV>, 
#### #### ####                 id <idV>, frag-off <fV> , ttl <ttlV>, protocol <pV> checksum <cV>, hdrlength <hV>
#### #### ####                 saddr <sV>, daddr <dV>, version <vV> 
#### #### #### match ip6     : dscp <dscpV> , length <lenV>, 
#### #### ####                 flowlabel <fV>, nexthdr <hV>, hoplimit < hV> saddr
#### #### ####                 saddr <sV>, daddr <dV>, version <vV>
#### #### #### match tcp     : dport <> , sport <>, sequence <>, askseq <>, flags <>
#### #### ####                 window <> , checksum <>, urgptr <>, doff <>
#### #### #### match udp     : dport <> , sport <>, length <>, checksum <>
#### #### #### match udplite : dport <> , sport <>, checksum <>
#### #### #### match sctp    : dport <> , sprot <>, checksum <>, vtag <>
#### #### #### match dccp    : dport <> , sprot <>, type <>
#### #### #### match ah      : hdrlength <>, reserved <>, spi <>, sequence <>
#### #### #### match esp     : spi <>, sequence <>
#### #### #### match comp    : nexthdr <>, flags <>, cpi <>
#### #### #### match icmp    : type <>, code <>, checksum <>, id <>, sequence <> , mtu <> , gameway <>
#### #### ####       icmp-type : echo-reply, destination-unreachable, source-quench, redirect, echo-request, 
#### #### ####                   time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, 
#### #### ####                   address-mask-request, address-mask-reply, router-advertisement, router-solicitation
#### #### #### match icmpv6  : type <>, code <>, checksum <>, id <>, sequence <> , mtu <> , max-delay <>
#### #### ####       icmp-type : destination-unreachable, packet-too-big, time-exceeded, echo-request, 
#### #### ####                   echo-reply, mld-listener-query, mld-listener-report, mld-listener-reduction, 
#### #### ####                   nd-router-solicit, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, 
#### #### ####                   nd-redirect, parameter-problem, router-renumbering
#### #### #### match ether   : saddr <>, type <>
#### #### #### match dst     : nexthdr <>, hdrlength <>
#### #### #### match frag    : nexthdr <>, reserved <>, frag-off <>, more-fragments <>, id <>
#### #### #### match hbh     : nexthdr <>, hdrlength <>
#### #### #### match mh      : nexthdr <>, hdrlength <>, type <>, reserved <>, checksum <>
#### #### #### match rt      : nexthdr <>, hdrlength <>, type <>, seg-left <>
#### #### #### match vlan    : id <>, cfi <>, pcp <>
#### #### #### match arp     : ptype <>, htype <>, hlen <>, plen <>, operation <nak, inreply, inrequest, rreply, rrequest, reply, request>
#### #### #### match ct      : state <new, established, related, untracked> , direction <reply/original>
#### #### ####                 status <expected,seen-reply,assured,confirmed,snat,dnat,dying>, mark<>, expiration <>
#### #### ####                 helper "<>"
#### #### ####      ct [original | reply] : bytes <> , packets <> , saddr <> , daddr <>, l3proto <>, protocol <>, proto-dst <>, proto-src <>
#### #### #### match meta      : iifname <>, oifname <>, iif <> , oif <>, iiftype <ether, ppp, ipip, ipip6, loopback, sit, ipgre>
#### #### ####                   oiftype <>, length <>, protocol <>, nfproto <>, l4proto <>, mark [set] <>, skuid <user id>
#### #### ####                   skgid <group id>, rtclassid <class>, pkttype <broadcast, unicast, multicast>
#### #### ####                   cpu <>, iifgroup <>, oifgroup <>, cgroup <group>, 
#### rule_match end ####
#### rule_statements can be : 
#### ####     verdict statements : accept drop queue continue return jump goto 
#### ####     log     statements : level [over] <value> <unit> [burst <value> <unit>]
#### ####                          group <value> [queue-threshold <value>] [snaplen <value>] [prefix "<prefix>"]	
#### ####     reject  statements : with <protocol> type <type>
#### ####     counter statements : packets <packets> bytes <bytes>
#### ####     limit   statements : rate [over] <value> <unit> [burst <value> <unit>]
#### ####     nat     statements : dnat <>, snat <>, masquerade [<type>] [to :<port>]
#### ####     queue   statements : num <value> <scheduler>


add chain ip6 tbBlockIp6 chBlockIp6input    { type filter hook input   priority 310 ; policy drop ; }
add chain ip6 tbBlockIp6 chBlockIp6forward  { type filter hook forward priority 320 ; policy drop ; }
add chain ip6 tbBlockIp6 chBlockIp6output   { type filter hook output  priority 330 ; policy drop ; }

add rule  ip6 tbBlockIp6 chBlockIp6input        $(NFTcnt) drop
add rule  ip6 tbBlockIp6 chBlockIp6forward      $(NFTcnt) drop
add rule  ip6 tbBlockIp6 chBlockIp6output       $(NFTcnt) drop

endef
export NFtext_blockIpv6:=$(NFtext_blockIpv6)

#$(nf1):=ws2 wv1
#nf1: $($(nf1))

nf1:=BlockAllipv6Package
nf1: 
	echo "$${NFtext_blockIpv6}"  $(NFTsed1)      >> $(NFTfile)
	@wc                                     $(NFTfile)

linuxNft_OpList+=		\
	nf1						\


