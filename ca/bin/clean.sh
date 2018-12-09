#!/bin/bash
##
## Filename:	clean.sh
##
## Description:	clean certificate authority
##

if [ ! -f bin/__filetest__ ]; then
	echo "[ERROR] please run script for ca-directory"
	exit
fi

echo "[INFO] cleaning up ca-directory"

RM="rm -fr"

$RM index.txt*

$RM serial serial.old

# rm certificates (public/pricate)

$RM certs
$RM crl
$RM csr
$RM exports
$RM newcerts
$RM private

# reset index and serial

touch index.txt
echo 1000 > serial

echo "[INFO] done!"

##
## EOF
##
