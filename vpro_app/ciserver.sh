#!/bin/bash

#this script to install ciserver in CENTOS OR UBUNTU based on IF CONDITION

lsb_release -a

if [ $? == 0 ]

then 

echo "This is UBUNTU SERVER"

######################## CI-SERVER-UBUNTU ########################################################################

# This script updates the repository and installs openjdk
	sudo apt-get update
	sudo add-apt-repository ppa:openjdk-r/ppa -y
	sudo apt-get update
	sudo apt-get install openjdk-8-jdk -y
# installing git and cloning the repository from github.com
	sudo apt-get install git -y
	 cd /root
	sudo git clone -b vp-rem https://github.com/wkhanvisualpathit/VProfile.git
#install maven and Build the application
	sudo apt-get install maven -y
	 cd /root/VProfile

# inserting data base credentials into application.properties
	sed -i 's/password=password/password=root/g' src/main/resources/application.properties
	sed -i 's/newuser/root/g' src/main/resources/application.properties
        sed -i 's/localhost:3306/db01.com:3306/' src/main/resources/application.properties
	sed -i 's/address=127.0.0.1/address='rmq01.com'/' src/main/resources/application.properties
        
        sed -i 's/active.host=127.0.0.1/active.host='memcache01.com'/' src/main/resources/application.properties
	sudo mvn clean install


else 
#################################### CI-SERVER-CENTOS###############################################################

 This script updates the repository and installs openjdk
         echo "UPDATING THE REPO"
	 yum update -y
         echo "INSTALLING EPEL-RELEASE REPO"
	 yum install epel-release -y 	
	 yum update
         echo "installing java"
         echo "     "
         yum install java-1.8.0-openjdk-devel.x86_64 -y

# installing git and cloning the repository from github.com

        echo "installing git"
        echo "    "
	yum install install git -y
	cd /root
        echo "cloning git from branch"
        echo "    "
	git clone -b vp-rem https://github.com/wkhanvisualpathit/VProfile.git

#install maven and Build the application
        echo "     "
        echo "installing maven"
        yum install maven -y
	mvn -version
	cd /root/VProfile

# inserting data base credentials into application.properties


	sed -i 's/password=password/password=root/g' src/main/resources/application.properties
	sed -i 's/newuser/root/g' src/main/resources/application.properties
        sed -i 's/localhost:3306/db01.com:3306/' src/main/resources/application.properties
	sed -i 's/address=127.0.0.1/address='rmq01.com'/' src/main/resources/application.properties
        sed -i 's/active.host=127.0.0.1/active.host='memcache01.com'/' src/main/resources/application.properties
	
        echo "maven clean install"
        mvn clean install

  fi
