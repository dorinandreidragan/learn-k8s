# Introduction

## Tools

- Virtual Box
- Vagrant
- Ubuntu 20.04

## System Requirements

- 7 VMS (etcd, LB, worker nodes): 1 GB RAM, 5GB storage
- 3 VMS (master nodes): 2 GB RAM, 5 GB storage, 2 CPUs

10VMs (total of ~50 GB storage, 13 GB RAM, 2 CPUs/cores)

## Setup Process

```plantuml
@startuml

[HA Proxy LB] as HAProxy

package "Kubernetes Control Plane" as K8sControlPlane {
  [Master1] 
  [Master2]
  [Master3]

  [Master1] -[hidden]d-> [Master2]
  [Master2] -[hidden]d-> [Master3]
} 

HAProxy -[hidden]r-> [Master2]

package "etcd" {
  [Etcd1]
  [Etcd2]
  [Etcd3]

  [Etcd1] -[hidden]d-> [Etcd2]
  [Etcd2] -[hidden]d-> [Etcd3]
}

[Master3] --[hidden]d-> [Etcd1]

package "Kubernetes Workers" as K8sWorkers {
    [Worker1]
    [Worker2]
    [Worker3]

    [Worker1] -[hidden]d-> [Worker2]
    [Worker2] -[hidden]d-> [Worker3]
}

[Master2] --[hidden]r-> [Worker2]
@enduml 
```

### Step 1 - Create etcd cluster

Run `install-etcd.sh` on each node for etcd and give the ip of the corresponding etcd node as argument.

```bash
./install-etcd.sh {etcd#no-ip}
```
