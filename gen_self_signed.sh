#!/bin/bash

# Check if hostname argument is provided
if [ $# -lt 1 ]; then
    echo "Error: Hostname argument not provided."
    echo "Usage: $0 <hostname> [namespace]"
    exit 1
fi

# Assign the hostname from the first argument
HOSTNAME=$1

# Assign the namespace from the second argument or default to "logging"
NAMESPACE=${2:-logging}

# Generate a private key
PRIVATE_KEY=$(openssl genrsa 2048)

# Generate a certificate signing request (CSR)
CSR=$(openssl req -new -key <(echo "$PRIVATE_KEY") -subj "/CN=$HOSTNAME")

# Generate the self-signed certificate
CERT=$(openssl x509 -req -days 365 -in <(echo "$CSR") -signkey <(echo "$PRIVATE_KEY"))

# Create Kubernetes secret in the specified namespace
kubectl create secret tls grafana-tls --cert <(echo "$CERT") --key <(echo "$PRIVATE_KEY") -n "$NAMESPACE"


# Clean up
unset PRIVATE_KEY CSR CERT

