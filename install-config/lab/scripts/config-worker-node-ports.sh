#!/bin/bash

# https://kubernetes.io/docs/reference/ports-and-protocols/#node
# Worker node ports
# Protocol      Direction       Port Range      Purpose                 Used By
# TCP           Inbound         10250           Kubelet API             Self, Control plane
# TCP           Inbound         30000-32767     NodePort Services       All

sudo iptables -A INPUT -p tcp --dport 10250 -j ACCEPT
sudo iptables -A INPUT -p tcp --match multiport --dport 30000:32767 -j ACCEPT

# https://metallb.universe.tf/#requirements
# MetalLB ports:
# Protocol      Direction       Port Range      Purpose                 Used By
# TCP           I/O             7946            MetalLB                 All
# UDP           I/O             7946            MetalLB                 All

sudo iptables -A INPUT -p tcp --dport 7946 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 7946 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 7946 -j ACCEPT
sudo iptables -A OUTPUT -p udp --dport 7946 -j ACCEPT

source "`dirname "$0"`/save-iptables.sh"