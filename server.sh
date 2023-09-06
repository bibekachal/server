#!/bin/bash
#Script to install essentials
#You MUST MUST MUST upgrade server with yum upgrade and then yum update otherwise it does not work no chmod command!
yum upgrade
yum update
read -p 'Do you want to disable SE linux (later restart server manually) y/n: ' selinux

if [ $selinux = 'y' ] ; then
sed -i ' s/^SELINUX=.*/SELINUX=disabled/ ' /etc/selinux/config
fi


#apache
yum -y install httpd

#Enable UserDir
CONF=/etc/httpd/conf.d/userdir.conf
cp $CONF $CONF.bak
sed -i ' s/UserDir\sdisabled// ' $CONF
sed -i ' s/#UserDir.*/UserDir public_html/ ' $CONF

sed -i 's@^<Directory\s"\/home.*@<Directory "/home/*/web/*/public_html">@' /etc/httpd/conf.d/userdir.conf
sed -i 's/AllowOverride FileInfo.*/AllowOverride All/' $CONF
sed -i 's/Options MultiViews.*/Options Indexes FollowSymLinks/' $CONF
sed -i 's/Require method.*/Require all granted/' $CONF


systemctl start httpd.service
yum install firewalld
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
systemctl enable httpd.service


#MariaDB
echo 'Installing MariaDB...'
yum -y install mariadb-server mariadb
systemctl start mariadb
systemctl enable mariadb.service
mysql_secure_installation
echo 'Mariadb installed and started.';

#phpMyAdmin
dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm
dnf --enablerepo=remi install phpMyAdmin -y
sed -i '/^<Directory.*phpMyAdmin\/>/,/^<\/Directory>/c\
<Directory /usr/share/phpMyAdmin/>\
AddDefaultCharset UTF-8\
<IfModule mod_authz_core.c>\
<RequireAny>\
  Require all granted\
</RequireAny>\
</IfModule>\
<IfModule !mod_authz_core.c>\
  Order Deny,Allow\
  Deny from All\
  Allow from 127.0.0.1\
  Allow from ::1\
</IfModule>\
</Directory>' /etc/httpd/conf.d/phpMyAdmin.conf
echo 'phpMyAdmin is installed.'

#PHP
echo 'Installing PHP...'
yum -y install php
yum -y install php-gd php-pear php-mbstring
yum -y install php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap curl curl-devel
echo 'PHP installed.'

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

exit 0
