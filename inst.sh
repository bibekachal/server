#!/bin/bash
#Initial code
#curl -O https://raw.githubusercontent.com/bibekachal/server/main/inst.sh
#dos2unix inst.sh
#chmod +x inst.sh
#sh inst.sh

sudo curl -O https://raw.githubusercontent.com/bibekachal/server/main/server.sh
sudo curl -O https://raw.githubusercontent.com/bibekachal/server/main/user.sh
sudo curl -O https://raw.githubusercontent.com/bibekachal/server/main/vhost.sh

sudo yum install dos2unix

sudo dos2unix server.sh
sudo dos2unix user.sh
dos2unix vhost.sh

sudo chmod +x server.sh
sudo chmod +x user.sh
sudo chmod +x vhost.sh

sudo sh server.sh
sudo sh user.sh
#sh vhost.sh

exit 0
