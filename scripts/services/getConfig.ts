import { compat, types as T } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
  "tor-address": {
     "name": "Network Tor Address",
     "description": "The Tor address for the network interface.",
     "type": "pointer",
     "subtype": "package",
     "package-id": "agora",
     "target": "tor-address",
     "interface": "main"
  },
  "directory": {
     "name": "Root Directory Path",
     "description": "The path to the root directory in File Browser that will host your Agora files. If this directory does not already exist, it will be created upon saving this config.",
     "type": "string",
     "pattern": "^(\\.|[a-zA-Z0-9_ -][a-zA-Z0-9_ .-]*|([a-zA-Z0-9_ .-][a-zA-Z0-9_ -]+\\.*)+)(/[a-zA-Z0-9_ -][a-zA-Z0-9_ .-]*|/([a-zA-Z0-9_ .-][a-zA-Z0-9_ -]+\\.*)+)*/?$",
     "pattern-description": "Must be a valid relative file path",
     "nullable": false,
     "default": "agora-files",
     "placeholder": "e.g. 'agora-files', 'bitcoin-stuff/agora', etc"
  },
  "lightning": {
   "type": "object",
   "name": "Lightning Settings",
   "description": "Choose which Lightning implementation you want to use, whether you want to enable payments and for how much, or maybe host files for free.",
   "spec": {
      "wallet": {
         "name": "Select Lightning Node",
         "description":
           "Choose which Lightning node you want to use for payments.",
         "type": "enum",
         "values": [
           "lnd",
           "cln",
         ],
         "value-names": {
           "lnd": "Lightning Network Daemon (LND)",
           "cln": "Core Lightning (CLN)",
         },
         "default": "lnd",
       },
       "payments": {
         "type": "boolean",
         "name": "Enable payments",
         "description": "Decide whether to charge for files or make them freely available. This can be overridden on a subdirectory basis.",
         "default": true,
      },
       "price": {
         "type": "number",
         "name": "Price for files (in satoshis)",
         "nullable": false,
         "range": "[1,10000000]",
         "integral": true,
         "units": "satoshis",
         "description": "The default amount of satoshis users must pay per each file you host on Agora. This can be overridden on a subdirectory basis.",
         "default": 500
       },
       },
 },

});
