#!/bin/bash
set -e

FILES_DIR=$(yq e '.directory' /root/start9/config.yaml)
AGORA_PORT=8080
LND_RPC_AUTHORITY="lnd.embassy:10009"
TLS_CERT_PATH="/mnt/lnd/tls.cert"
INVOICES_MACAROON_PATH="/mnt/lnd/invoice.macaroon"
CORE_LIGHTNING_RPC_PATH="/mnt/c-lightning/lightning-rpc"
WALLET=$(yq e '.lightning.wallet' /root/start9/config.yaml)
PAYMENT=$(yq e '.lightning.payments' /root/start9/config.yaml)
PRICE=$(yq e '.lightning.price' /root/start9/config.yaml)

# Create directory for the agora files
mkdir -p "/mnt/filebrowser/${FILES_DIR}"

# Create sample .agora.yaml config file
if [ ! -e "/mnt/filebrowser/${FILES_DIR}/.agora.yaml" ] ; then
    cat >> "/mnt/filebrowser/${FILES_DIR}/.agora.yaml" <<"AGR"
# whether or not to charge for files
paid: true
# price for files in satoshis
base-price: 500 sat
AGR
echo "Agora config file created"
fi

echo "Updating config ..."
sed -i "s/paid:.*/paid: ${PAYMENT}/g" "/mnt/filebrowser/${FILES_DIR}/.agora.yaml"
sed -i "s/base-price:.*/base-price: ${PRICE} sat/g" "/mnt/filebrowser/${FILES_DIR}/.agora.yaml"

# Starting Agora process

if [ "$WALLET" = "lnd" ]; then
    echo "Running on Lightning Network Daemon."
    echo "Starting agora ..."
    exec tini -p SIGTERM -- agora \
        --directory "/mnt/filebrowser/${FILES_DIR}" \
        --http-port $AGORA_PORT \
        --lnd-rpc-authority $LND_RPC_AUTHORITY \
        --lnd-rpc-cert-path $TLS_CERT_PATH \
        --lnd-rpc-macaroon-path $INVOICES_MACAROON_PATH
else
	echo "Running on Core Lightning."
    echo "Starting agora ..."
    exec tini -p SIGTERM -- agora \
        --directory "/mnt/filebrowser/${FILES_DIR}" \
        --http-port $AGORA_PORT
        --core_lightning_rpc_file_path $CORE_LIGHTNING_RPC_PATH 
fi
