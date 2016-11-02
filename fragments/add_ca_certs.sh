#!/bin/bash

echo "$CACERT" > /etc/pki/ca-trust/source/anchors/teco-eu-ca-chain.pem
update-ca-trust extract
