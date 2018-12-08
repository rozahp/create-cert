#!/bin/bash
##
## Filename:	clean.sh
##
## Description:	clean certificate authority
##

if [ ! -f bin/__filetest__ ]; then
	echo "Err: please run script for ca-directory ..."
	exit
fi

echo "Log: cleaning up ca-directory ..."

RM="rm -f"

# rm index.txt
$RM index.txt*

# rm serial
$RM serial serial.old

# rm certificates (public/pricate)

$RM certs/*
$RM crl/*
$RM csr/*
$RM exports/*
$RM newcerts/*
$RM private/*

# reset index and serial

touch index.txt
echo 1000 > serial

echo "Log: Done!"

##
## EOF
##
