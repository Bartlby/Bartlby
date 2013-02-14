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

	cd $BS/$x
	git checkout master
	git pull
	#UPDATE VERSION 
	perl -pi -e "s/AC_INIT\((.*),(.*),(.*)\)/AC_INIT\(\$1,$VE,\$3\)/g" configure.ac && grep AC_INIT configure.ac
	git commit -m "Release $VE" -a;
	git tag $VE
	git push
	git push --tags
	

done

#update submodules to master~head
$BS/Bartlby/update_repository_with_latest_module_commits.sh
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


echo "Release $VE is ready at $BS/bartlby-$VE.tgz"
