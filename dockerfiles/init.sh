#!/bin/bash

SHORT=P:,A:,T:
LONG=port:,app:,timeout:
OPTS=$(getopt -a -n init --options $SHORT --longoptions $LONG -- "$@")

eval set -- "$OPTS"

while :
do
  case "$1" in
    -P | --port )
      PORT="$2"
      shift 2
      ;;
    -A | --app )
      APP="$2"
      shift 2
      ;;
    -T | --timeout )
      TIMEOUT="$2"
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

NOTEBOOKSPATH=/tmp/notebooks
python get_notebooks.py --notebooks-path $NOTEBOOKSPATH

export PYTHONPATH=$NOTEBOOKSPATH

# gunicorn --bind $PORT --workers 1 --timeout $TIMEOUT $APP
gunicorn --bind $PORT --workers 1 --timeout 0 $APP
