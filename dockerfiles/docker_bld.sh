#!/bin/bash
# Scripted docker image build for the containers in Aible Cloud Account deployment

SHORT=P:,E:
LONG=project:,env:
OPTS=$(getopt -a -n init --options $SHORT --longoptions $LONG -- "$@")

eval set -- "$OPTS"

while :
do
  case "$1" in
    -P | --project )
      PROJECT="$2"
      shift 2
      ;;
    -E | --env )
      ENV=$2
      shift 2
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      ;;
  esac
done

DOMAIN=""  # DOMAIN not required for image build

. ../config.sh

docker build --progress plain -t ${REPO}/base:${TAG} -f base/Dockerfile .

docker push ${REPO}/base:${TAG}

docker build --progress plain --tag ${REPO}/exec:${TAG} \
--build-arg REPO=${REPO} --build-arg TAG=${TAG} \
--file exec/Dockerfile .

docker build --progress plain --tag ${REPO}/app:${TAG} \
--build-arg REPO=${REPO} --build-arg TAG=${TAG} \
--file app/Dockerfile .

docker push ${REPO}/exec:${TAG}

docker push ${REPO}/app:${TAG}
