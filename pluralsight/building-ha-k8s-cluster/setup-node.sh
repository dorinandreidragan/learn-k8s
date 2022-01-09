#!/bin/bash

set -e
set -x

source "`dirname "$1"`/config.conf"

sudo swapoff -a; sudo sed -i '/swap/d' /etc/fstab

echo "install container runtime Docker"
source "`dirname "$0"`/install-docker.sh" $DOCKER_VERSION

echo "install kubeadm kubelet kubectl"
source "`dirname "$0"`/install-kube.sh" $KUBERNETES_VERSION