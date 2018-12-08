#!/bin/bash
#

TARGET=/etc/nginx/ssl

rm csr/nginx.csr.pem
mv private/nginx.key.pem $TARGET
mv certs/nginx.cert.pem $TARGET
cat $TARGET/nginx.cert.pem > $TARGET/nginx.cert.chain.pem
cat $TARGET/ca.cert.pem >> $TARGET/nginx.cert.chain.pem
#nano index.txt
