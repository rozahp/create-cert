# Base for creating a certificate authority

Easily create a certificate authority for your local network. There after you can create client and server certificates for many usages. It's really very fun!

## AUTHOR

Compiled by Phazor / Cascade 1733 for sources on the Internet.

## LICENSE

Please feel free to copy, distribute and change it in any way you like.

## INSTRUCTIONS

1. jump to the ca/ directory
2. bin/clean.sh
3. bin/initialize.sh
4. edit config/{openssl.conf,openssl-nginx-server,openssl-server.conf} to your liking, especially this parts:

[ req_distinguished_name ]

[ alternate_names ]

5. 

## Push certificate to an nginx server

``TARGET=/etc/nginx/ssl
rm csr/nginx.csr.pem
mv private/nginx.key.pem $TARGET
mv certs/nginx.cert.pem $TARGET
cat $TARGET/nginx.cert.pem > $TARGET/nginx.cert.chain.pem
cat $TARGET/ca.cert.pem >> $TARGET/nginx.cert.chain.pem``

Install ca.cert.pem on your browser clients.

## Have fun!

##
## EOF
##