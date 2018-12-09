#!/bin/bash
##
## Filename:	initialize.sh
##
## Description:	init certificate authority
##

MKDIR="mkdir"

if [ ! -f bin/__filetest__ ]; then
	echo "[ERROR] please run script from ca-directory."
	exit
fi

echo "[INFO] initializing ca"

$MKDIR certs crl csr exports newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

echo "[INFO] done!"

##
## EOF
##
