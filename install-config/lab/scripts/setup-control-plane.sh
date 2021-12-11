#!/bin/bash

echo "Disable swap"
sudo swapoff -a

echo "letting iptables see bridged traffic"
source "`dirname "$0"`/config-br-netfilter.sh"

echo "set iptables"
source "`dirname "$0"`/config-control-plane-ports.sh"

echo "install container runtime Docker"
source "`dirname "$0"`/install-container-runtime-docker.sh" $DOCKER_VERSION