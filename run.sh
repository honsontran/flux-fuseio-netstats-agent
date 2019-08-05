#!/bin/bash
set -e

# Create an array by the argument string.
IFS=' ' read -r -a ARG_VEC <<< "$@"

instance_name=$(hostname)

if [[ ${#ARG_VEC[@]} < 2 ]] ; then
  echo "Missing instance-name argument"
  exit 1
fi

for (( i=0; i<${#ARG_VEC[@]}; i++ )) ; do
  arg="${ARG_VEC[i]}"
  nextIndex=$((i + 1))

  # Define the instance name for the client.
  if [[ $arg == --instance-name ]] ; then
    instance_name="${ARG_VEC[$nextIndex]}"
    i=$nextIndex

  # A not known argument.
  else
    echo Unkown argument: $arg
    exit 1
  fi
done

cd /home/ethnetintel/eth-net-intelligence-api
jq -r --arg e "${instance_name}" '.[0].env.INSTANCE_NAME |= $e | .[0].env.WS_SECRET |= "i5WsUJWaMUHOS2CwvTRy"' app.json.example > app.json
/usr/bin/pm2 start ./app.json
/usr/bin/pm2 logs netstat_daemon --lines 1000