#!/bin/bash
### ****************************************************************************
###
### Run checks
###
###
### ****************************************************************************


### Check for Necessary Environment Variables
if [ -z ${__GITHUBAUTHTOKEN+x} ]; then
	echo "ERROR: No GitHub auth token found"
	return;
fi
if [ -z ${__LOGENTRIESACCTKEY+x} ]; then
	echo "ERROR: No LogEntries Account Key found"
	return;
fi
if [ -z ${__AUTHYAPIKEY+x} ]; then
	echo "ERROR: No Authy API Key found"
	return;
fi
if [ -z ${__NEWUSERAUTHYINFO+x} ]; then
	echo "ERROR: No authy access information found for user account"
	return;
fi
if [ -z ${__NEWUSERNAME+x} ]; then
	echo "ERROR: No name found for user account"
	return;
fi
if [ -z ${__NEWUSERUID+x} ]; then
	echo "ERROR: No UID found for user account"
	return;
fi
if [ -z ${__NEWUSERLONGNAME+x} ]; then
	echo "ERROR: No full name found for user account"
	return;
fi
if [ -z ${__PUSHOVEREMAILAPIKEY+x} ]; then
	echo "ERROR: No Pushover Email API Key found"
	return;
fi


