#!/bin/bash
#Initial code
#curl -O https://www.tinywebhut.com/shells/inst.sh
#dos2unix inst.sh
#chmod +x inst.sh
#sh inst.sh

curl -O https://www.tweegr.com/shells/server.sh
curl -O https://www.tweegr.com/shells/user.sh
curl -O https://www.tweegr.com/shells/vhost.sh

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
