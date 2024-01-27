#!/bin/bash
#Script to install essentials
#You MUST MUST MUST upgrade server with yum upgrade and then yum update otherwise it does not work no chmod command!
yum upgrade

read -p 'Do you want to disable SE linux (later restart server manually) y/n: ' selinux

if [ $selinux = 'y' ] ; then
sed -i ' s/^SELINUX=.*/SELINUX=disabled/ ' /etc/selinux/config
fi


#apache
yum -y install httpd
systemctl start httpd.service
systemctl enable httpd.service

#Enable UserDir
CONF=/etc/httpd/conf.d/userdir.conf
cp $CONF $CONF.bak
sed -i ' s/UserDir\sdisabled// ' $CONF
sed -i ' s/#UserDir.*/UserDir public_html/ ' $CONF

sed -i 's@^<Directory\s"\/home.*@<Directory "/home/*/web">@' /etc/httpd/conf.d/userdir.conf
sed -i 's/AllowOverride FileInfo.*/AllowOverride All/' $CONF
sed -i 's/Options MultiViews.*/Options Indexes FollowSymLinks/' $CONF
sed -i 's/Require method.*/Require all granted/' $CONF



yum install firewalld
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload



#MariaDB v 10.11 on rhel v9
echo 'Installing MariaDB...'
curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version="mariadb-10.11"
systemctl start mariadb
systemctl enable mariadb.service
mysql_secure_installation
echo 'Mariadb installed and started.';



#PHP
echo 'Installing PHP...'
yum -y install php php-mysqli
yum -y install php-gd php-pear php-mbstring
yum -y install php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap curl curl-devel
echo 'PHP installed.'

#phpMyAdmin 5.2.1 for Apache v 2.4.57
yum makecache
yum install wget unzip
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip 
unzip phpMyAdmin-5.2.1-all-languages.zip
mv phpMyAdmin-5.2.1-all-languages /usr/share/phpmyadmin 
chown -R apache /usr/share/phpmyadmin 
chmod -R 755 /usr/share/phpmyadmin 

echo "<Directory "/usr/share/phpmyadmin">
    Options Indexes FollowSymLinks MultiViews
    DirectoryIndex index.php
    AllowOverride all
    Require all granted
</Directory>
Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phpMyAdmin /usr/share/phpmyadmin
" > /etc/httpd/conf.d/phpmyadmin.conf



#ftp
echo 'Installing VSFTPD...';
yum -y install vsftpd ftp
systemctl enable vsftpd
systemctl start vsftpd

echo 'VSFTPD is installed and enabled.'

firewall-cmd --permanent --add-port=21/tcp
firewall-cmd --permanent --add-port=20/tcp
firewall-cmd --permanent --add-service=ftp

systemctl restart httpd.service
apachectl restart
echo 'Server essentials are installed.'
