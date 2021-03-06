
all:

df321:=diff_win_linx__xst_para
df321:
	@cat nowX/FPGA_TOP.xst |unix2dos|dos2unix\
		|sort \
		> 1.txt
	@cat out/$(FNxstSCR1) |unix2dos|dos2unix\
		|sort \
		> 2.txt
	@echo diff nowX/FPGA_TOP.xst out/$(FNxstSCR1) \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	vim 9.diff

df322:=diff_win_linx__verilog_file_list
df322:
	@cat nowX/FPGA_TOP.prj |unix2dos|dos2unix\
		|$(awk) '{print $$3}' \
		|xargs -n 1 basename \
		|sort \
		> 1.txt
	@cat out/$(FNxstSCR2) |unix2dos|dos2unix\
		|$(awk) '{print $$3}' \
		|xargs -n 1 basename \
		|sort \
		> 2.txt
	@echo diff nowX/FPGA_TOP.prj out/$(FNxstSCR2) \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	#vim 9.diff
	vimdiff 1.txt 2.txt

df341:=diff_win_linx__ngdbuild_para
df341:
	cat nowX/FPGA_TOP.cmd_log |unix2dos|dos2unix\
		|grep ^'ngdbuild ' \
		|tail -n 1 \
		|sed -e 's;\s-;\n-;g' \
		|sort \
		> 1.txt
	@cat out/$(FNngdCMD1) |unix2dos|dos2unix\
		|sed -e 's;\s-;\n-;g' \
		|sort \
		> 2.txt
	@echo diff nowX/FPGA_TOP.cmd_log out/$(FNngdCMD1) \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	#vim 9.diff
	vimdiff 1.txt 2.txt

# diff tmp/obj_proj_FPGA_TOP_34_2_ngd_ngdbuild.xrpt nowX/FPGA_TOP_ngdbuild.xrpt |wc
df342:=diff_win_linx__ngdbuild_report
df342:
	cat nowX/FPGA_TOP_ngdbuild.xrpt |unix2dos|dos2unix\
		|sed -e '1,/NGDBUILD_REPORT/ d' \
		> 1.txt
	@cat tmp/obj_$(FNngdEXT0)_ngdbuild.xrpt |unix2dos|dos2unix\
		|sed -e '1,/NGDBUILD_REPORT/ d' \
		> 2.txt
	@echo diff nowX/FPGA_TOP_ngdbuild.xrpt tmp/obj_$(FNngdEXT0)_ngdbuild.xrpt \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	#vim 9.diff
	vimdiff 1.txt 2.txt

df361:=diff_win_linx__map_para
df361:
	cat nowX/FPGA_TOP.cmd_log |unix2dos|dos2unix\
		|grep ^'map ' \
		|tail -n 1 \
		|sed -e 's;\s-;\n-;g' \
		|sort \
		> 1.txt
	@cat out/$(FNmapCmd1) |unix2dos|dos2unix\
		|sed -e 's;\s-;\n-;g' \
		|sort \
		> 2.txt
	@echo diff nowX/FPGA_TOP.cmd_log out/$(FNmapCmd1) \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	vim 9.diff

# diff nowX/FPGA_TOP_map.mrp out/log2_obj_proj_FPGA_TOP_36_3_map.mrp
df362:=diff_win_linx__map_report
df362:
	cat nowX/FPGA_TOP_map.mrp |unix2dos|dos2unix\
		|sed -e '1,/^Design Summary/ d' \
		|sed -e '/^Table of Contents/,$$ d' \
		> 1.txt
	@cat out/log2_$(FNmapOut0).mrp |unix2dos|dos2unix\
		|sed -e '1,/^Design Summary/ d' \
		|sed -e '/^Table of Contents/,$$ d' \
		> 2.txt
	@echo diff nowX/FPGA_TOP.cmd_log out/log2_$(FNmapOut0).mrp \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	#vim 9.diff
	vimdiff 1.txt 2.txt 

df371:=diff_win_linx__par_para
df371:
	cat nowX/FPGA_TOP.cmd_log |unix2dos|dos2unix\
		|grep ^'par ' \
		|tail -n 1 \
		|sed -e 's;\s-;\n-;g' \
		|sort \
		> 1.txt
	@cat out/$(FNparCmd1) |unix2dos|dos2unix\
		|sed -e 's;\s-;\n-;g' \
		|sort \
		> 2.txt
	@echo diff nowX/FPGA_TOP.cmd_log out/$(FNparCmd1) \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	vim 9.diff

# nowX/FPGA_TOP.par out/log2_obj_proj_FPGA_TOP_37_4_par_outNCD.par
# out/log2_$(FNparOut0).par
df372:=diff_win_linx__par_report
df372:
	cat nowX/FPGA_TOP.par |unix2dos|dos2unix\
		> 1.txt
	@cat out/log2_$(FNparOut0).par |unix2dos|dos2unix\
		> 2.txt
	@echo diff nowX/FPGA_TOP.par out/log2_$(FNparOut0).par \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	#vim 9.diff
	vimdiff 1.txt 2.txt 

df391:=diff_win_linx__bitgen_para
df391:
	cat nowX/FPGA_TOP.ut |unix2dos|dos2unix\
		|sed -e 's;\s-;\n-;g' \
		|sort \
		> 1.txt
	@cat out/$(FNbitScr1) |unix2dos|dos2unix\
		|sed -e 's;\s-;\n-;g' \
		|sort \
		> 2.txt
	@echo diff nowX/FPGA_TOP.ut out/$(FNbitScr1) \
		> 9.diff
	diff 1.txt 2.txt \
		>> 9.diff || echo -n
	vim 9.diff


showRunHelpList += df321 df322 df341 df342 df361 df362 df371 df372 df391   
