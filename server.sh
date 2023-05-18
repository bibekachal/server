#!/bin/bash

#Script to install essentials

# you MUST MUST MUST upgrade server with yum upgrade and then yum update otherwise it does not work no chmod command!
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

#sed -i ' s/UserDir\sdisabled// ' /etc/httpd/conf.d/userdir.conf
#sed -i ' s/#UserDir.*/UserDir public_html/ ' /etc/httpd/conf.d/userdir.conf


systemctl start httpd.service

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

systemctl enable httpd.service


#MariaDB
yum -y install mariadb-server mariadb

#EPEL AND REMI
yum -y install epel-release
yum -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm

systemctl start mariadb
systemctl enable mariadb.service

mysql_secure_installation


#PHP
yum -y install php
yum -y install php-gd php-pear php-mbstring
yum -y install php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap curl curl-devel

#phpMyAdmin
#phpMyAdmin is not default with centos8
#thsese links did not work centos stream 9, worked once and did not work later so don't use these commented lines
#dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
#dnf -y install http://rpms.remirepo.net/enterprise/8/remi/x86_64/php-fedora-autoloader-1.0.0-5.el8.remi.noarch.rpm
#Guide link for extra info https://wiki.crowncloud.net/?How_to_Install_phpMyAdmin_on_CentOS_Stream_9
dnf config-manager --set-enabled crb

dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

dnf install https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

# dnf config-manager --set-enabled remi
#dnf install phpMyAdmin
yum -y --enablerepo=remi install phpMyAdmin

##Fix phpMyAdmin Conf
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

##note that worked without the below command in centos8 stream
sed -i '/^<Directory.*setup\/>/,/^<\/Directory>/c\
<Directory /usr/share/phpMyAdmin/setup/>\
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



#ftp
yum -y install vsftpd ftp
systemctl enable vsftpd
systemctl start vsftpd

firewall-cmd --permanent --add-port=21/tcp
firewall-cmd --permanent --add-port=20/tcp
firewall-cmd --permanent --add-service=ftp

systemctl restart httpd.service
apachectl restart
echo 'Done server Essentials'

exit 0
