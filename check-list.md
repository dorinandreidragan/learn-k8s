# Check List

## Before you begin

<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin>

- [x] Compatible Linux host
- [x] 2 GB or more of RAM
- [x] 2 CPUs or more
- [x] Full network connectivity between all machines in the cluster
- [x] A compatible Linux host. The Kubernetes project provides generic instructions for Linux distributions based on Debian and Red Hat, and those distributions without a package manager.
- [x] 2 GB or more of RAM per machine (any less will leave little room for your apps).
- [x] 2 CPUs or more.
- [x] Full network connectivity between all machines in the cluster (public or private network is fine).
- [x] Unique hostname, MAC address, and product_uuid for every node.
- [x] Certain ports are open on your machines. See [here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports) for more details.
- [x] Swap disabled. You **MUST** disable swap in order for the kubelet to work properly.

## Verify the MAC address and product_uuid are unique for every node

<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#verify-mac-address>

- [x] You can get the MAC address of the network interfaces using the command `ip link` or `ifconfig -a`
- [x] The `product_uuid` can be checked by using the command sudo cat `/sys/class/dmi/id/product_uuid`

## Check network adapters

- [ ] If you have more than one adapter, and If you have more than one network adapter, and your Kubernetes components are not reachable on the default route, we recommend you add IP route(s) so Kubernetes cluster addresses go via the appropriate adapter.
  - [ ] Learn about IP Routing

## Letting iptables see bridged traffic

<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#letting-iptables-see-bridged-traffic>

- [x] Make sure that the br_netfilter module is loaded. This can be done by running lsmod | grep br_netfilter. To load it explicitly call sudo modprobe br_netfilter.

- [x] As a requirement for your Linux Node's iptables to correctly see bridged traffic, you should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g.

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
```

## Check required ports

- [x] Control plane ports
  
  <https://kubernetes.io/docs/reference/ports-and-protocols/#control-plane>

  | Protocol | Direction | Port      | Range                   | Purpose              | Used By |
  | -------- | --------- | --------- | ----------------------- | -------------------- | ------- |
  | TCP      | Inbound   | 6443      | Kubernetes API server   | All                  |
  | TCP      | Inbound   | 2379-2380 | etcd server client API  | kube-apiserver, etcd |
  | TCP      | Inbound   | 10250     | Kubelet API             | Self, Control plane  |
  | TCP      | Inbound   | 10259     | kube-scheduler          | Self                 |
  | TCP      | Inbound   | 10257     | kube-controller-manager | Self                 |

  Although etcd ports are included in control plane section, you can also host your own etcd cluster externally or on custom ports.

- [x] Worker node(s)

  <https://kubernetes.io/docs/reference/ports-and-protocols/#node>

  | Protocol | Direction | Port Range  | Purpose           | Used By             |
  | -------- | --------- | ----------- | ----------------- | ------------------- |
  | TCP      | Inbound   | 10250       | Kubelet API       | Self, Control plane |
  | TCP      | Inbound   | 30000-32767 | NodePort Services | All                 |

- [ ] MetalLB Ports

  <https://metallb.universe.tf/#requirements>

  | Protocol | Direction | Port Range | Purpose | Used By                       |
  | -------- | --------- | ---------- | ------- | ----------------------------- |
  | TCP      | I/O       | 7946       | MetalLB | Control Plane, Worker node(s) |
  | UDP      | I/O       | 7946       | MetalLB | Control Plane, Worker node(s) |
  
## Installing runtime

<https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime>

## Installing kubeadm, kubelet and kubectl
