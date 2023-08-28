# Jira Init Script

This script initializes a local Jira instance for development purposes.

## Requirements

You need to install docker and docker-compose on your local machine. This script was tested on Linux

## Guide

For each Jira version, a new directory structure will be created. At this time the port number is fixed inside the script, so only 1 instance can be run at a time.

The script will initialy start Jira in interactive mode. You can shut it down (Ctrl+C) and simply use 

***
docker-compose up -d
***

to start the instance.

You can deploy scripts to this instance via 

***
atlas-package && atlas-install-plugin --server yourhostname -p 8080 --context-path ""
***

This live instance runs much faster than the development instance started via atlas-run
