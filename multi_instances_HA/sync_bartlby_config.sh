#!/bin/bash
#get config from master
ssh -i /storage/SF.NET/BARTLBY/priv  root@januschka.com -C "mysqldump  -u root --password=volLKorn8BROt4  bartlby_second > /root/1.mysql"
scp -i /storage/SF.NET/BARTLBY/priv root@januschka.com:/root/1.mysql /root/1.mysql

mysql  -u root --password=volLKorn8BROt4 bartlbydev < /root/1.mysql
/storage/SF.NET/BARTLBY/GIT/bartlby-core/bartlby_shmt  /storage/SF.NET/BARTLBY/GIT/bartlby-core/BARTLBY.local reload

