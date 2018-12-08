#!/bin/bash
##
## Filename:	create-server-cert.sh
##

if [ ! -f bin/__filetest__ ]; then
	echo "Err: please run script from ca-directory ..."
	exit
fi

DAYS=365	# 1 YEARS
KEYSIZE=1024
SERVER=$1

if [ "a"$SERVER = "a" ]; then
	echo "Err: no argument (=server name)"
	exit
fi

echo "Log: creating server key ... (add genrsa -aes256 for password protection)"

## add 'genrsa -aes256' if you want password protection of key

openssl genrsa \
	-out private/$SERVER.key.pem $KEYSIZE

chmod 400 private/$SERVER.key.pem

echo -n "Log: creating server cert ... hit enter to continue ..."
read X

openssl req -config config/openssl-server.conf \
	-key private/$SERVER.key.pem \
	-new -sha256 -out csr/$SERVER.csr.pem

echo -n "Log: signing cert with root ca ... hit enter to continue ..."
read X

openssl ca -config config/openssl-server.conf \
	-extensions server_cert -days $DAYS -notext -md sha256 \
	-in csr/$SERVER.csr.pem \
	-out certs/$SERVER.cert.pem

chmod 444 certs/$SERVER.cert.pem

echo -n "Log: verifying cert ... hit enter to continue ..."
read X

openssl x509 -noout -text \
	-in certs/$SERVER.cert.pem | less

echo -n "Log: verify certificate ... hit enter to continue ..."
read X

openssl verify  -CAfile certs/ca.cert.pem \
	certs/$SERVER.cert.pem


echo "Log: copy these files to server/application/browsers ..."
echo
echo "     1. certs/ca.cert.pem"
echo "     2. private/$SERVER.key.pem"
echo "     3. certs/$SERVER.cert.pem"
echo
echo "Log: Done!"

##
## EOF
##
