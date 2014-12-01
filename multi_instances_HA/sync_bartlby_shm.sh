#!/bin/bash


############ BARTLBY CONF
#data_library=/opt/bartlby/lib/mysql.so
#max_concurent_checks=6
#max_load=0
#shm_key=/opt/bartlby-1
#shm_size=15
#logfile=/opt/bartlby-1/var/log/bartlby  
#### TRIGGERS FROM MASTER
#trigger_dir=/opt/bartlby/trigger
#agent_plugin_dir=/opt/bartlby-agent/plugins
#
#mysql_host=localhost
#mysql_user=root
#mysql_pw=volLKorn8BROt4
#mysql_db=bartlby_second
###########################################

##### BASIC
LOCAL_ARCH=$(uname -m);

MASTE_UI_HTDOCS=/var/www/htdocs/bartlby.januschka.com/bartlby-ui/

############ SHM
LOCAL_IDX=1
REMOTE_HOST="hotzenplotz@78.46.101.204"
REMOTE_SHM_KEY=/opt/bartlby
LOCAL_SHM_KEY=/opt/bartlby-$LOCAL_IDX
KEY_TO_USE="/storage/SF.NET/BARTLBY/priv"
REMOTE_BARTLBY_BIN_PATH=/storage/SF.NET/BARTLBY/GIT/bartlby-core/
LOCAL_BARTLBY_BIN_PATH=/storage/SF.NET/BARTLBY/GIT/bartlby-core/

REMOTE_BARTLBY_CONF="/storage/SF.NET/BARTLBY/GIT/bartlby-core/BARTLBY.local";


LOCAL_EXPECTCORE=$($LOCAL_BARTLBY_BIN_PATH/bartlby_shmt expectcore)
REMOTE_EXPECTCORE=$(ssh -i $KEY_TO_USE $REMOTE_HOST -C "$REMOTE_BARTLBY_BIN_PATH/bartlby_shmt expectcore")


##### CONFIG
LOCAL_MYSQL_CONN_STR=" -u root --password=volLKorn8BROt4 bartlby_second"
REMOTE_MYSQL_CONN_STR=" -u root --password=volLKorn8BROt4 bartlbydev"


## ADDITIONAL FOLDER SYNC
ADD_FOLDERS="/opt/bartlby/:/opt/bartlby-$LOCAL_IDX/ /var/www/htdocs/bartlby.januschka.com/bartlby-ui/rights/:/var/www/htdocs/bartlby.januschka.com/bartlby-ui/rights-$LOCAL_IDX/ /opt/pnp4nagios/var/perfdata/:/opt/pnp4nagios/var/perfdata/ /var/www/htdocs/bartlby.januschka.com/bartlby-ui/rrd/:/var/www/htdocs/bartlby.januschka.com/bartlby-ui/rrd/"

REMOTE_ARCH=$(ssh -i $KEY_TO_USE $REMOTE_HOST -C "uname -m");

if [ "$LOCAL_EXPECTCORE" != "$REMOTE_EXPECTCORE" ];
then
	echo "CORE VERSION MISMATCH";
	echo "EXPECTED $LOCAL_EXPECTCORE got $REMOTE_EXPECTCORE"
	exit;
	
fi
if [ "$LOCAL_ARCH" != $REMOTE_ARCH ];
then
	echo "ARCH FAIL $LOCAL_ARCH , $REMOTE_ARCH";
	exit;
fi;
echo "Arch: $REMOTE_ARCH";
echo "EXPECT CORE: $LOCAL_EXPECTCORE";

TEMP_DIR=/tmp/bartlby_sync.$$
mkdir $TEMP_DIR;
cd $TEMP_DIR;
ssh -i $KEY_TO_USE $REMOTE_HOST -C "mkdir -p $TEMP_DIR";


if [ "x$1" = "xconfig"  ];
then
	# Push CONFIG
	### dump
	mysqldump $LOCAL_MYSQL_CONN_STR   > $TEMP_DIR/mysql.dump
	### scp
	gzip $TEMP_DIR/mysql.dump;
	scp -i $KEY_TO_USE $TEMP_DIR/mysql.dump.gz $REMOTE_HOST:$TEMP_DIR/mysql.dump.gz
	### populate
	ssh -i $KEY_TO_USE $REMOTE_HOST -C "gunzip $TEMP_DIR/mysql.dump.gz; mysql $REMOTE_MYSQL_CONN_STR < $TEMP_DIR/mysql.dump";
	### reload
	ssh -i $KEY_TO_USE $REMOTE_HOST -C "$REMOTE_BARTLBY_BIN_PATH/bartlby_shmt $REMOTE_BARTLBY_CONF reload";
	sleep 3;
	echo "CONFIG pushed to REMOTE";
fi;



#DUMP REMOTE SITE

ssh -i $KEY_TO_USE $REMOTE_HOST -C "$REMOTE_BARTLBY_BIN_PATH/bartlby_shmt  dump  $REMOTE_SHM_KEY $TEMP_DIR/shm.dump; gzip $TEMP_DIR/shm.dump";

#TRANSFER DUMP TO LOCAL_ID
scp -i $KEY_TO_USE $REMOTE_HOST:$TEMP_DIR/shm.dump.gz $TEMP_DIR/shm.dump.gz

#unzip it
gunzip $TEMP_DIR/shm.dump.gz

SI=$(stat -t $TEMP_DIR/shm.dump|awk '{print $2}');
SI=$[SI+20+30];


LOCAL_SHM_HEX=$($LOCAL_BARTLBY_BIN_PATH/bartlby_shmt ftok $LOCAL_SHM_KEY);
LOCAL_SHM_SIZE=$(ipcs -m|grep $LOCAL_SHM_HEX|awk '{print $5}');
LOCAL_SHM_ID=$(ipcs -m|grep $LOCAL_SHM_HEX|awk '{print $2}');


echo "SHM Size required: $SI local_shm_size: $LOCAL_SHM_SIZE";

if [ $SI -gt $LOCAL_SHM_SIZE ];
then
	echo "REMOVED too small shm";
	ipcrm shm $LOCAL_SHM_ID;
fi;

#fill shm
$LOCAL_BARTLBY_BIN_PATH/bartlby_shmt replay $LOCAL_SHM_KEY $TEMP_DIR/shm.dump $SI



if [ "x$1" = "xdiv" ];
then

	for x in $ADD_FOLDERS;
	do
		LFOLD=$(echo $x|awk -F":" '{print $1}');
		RFOLD=$(echo $x|awk -F":" '{print $2}');
		rsync  -e "ssh -i $KEY_TO_USE" -av -u $REMOTE_HOST:$LFOLD $RFOLD
	done;

fi

rm -vfr "$TEMP_DIR";
ssh -i $KEY_TO_USE $REMOTE_HOST -C "rm -vfr $TEMP_DIR";

#update sync time
date +%s > $MASTE_UI_HTDOCS/last_sync-$LOCAL_IDX
exit;
#

