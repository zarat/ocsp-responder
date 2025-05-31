#!/bin/bash
 
# Exit on error
set -e
 
CA_DIR="$HOME/myCA"
ISSUED_DIR="$CA_DIR/issued"
CRL_PUB_DIR="/var/www/html"
 
# Prüfe ob Servername übergeben wurde
if [ -z "$1" ]; then
    echo " Bitte gib den Servernamen als Parameter an!"
    echo "   Beispiel: $0 server2.local"
    exit 1
fi
 
SERVER="$1"
CERT_FILE="$ISSUED_DIR/$SERVER/$SERVER.cert.pem"
 
# Prüfe ob Zertifikat existiert
if [ ! -f "$CERT_FILE" ]; then
    echo " Zertifikat nicht gefunden: $CERT_FILE"
    exit 1
fi
 
# Zertifikat widerrufen
openssl ca -config "$CA_DIR/openssl.cnf" -revoke "$CERT_FILE"
 
# Neue CRL generieren
openssl ca -config "$CA_DIR/openssl.cnf" -gencrl -out "$CA_DIR/crl/ca.crl.pem"
 
# CRL veröffentlichen
mkdir -p "$CRL_PUB_DIR"
cp "$CA_DIR/crl/ca.crl.pem" "$CRL_PUB_DIR/ca.crl.pem"
 
echo "Zertifikat $SERVER widerrufen und CRL aktualisiert:"
echo "   -> CRL: $CRL_PUB_DIR/ca.crl.pem"
