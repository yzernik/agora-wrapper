#!/bin/bash
set -e

FILES_DIR=$(yq e '.directory' /root/start9/config.yaml)
AGORA_PORT=8080
LND_RPC_AUTHORITY="lnd.embassy:10009"
TLS_CERT_PATH="/mnt/lnd/tls.cert"
INVOICES_MACAROON_PATH="/mnt/lnd/data/chain/bitcoin/mainnet/invoice.macaroon"
PAYMENT=$(yq e '.payments' /root/start9/config.yaml)
PRICE=$(yq e '.price' /root/start9/config.yaml)

# Create directory for the agora files
mkdir -p /mnt/filebrowser/${FILES_DIR}

# Create sample .agora.yaml config file
if [ ! -e "/mnt/filebrowser/${FILES_DIR}/.agora.yaml" ] ; then
    cat >> "/mnt/filebrowser/${FILES_DIR}/.agora.yaml" <<"AGR"
# whether or not to charge for files
paid: true
# price for files in satoshis
base-price: 500 sat
AGR
sed -i "s/paid:.*/paid: ${PAYMENT}/g" /mnt/filebrowser/Agora-Test/Satoshi/.agora.yaml
sed -i "s/base-price:.*/base-price: ${PRICE} sat/g" /mnt/filebrowser/Agora-Test/Satoshi/.agora.yaml
echo "Agora config file created"
fi

# Starting Agora process
echo "starting agora..."
exec agora \
     --directory "/mnt/filebrowser/${FILES_DIR}" \
     --http-port $AGORA_PORT \
     --lnd-rpc-authority $LND_RPC_AUTHORITY \
     --lnd-rpc-cert-path $TLS_CERT_PATH \
     --lnd-rpc-macaroon-path $INVOICES_MACAROON_PATH
