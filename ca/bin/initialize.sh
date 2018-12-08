#!/bin/bash
##
## Filename:	initialize.sh
##
## Description:	init certificate authority
##

MKDIR="mkdir"

if [ ! -f bin/__filetest__ ]; then
	echo "Err: please run script from ca-directory ..."
	exit
fi

echo "Log: initializing ca ..."

$MKDIR certs crl newcerts
chmod 700 private
touch index.txt
echo 1000 > serial

##
## EOF
##
