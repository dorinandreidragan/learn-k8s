#!/bin/bash

# Disable swap
sudo swapoff -a

# Letting iptables see bridged traffic

# Make sure the br_netfilter module is loaded
sudo modprobe br_netfilter

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic
# As a requirement for your Linux Node's iptables to correctly 
# see bridged traffic, you should ensure net.bridge.bridge-nf-call-iptables
# is set to 1 in your sysctl config, e.g.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system