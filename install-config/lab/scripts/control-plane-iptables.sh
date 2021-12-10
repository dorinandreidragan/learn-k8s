#!/bin/bash

# Control Plane ports
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

# save iptables
sudo sh -c "iptables-save -c > /etc/iptables.rules"

# create scripts for if-pre-up.d
sudo bash -c 'cat <<EOF | sudo tee /etc/network/if-pre-up.d/iptablesload
#!/bin/sh
iptables-restore < /etc/iptables.rules
exit 0
EOF'
sudo chmod +x /etc/network/if-pre-up.d/iptablesload

# creat scripts for if-post-down.d
sudo bash -c 'cat <<EOF | sudo tee /etc/network/if-post-down.d/iptablessave
#!/bin/sh
iptables-save -c > /etc/iptables.rules
if [ -f /etc/iptables.downrules ]; then
  iptables-restore < /etc/iptables.downrules
fi
exit 0
EOF'
sudo chmod +x /etc/network/if-post-down.d/iptablessave
