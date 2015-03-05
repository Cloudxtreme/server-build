#!/bin/bash
### ****************************************************************************
###
### Backup files using rdiff-backup
###
### REQUIRES:
###  - rdiff-backup to be installed (sudo apt-get install rdiff-backup)
### ****************************************************************************

# config
BACKUPROOT=/backups
MAXAGEDAYS=30

# run as root only
if [ `id -u` -ne 0 ]
    then echo "Please run as root"
    return
fi

# derive the job name for the source path (ARG1)
SOURCEFLDR=$(readlink -f $1)   #get abs path
JOBNAME=${SOURCEFLDR//\//-}    #convert slash to dash
JOBNAME=${JOBNAME:1}           #drop first character
JOBNAME=${JOBNAME,,}           #convert to lowercase
JOBNAME=${JOBNAME#data-}       #remove data- from beginning

# check folder exists
if [ ! -d ${SOURCEFLDR} ]; then
    echo "ERROR: Can not find source folder '${SOURCEFLDR}'"
    return
fi
# check backup destination exists
if [ ! -d ${BACKUPROOT} ]; then
    echo "ERROR: Can not find backup folder '${BACKUPROOT}'"
    return
fi

# make job folder if needed
[[ -d ${BACKUPROOT}/${JOBNAME} ]] || mkdir ${BACKUPROOT}/${JOBNAME}

# run rdiff-backup
#echo "Running rdiff-backup job for ${SOURCEFLDR}"
rdiff-backup ${SOURCEFLDR} ${BACKUPROOT}/${JOBNAME}

# clean-up old backup files
#echo "Cleaning up old backup data for ${SOURCEFLDR}"
rdiff-backup --force --remove-older-than ${MAXAGEDAYS}D ${BACKUPROOT}/${JOBNAME} > /dev/null