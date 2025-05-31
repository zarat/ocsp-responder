#!/bin/bash
 
# Exit on error
set -e
 
CA_DIR="$HOME/myCA"
ISSUED_DIR="$CA_DIR/issued"
 
# Prüfe ob Servername übergeben wurde
if [ -z "$1" ]; then
    echo " Bitte gib den Servernamen als Parameter an!"
    echo "   Beispiel: $0 server1.local"
    exit 1
fi
 
SERVER="$1"
SERVER_DIR="$ISSUED_DIR/$SERVER"
 
mkdir -p "$SERVER_DIR"
 
# Privaten Schlüssel erstellen
openssl genrsa -out "$SERVER_DIR/$SERVER.key.pem" 2048
 
# CSR erstellen
openssl req -new -key "$SERVER_DIR/$SERVER.key.pem" \
    -out "$SERVER_DIR/$SERVER.csr.pem" \
    -subj "/C=AT/ST=Vienna/O=Brainworx/CN=$SERVER"
 
# Zertifikat signieren
openssl ca -config "$CA_DIR/openssl.cnf" \
    -in "$SERVER_DIR/$SERVER.csr.pem" \
    -out "$SERVER_DIR/$SERVER.cert.pem" \
    -days 825 -batch -extensions v3_ca
 
echo " Zertifikat erfolgreich erstellt:"
echo "   -> Key:        $SERVER_DIR/$SERVER.key.pem"
echo "   -> CSR:        $SERVER_DIR/$SERVER.csr.pem"
echo "   -> Zertifikat: $SERVER_DIR/$SERVER.cert.pem"
