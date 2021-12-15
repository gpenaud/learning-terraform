#! /bin/bash

yum -y update
yum -y install httpd

MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>built by power of <font color)="red">terraform</font></h2><br>
webserver with static private_ip: $MYIP

version: 1.0

</html>
EOF

service httpd start
chkconfig httpd on
