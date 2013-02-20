#!/bin/bash

MODS="bartlby-core bartlby-agent bartlby-php bartlby-chrome bartlby-plugins bartlby-ui bartlby-extensions";
BS=/storage/SF.NET/BARTLBY/GIT/

if [ "x$1" = "x" ];
then
	echo "specify version x.y.z";
	exit 1;
fi;



VE=$1;


for x in $MODS; 
do



	echo -n "Release $x [y/n](y)?";
	read stopit;
	if [ "x$stopit" = "x" ];
	then
				cd $BS/$x
				git checkout master
				git pull
				#UPDATE VERSION 
				echo -n "Bump Version of $x [y/n](y)?";
				read stopit;
				if [ "x$stopit" = "x" ];
				then
						perl -pi -e "s/AC_INIT\((.*),(.*),(.*)\)/AC_INIT\(\$1,$VE,\$3\)/g" configure.ac && grep AC_INIT configure.ac
						if [ "$x" = "bartlby-core" ];
						then
							dch --newversion=$VE
						fi;
						if [ "$x" = "bartlby-agent" ];
						then
							dch --newversion=$VE
						fi;
						git commit -m "Release $VE" -a;
						git tag $VE
						git branch -b release-$VE $VE
						git push origin release-$VE
						git checkout master
						git push
						git push --tags
						
				fi;
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
				git checkout development/stage
				
	else
		echo "skipping $x";	
	fi;
	

	

done

echo -n "Update Organization GIT account [y/n](y)?";
read stopit;
if [ "x$stopit" = "x" ];
then
#update submodules to master~head
	cd $BS/Bartlby/
	./update_repository_with_latest_module_commits.sh
fi;

echo -n "Create all-in-one tgz [y/n](y)?";
read stopit;
if [ "x$stopit" = "x" ];
then
	rm -vfr /tmp/bartlby-$VE
	mkdir /tmp/bartlby-$VE
	cd /tmp/bartlby-$VE
	git clone --recursive git@github.com:Bartlby/Bartlby.git



	for x in $MODS;
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
if [ "x$stopit" = "x" ];
then
	cd /var/www/htdocs/bartlby.januschka.com/Bartlby/debs/
	dpkg-scanpackages binary /dev/null | gzip -9c > binary/Packages.gz

fi;