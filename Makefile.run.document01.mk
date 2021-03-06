all: 


CFGrunGoINCset1:=\

CFGrunGoINCset2:=$(foreach aa1,$(CFGrunGoINCset1),$(TM)/$(aa1))

docDIRprefix0:=src src? src?? exampleSRC exampleSRC? exampleSRC?? 
docDIRprefix1:=$(foreach aa1,$(docDIRprefix0),$(aa1)/*. $(aa1)/*/*. $(aa1)/*/*/*.)
docDIRprefix2:=$(foreach aa1,$(docDIRprefix0),$(aa1)/Makefile* $(aa1)/*/Makefile* $(aa1)/*/*/Makefile*)
docVimFileSetS1:=$(sort $(wildcard $(foreach aa1,txt c h cpp hpp go pl plx bat BAT,     $(foreach aa2,$(docDIRprefix1),$(aa2)$(aa1)) )))
docVimFileSetS2:=$(sort $(wildcard $(foreach aa1,pdf,                                   $(foreach aa2,$(docDIRprefix1),$(aa2)$(aa1)) )))
docVimFileSetS3:=$(sort $(wildcard $(foreach aa1,jpg png gif jpeg bmp,                  $(foreach aa2,$(docDIRprefix1),$(aa2)$(aa1)) )))
docVimFileSetS4:=$(sort $(wildcard $(foreach aa1,doc docx ppt pptx xls xlsx,            $(foreach aa2,$(docDIRprefix1),$(aa2)$(aa1)) )))
docVimFileSetS5:=$(sort $(wildcard                                                      $(docDIRprefix2),$(aa2)                       ))
docVimFileSetS6:=$(sort $(wildcard $(foreach aa1,html htm xml,                          $(foreach aa2,$(docDIRprefix1),$(aa2)$(aa1)) )))

include $(CFGmakeEnv)


showRunHelpList += 

define showRunHelpTEXText1
endef


$(call genVimWithFileList,showSourceCodeTEXT1,$(docVimFileSetS1),vg)
$(call genVimWithFileList,showSourceCodeTEXT2,$(docVimFileSetS2),pg)
$(call genVimWithFileList,showSourceCodeTEXT3,$(docVimFileSetS3),jp)
$(call genVimWithFileList,showSourceCodeTEXT4,$(docVimFileSetS4),do)
$(call genVimWithFileList,showSourceCodeTEXT5,$(docVimFileSetS5),mm)
$(call genVimWithFileList,showSourceCodeTEXT6,$(docVimFileSetS6),ff)

$(iinfo docDIRprefix1 $(docDIRprefix1))
$(iinfo docVimFileSetS5 $(docVimFileSetS5))
$(iinfo docDIRprefix2 $(docDIRprefix2))
$(iinfo docVimFileSetS6 $(docVimFileSetS6))


$(eval $(foreach aa2,$(CFGrunGoINCset2),$(call tryINCmustExist,$(aa2),db8193911)))

aaa?=show_document_only
$(aaa)?=nothing_now
aaa: $($(aaa))

showRunHelpList += aaa 



