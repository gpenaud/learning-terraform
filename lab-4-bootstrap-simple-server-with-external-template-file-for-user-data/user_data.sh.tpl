#! /bin/bash

yum -y update
yum -y install httpd

MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>built by power of <font color)="red">terraform</font></h2><br>
server owner is: ${f_name} ${l_name} <br>

%{ for name in names ~}
hello to ${name}
%{ endfor ~}

</html>
EOF

service httpd start
chkconfig httpd on
