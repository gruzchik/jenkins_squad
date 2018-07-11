#!/bin/bash
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#source ${SCRIPTPATH}/config

# check if docker was installed
if [ ! -x "$(command -v docker)" ] || [ ! -x "$(command -v docker-compose)" ]; then
	# prepare docker env
	apt-get update
	apt-get install -y apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

	# add repo  and install docker
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	apt-get update && apt-get install -y docker-ce docker-compose
fi

# generate docker-compose file
cat <<EOF > ${SCRIPTPATH}/docker-compose.yml
version: '2'
services:
 jenkins:
  image: jenkins
  container_name: jenkins_master
  ports:
   - "8080:8080"
  volumes:
   - /var/lib/jenkins:/var/jenkins_home
EOF

cd ${SCRIPTPATH} && docker-compose up -d
