#!/bin/bash

read -p 'Do you want to create a virtual host in user\'s directory? (y/n): ' vhost

if [ $vhost = 'y' ] ; then

read -p 'Domain name for virtual host (example.com) for virtual host: ' domain
read -p 'Username of the user who is assigned this virtual host: ' username
read -p 'Server IP:' ip

WEBDIR=/home/$username/web/$domain/public_html
CONFDIR=/etc/httpd/conf.d
[ -d $CONFDIR ] || mkdir -p $CONFDIR

echo "<VirtualHost $ip:80>
      ServerName www.$domain
      ServerAlias $domain
      DocumentRoot "$WEBDIR"
    </VirtualHost>" > $CONFDIR/$domain.conf

mkdir -p $WEBDIR
echo "Welcome to $domain" > $WEBDIR/index.php

chmod 711 -R /home/$username
chmod 755 -R /home/$username/web/$domain/public_html
chown $username -R /home/$username
chown $username -R /var/www

#Apend apache to the newly created user's group so that it has the write access to the user's directory
#Do not forget to apend the user to the existing group (-a), and (-G); note the uppercase G here
usermod -a -G $username apache


echo 'Restarting apache'
apachectl restart
systemctl restart httpd.service
"Reboot server manually with reboot; you must do that if it's the first installation with SE Linux disabled"

fi

