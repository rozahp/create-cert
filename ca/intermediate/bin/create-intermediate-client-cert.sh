#!/bin/bash
##
## Filename:	create-intermediate-client-cert.sh
##

KEYSIZE=1024
DAYS=365
CLIENT=$1

if [ ! -f bin/__filetest__ ]; then
	echo "[ERROR] please run script from ca-directory."
	exit
fi

if [ "a"$CLIENT = "a" ]; then
	echo "[ERROR] no argument (=name of cert)"
	exit
fi

echo "[INFO] creating intermediate client key ... (add genrsa -aes256 for password protection)"
echo "[INFO] to add password protection, add 'genrsa -aes256' to command in this script: $0"

openssl genrsa \
	-out intermediate/private/$CLIENT.key.pem $KEYSIZE

chmod 400 intermediate/private/$CLIENT.key.pem

echo "[INFO] creating intermediate client cert ..."

openssl req -config intermediate/config/openssl-intermediate.conf \
	-key intermediate/private/$CLIENT.key.pem \
	-new -sha256 -out intermediate/csr/$CLIENT.csr.pem

echo "[INFO] signing intermediate cert with intermediate ca ..."

openssl ca -config intermediate/config/openssl-intermediate.conf \
	-extensions usr_cert -days $DAYS -notext -md sha256 \
	-in intermediate/csr/$CLIENT.csr.pem \
	-out intermediate/certs/$CLIENT.cert.pem

chmod 444 intermediate/certs/$CLIENT.cert.pem

echo -n "[INFO] verifying intermediate cert ... hit enter to continue ..."
read X

openssl x509 -noout -text \
	-in intermediate/certs/$CLIENT.cert.pem | less

openssl verify -CAfile intermediate/certs/intermediate.cert.chain.pem \
	intermediate/certs/$CLIENT.cert.pem

echo "[INFO] creating PKCS for export to browsers."
echo "[INFO] note: password is optional."

openssl pkcs12 -export -clcerts -in intermediate/certs/$CLIENT.cert.pem \
	-inkey intermediate/private/$CLIENT.key.pem \
	-out intermediate/exports/$CLIENT.p12

echo "[INFO] creating combined PEM-file for use with openssl programs ..."
echo "[INFO] note: 'Import Password' is the same as above, if not set just hit enter."
echo "[INFO] note: to set password remove '-nodes' from command"

openssl pkcs12 -nodes -in intermediate/exports/$CLIENT.p12 \
	-out intermediate/exports/$CLIENT.pem -clcerts

echo "[INFO]"
echo "[INFO] copy these files to applications/browsers:"
echo "[INFO]"
echo "[INFO]    1. certs/ca.cert.pem (root ca)"
echo "[INFO]    2. intermediate/certs/intermediate.cert.chain.pem (root + intermediate ca)"
echo "[INFO]    3. certs/$CLIENT.cert.pem"
echo "[INFO]    4. private/$CLIENT.key.pem"
echo "[INFO]    5. exports/$CLIENT.p12 (for browsers)"
echo "[INFO]    6. exports/$CLIENT.pem (for openssl programs)"
echo "[INFO]"
echo "[INFO] done!"

##
## EOF
##
