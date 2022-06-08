#!/bin/bash
set -e

FILES_DIR=$(yq e '.directory' /root/start9/config.yaml)
AGORA_PORT=8080
LND_RPC_AUTHORITY="lnd.embassy:10009"
TLS_CERT_PATH="/mnt/lnd/tls.cert"
INVOICES_MACAROON_PATH="/mnt/lnd/data/chain/bitcoin/mainnet/invoice.macaroon"

# Create directory for the agora files
mkdir -p /mnt/filebrowser/${FILES_DIR}

# Starting Agora process
echo "starting agora..."
exec agora \
     --directory "/mnt/filebrowser/${FILES_DIR}" \
     --http-port $AGORA_PORT \
     --lnd-rpc-authority $LND_RPC_AUTHORITY \
     --lnd-rpc-cert-path $TLS_CERT_PATH \
     --lnd-rpc-macaroon-path $INVOICES_MACAROON_PATH
