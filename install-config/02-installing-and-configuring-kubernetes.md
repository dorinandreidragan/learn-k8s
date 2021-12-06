# Installing and Configuring Kubernetes

## Installation Considerations

Where to install?

- Cloud
  - IaaS - Virtual Machines
  - PaaS - Managed Service
- On-Premises
  - Bare Metal
  - Virtual Machines

Which one should you choose?

Cluster Networking

Scalability

High Availability

Disaster Recovery

## Installation Overview

### Installation Methods

- Desktop
- kubeadm
- Cloud Scenarios

### Installation Requirements

System Requirements

- Linux - Ubuntu/RHEL
- 2 CPUs
- 2GB RAM
- Swap Disabled

Container Runtime

- Container Runtime Interface (CRI)
- containerd
- Docker (Deprecated 1.20)
- CRI-O

Networking

- Connectivity between all Nodes
- Unique hostname
- Unique MAC Address

Cluster Network Ports

![Kubernetes Architecture](../resources/install-config/kubernetes-architecture.png)

- Control Plane Node Ports

  | Component          | Ports (tcp) | Used By       |
  | ------------------ | ----------- | ------------- |
  | API                | 6443        | All           |
  | etcd               | 2379-2380   | API/etcd      |
  | Scheduler          | 10251       | Self          |
  | Controller Manager | 10252       | Self          |
  | Kubelet            | 10250       | Control Plane |

- Node Ports

  | Component | Ports (tcp) | Used By       |
  | --------- | ----------- | ------------- |
  | Kubelet   | 10250       | Control Plane |
  | NodePort  | 30000-32767 | All           |

## Getting Kubernetes

- https://github.com/kubernetes/kubernetes
- Linux distribution

## Installing a Cluster with kubeadm

- Install and Configure Packages
- Create Your Cluster
- Configure Pod Networking
- Join Nodes to Your Cluster

Required Packages

- containerd
- kubelet
- kubeadm
- kubectl

> Note: Install on all Nodes in your cluster

### Installing Kubernetes on Ubuntu VMs

#### Lab Environment

#### Bootstrapping a Cluster with kubeadm

- `kubeadm init`
- Pre-flight checks
- Creates a Certificate Authority
- Generates kubeconfig files
- Generates Static Pod Manifests
- Wait for the Control Plane Pods to Start
- Taints the Control Plane Node
- Generates Bootstrap Token
- Starts Add-On components: DNS and kube-proxy

#### Understanding the Certificate Authority's Role in Your Cluster

Certificate Authority

- Self signed Certificate Authority (CA)
- Can be part of an external PKI
- Securing cluster communications
  - API Server
- Authentication of users and cluster components
  `/etc/kubernetes/pki`
- Distributed to each Node

https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init

#### kubeadm Created kubeconfig Files

Used to define how to connect to your Cluster

- Client certificates
- Cluster API Server network location

```bash
/etc/kubernets
  admin.conf (kubernetes-admin)
  kubelet.conf
  controller-manager.conf
  scheduler.conf
```

#### Static Pod Manifests

Manifest describe a configuration

`/etc/kubernetes/manifests`

- etcd
- API Server
- Controller Manager
- Scheduler

Watched by the kubelet started automatically when the system starts and over time

#### Pod Networking Fundamentals

Overlay networking

- Flannel - Layer 3 virtual network
- Calico - L3 and policy based traffic management
- Weave Net - multi-host network

https://kubernetes.io/docs/concepts/cluster-administration/networking/

#### Creating a Cluster Control Plane Node

```bash
wget https://docs.projectcalico.org/manifests/calico.yaml

kubeadm config print init-defaults | tee ClusterConfiguration.yaml

sudo kubeadm init \
  -- config=ClusterConfiguration.yaml \
  -- cri-socket /run/containerd/containerd.sock \

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f calico.yaml
```

#### Adding a Node to a Cluster

- Install Packages
- `kubeadm join`
- Download Cluster Information
- Node submits a CSR
- CA Signs the CSR automatically
- Configures `kubelet.conf`

```bash
# use control plane ip
kubeadm join 192.168.1.10 \
  --token {k8s-token} \
  --discovery-token-ca-cert-hash \
  sha256:{hash}
```
