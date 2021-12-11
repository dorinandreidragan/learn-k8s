#!/bin/bash

# https://kubernetes.io/docs/reference/ports-and-protocols/#control-plane
# Control Plane ports: 
# Protocol      Direction       Port Range      Purpose                 Used By
# TCP           Inbound         6443            Kubernetes API server   All
# TCP           Inbound         2379-2380       etcd server client API  kube-apiserver, etcd
# TCP           Inbound         10250           Kubelet API             Self, Control plane
# TCP           Inbound         10259           kube-scheduler          Self
# TCP           Inbound         10257           kube-controller-manager Self

sudo iptables -A INPUT -p tcp --dport 6443 -j ACCEPT
sudo iptables -A INPUT -p tcp --match multiport --dport 2379:2380 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 10250 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 10259 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 10257 -j ACCEPT

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
