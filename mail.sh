firewall-cmd --permanent --add-port 25/tcp
firewall-cmd --permanent --add-port 465/tcp
firewall-cmd --permanent --add-port 587/tcp
firewall-cmd --permanent --add-port 995/tcp
firewall-cmd --permanent --add-port 993/tcp
firewall-cmd --permanent --add-port 143/tcp
firewall-cmd --permanent --add-port 110/tcp
firewall-cmd reload



