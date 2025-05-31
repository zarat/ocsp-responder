#!/bin/bash
 
set -e
 
CA_DIR="$HOME/myCA"
SERVER=$1  
SERVER_CERT="$CA_DIR/issued/$SERVER/$SERVER.cert.pem"
 
URI=$(openssl x509 -in "$SERVER_CERT" -noout -ocsp_uri)
 
openssl ocsp \
  -issuer "$CA_DIR/certs/ca.cert.pem" \
  -cert "$SERVER_CERT" \
  -url $URI \
  -resp_text -noverify
