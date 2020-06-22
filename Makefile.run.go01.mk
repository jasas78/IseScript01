all: 

### /usr/bin/ld: skipping incompatible /usr/lib/gcc/x86_64-linux-gnu/7/libgcc.a when searching for -lgcc
### if the above error met : apt install g++-multilib
### or , if you are using a gcc package other than the default one (e.g. gcc-7), 
### and you want small size ,
### then you'll need to install the package for that specific version:
### apt install g++-7-multilib

ifeq (,$(GoTOP))
$(info )
$(info ' go lang project , should has a VAR named GoTOP being defined in Makefile.env.mk')
$(info '                   as the end target name; ')
$(info ' and the src files being put into the src?/*.go' )
$(info )
$(error )
endif

# https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63
GOOS_list := android darwin dragonfly freebsd linux nacl netbsd openbsd plan9 solaris windows zos
GOARCH_list := 386 amd64 amd64p32 arm armbe arm64 arm64be ppc64 ppc64le \
	mips mipsle mips64 mips64le mips64p32 mips64p32le ppc s390 s390x sparc sparc64
GOARCH_list32 := 386 amd64p32 arm armbe mips mipsle mips64p32 mips64p32le ppc s390 sparc
GOARCH_list64 := amd64 arm64 arm64be ppc64 ppc64le mips64 mips64le s390x sparc64
GOOS_GOARCH_32 := darwin/386 freebsd/386 freebsd/arm linux/386 linux/arm linux/mips linux/mipsle \
	nacl/386 nacl/amd64p32 nacl/arm netbsd/386 netbsd/arm openbsd/386 openbsd/arm plan9/386 plan9/arm windows/386
GOOS_GOARCH_64 := darwin/amd64 dragonfly/amd64 freebsd/amd64 linux/amd64 linux/arm64 linux/ppc64 linux/ppc64le \
    linux/mips64 linux/mips64le linux/s390x netbsd/amd64 openbsd/amd64 plan9/amd64 solaris/amd64 windows/amd64

GoPreWin386:=     GOOS=windows GOARCH=386
GoPreWinALL?=     Win386

GoPreLinux386:=   GOOS=linux   GOARCH=386
GoPreLinuxX64:=   GOOS=linux   GOARCH=amd64
GoPreLinuxArm:=   GOOS=linux   GOARCH=arm
GoPreLinuxArm64:= GOOS=linux   GOARCH=arm64
GoPreLinuxALL?= Linux386 LinuxArm LinuxX64 LinuxArm64
GoPreDockerALL?= Linux386 LinuxArm LinuxX64 LinuxArm64

StripLinux386:=strip
StripLinuxX64:=strip
StripLinuxArm:=$(firstword   $(wildcard $(shell which arm-none-eabi-strip)        $(shell which llvm-strip)))
StripLinuxArm64:=$(firstword $(wildcard $(shell which aarch64-linux-gnu-strip)    $(shell which llvm-strip)))
ifeq (,$(StripLinuxArm))
$(info ) $(info ) $(info not StripLinuxArm exist. 83818198 )
$(info ) $(error )
endif

Wput_default :=wput -u -nc 

CFGrunGoINCset1:=\
Makefile.1021.docker01.mk \
Makefile.3071.beautifyBase.mk    \
Makefile.3073.beautifyGo.mk    \
Makefile.4001.go.lang.analyze.mk    \

CFGrunGoINCset2:=$(foreach aa1,$(CFGrunGoINCset1),$(TM)/$(aa1))

#goVimFileSetS2:=$(sort $(wildcard src/*.go src?/*.go ))
#goVimFileSetS:=$(sort $(foreach aa1, $(goVimFileSetS2) $(goVimFileSetS2) ,$(shell /usr/bin/realpath --relative-to . $(aa1))))
goVimFileSetS:=$(sort $(shell /usr/bin/realpath --relative-to . $(wildcard src/*.go src?/*.go )))

include $(CFGmakeEnv)

create_tmp_dir:=$(shell [ -d  win/ ] || mkdir -p win/ )
create_tmp_dir+=$(shell [ -d  lnx/ ] || mkdir -p lnx/ )

c:=clean_all_tmp_files_during_go_compile
$(c):= cw cl
c:$($(c))

cw:=clean_win
$(cw):=clean_win_tmp_files
cw:
	rm -fr win/*
cl:=clean_linux
$(cl):=clean_linux_tmp_files
cl:
	rm -fr lnx/*

ll:=list_tmp_and_out_directory
ll:
	@ls -dl win/* ; echo ;ls -dl lnx/* ; 

bw:=build_go_lang_for_win
bw: $(foreach aa2,$(GoPreWinALL),\
	$(foreach aa1,$(GoTOP),\
		win/$(aa1).win.$(aa2).exe \
		))
	@ls -l win/* -d

#	$(GoPreWin386) \
#		$(GObinNow) \
#		build  -o win/$(GoTOP).win.exe $(goVimFileSetS) 
#	echo strip win/$(GoTOP).win.exe
#	ls -l win/* -d
ifdef wputPATH
	$(Wput_default) win/$(GoTOP).win.exe $(wputPATH)/ 
endif

bl:=build_go_lang_for_linux
bl: $(foreach aa2,$(GoPreLinuxALL),\
	$(foreach aa1,$(GoTOP),\
		lnx/$(aa1).lnx.$(aa2).exe \
		))
	@ls -l lnx/* -d


define build_go_lang_tp02
endef
define build_go_lang_tp01
$(eval lnxGoSrc00:=$(wildcard $(1) $(1).go src?/$(1) src?/$(1).go))
$(eval $(iinfo lnxGoSrc00::::=NOTexist183817:$1))
$(eval $(if $(strip $(lnxGoSrc00)),,$(error 8119191 why file [$1] do NOT exist ?)))
$(eval lnxGoDir01:=$(shell dirname $(firstword $(lnxGoSrc00))))
$(eval lnxGoSrc01:=\
	$(if $($(1)),\
	$(wildcard $(foreach bb1,$($(1)),$(bb1) $(bb1).go $(lnxGoDir01)/$(bb1) $(lnxGoDir01)/$(bb1).go )) \
	,$(goVimFileSetS)\
	)\
)
$(if $(wildcard $(filter %test.go,$(lnxGoSrc01))),$(error " *test.go is not allow in the source file." ))
lnx/$(1).lnx.$(2).exe : $(lnxGoSrc01)
	@echo "building...[$$@]"
	CGO_ENABLED=0 \
				$(GoPre$(2)) \
				$$(GObinNow) \
				build  \
				-a -ldflags '-w -extldflags "-static"' \
				-tags 'osusergo netgo static_build' \
				-o lnx/$(1).lnx.$(2).exe \
				$(lnxGoSrc01)
	$(Strip$(2)) lnx/$(1).lnx.$(2).exe
	$(if $(strip $(DockerList)),-echo ; docker image rm -f \
		$$(DockerUserName)/$(shell echo $(1).lnx.$(2).exe|tr [A-Z] [a-z]|tr -d '\.\-_' 2>/dev/null) \
		> /dev/null \
		)

win/$(1).win.$(2).exe : $(lnxGoSrc01)
	@echo "building...[$$@]"
	CGO_ENABLED=0 \
				$(GoPre$(2)) \
				$$(GObinNow) \
				build  \
				-a -ldflags '-w -extldflags "-static"' \
				-tags 'osusergo netgo static_build' \
				-o win/$(1).win.$(2).exe \
				$(lnxGoSrc01)

endef

$(iinfo GoPreLinuxALL:$(GoPreLinuxALL))
$(iinfo GoTOP:$(GoTOP))
$(foreach aa2,$(GoPreLinuxALL),\
	$(foreach aa1,$(GoTOP),\
	$(eval $(call build_go_lang_tp01,$(aa1),$(aa2)))\
	))
$(foreach aa2,$(GoPreWinALL),\
	$(foreach aa1,$(GoTOP),\
	$(eval $(call build_go_lang_tp01,$(aa1),$(aa2)))\
	))

ttX1:=test

$(ttX1):=$(foreach aa2,$(GoPreLinuxALL),$(foreach aa1,$(GoTOP),lnx/$(aa1).lnx.$(aa2).exe ))
ttX1:
	$(foreach aa2,$(GoPreLinuxALL),$(foreach aa1,$(GoTOP),lnx/$(aa1).lnx.$(aa2).exe $(runPara_$(aa1)) $(EOL)))
	@reset

t:=ttX1
t:ttX1

showRunHelpList += cw cl c ll bw bl ttX1  t vpgo tour

define showRunHelpTEXText1
endef


$(call genVimWithFileList,showSourceCodeTEXT0,$(goVimFileSetS),vg)


$(eval $(foreach aa2,$(CFGrunGoINCset2),$(call tryINCmustExist,$(aa2),db8193911)))

aaa:=build_win_and_linux_execute_bin_fileS
$(aaa):=cw cl bw bl
aaa: $($(aaa))

lnxAll:=build_and_test_linux_only
$(lnxAll):=cl bl ttX1
lnxAll:$($(lnxAll))

showRunHelpList += aaa lnxAll

#$(info goVimFileSetS -> $(goVimFileSetS))
btList01verilog += $(goVimFileSetS)


