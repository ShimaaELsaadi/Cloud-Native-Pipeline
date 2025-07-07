#!/bin/bash

apt-get update && apt-get install -y curl tar grep sed

TRIVY_VERSION=$(curl -sL https://api.github.com/repos/aquasecurity/trivy/releases/latest \
  | grep '"tag_name":' \
  | sed -E 's/.*"v([^"]+)".*/\1/')

curl -L https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz \
  | tar -zxvf -

