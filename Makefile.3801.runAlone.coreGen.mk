env64:=LD_LIBRARY_PATH=/lib64:/usr/lib64
env32:=LD_LIBRARY_PATH=/lib:/usr/lib:/lib32:/usr/lib32
awk:=$(env64) awk

all:

#$(info ) $(info ISEbin $(ISEbin)) $(info ) $(error )
coregen:=$(ISEbin)/coregen

define EOL


endef

cg:=coreGen

cgDIR:=$(shell pwd)
cgROMname?=cgROMname
$(info cgROMname:$(cgROMname))
cgSRCdir:=$(shell dirname $(cgROMname))
cgSRCname1:=$(shell basename $(cgROMname))
cgSRCname2:=$(patsubst %.xise,%, $(cgSRCname1) )
cgSRCname31:=$(cgSRCdir)/$(cgSRCname2).xco
cgSRCname32:=$(cgSRCdir)/coregen.cgp
cgLOADfile1:=$(shell realpath $(cgROMcontent) )

#$(eval \
#	$(info )\
#	$(foreach aa1,\
#	cgDIR \
#	cgROMname \
#	cgROMcontent\
#	cgSRCdir\
#	cgSRCname1\
#	cgSRCname2\
#	cgSRCname31\
#	cgSRCname32\
#	cgLOADfile1\
#	, \
#	$(info $(aa1) -> $($(aa1)) -> $(shell cat $($(aa1)) |md5sum |$(awk) '{print $$1}') \
#	))\
#	$(info )\
#	)

cgInfo:
	$(foreach aa1,\
	cgDIR \
	cgROMname \
	cgROMcontent \
	cgSRCdir \
	cgSRCname1 \
	cgSRCname2 \
	cgSRCname31 \
	cgSRCname32 \
	cgLOADfile1 \
	, \
	@echo "$(aa1) -> $($(aa1)) -> $$( [ -f $($(aa1)) ] && (cat $($(aa1)) |md5sum |$(awk) '{print $$1}' ) || echo ' no_a_file ' )" \
	$(EOL))


c clean : cgInfo
	rm -f          $(cgSRCname2).*  $(cgSRCname2)_flist.txt $(cgSRCname2)_xmdf.tcl \
		coregen.cgp coregen.log coregen.cgc summary.log 
	rm -fr         tmp/ $(cgSRCname2)/ xlnx_auto_?_xdb/
	ls -l
cg $(cg) : clean 
	[ -n "$(cgROMcontent)" -a -f "$(cgROMcontent)" ] || ( echo ; echo ' why no soruce file $$cgROMcontent ? ' ; echo ; exit 38 )
	cp              $(cgSRCname31) $(cgSRCname32) ./
	chmod 644       $(cgSRCname2).* coregen.*
	dos2unix        $(cgSRCname2).* coregen.*
	sed -i -e 's;^CSET *coe_file=.*$$;CSET coe_file=$(cgLOADfile1);g'  $(cgSRCname2).xco
	cd .. && cp $(cgLOADfile1) used_coe_is_$$(cat $(cgLOADfile1)|md5sum|$(awk) '{print $$1}')__$$(echo $(cgLOADfile1)|sed -e 's;/;_;g').coe
	ls -l
	$(coregen)         -p $${PWD}          -b ./$(cgSRCname2).xco
	ln -s $(cgSRCname1)_cDIR/$(cgSRCname2).v   ../
	ln -s $(cgSRCname1)_cDIR/$(cgSRCname2).ngc ../
	ln -s $(cgSRCname1)_cDIR/$(cgSRCname2).veo ../
