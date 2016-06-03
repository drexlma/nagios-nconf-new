#!/bin/bash

OUTPUT_DIR="/var/www/nconf/output/"
NAGIOS_DIR="/usr/local/nagios/etc/"
TEMP_DIR=${NAGIOS_DIR}"import/"
CONF_ARCHIVE="NagiosConfig.tgz"

if [ ! -e ${TEMP_DIR} ] ; then
mkdir -p ${TEMP_DIR}
fi
 md5=$(md5sum /usr/local/nagios/etc/nagios.cfg |awk '{print $1}');
if [[ $md5 != "68bd78c0b1786a6600b747b584b96871" ]];then
 cp -rfp /nagios.cfg /usr/local/nagios/etc/ 
 fi;
#if [ ${OUTPUT_DIR}${CONF_ARCHIVE} -nt ${TEMP_DIR}${CONF_ARCHIVE} ] ; then
cp -p ${OUTPUT_DIR}${CONF_ARCHIVE} ${TEMP_DIR}${CONF_ARCHIVE}
tar -xf ${TEMP_DIR}${CONF_ARCHIVE} -C ${NAGIOS_DIR}
#/etc/init.d/nagios reload
supervisorctl restart nagios4
#fi

#exit
 /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
status=$(echo $?);
if [ $status == 0 ]
then

mysqldump -u root -pNag123 nconf >nconf_dump.sql
s3cmd -c /.s3cfg  put  nconf_dump.sql  "s3://inmobi-noc/${stack}/"
fi;
