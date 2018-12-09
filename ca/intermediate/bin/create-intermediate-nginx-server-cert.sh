#!/bin/bash
##
## Filename:	create-intermediate-nginx-server-cert.sh
##

KEYSIZE=1024
DAYS=365
SERVER=nginx

if [ ! -f bin/__filetest__ ]; then
	echo "[ERROR] please run script from ca-directory."
	exit
fi

if [ "a"$SERVER = "a" ]; then
	echo "[ERROR] no argument (=server name)"
	exit
fi

echo "[INFO] creating intermediate server key ... (add genrsa -aes256 for password protection)"

openssl genrsa \
	-out intermediate/private/$SERVER.key.pem $KEYSIZE

chmod 400 intermediate/private/$SERVER.key.pem

echo "[INFO] creating intermediate server cert ... "

openssl req -config intermediate/config/openssl-intermediate-nginx-server.conf \
	-key intermediate/private/$SERVER.key.pem \
	-new -sha256 -out intermediate/csr/$SERVER.csr.pem

echo "[INFO] signing intermediate cert with intermediate ca ..."

openssl ca -config intermediate/config/openssl-intermediate-nginx-server.conf \
	-extensions server_cert -days $DAYS -notext -md sha256 \
	-in intermediate/csr/$SERVER.csr.pem \
	-out intermediate/certs/$SERVER.cert.pem

chmod 444 intermediate/certs/$SERVER.cert.pem

echo -n "[INFO] verifying intermediate cert ... hit enter to continue ..."
read X

openssl x509 -noout -text \
	-in intermediate/certs/$SERVER.cert.pem | less

openssl verify -CAfile intermediate/certs/intermediate.cert.chain.pem \
	intermediate/certs/$SERVER.cert.pem

echo "[INFO] creating root-intermediate-server-cert-chain ..."

cat intermediate/certs/$SERVER.cert.pem intermediate/certs/intermediate.cert.pem certs/ca.cert.pem > intermediate/certs/$SERVER.cert.chain.pem

cat intermediate/certs/$SERVER.cert.pem intermediate/certs/intermediate.cert.pem > intermediate/certs/$SERVER.cert.chain.small.pem

echo "[INFO]"
echo "[INFO] files to copy to server/application/browsers:"
echo "[INFO]"
echo "[INFO]    1. certs/ca.cert.pem (root ca)"
echo "[INFO]    2. intermediate/certs/intermediate.cert.chain.pem (root + intermediate ca)"
echo "[INFO]    3. intermediate/private/$SERVER.key.pem"
echo "[INFO]    4. intermediate/certs/$SERVER.cert.pem"
echo "[INFO]    5. intermediate/certs/$SERVER.cert.chain.pem (root + intermediate + server)"
echo "[INFO]    6. intermediate/certs/$SERVER.cert.chain.small.pem (intermediate + server)"
echo "[INFO]"
echo "[INFO] done!"

##
## EOF
##
