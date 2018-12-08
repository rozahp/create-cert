#!/bin/bash
##
## Filename:	create-client-cert.sh
##

if [ ! -f bin/__filetest__ ]; then
	echo "Err: please run script from ca-directory ..."
	exit
fi

DAYS=365	# 1 YEAR
KEYSIZE=1024
CLIENT=$1

if [ "a"$CLIENT = "a" ]; then
	echo "Err: no argument (=name of cert)"
	exit
fi

echo "Log: creating client key ... (add genrsa -aes256 for password protection)"

## add 'genrsa -aes256' if you want password protection of key

openssl genrsa \
	-out private/$CLIENT.key.pem $KEYSIZE

chmod 400 private/$CLIENT.key.pem

echo "Log: creating client cert ..."

openssl req -config config/openssl.conf \
	-key private/$CLIENT.key.pem \
	-new -sha256 -out csr/$CLIENT.csr.pem

echo "Log: signing cert with ca ..."

openssl ca -config config/openssl.conf \
	-extensions usr_cert -days $DAYS -notext -md sha256 \
	-in csr/$CLIENT.csr.pem \
	-out certs/$CLIENT.cert.pem

chmod 444 certs/$CLIENT.cert.pem

echo "Log: verifying cert ..."

openssl x509 -noout -text \
	-in certs/$CLIENT.cert.pem | less

openssl verify  -CAfile certs/ca.cert.pem \
	certs/$CLIENT.cert.pem

echo "Log: creating PKCS for export to browsers ..."

openssl pkcs12 -export -clcerts -in certs/$CLIENT.cert.pem \
	-inkey private/$CLIENT.key.pem \
	-out exports/$CLIENT.p12

echo "Log: creating combined PEM-file for use with openssl programs ..."

openssl pkcs12 -in exports/$CLIENT.p12 \
	-out exports/$CLIENT.pem -clcerts

echo "Log: copy these files to client application:"
echo
echo "     2. private/$CLIENT.key.pem"
echo "     3. certs/$CLIENT.cert.pem"
echo "     4. exports/$CLIENT.p12 (for browsers)"
echo "     5. export/$CLIENT.pem (for openssl programs)"
echo
echo "Log: Done!"

##
## EOF
##
