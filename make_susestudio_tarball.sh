#!/bin/sh

MODS="bartlby-core bartlby-agent bartlby-php bartlby-chrome bartlby-plugins bartlby-ui bartlby-extensions";

TDIR=/tmp/bartlby-susestudio-$$;
mkdir $TDIR;
cd $TDIR;


for x in $MODS;
do
	git clone git@github.com:Bartlby/${x}.git

done

cd $TDIR

tar cjvf /var/www/htdocs/bartlby.januschka.com/bartlby.tar.bz2 .;

