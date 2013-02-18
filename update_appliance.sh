#!/bin/sh
cd /tmp

type -a mysqldiff

if [ $? = 1 ];
then
	echo "MySQL Diff not installed ... fetch and install it"
	wget http://search.cpan.org/CPAN/authors/id/A/AS/ASPIERS/MySQL-Diff-0.43.tar.gz
	tar xzvf MySQL-Diff-0.43.tar.gz
	cd MySQL-Diff-0.43
	perl Makefile.PL
	make install

fi;

echo -n "Stop Bartlby before upgrade [y/n]";
read stopit;
if [ "$stopit" != "n" ];
then
	/opt/bartlby/etc/bartlby.startup stop 2>&1 >> /dev/null
	/opt/bartlby/etc/bartlby.startup remove 2>&1 >> /dev/null
fi;


cd /usr/local/src


echo -n "Upgrade Core [y/n]";
read stopit;
if [ "$stopit" != "n" ];
then

	#### UPDATE CORE :)
	cd bartlby-core
	git stash
	echo -n "Wich Branch of Core (Default: master):";
	read stopit;
	if [ "x$stopit" = "x" ];
	then
		git checkout master;
	else
		git checkout development/stage	
	fi;
	
	git pull
	./autogen.sh
	./configure --enable-nrpe --enable-ssh  --enable-ssl --prefix=/opt/bartlby/ 
	make
	make install
	
	
fi

echo -n "Patch Database [y/n]";
read stopit;
if [ "$stopit" != "n" ];
then
	#### PATCH DATABASE
	echo "Patching Database"
	mysqldump -u bartlby --password=bartlby --databases bartlbydev > /root/bartlbydev.sql
	mysqldiff  --host=localhost --user=bartlby --password=bartlby bartlbydev mysql.shema
	echo -n "Apply Patch [y/n]";
	read stopit;
	if [ "$stopit" != "n" ];
	then
		mysqldiff  --host=localhost --user=bartlby --password=bartlby bartlbydev mysql.shema |mysql -u bartlby --password=bartlby bartlbydev
		echo "DB Patching done";
	fi;
	
	echo "Backup is in /root/bartlbydev.sql";
fi;


echo -n "Update UI [y/n]";
read stopit;
if [ "$stopit" != "n" ];
then
	#### update UI
	cd /usr/local/src
	cd bartlby-ui
	git stash
	echo -n "Wich Branch of UI (Default: master):";
	read stopit;
		if [ "x$stopit" = "x" ];
		then
			git checkout master;
		else
			git checkout development/stage	
		fi;
	git pull
	rm setup.php
	cp -pva * /srv/www/htdocs/bartlby-ui/
	chmod -R a+rwx  /srv/www/htdocs/bartlby-ui/
	rm /srv/www/htdocs/bartlby-ui/setup.php
	echo "UI Updated"
	
fi;

echo -n "Update Agent [y/n]";
read stopit;
if [ "$stopit" != "n" ];
then
	### update agent
	cd /usr/local/src/bartlby-agent
	git stash
	echo -n "Wich Branch of Agent (Default: master):";
	read stopit;
		if [ "x$stopit" = "x" ];
		then
			git checkout master;
		else
			git checkout development/stage	
		fi;
	git pull
	./autogen.sh
	./configure --prefix=/opt/bartlby-agent/ --enable-ssl
	make
	make install
	
fi;

echo -n "Update PHP [y/n]";
read stopit;
if [ "$stopit" != "n" ];
then
	### update php module
	cd /usr/local/src/bartlby-php
	git stash
	echo -n "Wich Branch of PHP (Default: master):";
	read stopit;
		if [ "x$stopit" = "x" ];
		then
			git checkout master;
		else
			git checkout development/stage	
		fi;
	git pull
	phpize
	./configure 
	make
	make install
	
fi;

echo -n "Update Plugins [y/n]";
read stopit;
if [ "$stopit" != "n" ];
then
	### update modules
	cd /usr/local/src/bartlby-plugins
	git stash
	echo -n "Wich Branch of Plugins (Default: master):";
	read stopit;
		if [ "x$stopit" = "x" ];
		then
			git checkout master;
		else
			git checkout development/stage	
		fi;
	git pull
	./configure --prefix=/opt/bartlby-agent/plugins
	make
	make install
	
fi;

echo -n "Update Extensions [y/n]";
read stopit;
if [ "$stopit" != "n" ];
then
	### update modules
	cd /usr/local/src/bartlby-extensions
	git stash
	./autogen.sh
	echo -n "Wich Branch of Extensions (Default: master):";
	read stopit;
		if [ "x$stopit" = "x" ];
		then
			git checkout master;
		else
			git checkout development/stage	
		fi;
	git pull
	./configure --prefix=/opt/bartlby-extensions
	make
	make install
	
fi;

/opt/bartlby/etc/bartlby.startup start

#cron */10 * * * * (/opt/pnp4nagios/libexec/process_perfdata.pl  -b "/opt/pnp4nagios//var/perfdata.log")
tar cjvf /root/pnp4nagios.tar.bz2 /opt/pnp4nagios/
tar cjvf /root/bartlby-core.tar.bz2 /opt/bartlby/
tar cjvf /root/bartlby-extensions.tar.bz2 /opt/bartlby-extensions/
tar cjvf /root/bartlby-agent.tar.bz2 /opt/bartlby-agent/
tar cjvf /root/bartlby-ui.tar.bz2 /srv/www/htdocs/bartlby-ui/
cp /usr/lib64/php5/extensions/bartlby.so /root/

