#!/bin/bash

env=proto-${ENV}  # current Aible Cloud environment - e.g. proto-gcp-beta. set --env gcp-beta
version=v11.0.7
REGION=us-central1
PROJECT=aible-gcp-containers-beta
US-REPO=demo-multi-region-us
ASIA-REPO=demo-multi-region-asia
#REPO=${REGION}-docker.pkg.dev/${PROJECT}/aible-daml
TAG=${env}-${version}

AIBLE_NET_LOC=api-${ENV}.${DOMAIN}.com  # from Aible - network location of the API - e.g. api-gcp-beta.p.iamaible.com. set --domain p.iamaible
