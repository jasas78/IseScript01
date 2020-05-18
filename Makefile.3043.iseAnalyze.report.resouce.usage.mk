all:

an:=analyze_ise_report_for_resource_usage
$(an):=Makefile.3043.iseAnalyze.report.resouce.usage.mk
an:
	 @echo
	 @cd out && \
		 grep ' out  *of ' log_* \
		 |sed \
		 -e 's; \+\([0-9]\+ \+out \+of\) \+;: \1;g' \
		 -e 's;:\+;:;g' \
		 -e 's; \+; ;g' \
		 |$(awk) -F: '{printf "%25s _ %50s _ %s \n\r" , $$1 , $$2, $$3}' 
	 @echo



showRunHelpList += an
