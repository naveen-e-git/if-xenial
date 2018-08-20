#!/bin/bash 

lsb_release -a

if [ $? == 0 ]
then
##############################################################################################

          echo "######## THIS SYSTEM WORKS ON DEBIAN LINUX  PLATFORM ########## "
          echo
          echo "installing mysql-server on ubuntu"
          echo 
          echo
          sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
          sudo  debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
          sudo apt-get update
          sudo apt-get install mysql-server -y
	  sudo systemctl start mydql
          sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
          echo "restoring  the dump file for the application"
          echo
          echo
          mysql -u root -e "create database accounts" --password='root';
          mysql -u root -e "grant all privileges on *.* TO 'root'@'app01.com' identified by 'root'" --password='root';
          mysql -u root -e "grant all privileges on *.* TO 'root'@'%' identified by 'root'" --password='root';
          mysql -u root -e "create user 'admin'@'%' identified by 'admin123'" --password='root';
          mysql -u root -e "grant all privileges on *.* TO 'admin'@'%' identified by 'admin123'" --password='root';
          mysql -u root --password='root' accounts < /root/VProfile/src/main/resources/db_backup.sql; 
          mysql -u root -e "FLUSH PRIVILEGES" --password='root';
          sudo  systemctl restart mysql

          echo "adding mysql service to firewall"
          echo
         #sudo ufw enable
          sudo ufw allow 3306/tcp
          sudo ufw status numbered
          echo

else

##############################################################################################################

          echo "######## THIS SYSTEM WORKS ON REDHAT LINUX PLATFORM"
          echo "installing  mariadb-server on centos"
          echo
          sudo yum install epel-release -y
          sudo yum update -y
          sudo yum install mysql-server -y

          sudo systemctl start mariadb
          sudo echo "bind-address  = 0.0.0.0" >> /etc/my.cnf

          echo
          echo  "restoring  the dump file for the application"
          echo
          mysql -u root -e "create database accounts" --password='';
          mysql -u root -e "grant all privileges on *.* TO 'root'@'app01.com' identified by 'root'" --password='';
          mysql -u root -e "create user 'admin'@'%' identified by 'admin'" --password='';
          mysql -u root -e "grant ALL privileges on *.* TO 'admin'@'%' identified by 'admin'" --password='';
          mysql -u root --password='' accounts < /root/VProfile/src/main/resources/db_backup.sql;
          mysql -u root -e "FLUSH PRIVILEGES" --password='';
          echo
          echo "starting & enabling mariadb-server"
          echo
          sudo systemctl restart mariadb
          #sudo chkconfig mysqld on
          echo
          echo "starting the firewall and allowing the mariadb to access from port no. 3306"
          echo 
          sudo systemctl start firewalld
          sudo systemctl enable firewalld
          sudo firewall-cmd --get-active-zones
          sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
          sudo firewall-cmd --reload
          
fi
