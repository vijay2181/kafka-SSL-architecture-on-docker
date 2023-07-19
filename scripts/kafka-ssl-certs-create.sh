#!/bin/bash

set -o nounset \
    -o errexit

function log_msg {
current_time=$(date "+%Y-%m-%d %H:%M:%S.%3N")
log_level=$1
log_msg="${@:2}"
echo -n "[$current_time] $log_level - $log_msg"
}

function log_error {
log_msg "ERROR" "$@"
}

function log_info {
log_msg "INFO " "$@"
}

function log_warn {
log_msg "WARNING" "$@"
}


PASS="password"
log_info "Deleting previous (if any)..."
mkdir -p secrets
mkdir -p tmp
mkdir -p ca
echo " OK!"
CA_CERT=ca/kafka-ca.crt
CA_KEY=ca/kafka-ca.key

# Generate CA key
if [[ ! -f $CA_CERT ]] && [[ ! -f $CA_KEY ]];then
openssl req -new -x509 -keyout $CA_KEY -out $CA_CERT -days 3650 -subj '/CN=Kafka CA/OU=Devops/O=Devopsforall/L=Hyderabad/C=IN' -passin pass:$PASS -passout pass:$PASS >/dev/null 2>&1
log_info "Creating CA..."
echo " OK!"
else
log_warn "CA certs already exists - Skip creating it.."
echo " OK!"
fi


for i in 'kafka1' 'kafka2' 'kafka3' 'producer' 'consumer' 'zk1' 'zk2' 'zk3' 'root' 'Dev' 'kafka4' 'kafka5'
do
        if [[ ! -f secrets/$i.keystore.jks ]] && [[ ! -f secrets/$i.truststore.jks ]];then
        log_info "Creating cert and keystore of $i..."
        # Create keystores
        keytool -genkey -noprompt \
                                 -alias $i \
                                 -dname "CN=$i, OU=Devops, O=Devopsforall, L=Hyderabad, C=IN" \
                                 -keystore secrets/$i.keystore.jks \
                                 -keyalg RSA \
                                 -storepass $PASS \
                                 -keypass $PASS  >/dev/null 2>&1

        # Create CSR, sign the key and import back into keystore
        keytool -keystore secrets/$i.keystore.jks -alias $i -certreq -file tmp/$i.csr -storepass $PASS -keypass $PASS >/dev/null 2>&1

        openssl x509 -req -CA $CA_CERT -CAkey $CA_KEY -in tmp/$i.csr -out tmp/$i-ca-signed.crt -days 1825 -CAcreateserial -passin pass:$PASS  >/dev/null 2>&1

        keytool -keystore secrets/$i.keystore.jks -alias CARoot -import -noprompt -file $CA_CERT -storepass $PASS -keypass $PASS >/dev/null 2>&1

        keytool -keystore secrets/$i.keystore.jks -alias $i -import -file tmp/$i-ca-signed.crt -storepass $PASS -keypass $PASS >/dev/null 2>&1

        # Create truststore and import the CA cert.
        keytool -keystore secrets/$i.truststore.jks -alias CARoot -import -noprompt -file $CA_CERT -storepass $PASS -keypass $PASS >/dev/null 2>&1
  echo " OK!"
     else
        log_warn "Keystore: $i.keystore.jks and truststore: $i.truststore.jks already exist..skip creating it.."
        echo " OK!"
  fi
done

echo "$PASS" > secrets/cert_creds
rm -rf tmp
[ $? -eq 0 ] && echo "Certs are Created Successfully"
