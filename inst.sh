#!/bin/bash
#Initial code
#curl -O https://raw.githubusercontent.com/bibekachal/server/main/inst.sh
#dos2unix inst.sh
#chmod +x inst.sh
#sh inst.sh

curl -O https://raw.githubusercontent.com/bibekachal/server/main/server.sh
curl -O https://raw.githubusercontent.com/bibekachal/server/main/user.sh
curl -O https://raw.githubusercontent.com/bibekachal/server/main/vhost.sh

yum install dos2unix

dos2unix server.sh
dos2unix user.sh
dos2unix vhost.sh

chmod +x server.sh
chmod +x user.sh
chmod +x vhost.sh

sh server.sh
sh user.sh
#sh vhost.sh

exit 0
