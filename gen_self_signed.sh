#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Error: Hostname argument not provided."
    echo "Usage: $0 <hostname> [namespace]"
    exit 1
fi

HOSTNAME=$1
NAMESPACE=${2:-logging}

PRIVATE_KEY=$(openssl genrsa 2048)
CSR=$(openssl req -new -key <(echo "$PRIVATE_KEY") -subj "/CN=$HOSTNAME")
CERT=$(openssl x509 -req -days 365 -in <(echo "$CSR") -signkey <(echo "$PRIVATE_KEY"))
kubectl create secret tls grafana-tls --cert <(echo "$CERT") --key <(echo "$PRIVATE_KEY") -n "$NAMESPACE"

unset PRIVATE_KEY CSR CERT

