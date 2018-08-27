all:


# NFtext_blockIpv6

ng1:=genGroup01
$(ng1):=nc1 nf1 nf31 
ng1: $($(ng1))

linuxNft_OpList+=		\
	ng1						\


tgDST_ALL:=vm37 vm39 vm40 vm41 vm42 vm43 vm44 vm45 vm46

tgDST_idx=1

define tgDST_macroX

endef

define tgDST_macro
tg$(tgDST_idx)_DST:=$(1)
tg$(tgDST_idx):=modifi_then_gen_the_test_group__$$(tg$(tgDST_idx)_DST)
$$(tg$(tgDST_idx)):= $$($$(tg$(tgDST_idx)_DST)) $($(ng1))

tg$(tgDST_idx):
	make $$(tg$(tgDST_idx)_DST)
	make $$(ng1)

linuxNft_OpList+=		\
	tg$(tgDST_idx)						\


$$(eval linuxNft_OpList += $$(if $(strip $$(shell [ $$$$(($$(tgDST_idx) % 3 )) = 2 ] && echo -n 111 )),space) )

$$(eval tgDST_idx:=$$(strip $$(shell echo -n $$$$(($$(tgDST_idx)+1)))))

endef

$(foreach aa1,$(tgDST_ALL),$(eval $(call tgDST_macro,$(aa1))))




