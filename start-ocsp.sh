#!/bin/sh
 
set -e
 
CA_DIR="$HOME/myCA"
OCSP_NAME="ocsp"
OCSP_DIR="$CA_DIR/$OCSP_NAME"
 
openssl ocsp \
  -port 8888 \
  -text \
  -index "$CA_DIR/index.txt" \
  -CA "$CA_DIR/certs/ca.cert.pem" \
  -rkey "$OCSP_DIR/$OCSP_NAME.key.pem" \
  -rsigner "$OCSP_DIR/$OCSP_NAME.cert.pem" \
  -nmin 1
