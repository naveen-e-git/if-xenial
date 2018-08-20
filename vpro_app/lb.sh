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
                cp /root/vproapp /etc/nginx/site-available/vproapp 
                rm -rfv /etc/nginx/site-enabled/default
		ln -s /etc/nginx/site-available/vproapp /etc/nginx/site-enabled/
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

<<<<<<< HEAD

         cat /root/vproapp > /etc/nginx/conf.d/vproapp.conf

=======
         sudo cp -rvf vproapp /etc/nginx/conf.d/vproapp.conf
>>>>>>> c2a680c11f97b974ae0f4ecf6101e0f323674387


#firewall enabiling
         echo "enable firewall"
         firewall-cmd --get-active-zones
         firewall-cmd --zone=public --add-port=80/tcp --permanent
         firewall-cmd --reload
         sudo systemctl restart nginx

fi
