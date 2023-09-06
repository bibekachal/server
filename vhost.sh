#!/bin/bash
read -p 'Domain name for virtual host (example.com) for virtual host: ' domain
read -p 'Username of the user who is assigned this virtual host: ' username
read -p 'Server IP:' ip

WEBDIR=/home/$username/web/$domain/public_html/
CONFDIR=/etc/httpd/conf.d
[ -d $CONFDIR ] || mkdir -p $CONFDIR

echo "<VirtualHost $ip:80>
      ServerName www.$domain
      ServerAlias $domain
      DocumentRoot "$WEBDIR"
    </VirtualHost>" > $CONFDIR/$domain.conf

mkdir -p $WEBDIR

chmod 711 -R /home/$username
chmod 755 -R /home/$username/web/$domain/public_html

chown $username -R /home/$username
#Apend apache to the newly created user's group so that it has the write access to the user's directory
#Do not forget to apend the user to the existing group (-a), and (-G); note the uppercase G here
usermod -a -G $username apache
echo "New site for $domain" > $WEBDIR/index.html

echo 'Restarting apache'
apachectl restart
systemctl restart httpd.service
"Reboot server manually with reboot; you must do that if it's the first installation with SE Linux disabled"


#In wordpress script add define('FS_METHOD','direct'); above DB_NAME to remove ftp error; another error occurred after doing this
#'could not create directory error -> needed to set ftp constants (https://wordpress.org/support/article/editing-wp-config-php/)'
#and https://wordpress.stackexchange.com/questions/48/how-can-i-stop-wordpress-from-prompting-me-to-enter-ftp-information-when-doing-u
