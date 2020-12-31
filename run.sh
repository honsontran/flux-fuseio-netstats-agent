#!/bin/bash
set -e

# Create an array by the argument string.
IFS=' ' read -r -a ARG_VEC <<< "$@"

instance_name=$(hostname)
bridge_version=""
role=""
parity_version=""
fuseapp_version=""
netstats_version=""

if [ ${#ARG_VEC[@]} -lt 2 ] ; then
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

  elif [[ $arg == --bridge-version ]] ; then
    bridge_version="${ARG_VEC[$nextIndex]}"
    i=$nextIndex

  elif [[ $arg == --role ]] ; then
    role="${ARG_VEC[$nextIndex]}"
    i=$nextIndex

  elif [[ $arg == --parity-version ]] ; then
    parity_version="${ARG_VEC[$nextIndex]}"
    i=$nextIndex

  elif [[ $arg == --fuseapp-version ]] ; then
    fuseapp_version="${ARG_VEC[$nextIndex]}"
    i=$nextIndex

  elif [[ $arg == --netstats-version ]] ; then
    netstats_version="${ARG_VEC[$nextIndex]}"
    i=$nextIndex

  # A not known argument.
  else
    echo Unkown argument: $arg
    exit 1
  fi
done

cd /home/ethnetintel/eth-net-intelligence-api
jq -r --arg in "${instance_name}" --arg bv "${bridge_version}" --arg r "${role}" --arg pv "${parity_version}" --arg fv "${fuseapp_version}" --arg nv "${netstats_version}" '.[0].env.INSTANCE_NAME |= $in | .[0].env.BRIDGE_VERSION |= $bv | .[0].env.ROLE |= $r | .[0].env.FUSE_APP_VERSION |= $fv | .[0].env.PARITY_VERSION |= $pv | .[0].env.NETSTATS_VERSION |= $nv |.[0].env.WS_SECRET |= "i5WsUJWaMUHOS2CwvTRy"' app.json.example > app.json
/usr/bin/pm2 start ./app.json
/usr/bin/pm2 logs netstat_daemon --lines 1000