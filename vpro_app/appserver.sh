
#!/bin/bash

#this script to install ciserver in CENTOS OR UBUNTU based on IF CONDITION

lsb_release -a

if [ $? == 0 ]

then 

echo "This is UBUNTU SERVER"

########################################## APPSERVER-UBUNTU ################################################################
# This script updates the repository and installs openjdk
        
        sudo apt-get update
	sudo add-apt-repository ppa:openjdk-r/ppa -y
	sudo apt-get update
        sudo apt-get install openjdk-8-jdk -y

#install wget to download apache tomcat zip file
	sudo apt-get install wget -y

#download tomcat zip file and move it to /opt/  deploy the application into tomcat
        cd /root
	sudo wget http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz
	sudo mv apache-tomcat-8.5.32.tar.gz /opt/apache-tomcat-8.5.32.tar.gz
        cd /opt/
	sudo tar -xvzf apache-tomcat-8.5.32.tar.gz

#remove default home page for tomcat and deploy our app as ROOT.war
	sudo rm -rf /opt/apache-tomcat-8.5.32/webapps/ROOT
	sudo cp ~/VProfile/target/vprofile-v1.war /opt/apache-tomcat-8.5.32/webapps/ROOT.war
	sudo nohup /opt/apache-tomcat-8.5.32/bin/startup.sh &
        
	echo "TOMCAT STARTED" 
else 

######################################### APPSERVER-CENTOS ########################################################
#This script updates the repository and installs openjdk

        yum update
        yum install epel-release
        yum install wget -y
        yum update
	yum install java-1.8.0-openjdk -y

		
#download tomcat zip file and move it to /opt/  deploy the application into tomcat

	cd /root
	wget http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz
	mv apache-tomcat-8.5.32.tar.gz /opt/apache-tomcat-8.5.32.tar.gz
	cd /opt/
	tar -xvzf apache-tomcat-8.5.32.tar.gz

#remove default home page for tomcat and deploy our app as ROOT.war

	rm -rf /opt/apache-tomcat-8.5.32/webapps/ROOT
	cp /root/VProfile/target/vprofile-v1.war /opt/apache-tomcat-8.5.32/webapps/ROOT.war

##### enabling the firewall and allowing port 8080 to access the tomcat

	systemctl start firewalld        
        systemctl enable firewalld
	firewall-cmd --get-active-zones
	firewall-cmd --zone=public --add-port=8080/tcp --permanent
	firewall-cmd --reload
	/opt/apache-tomcat-8.5.32/bin/startup.sh

	echo " TOMCAT STARTED"

fi

