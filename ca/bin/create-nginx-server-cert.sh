#!/bin/bash
##
## Filename:	create-server-cert.sh
##

if [ ! -f bin/__filetest__ ]; then
	echo "[ERROR] please run script from ca-directory."
	exit
fi

DAYS=365	# 1 YEAR
KEYSIZE=1024
SERVER=nginx

echo "[INFO] creating server key ... (add genrsa -aes256 for password protection)"

openssl genrsa \
	-out private/$SERVER.key.pem $KEYSIZE

chmod 400 private/$SERVER.key.pem

echo "[INFO] creating server cert ... "

openssl req -config config/openssl-nginx-server.conf \
	-key private/$SERVER.key.pem \
	-new -sha256 -out csr/$SERVER.csr.pem

echo "[INFO] signing cert with root ca ... "

openssl ca -config config/openssl-nginx-server.conf \
	-extensions server_cert -days $DAYS -notext -md sha256 \
	-in csr/$SERVER.csr.pem \
	-out certs/$SERVER.cert.pem \

chmod 444 certs/$SERVER.cert.pem

echo -n "[INFO] verifying cert ... hit enter to continue ..."
read X

openssl x509 -noout -text \
	-in certs/$SERVER.cert.pem | less

openssl verify -CAfile certs/ca.cert.pem \
	certs/$SERVER.cert.pem

echo "[INFO] creating cert-chain ..."

cat certs/$SERVER.cert.pem certs/ca.cert.pem > certs/$SERVER.cert.chain.pem

echo "[INFO]"
echo "[INFO] files to copy to server/application/browsers:"
echo "[INFO]"
echo "[INFO]    1. certs/ca.cert.pem"
echo "[INFO]    2. private/$SERVER.key.pem"
echo "[INFO]    3. certs/$SERVER.cert.pem"
echo "[INFO]    4. certs/$SERVER.cert.chain.pem"
echo "[INFO]"
echo "[INFO] done!"

##
## EOF
##
