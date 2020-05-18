
all:

nf31_TEXT:=\
	NFTtext_11_ipv4_input \
	NFTtext_13_ipv4_output \
	NFTtext_15_ipv4_forward \
	NFTtext_21_ipv4_natPre \
	NFTtext_23_ipv4_natPost \
	NFTtext_25_ipv4_natInPut \
	NFTtext_27_ipv4_natOutPut \
	NFTtext_29_ipv4_natForward \

#$(foreach aa1,$(nf31_TEXT),\
#  $(eval export $(aa1) )	\
#)

nf31:=deal_with_local_machine_packages_ipv4
nf31:
	$(foreach aa1,$(nf31_TEXT),\
		echo "$${$(aa1)}"  $(NFTsed1)     >> $(NFTfile)$(EOL)$(EOL))
	@wc                                     $(NFTfile)

linuxNft_OpList+=		\
	nf31						\


