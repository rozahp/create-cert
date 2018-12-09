#!/bin/bash
##
## Filename:	create-intermediate-ca.sh
##
## Description:	creates intermediate ca key and certificate
##

KEYSIZE=2048
DAYS=3650

if [ ! -f intermediate/bin/__filetest__ ]; then
	echo "[ERROR] please run script from ca-directory."
	exit
fi

echo -n "[INFO] creating intermediate ca key ..."

openssl genrsa -aes256 -out intermediate/private/intermediate.key.pem $KEYSIZE
chmod 400 intermediate/private/intermediate.key.pem

echo "[INFO] creating intermediate ca certificate ..."

openssl req -config intermediate/config/openssl-intermediate.conf -new -sha256 \
	-key intermediate/private/intermediate.key.pem \
	-out intermediate/csr/intermediate.csr.pem

echo "[INFO] signing intermediate ca cert with ca ... "

openssl ca -config config/openssl.conf \
    -extensions v3_intermediate_ca -days $DAYS -notext -md sha256 \
    -in intermediate/csr/intermediate.csr.pem \
    -out intermediate/certs/intermediate.cert.pem \

chmod 444 intermediate/certs/intermediate.cert.pem

echo -n "[INFO] verifying intermediate ca ... hit enter to continue ..."
read X

openssl x509 -noout -text -in intermediate/certs/intermediate.cert.pem | less

echo -n "[INFO] verifying intermediate ca against root ca ... hit enter to continue ..."
read X

openssl verify -CAfile certs/ca.cert.pem \
      intermediate/certs/intermediate.cert.pem

echo "[INFO] creating certificate chain file  ..."

cat intermediate/certs/intermediate.cert.pem \
      certs/ca.cert.pem > intermediate/certs/intermediate.cert.chain.pem
chmod 444 intermediate/certs/intermediate.cert.chain.pem

echo "[INFO]"
echo "[INFO] intermediate CA certificates, private key and chain file:"
echo "[INFO]"
echo "[INFO]    1. intermediate/certs/intermediate.cert.pem"
echo "[INFO]    2. intermediate/certs/intermediate.cert.chain.pem (root + intermediate ca)"
echo "[INFO]    3. intermediate/private/intermediate.key.pem"
echo "[INFO]"

echo "[INFO] done!"

##
## EOF
##
