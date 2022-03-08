#!/bin/bash

CONTAINER_IMAGE="${CONTAINER_IMAGE:-localhost/fdo-admin-cli}"

mkdir -p keys
for i in "diun" "manufacturer" "device_ca" "owner"; do sudo podman run -v $PWD/keys:/keys:z $CONTAINER_IMAGE generate-key-and-cert $i; done
echo "sha256:$(openssl x509 -fingerprint -sha256 -noout -in keys/diun_cert.pem | cut -d"=" -f2 | sed 's/://g')" > keys/diun_pub_key_hash

touch keys/.created