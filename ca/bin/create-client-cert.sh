#!/bin/bash
##
## Filename:	create-client-cert.sh
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

echo "[INFO] creating client key ... (add genrsa -aes256 for password protection)"
echo "[INFO] to add password protection, add 'genrsa -aes256' to command in this script: $0"

openssl genrsa \
	-out private/$CLIENT.key.pem $KEYSIZE

chmod 400 private/$CLIENT.key.pem

echo "[INFO] creating client cert ..."

openssl req -config config/openssl.conf \
	-key private/$CLIENT.key.pem \
	-new -sha256 -out csr/$CLIENT.csr.pem

echo "[INFO] signing cert with ca ..."

openssl ca -config config/openssl.conf \
	-extensions usr_cert -days $DAYS -notext -md sha256 \
	-in csr/$CLIENT.csr.pem \
	-out certs/$CLIENT.cert.pem

chmod 444 certs/$CLIENT.cert.pem

echo -n "[INFO] verifying cert ... hit enter to continue ..."
read X

openssl x509 -noout -text \
	-in certs/$CLIENT.cert.pem | less

openssl verify -CAfile certs/ca.cert.pem \
	certs/$CLIENT.cert.pem

echo "[INFO] creating PKCS for export to browsers."
echo "[INFO] note: password is optional."

openssl pkcs12 -export -clcerts -in certs/$CLIENT.cert.pem \
	-inkey private/$CLIENT.key.pem \
	-out exports/$CLIENT.p12

echo "[INFO] creating combined PEM-file for use with openssl programs ..."
echo "[INFO] note: 'Import Password' is the same as above, if not set just hit enter."
echo "[INFO] note: to set password remove '-nodes' from command"

openssl pkcs12 -nodes -in exports/$CLIENT.p12 \
	-out exports/$CLIENT.pem -clcerts

echo "[INFO]"
echo "[INFO] copy these files to applications/browsers:"
echo "[INFO]"
echo "[INFO]    2. private/$CLIENT.key.pem"
echo "[INFO]    3. certs/$CLIENT.cert.pem"
echo "[INFO]    4. exports/$CLIENT.p12 (for browsers)"
echo "[INFO]    5. exports/$CLIENT.pem (for openssl programs)"
echo "[INFO]"
echo "[INFO] done!"

##
## EOF
##
