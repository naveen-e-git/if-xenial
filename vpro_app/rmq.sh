#!/bin/bash
   
lsb_release -a

if [ $? == 0 ]
then
          echo "################## THIS SYSTEM IS DEBIAN LINUX BASED PLATFORM #########################"
          echo 
          echo "################### adding the repository and key for rabbitmq      ######################"
	  echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
          echo
	  sudo wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
	  sudo wget -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc| sudo apt-key add -
          echo
          echo
          echo "################## installing  rabbitmq make configuration changes for queuing   ##############"
          echo
	  echo
	  sudo apt-get install rabbitmq-server -y
	  echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config
	  rabbitmqctl add_user test test
	  rabbitmqctl set_user_tags test administrator
	  sudo systemctl start rabbitmq-server
	  sudo systemctl status rabbitmq-server 
          echo 
          echo "##### enabling the firewall and allowing port 25672 to access the rabbitmq permanently ######"
          sudo ufw allow 25672/tcp
          sudo ufw status numbered

else

          echo "################# THIS SYSTEM IS REDHAT LINUX BASED PLATFORM #######################"
          echo
          echo "adding the repository & dependency for rabbitmq-server"
          echo 
          sudo yum install epel-release -y
          sudo yum install socat -y
	  sudo yum install erlang -y
	  sudo yum install wget -y
	  sudo yum update
          echo
          echo "adding keys and installing rabbitmq-server and starting rabbitmq-server"
          echo
          sudo wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.10/rabbitmq-server-3.6.10-1.el7.noarch.rpm
          sudo rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc
          sudo yum update 
          sudo rpm -Uvh rabbitmq-server-3.6.10-1.el7.noarch.rpm
          sudo  systemctl start rabbitmq-server
          sudo  systemctl enable rabbitmq-server
          sudo  systemctl status rabbitmq-server
          sudo
          echo "#################  adding user #########################"
          echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config
	  rabbitmqctl add_user test test
	  rabbitmqctl set_user_tags test administrator
	  echo "##### enabling the firewall and allowing port 25672 to access the rabbitmq permanently ######"
	  sudo systemctl start firewalld
          sudo systemctl enable firewalld
	  sudo firewall-cmd --get-active-zones
	  sudo firewall-cmd --zone=public --add-port=25672/tcp --permanent
	  sudo firewall-cmd --reload
fi
