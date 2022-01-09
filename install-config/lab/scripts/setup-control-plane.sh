#!/bin/bash

source "`dirname "$0"`/config.conf"

echo "Disable swap"
# sudo swapoff -a
# to check if swap is off you can run
#   cat /proc/swaps
# if you see no entries then swap is off

# echo "Disable swap"
# sudo swapoff -a

# echo "letting iptables see bridged traffic"
# source "`dirname "$0"`/config-br-netfilter.sh"

echo "install container runtime Docker"
source "`dirname "$0"`/install-docker.sh" $DOCKER_VERSION

echo "install kubeadm kubelet kubectl"
source "`dirname "$0"`/install-kube.sh" $KUBERNETES_VERSION
# echo "set iptables"
# source "`dirname "$0"`/config-control-plane-ports.sh"

# echo "install container runtime Docker"
# source "`dirname "$0"`/install-container-runtime-docker.sh" $DOCKER_VERSION
