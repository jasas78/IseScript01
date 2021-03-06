all:




so:=showOption
so :
	@[ -z "$${showRunHelpTEXText4}" ] || echo "$${showRunHelpTEXText4}" 
	@echo "$${showOptionTEXT}" ; echo

h := help 
$(h) := showHelp
h :
	@[ -z "$${showRunHelpTEXText2}" ] || echo "$${showRunHelpTEXText2}" 
	@echo "$${showHelpTEXT}" ; echo

srh:=showRunHelp
$(srh):=show_all_operation_can_be_done_by_this_project_______current_dir
srh:
	@[ -z "$${showRunHelpTEXText1}" ] || echo "$${showRunHelpTEXText1}" 
	@echo "$${showRunHelpTEXT}" ; echo
	@[ -z "$${showRunHelpTEXText5}" ] || echo "$${showRunHelpTEXText5}" 
	@$(if $(GOapkNow),echo "    GOapkNow=$(GOapkNow)";echo "    GObinNow=$(GObinNow)";echo)
	@[ -z "$${showFtpHelpTEXTup}"   ] || echo "     $${showFtpHelpTEXTup}" 
	@[ -z "$${showFtpHelpTEXTdown}" ] || echo "     $${showFtpHelpTEXTdown}" 

ss:=showSourceCode
$(ss):=show_all_source_files_in_current_dir_for_vim_______current_dir
ssList:=0 1 2 3 4 5 6
ss: ssXX $(foreach aa1,$(ssList), ss$(aa1))
ssXX:
	@echo
	@[ -z "$${showRunHelpTEXText3}" ] || ( echo "$${showRunHelpTEXText3}" ; echo )
define ssTP1

ss$(1):
	@[ -z "$$$${showSourceCodeTEXT$(1)}" ] || ( echo "$$$${showSourceCodeTEXT$(1)}" ; echo )

endef
$(foreach aa1,$(ssList),$(eval $(call ssTP1,$(aa1))))
# showSourceCodeTEXT0 showSourceCodeTEXT1 

#ss0:
#	@echo "$${showSourceCodeTEXT0}"


$(call CallExpandHelpAll,showHelpTEXT,so sml srh )

showOptionList += $(showOptionListDefault)
$(call CallExpandHelpAll,showOptionTEXT,$(showOptionList))



ifdef inMakeScriptDIR
all: showOption showVimMakefileList
#	echo kkk99000021
else
showRunHelpList += $(showRunHelpListLast)
$(call CallExpandHelpAll,showRunHelpTEXT,$(showRunHelpList))

$(call CallExpandFtpALLup,   showFtpHelpTEXTup,   ftpRunHelpListUP)
$(call CallExpandFtpALLdown, showFtpHelpTEXTdown, ftpRunHelpListDOWN )

# showSourceCodeTEXT0 showSourceCodeTEXT1 
$(foreach aa1,$(ssList),$(eval export showSourceCodeTEXT$(aa1)))

#export showRunHelpTEXText1
$(foreach aa1,1 2 3 4 5,$(eval export showRunHelpTEXText$(aa1)))
export showRunHelpTEXT
export showFtpHelpTEXTup
export showFtpHelpTEXTdown

all: showSourceCode showOption showRunHelp $(if $(showLast),showLast)
#	echo kkk99000022
endif


