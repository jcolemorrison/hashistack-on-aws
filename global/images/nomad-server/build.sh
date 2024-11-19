#!/bin/bash

packer init .

export HCP_PACKER_BUILD_FINGERPRINT=$(git rev-parse HEAD)
export HCP_PACKER_BUILD_DETAILS=nomad-client

packer build .