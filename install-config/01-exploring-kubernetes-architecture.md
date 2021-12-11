# Exploring Kubernetes Architecture

## What Is Kubernetes

- Container Orchestrator
- Workload Placement
- Infrastructure Abstraction
- Desired State

## Benefits of Using Kubernetes

- Speed of deployment
- Ability to absorb change quickly
- Ability to recover quickly
- Hide complexity in the cluster

## Kubernetes Principles

- Desired State / Declarative Configuration
- Controllers / Control Loops
- Kubernetes API / The API Server

## Kubernetes API

### Kubernetes API Server

- RESTful API over HTTP using JSON
- The sole way to interact with your cluster

### Kubernetes API Objects

- Pods
- Controllers
- Services
- Storage

#### Pods

- One or more containers
- It's your application or service
- The most basic unit of work
- Unit of scheduling
- Ephemeral - no Pod is ever "redeployed"
- Atomicity - they're there or NOT
- Kubernetes' job is keeping your Pods running
- More specifically keeping the desired state
  - State - is the Pod up and running
  - Health - is the application in the Pod running
    - Probes

#### Controllers

- Defines your desired state
- Create and manage Pods for you
- Respond to Pod state and health

`ReplicaSet`

- Number of replicas

`Deployment`

- Manage rollout of ReplicaSets

#### Services

- Adds persistency to our ephemeral world
- Networking abstraction for Pod access
- IP and DNS name for the Service
- Dynamically updated based on Pod lifecycle
- Scaled by adding/removing Pods
- Load Balancing

#### Storage

- Volumes
- Persistent Volume
- Persistent Volume Claim

## Kubernetes Architecture

### Cluster Components

- Control Plane Node
- Node

#### Control Plane Node

- API Server
  - Central
  - Simple
  - RESTful
  - Updates etcd
- etcd
  - Persists State
  - API Objects
  - Key-value
- Scheduler
  - Watches API Server
  - Schedules Pods
  - Resources
  - Respects constraints
- Controller Manager
  - Controller Loops
  - Lifecycle functions and desired state
  - Watch and update the API Server
  - ReplicaSets

#### Nodes

- Kubelet
  - Monitors API Server for changes
  - Responsible for Pod Lifecycle
  - Reports Node & Pod state
  - Pod probes
- Kube-proxy
  - iptables
  - Implements Services
  - Routing traffic to Pods
  - Load Balancing
- Container Runtime
  - Downloads images & run containers
  - Container Runtime Interface (CRI)
  - containerd
  - Many others ...

`kubectl` - administrative command tool

#### Cluster Add-On Pods

- DNS
- Ingress
- Dashboard

## Kubernetes Networking Requirements

- Pods on a Node can communicate with all Pods on all Nodes without Network Address Translation (NAT)
- Agents on a Node can communicate with all Pods on that Node
