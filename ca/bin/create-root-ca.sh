#!/bin/bash
##
## Filename:	create-root-ca.sh
##
## Description:	creates root ca key and certificate
##

KEYSIZE=2048

if [ ! -f bin/__filetest__ ]; then
	echo "Err: please run script from ca-directory ..."
	exit
fi

echo -n "Log: creating root ca key .. hit enter to continue .."
read X

openssl genrsa -aes256 -out private/ca.key.pem $KEYSIZE
chmod 400 private/ca.key.pem

echo -n "Log: creating root ca certificate - hit enter to continue ..."
read X

openssl req -config config/openssl.conf -key private/ca.key.pem \
	-key private/ca.key.pem \
	-new -x509 -days 7300 -sha256 -extensions v3_ca \
	-out certs/ca.cert.pem

chmod 444 certs/ca.cert.pem

echo "Log: verifying root ca ... hit enter to continue ..."
read X

openssl x509 -noout -text -in certs/ca.cert.pem | less

echo "Log: Done!"

##
## EOF
##
