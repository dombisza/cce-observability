#!/bin/bash
# OTC auth


TARGET_V="2.0.7"
CURRENT_V=$(otc-auth -v | awk '{print $3}')

 if [ "$(printf '%s\n' "$TARGET_V" "$CURRENT_V" | sort -V | head -n1)" = "$TARGET_V" ]; then
    >&2 echo "[INFO] otc-auth version: ${CURRENT_V}"
 else
    >&2 echo "[WARN] Recommended otc-auth version is >= ${TARGET_V}"
    sleep 5
    >&2 echo "[INFO] Attempting IAM login nevertheless..."
 fi

otc-auth login iam --overwrite-token
otc-auth temp-access-token create --duration-seconds 86390
source ./ak-sk-env.sh
export TF_VAR_ak_sk_security_token=$AWS_SESSION_TOKEN
rm -f ./ak-sk-env.sh

if [ -z "${TF_VAR_ak_sk_security_token}" ]; then
  >&2 echo "[ERROR] security_token variable is empty."
else
  >&2 echo "[INFO] TOKEN has been sourced, gods speed terraforming."
fi
