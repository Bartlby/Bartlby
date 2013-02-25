#!/bin/bash

MODS="bartlby-core bartlby-agent bartlby-php bartlby-chrome bartlby-plugins bartlby-ui bartlby-extensions";
BS=/storage/SF.NET/BARTLBY/GIT/




if [ ! -d /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/ ];
then
	echo "making DEB storage";
	mkdir -p /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/
fi;

	for x in $MODS;
	do
		if [ ! -d $BS/$x ];
		then
		mkdir -p $BS;
		cd $BS;
		git clone git://github.com/Bartlby/$x.git	
		fi;
	done;


type -a checkinstall
EX=$?;

if [ $EX = 1 ];
then
	apt-get install checkinstall
fi;

type -a git-buildpackage
EX=$?;

if [ $EX = 1 ];
then
	apt-get install git-buildpackage
fi;
#apt-get install libmysqlclient-dev mysql-server libsnmp-dev libssh-dev rrdtool libssl-dev libfile-slurp-perl git


MODS_SEL="";

for x in $MODS; 
do

	echo -n "Release $x [y/n](y)?";
	read stopit;
	if [ "x$stopit" = "x" ] ||  [ "x$stopit" = "xy" ] ||  [ "x$stopit" = "xY" ];
	then
				MODS_SEL="${MODS_SEL} $x";
				cd $BS/$x
				git checkout master
				git pull
				#UPDATE VERSION 
				echo -n "Bump Version of $x [y/n](y)?";
				read stopit;
				if [ "x$stopit" = "x" ] ||  [ "x$stopit" = "xy" ] ||  [ "x$stopit" = "xY" ];
				then
						echo -n "Specify Version x.y.z (current version bellow):";
						
						if [ "$x" = "bartlby-core" ];
						then
							 grep AC_INIT configure.ac
						fi;
						
						if [ "$x" = "bartlby-agent" ];
						then
							 grep AC_INIT configure.ac
						fi;
						
						if [ "$x" = "bartlby-extensions" ];
						then
							 grep AC_INIT configure.ac
						fi;
						if [ "$x" = "bartlby-php" ];
						then
							 grep BARTLBY_VERSION php_bartlby.h
						fi;
						if [ "$x" = "bartlby-ui" ];
						then
							 grep BARTLBY_UI_VERSION bartlby-ui.class.php
						fi;
						
						
						read VE;
						if [ "x$VE" = "x" ];
						then
							echo "EMPTY VERSION STOPPING";
							continue;
						fi;
						
						if [ "$x" = "bartlby-core" ];
						then
						 	EXP=${VE//.}
							perl -pi -e "s/#define EXPECTCORE (.*)/#define EXPECTCORE ${EXP}0000/g" include/bartlby.h && grep AC_INIT include/bartlby.h
							perl -pi -e "s/AC_INIT\((.*),(.*),(.*)\)/AC_INIT\(\$1,$VE,\$3\)/g" configure.ac && grep AC_INIT configure.ac
							dch --newversion=$VE
						fi;
						if [ "$x" = "bartlby-agent" ];
						then
							perl -pi -e "s/AC_INIT\((.*),(.*),(.*)\)/AC_INIT\(\$1,$VE,\$3\)/g" configure.ac && grep AC_INIT configure.ac
							dch --newversion=$VE
						fi;
						if [ "$x" = "bartlby-extensions" ];
						then
							perl -pi -e "s/AC_INIT\((.*),(.*),(.*)\)/AC_INIT\(\$1,$VE,\$3\)/g" configure.ac && grep AC_INIT configure.ac
							
						fi;
						if [ "$x" = "bartlby-php" ];
						then
							perl -pi -e "s/#define BARTLBY_VERSION \"(.*)\"/#define BARTLBY_VERSION \"$VE\"/g" php_bartlby.h  && grep BARTLBY_VERSION php_bartlby.h
							
						fi;
						if [ "$x" = "bartlby-ui" ];
						then
							perl -pi -e "s/define\(\"BARTLBY_UI_VERSION\", \"2.2-(.*)\"\);/define\(\"BARTLBY_UI_VERSION\", \"2.2-$VE\"\);/g" bartlby-ui.class.php  && grep BARTLBY_UI_VERSION bartlby-ui.class.php
							
						fi;
					
				fi;
				
				if [ ! -f "configure" ];
				then
					./autogen.sh
				fi;
				
				git checkout master
				case $x in
						bartlby-core)
							#BUILD DEBIAN PACKAGE
							git-buildpackage --git-ignore-new
							mv ../bartlby-core_${VE}_amd64.deb /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/binary
						;;
						bartlby-agent)
							#BUILD DEBIAN PACKAGE
							git-buildpackage --git-ignore-new
							mv ../bartlby-agent_${VE}_amd64.deb /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/binary
						;;
						bartlby-plugins)
							#BUILD DEBIAN PACKAGE
							./checkinstall.sh
							mv bartlby-plugins_${VE}-1_amd64.deb /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/binary
						;;
						bartlby-ui)
							#BUILD DEBIAN PACKAGE
							./make_deb.sh
							mv bartlby-ui_${VE}.deb /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/binary
						;;
				esac;
				echo -n "Commit and Tag release? [y/n](y) - only required for main arch";
				read stopit;
				if [ "x$stopit" = "x" ] ||  [ "x$stopit" = "xy" ] ||  [ "x$stopit" = "xY" ];
				then
					git commit -m "Release $VE" -a;
					git tag $VE
					git checkout  $VE -b release-$VE 
					git checkout development/stage
					git merge master
					git push origin release-$VE
					git push
					git push --tags
				fi;	
	else
		echo "skipping $x";	
	fi;
	
done

echo -n "Update Organization GIT account [y/n](y)?";
read stopit;
if [ "x$stopit" = "x" ] ||  [ "x$stopit" = "xy" ] ||  [ "x$stopit" = "xY" ];
then
#update submodules to master~head
	cd $BS/Bartlby/
	./update_repository_with_latest_module_commits.sh
fi;

echo -n "Create all-in-one tgz (USING: $MODS_SEL) [y/n](y)?";
read stopit;
if [ "x$stopit" = "x" ] ||  [ "x$stopit" = "xy" ] ||  [ "x$stopit" = "xY" ];
then
						echo -n "ALL IN ONE VERSION";
						read VE;
						if [ "x$VE" = "x" ];
						then
							echo "EMPTY VERSION STOPPING";
							continue;
						fi;

	rm -vfr /tmp/bartlby-$VE
	mkdir /tmp/bartlby-$VE
	cd /tmp/bartlby-$VE
	git clone --recursive git@github.com:Bartlby/Bartlby.git



	for x in $MODS_SEL;
	do
	
		cd /tmp/bartlby-$VE
		cd Bartlby
		cd $x;
		./autogen.sh
	done
	
	cd /tmp/bartlby-$VE
	cd Bartlby
	
	find  /tmp/bartlby-$VE/Bartlby/ -name .git -exec rm -vfr {} \;
	
	tar  czvf   $BS/bartlby-$VE.tgz   .
	
	mv $BS/bartlby-$VE.tgz /root/RELEASE/
	echo "Release $VE is ready at /root/RELEASE/bartlby-$VE.tgz"

fi;

echo -n "Rescan Debian Packages [y/n](y)?";
read stopit;
if [ "x$stopit" = "x" ] ||  [ "x$stopit" = "xy" ] ||  [ "x$stopit" = "xY" ];
then
	cd /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/
	dpkg-scanpackages binary /dev/null | gzip -9c > binary/Packages.gz

fi;

echo -n "SCP DEBS to upstream [y/n](y)?";
read stopit;
if [ "x$stopit" = "x" ] ||  [ "x$stopit" = "xy" ] ||  [ "x$stopit" = "xY" ];
then
	cd /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/
	scp *.deb root@januschka.com:/var/www/htdocs/bartlby.januschka.com/Bartlby/debs/

fi;