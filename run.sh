#!/bin/bash

# If something wrong - exit!
set -e

# Specify default values for args
NETWORK=""
INSTANCE_NAME=""
ROLE=""
BRIDGE_VERSION=""
FUSE_APP_VERSION=""
NETSTATS_VERSION=""
PARITY_VERSION=""
CONTACT_DETAILS=""

# Specify default WS parameters
WS_SERVER="wss://localhost:3000/"
WS_SECRET="i5WsUJWaMUHOS2CwvTRy"

# Help
function help() {
    echo "Netstats Agent - Startup script"
    echo
    echo "Description:"
    echo "  Script allow to generate processes.json file and run Netstats agent (NodeJS application)."
    echo
    echo "Note:"
    echo "  This script is running in Docker environment (Linux - based Docker images)."
    echo
    echo "Usage:"
    echo "  ./quickstart.sh [--network|--instance-name|--role|--bridge-version|--netstats-version|--fuseapp-version|--contact-details|--help]"
    echo
    echo "Options:"
    echo "  --network                   Network name. Example: 'fuse', 'spark'"
    echo "  --instance-name             Node name in https://health.fuse.io or https://health.fusespark.io. Example: 'my-personal-node'"
    echo "  --role                      Node role: Example: 'Node', 'Bootnode', etc."
    echo "  --bridge-version            Bridge version (Note: specify it if your role is 'Bridge'). Example: '1.0.0'"
    echo "  --netstats-version          Netstats agent version. Example: '1.0.0'"
    echo "  --parity-version            Fuse / Spark Network version based on OE Parity client. Example: '2.0.2'"
    echo "  --fuseapp-version           Validator app version (Note: specify it if your role is 'Validator' and 'Bridge'). Example: '1.0.0'"
    echo "  --contact-details           Contact details. Example: 'cto@fuse.io'"
    echo "  --help                      Help page"
}

# Generate processes.json file
function generates_file() {

    # Identify needed WS parameters related to the specific network
    if [[ "$NETWORK" == "fuse" ]]; then

        # Fuse Network
        WS_SERVER="https://health.fuse.io/ws"

    elif [[ "$NETWORK" == "spark" ]]; then

        # Spark Network
        WS_SERVER="https://health.fusespark.io/ws"

    else
        echo "Unrecognized network name. Valid network: 'fuse', 'spark'."
        exit 1
    fi

    # Generate processes.json file
    cat >processes.json <<EOF
[
    {
        "name": "netstats-agent",
        "script": "app.js",
        "log_date_format": "YYYY-MM-DD HH:mm Z",
        "merge_logs": false,
        "watch": false,
        "max_restarts": 10,
        "exec_interpreter": "node",
        "exec_mode": "fork_mode",
        "env": {
            "NODE_ENV": "production",
            "RPC_HOST": "localhost",
            "RPC_PORT": "8545",
            "LISTENING_PORT": "30303",
            "INSTANCE_NAME": "${INSTANCE_NAME}",
            "ROLE": "${ROLE}",
            "BRIDGE_VERSION": "${BRIDGE_VERSION}",
            "FUSE_APP_VERSION": "${FUSE_APP_VERSION}",
            "NETSTATS_VERSION": "${NETSTATS_VERSION}",
            "PARITY_VERSION": "${PARITY_VERSION}",
            "CONTACT_DETAILS": "${CONTACT_DETAILS}",
            "WS_SERVER": "${WS_SERVER}",
            "WS_SECRET": "${WS_SECRET}",
            "VERBOSITY": 2
        }
    }
]
EOF
}

ARGS=$(getopt -a -u --options n:i:r:b:a:p:f:c:h --longoptions network:,instance-name:,role:,bridge-version:,netstats-version:,parity-version:,fuseapp-version:,contact-details:,help -- $@)

eval set -- "$ARGS"

# If no arguments are provided exit
if [[ $@ == "--" ]]; then
    echo "No arguments provided."
    exit 1
fi

while true; do
    case "$1" in
    -n | --network)
        NETWORK="$2"
        shift 2
        ;;
    -i | --instance-name)
        INSTANCE_NAME="$2"
        shift 2
        ;;
    -r | --role)
        ROLE="$2"
        shift 2
        ;;
    -b | --bridge-version)
        BRIDGE_VERSION="$2"
        shift 2
        ;;
    -a | --netstats-version)
        NETSTATS_VERSION="$2"
        shift 2
        ;;
    -p | --parity-version)
        PARITY_VERSION="$2"
        shift 2
        ;;
    -f | --fuseapp-version)
        FUSE_APP_VERSION="$2"
        shift 2
        ;;
    -c | --contact-details)
        CONTACT_DETAILS="$2"
        shift 2
        ;;
    -h | --help)
        help
        exit 1
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Unexpected option: $1"
        shift 2
        break
        ;;
    esac
done

shift "$((OPTIND - 1))"

# Generate JSON file
generates_file

# Show generated JSON file
echo "Here is your generated file: "
echo ""

cat processes.json

echo ""

# Run PM2
pm2 start processes.json --no-daemon
