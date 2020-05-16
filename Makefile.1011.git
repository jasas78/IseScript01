all:



gs:=git_status
$(gs):=git_status______current_dir_files
gs :
	git status
gc:=git_commit
$(gc):=git_commit_with_date______current_dir_files
gc :
	rm -f date.now.txt
	echo "$(TT)_ _$(time_called)" > date.now.txt
	git commit -a --template=date.now.txt

gcXmmm:=$(shell (LC_ALL=C date +"%Y%m%d_%H%M%p")|tr "/\r\n-" _)
gcX:=git_commit_X
$(gcX):=git_commit_with_date______current_dir_filesX
gcX :
	nice -n 17 git commit -a -m $(gcXmmm)

#git:
#	@echo
#	@echo ' if met error, try ... '
#	@echo 'git config --global pack.windowMemory "32m"'
#	@echo 'git repack -a -d --window-memory 10m --max-pack-size 100m '
#	@echo

git :
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"
	git config --global pack.windowMemory           "32m"
	git config --global pack.packSizeLimit          "33m"
	git config --global pack.deltaCacheSize         "34m"
	git config --global pack.threads                "1"
	git config --global core.packedGitLimit         "35m"
	git config --global core.packedGitWindowSize    "36m"
	git config --global http.postbuffer             "5m"
	git config --global core.fileMode               false
	git repack -a -d --window-memory 10m --max-pack-size 50m

gitX:
	swapoff                /swapfile || echo
	#dd if=/dev/zero     of=/swapfile bs=1024 count=1048576
	dd if=/dev/zero     of=/swapfile bs=1024 count=4194304
	chmod 600              /swapfile
	mkswap                 /swapfile
	swapon                 /swapfile


gd:=git_diff
$(gd):=git_diff______current_dir_files
gd :
	git diff

ga:=git_add
$(ga):=git_add______current_dir_files
ga :
	git add .

showOptionListDefault += gs gc gcX gd ga

ifndef inMakeScriptDIR

gss:=git_status_______script_dir_files
gss:
	make -C $(TM) gs
#	cd $(TM) && git status
gcc:=git_commit_______script_dir_files
gcc:
	make -C $(TM) gc
#	cd $(TM) && rm -f date.now.txt
#	cd $(TM) && echo "$(TT)_ _$(time_called)" > date.now.txt
#	cd $(TM) && git commit -a --template=date.now.txt
#	cd $(TM) && sync

gdd:=git_diff_______script_dir_files
gdd:
	make -C $(TM) gd
#	cd $(TM) && git diff

gaa:=git_add_______script_dir_files
gaa :
	make -C $(TM) ga

gcXX:=git_commit_XX
$(gcXX):=git_commit_with_date______script_dir_filesXX
gcXX :
	make -C $(TM) gcX


showOptionListDefault += gss gcc gcXX gdd gaa
endif
