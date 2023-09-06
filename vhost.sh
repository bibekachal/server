#!/bin/bash
read -p 'Domain name for virtual host (example.com) for virtual host: ' domain
read -p 'Username (add existing username for whom the vhost is): ' username
read -p 'Server IP:' ip

WEBDIR=/home/$username/web/$domain/public_html/
CONFDIR=/etc/httpd/conf.d
sudo [ -d $CONFDIR ] || mkdir -p $CONFDIR

sudo echo "<VirtualHost $ip:80>
      ServerName www.$domain
      ServerAlias $domain
      DocumentRoot "$WEBDIR"
    </VirtualHost>" > $CONFDIR/$domain.conf

sudo mkdir -p $WEBDIR

sudo chmod 711 -R /home/$username
sudo chmod 755 -R /home/$username/web/$domain/public_html

sudo chown $username -R /home/$username

echo "New site for $domain" > $WEBDIR/index.html

echo 'Restarting apache'
sudo apachectl restart
sudo systemctl restart httpd.service
echo "Reboot server manually with reboot; you must do that if it's the first installation with SE Linux disabled"
exit 0

#In wordpress script add define('FS_METHOD','direct'); above DB_NAME to remove ftp error; another error occurred after doing this
#'could not create directory error -> needed to set ftp constants (https://wordpress.org/support/article/editing-wp-config-php/)'
#and https://wordpress.stackexchange.com/questions/48/how-can-i-stop-wordpress-from-prompting-me-to-enter-ftp-information-when-doing-u
