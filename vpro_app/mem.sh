#!/bin/bash


lsb_release -a

if [ $? == 0 ]

then

echo "THIS IS DEBIAN"

#install memcached

echo "install memcached"
sudo apt install memcached -y
memcached -p 11111 -U 11111 -u memcache -d
sudo apt update -y


#enable firewalld

sudo ufw allow 11211/tcp
sudo ufw status numbered

#<<<<<<<<<<<memcache installed>>>>>>>>>>>
else

echo "THIS IS REDHAT"

#adding repository and installing memcache	

   sudo	yum update
   sudo	yum install epel-release -y
   sudo	yum install memcached -y
   memcached -p 11111 -U 11111 -u memcached -d
   sudo	systemctl start memcached
   sudo	systemctl enable memcached
   sudo	systemctl status memcached

#<<<<<<<<firewall>>>>>>>
        
   sudo systemctl enable firewalld
   sudo systemctl start firewalld
   sudo systemctl status firewalld
   sudo	firewall-cmd --add-port=11211/tcp --permanent
   firewall-cmd --reload
fi
