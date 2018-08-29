#!/bin/bash


lsb_release -a

if [ $? == 0 ]

then 

             echo "THIS IS DEBIAN"

#installing nginx in UBUNTU
             echo "installing nginx"
             sudo apt-get install nginx -y
             sudo systemctl start nginx
             sudo systemctl enable nginx
             sudo systemctl status nginx


cat <<EOT > vproapp

upstream vproapp {

 server app01.com:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://vproapp;

}

}

EOT
                cp /root/vproapp /etc/nginx/sites-available/vproapp 
                rm -rfv /etc/nginx/sites-enabled/default
		rm -rfv /etc/nginx/sites-available/default
		ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/
                sudo systemctl restart nginx

#enable firewall

            echo "enable firewall"
            sudo ufw allow 80/tcp
            sudo ufw status numbered

else



           echo "THIS IS REDHAT"

#nginx installation in CENTOS
         
          echo "nginx installation"
          sudo yum update
          sudo yum install epel-release -y
          sudo yum install nginx -y
          sudo systemctl start nginx 
          sudo systemctl enable nginx
          sudo yum install firewalld -y
          sudo systemctl start firewalld
		

cat <<EOT > vproapp

upstream vproapp {

 server app01.com:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://vproapp;

}

}

EOT
         sudo cp /root/vproapp /etc/nginx/conf.d/vproapp.conf



#firewall enabiling
         echo "enable firewall"
         firewall-cmd --get-active-zones
         firewall-cmd --zone=public --add-port=80/tcp --permanent
         firewall-cmd --reload
         sudo systemctl restart nginx

fi
