all: 

### /usr/bin/ld: skipping incompatible /usr/lib/gcc/x86_64-linux-gnu/7/libgcc.a when searching for -lgcc
### if the above error met : apt install g++-multilib
### or , if you are using a gcc package other than the default one (e.g. gcc-7), 
### and you want small size ,
### then you'll need to install the package for that specific version:
### apt install g++-7-multilib

ifeq (,$(GoTOP))
$(info )
$(info ' go lang project , should has a VAR named GoTOP being defined in Makefile.env')
$(info '                   as the end target name; ')
$(info ' and the src files being put into the src?/*.go' )
$(info )
$(error )
endif


CFGrunGoINCset1:=\
Makefile.3071.beautifyBase    \
Makefile.3073.beautifyGo    \
Makefile.4001.go.lang.analyze    \

CFGrunGoINCset2:=$(foreach aa1,$(CFGrunGoINCset1),$(TM)/$(aa1))

goVimFileSetSgo1:=src src? src?? exampleSRC exampleSRC? exampleSRC?? 
goVimFileSetSgo2:=*.go *.xml Makefile* makefile*
goVimFileSetSgo8:=$(foreach aa1,$(goVimFileSetSgo1),$(foreach aa2,$(goVimFileSetSgo2),$(aa1)/$(aa2)))
goVimFileSetSgo9:=$(sort $(wildcard $(goVimFileSetSgo8)))

$(iinfo goVimFileSetSgo8 $(goVimFileSetSgo8))
$(iinfo goVimFileSetSgo9 $(goVimFileSetSgo9))

include $(CFGmakeEnv)


tmp_localProject_path:=$(shell  dirname  `realpath .`)
tmp_localProject_name1:=$(shell basename `realpath .`)
tmp_localProject_name2:=$(shell \
	[ -f src/AndroidManifest.xml ] \
	&& (grep '\bpackage=' src/AndroidManifest.xml |tr '"' ' ' |awk '{printf $$2}') \
	|| echo org.golang.todo.$(tmp_localProject_name1) \
	)
tmp_localProject_name3:=$(shell \
	echo $(tmp_localProject_name2) |tr '-' '_')
dstApkList:=mobile/$(GoTOP).apk
dstAPK:=$(firstword $(dstApkList))
dstAPK:=mobile/$(tmp_localProject_name1).apk

c:=clean_all_tmp_files_during_go_compile
$(c):= cm 
c:$($(c))

cm:=clean_mobile
$(cm):=clean_mobile_tmp_files
cm:
	[ -d mobile ] || mkdir mobile
	rm -f mobile/*.apk

ll:=list_tmp_and_out_directory
ll:
	@echo ; ls -dl mobile/* ; echo 

bm:=bb
$(bm):=build_go_lang_for_mobile
bm :
	@[ -d mobile ] || mkdir mobile
	rm -f /tmp/tmp.localProject 
	rm -f $(tmp_localProject_name1)
	ln -s src/ $(tmp_localProject_name1)
	ln -s $(tmp_localProject_path)/    /tmp/tmp.localProject
	$(GObinPathX)          \
		$(GOapkNow)        \
		build              \
		-target=android    \
		-v                 \
		-o      $(dstAPK)  \
		tmp.localProject/$(tmp_localProject_name1)/$(tmp_localProject_name1)/ \
		|| \
		( echo ; echo ;  \
		echo " if errer is ---->>>  does not import \"golang.org/x/mobile/app\"" ; \
		echo if means this program is not for android , so , use go , instead of gomobile. ; \
		echo ;  echo ; exit 11 )
	@echo "$$(ls -l mobile/* -d)         $$(ls -lh mobile/* -d |awk '{print $$5}')"

in:=im
$(in):=install_target_apk_built_by_gomobile
in :
	-adb uninstall $(tmp_localProject_name3)
	adb install -r $(dstAPK)  
tm:=test
$(tm):=run_target_apk_built_by_gomobile
tm :
	adb shell am start -n $(tmp_localProject_name3)/org.golang.app.GoNativeActivity
#	adb shell am start -n org.golang.todo.$(tmp_localProject_name1)/org.golang.app.GoNativeActivity
#tmp_localProject_name3=$(tmp_localProject_name3)

un:=um
$(un):=uninstall_the_android_package_apk
un :
	-adb uninstall $(tmp_localProject_name3)

showRunHelpList += cm c ll bm in tm un vpgo tour

define showRunHelpTEXText1
endef


$(call genVimWithFileList,showSourceCodeTEXT0,$(goVimFileSetSgo9),vg)


$(eval $(foreach aa2,$(CFGrunGoINCset2),$(call tryINCmustExist,$(aa2),db8193911)))

aaa:=build_arm_arm64_x86_x86-64_for_android__and_install
$(aaa):=cm bm in tm
aaa: $($(aaa))

bbb:=build_arm_arm64_x86_x86-64_for_android__build_only
$(bbb):=cm bm 
bbb: $($(bbb))

showRunHelpList += aaa bbb

#$(info goVimFileSetSgo9 -> $(goVimFileSetSgo9))
btList01verilog += $(goVimFileSetSgo9)


