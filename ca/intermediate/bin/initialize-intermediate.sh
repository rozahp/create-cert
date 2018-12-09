#!/bin/bash
##
## Filename:	initialize.sh
##
## Description:	init intermediate certificate authority
##

MKDIR="mkdir"

if [ ! -f bin/__filetest__ ]; then
	echo "[ERROR] please run script from ca-directory."
	exit
fi

echo "[INFO] initializing intermediate ca"

cd intermediate

$MKDIR certs crl csr exports newcerts private
chmod 700 private
touch index.txt
echo "unique_subject = yes" > index.txt.attr # Fix first cert errors
echo 1000 > serial

cd ..

echo "[INFO] done!"

##
## EOF
##
