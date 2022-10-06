Ethereum Network Intelligence API
============

This is the backend service which runs along with ethereum and tracks the network status, fetches information through JSON-RPC and connects through WebSockets to [eth-netstats](https://github.com/cubedro/eth-netstats) to feed information. For full install instructions please read the [wiki](https://github.com/ethereum/wiki/wiki/Network-Status).


## Prerequisite

 * node
 * npm


## Installation on an Ubuntu EC2 Instance

Fetch and run the build shell. This will install everything you need: latest ethereum - CLI from develop branch (you can choose between eth or geth), node.js, npm & pm2.

```bash
bash <(curl https://raw.githubusercontent.com/cubedro/eth-net-intelligence-api/master/bin/build.sh)
```

## Installation as docker container (optional)

There is a `Dockerfile` in the root directory of the repository. Please read through the header of said file for
instructions on how to build/run/setup. Configuration instructions below still apply.

## Configuration

Configure the app modifying [processes.json](./processes.json.example). You could modify next block:

```json
"env":
	{
		"NODE_ENV"        : "production", // tell the client we're in production environment
		"RPC_HOST"        : "localhost", // eth JSON-RPC host
		"RPC_PORT"        : "8545", // eth JSON-RPC port
		"LISTENING_PORT"  : "30303", // eth listening port (only used for display)
		"INSTANCE_NAME"   : "", // whatever you wish to name your node
		"CONTACT_DETAILS" : "", // add your contact details here if you wish (email/skype)
		"WS_SERVER"       : "wss://rpc.ethstats.net", // path to eth-netstats WebSockets api server
		"WS_SECRET"       : "see http://forum.ethereum.org/discussion/2112/how-to-add-yourself-to-the-stats-dashboard-its-not-automatic", // WebSockets api server secret used for login
		"VERBOSITY"       : 2 // Set the verbosity (0 = silent, 1 = error, warn, 2 = error, warn, info, success, 3 = all logs)
	}
```

## Run

Run it using pm2:

```bash
cd ~/bin
pm2 start processes.json
```

## Run with run.sh script

 [run.sh](./run.sh) was created for easy development and start PM2 Netstats agent process related to Fuse / Spark Network.

 > Note: there are some custom fields send to the netstats-dashboard WebSocket service. Could be modified or added in https://github.com/fuseio/netstats-dashboard

 ```bash
 ./run.sh

 Netstats Agent - Startup script

 Description:
   Script allow to generate processes.json file and run Netstats agent (NodeJS application).

 Note:
   This script is running in Docker environment (Linux - based Docker images).

 Usage:
   ./quickstart.sh [--network|--instance-name|--role|--bridge-version|--netstats-version|--fuseapp-version|--contact-details|--help]

 Options:
   --network                   Network name. Example: 'fuse', 'spark'
  --instance-name             Node name in https://health.fuse.io or https://health.fusespark.io. Example: 'my-personal-node'
  --role                      Node role: Example: 'Node', 'Bootnode', etc.
  --bridge-version            Bridge version (Note: specify it if your role is 'Bridge'). Example: '1.0.0'
  --netstats-version          Netstats agent version. Example: '1.0.0'
  --parity-version            Fuse / Spark Network version based on OE Parity client. Example: '2.0.2'
  --fuseapp-version           Validator app version (Note: specify it if your role is 'Validator' and 'Bridge'). Example: '1.0.0'
  --contact-details           Contact details. Example: 'cto@fuse.io'
  --help
 ```
