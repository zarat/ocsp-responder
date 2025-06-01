#!/bin/bash

# Deine Server URI
OCSP_SERVER_URI=http://localhost:8888
 
CA_DIR="$HOME/myCA"
 
mkdir -p "$CA_DIR"/{certs,crl,newcerts,private}
chmod 700 "$CA_DIR/private"
touch "$CA_DIR/index.txt"
echo 1000 > "$CA_DIR/serial"
echo 1000 > "$CA_DIR/crlnumber"
 
cat <<EOF > "$CA_DIR/openssl.cnf"
[ ca ]
default_ca = CA_default
 
[ CA_default ]
dir               = $CA_DIR
certs             = \$dir/certs
crl_dir           = \$dir/crl
database          = \$dir/index.txt
new_certs_dir     = \$dir/newcerts
certificate       = \$dir/certs/ca.cert.pem
serial            = \$dir/serial
crlnumber         = \$dir/crlnumber
crl               = \$dir/crl/ca.crl.pem
private_key       = \$dir/private/ca.key.pem
RANDFILE          = \$dir/private/.rand
 
x509_extensions   = v3_ca
name_opt          = ca_default
cert_opt          = ca_default
default_days      = 3650
default_crl_days  = 30
default_md        = sha256
preserve          = no
policy            = policy_strict
email_in_dn    = no
rand_serial    = no
 
 
[ policy_strict ]
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional
 
[ req ]
default_bits        = 4096
prompt              = no
default_md          = sha256
distinguished_name  = dn
x509_extensions     = v3_ca
 
[ dn ]
C  = AT
ST = Vienna
L  = Vienna
O  = Brainworx
CN = Root CA
 
[ v3_ca ]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
authorityInfoAccess = OCSP;URI:$OCSP_SERVER_URI
 
[ crl_ext ]
authorityKeyIdentifier = keyid:always
 
[ v3_ocsp ]
basicConstraints = CA:FALSE
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, OCSPSigning
EOF
 
 
# generate root key
openssl genrsa -out ~/myCA/private/ca.key.pem 4096
chmod 400 ~/myCA/private/ca.key.pem
 
# generate root cert
openssl req -config ~/myCA/openssl.cnf \
    -key ~/myCA/private/ca.key.pem \
    -new -x509 -days 3650 -sha256 -extensions v3_ca \
    -out ~/myCA/certs/ca.cert.pem
 
# create crl
openssl ca -config ~/myCA/openssl.cnf -gencrl -out ~/myCA/crl/ca.crl.pem
 
# export pem or der
openssl crl -in ~/myCA/crl/ca.crl.pem -outform DER -out ~/myCA/crl/ca.crl.der
