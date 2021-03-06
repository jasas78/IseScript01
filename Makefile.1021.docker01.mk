

all:

# https://segmentfault.com/a/1190000000628247
# https://xebia.com/blog/create-the-smallest-possible-docker-container/
# https://medium.com/@adriaandejonge/simplify-the-smallest-possible-docker-image-62c0e0d342ef
#
#
#
# 1. 
# #### if use build-in : apt install docker docker.io( /usr/bin/docker )
# #### but : # https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce told us :
# 1.0 : if you need to clear the old-version docker-exe : apt-get remove docker docker-engine docker.io containerd runc
#       if you need to clear the old-version data : #      rm -fr /var/lib/docker/* ;  systemctl status docker
# 1.1 apt update
# 1.2 :
# apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
# apt-get remove docker docker-engine docker.io containerd runc
# 1.3 : curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# 1.4 :
# ubuntu : add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# debian : add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
# 1.5 : apt update
# 1.6 : apt-get install docker-ce docker-ce-cli containerd.io
# 1.9 : docker run hello-world
#
# 2. 
# systemctl enable docker.socket ; 
# systemctl start  docker.socket ; 
# systemctl enable docker.service ; 
# systemctl start  docker.service ;
#
# 3. add the user "dyn" into the group "docker" : usermod -aG docker dyn 
#
# 4.  ( don't run by root , using dyn )
# tar cv --files-from /dev/null | docker import - scratch 
# docker run -ti google/golang /bin/bash
# ##### then : see : /var/lib/docker/
# ## exit.
#
# 5.  ( don't run by root , using dyn )
# docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):$(which docker) -ti google/golang /bin/bash
# go get github.com/adriaandejonge/helloworld
# ### failed because newest version $GOPATH has multi-path ### cp $GOPATH/src/github.com/adriaandejonge/helloworld/Dockerfile $GOPATH
# cp /go/src/github.com/adriaandejonge/helloworld/Dockerfile /go/
# 
# 6. docker's id / account and password store in : ~/.docker/config.json
# dengyanuoapp@jjj123.com 
# 7. https://training.play-with-docker.com/ops-s1-hello/ can run a docker in classrom
#    https://training.play-with-docker.com/about/
#

ifdef DockerList
DockerUserName?=dengyanuoapp
DockerSource?=dyn_empty_docker
#DockerSource:=scratchx
DockerSource:=$(strip $(DockerSource))
DockerSrc01:=$(strip $(shell docker images|grep $(DockerSource)|awk '{print $$3}'))
$(iinfo DockerSrc01:$(DockerSrc01))
$(if $(DockerSrc01),,\
	$(info )\
	$(info DockerSrc01 want [$(DockerSource)] null or not exist. exit)\
	$(info you should run the following command :)\
	$(info tar cv --files-from /dev/null | docker import - dyn_empty_docker)\
	$(info )\
	$(error DockerSrc01 want [$(DockerSource)] null or not exist. exit))

define DockerBuildTP02
@echo "#$1,$2"                             >> $3
@echo "FROM $(DockerSource) AS $2"         >> $3
@echo "COPY lnx/$1      /lnx/$1"           >> $3

@echo                                      >> $3

endef

#-docker rmi $2 2>/dev/null
#-docker push   $2:`date +"%Y_%m_%d__%H%M%S__%s"`
define DockerBuildTP01
tar -cf -   -C lnx       $1|docker import --change 'CMD ["/$1"]' - $2
$(if $(noupload),,-docker push   $2)

endef

define DockerBuildTP03
$(eval bb1:=$(1).lnx.$(2).exe)\
$(eval bb2:=$(DockerUserName)/$(shell echo $(1).lnx.$(2).exe|tr [A-Z] [a-z]|tr -d '\.\-_'))\
$(eval bb3:=$(strip $(shell docker images |grep ^'$(bb2)\b')))\
$(iinfo $(bb1),$(bb2),$(bb3))\
$(if $(bb3),@echo "$(bb3) ... ... ... skip",\
$(call DockerBuildTP01,$(bb1),$(bb2))\
)

endef


dkb:=build_docker_images_for_test_only
dkb:
	@echo "Runing $($@)"
	$(foreach aa1,$(DockerList),\
	$(foreach aa2,$(GoPreDockerALL),\
	$(call DockerBuildTP03,$(aa1),$(aa2))\
	))
	-docker images |grep ^'$(DockerUserName)/' 2>/dev/null 

#	@echo "_doing $(aa1) $(aa2) lnx/$(bb1) $(bb2)" ;\
#	exit 33$(EOL)\
#

dkcn:=clean_docker_none
dkcn :
	@echo "Runing $($@)"
	 @echo ; for aa1 in $$(docker image ls -a  |grep '<none>'  |awk '{print $$3}' ) ; do\
		 echo docker image rm $${aa1} ; \
		      docker image rm $${aa1} ; \
		 done
dkcc:=clean_docker_cache
dkcc: 
	@echo "Runing $($@)"
	@-for aa1 in $$(docker container ls -a |awk '{print $$1}'|grep -v ^CONTAINER) ; do\
		docker container rm $${aa1} ; \
		done

dkci:=clean_docker_images
dkci: 
	@echo "Runing $($@)"
	for aa1 in $$(docker image ls |awk '{print $$1}'|grep ^'$(DockerUserName)/') ; do\
		docker image rm $${aa1} ; \
		done
	for aa1 in $$(docker image ls |awk '{print $$1}'|grep ^'udp_test/') ; do\
		docker image rm $${aa1} ; \
		done

dkl:=docker_login
$(dkl)=docker login -u $(DockerUserName)

showRunHelpList += dkcc dkcn dkci dkb dkl


endif

