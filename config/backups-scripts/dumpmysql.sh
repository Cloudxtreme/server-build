#!/bin/bash
### ****************************************************************************
###
### Backup mysql databases via mysqldump
###
### ****************************************************************************

# config
BACKUPROOT=/data/mysql
MAXAGEDAYS=30
EXCLUDEDBS="'information_schema', 'performance_schema', 'test'"
MYSQLOPTS="--defaults-file=/etc/mysql/debian.cnf"
MYSQLDUMPOPTS="--defaults-file=/etc/mysql/debian.cnf \
                 --single-transaction \
                 --opt \
                 --add-drop-database \
                 --comments \
                 --dump-date \
                 --events \
                 --routines \
                 --triggers"

# run as root only
if [ `id -u` -ne 0 ]
    then echo "Please run as root"
    return
fi
if [ ! -d ${BACKUPROOT} ]; then
    echo "ERROR: Can not find backup folder '${BACKUPROOT}'"
    return
fi

# get list of databases and dump them
DATABASES=$(mysql ${MYSQLOPTS} -Bse "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN (${EXCLUDEDBS});")
for DBNAME in $DATABASES
do
    JOBNAME=${DBNAME,,}
    #echo "Running mysqldump job for ${DBNAME}"
    mysqldump ${MYSQLDUMPOPTS} ${DBNAME} --result-file=${BACKUPROOT}/${JOBNAME}.sql
done

# http://dev.mysql.com/doc/refman/5.6/en/mysqldump.html