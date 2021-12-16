#! /bin/bash

yum -y update
yum -y install httpd

MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">built by power of </font><font color="red">terraform</font></font></h2><br><p>
<font color="green">webserver with static private_ip: </font><font color="aqua">$MYIP</font><br><br>
<font color="magenta"><b>version: 1.0</b></font>
</body>
</html>
EOF

service httpd start
chkconfig httpd on
