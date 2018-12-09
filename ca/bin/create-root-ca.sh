#!/bin/bash
##
## Filename:	create-root-ca.sh
##
## Description:	creates root ca key and certificate
##

KEYSIZE=2048
DAYS=3650

if [ ! -f bin/__filetest__ ]; then
	echo "[ERROR] please run script from ca-directory."
	exit
fi

echo -n "[INFO] creating root ca key ..."

openssl genrsa -aes256 -out private/ca.key.pem $KEYSIZE
chmod 400 private/ca.key.pem

echo "[INFO] creating root ca certificate ..."

openssl req -config config/openssl.conf -key private/ca.key.pem \
	-new -x509 -days $DAYS -sha256 -extensions v3_ca \
	-out certs/ca.cert.pem

chmod 444 certs/ca.cert.pem

echo -n "[INFO] verifying root ca ... hit enter to continue ..."
read X

openssl x509 -noout -text -in certs/ca.cert.pem | less

echo "[INFO]"
echo "[INFO] CA certificates and private key:"
echo "[INFO]"
echo "[INFO]    1. certs/ca.cert.pem"
echo "[INFO]    2. private/ca.key.pem"
echo "[INFO]"

echo "[INFO] done!"

##
## EOF
##
