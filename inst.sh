#!/bin/bash
#Initial code
#curl -O https://raw.githubusercontent.com/bibekachal/server/main/inst.sh?token=GHSAT0AAAAAACC2FP4GLGWFDGULHPRE5HPWZDGLB7A
#dos2unix inst.sh
#chmod +x inst.sh
#sh inst.sh

curl -O https://raw.githubusercontent.com/bibekachal/server/main/server.sh?token=GHSAT0AAAAAACC2FP4GNEKDJEYZY6IGZFV4ZDGK6WA
curl -O https://raw.githubusercontent.com/bibekachal/server/main/user.sh?token=GHSAT0AAAAAACC2FP4GW3GO5NAQBQP3H65EZDGK7VQ
curl -O https://raw.githubusercontent.com/bibekachal/server/main/vhost.sh?token=GHSAT0AAAAAACC2FP4H7TAXF6F7XW5CVNXCZDGLADA

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
