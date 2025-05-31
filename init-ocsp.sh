#!/bin/bash
 
set -e
 
CA_DIR="$HOME/myCA"
OCSP_NAME="ocsp"
OCSP_DIR="$CA_DIR/$OCSP_NAME"
mkdir -p "$OCSP_DIR"
 
# Key erstellen
openssl genrsa -out "$OCSP_DIR/$OCSP_NAME.key.pem" 4096
 
# CSR
openssl req -new -key "$OCSP_DIR/$OCSP_NAME.key.pem" \
    -out "$OCSP_DIR/$OCSP_NAME.csr.pem" \
    -subj "/C=AT/ST=Vienna/O=Brainworx/CN=OCSP Responder"
 
# Zertifikat signieren
openssl ca -config "$CA_DIR/openssl.cnf" \
    -in "$OCSP_DIR/$OCSP_NAME.csr.pem" \
    -out "$OCSP_DIR/$OCSP_NAME.cert.pem" \
    -days 825 -extensions v3_ocsp -batch
 
echo "OCSP-Zertifikat erstellt unter:"
echo "  $OCSP_DIR/$OCSP_NAME.cert.pem"
