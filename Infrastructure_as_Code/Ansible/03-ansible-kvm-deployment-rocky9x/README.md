# 03 - Ansible KVM Deployment Rocky Linux 9

Automated deployment and configuration of Rocky Linux KVM hypervisors using Ansible.

This project provisions and standardizes Rocky Linux 9 KVM hosts for virtualization environments. It prepares physical servers for enterprise virtualization workloads by configuring KVM, libvirt, Open vSwitch, IOMMU, nested virtualization, TPM support, bridge networking access, and host-level kernel tuning.

The goal is to provide a repeatable Infrastructure as Code (IaC) framework for deploying virtualization hosts that can later be used for:

* KVM virtual machines
* Open vSwitch networking
* Nested virtualization labs
* Kubernetes and container platforms
* Infrastructure testing environments
* Private cloud deployments

---

# Project Objectives

This project automates:

* Rocky Linux KVM host deployment
* Hypervisor package installation
* Open vSwitch installation
* Nested virtualization configuration
* IOMMU enablement
* TPM support
* Hostname and DNS configuration
* Kernel tuning
* Libvirt configuration
* Administrative access configuration

---

# Supported Platform

## Operating System

* Rocky Linux 9.x

## Hypervisor Stack

* KVM
* QEMU
* Libvirt
* Open vSwitch
* SWTPM
* OVMF / UEFI

---

# Repository Structure

```text
03-ansible-kvm-deployment-rocky9x/
├── ansible.cfg
├── README.md
│
├── inventories
│   └── production
│       ├── hosts.yml
│       └── group_vars
│           └── kvm_hosts.yml
│
├── playbooks
│   └── kvm-host.yml
│
└── roles
    ├── common_packages
    ├── hostname
    ├── selinux
    ├── kvm_install
    ├── sysctl
    ├── iommu
    ├── nested_kvm
    ├── kvm_user
    └── libvirt_qemu_bridge_access
```

---

# Inventory Configuration

Edit:

```text
inventories/production/hosts.yml
```

Example:

```yaml
all:
  children:

    kvm_hosts:
      hosts:
        vml-kvm01-rocky:
          ansible_host: 192.168.178.35

        vml-kvm02-rocky:
          ansible_host: 192.168.178.36
```

---

# Group Variables

Edit:

```text
inventories/production/group_vars/kvm_hosts.yml
```

Example:

```yaml
kvm_admin_user: sysadmin

cpu_vendor: intel

hostname_domain: lab.local

enable_nested_kvm: true

ip_forward: 1
rp_filter: 2

use_tpm: true
```

---

# Project-Specific Ansible Configuration

This repository uses a dedicated Ansible configuration file.

```bash
ANSIBLE_CONFIG=ansible.cfg
```

Advantages:

* Project isolation
* Predictable execution
* Portable deployments
* No dependency on global Ansible configuration

---

# Verify Connectivity

```bash
ANSIBLE_CONFIG=ansible.cfg ansible all \
-i inventories/production/hosts.yml \
-m ping \
-u sysadmin
```

Expected result:

```text
SUCCESS => {
    "ping": "pong"
}
```

---

# Syntax Validation

Before deployment:

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook \
playbooks/kvm-host.yml \
--syntax-check
```

---

# Dry Run

Preview all changes:

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook \
playbooks/kvm-host.yml \
--check \
-u sysadmin \
--ask-become-pass
```

---

# Deploy KVM Hosts

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook \
-i inventories/production/hosts.yml \
playbooks/kvm-host.yml \
-u sysadmin \
--ask-become-pass
```

---

# Deployment Workflow

The deployment playbook executes the following roles:

```yaml
roles:

  - common_packages
  - hostname
  - selinux
  - kvm_install
  - sysctl
  - iommu
  - nested_kvm
  - kvm_user
  - libvirt_qemu_bridge_access
```

---

# Implemented Roles

## common_packages

Installs commonly required utilities.

### Security Tools

* fail2ban
* sshguard
* openssl
* tcpdump

### Storage Tools

* lvm2
* xfsprogs
* rsync
* parted
* nfs-utils

### Administration Tools

* vim
* nano
* curl
* wget
* screen
* zip
* unzip

### Monitoring Tools

* htop
* iftop
* iotop
* glances
* sysstat
* dstat

---

## hostname

Configures:

* Fully qualified hostname
* Local host resolution

Example:

```text
vml-kvm01-rocky.lab.local
```

Also populates:

```text
/etc/hosts
```

using entries defined in:

```yaml
hosts_entries:
```

---

## selinux

Disables SELinux for virtualization lab environments.

Current configuration:

```yaml
state: disabled
```

Note:

Production environments should evaluate whether SELinux should remain enabled.

---

## kvm_install

Installs the complete virtualization stack.

### Open vSwitch

Installs:

```text
openvswitch
NetworkManager-ovs
```

### KVM Components

Installs:

```text
qemu-kvm
libvirt
virt-install
libguestfs-tools
virt-top
virt-viewer
```

### TPM Support

Optional installation:

```yaml
use_tpm: true
```

Packages:

```text
edk2-ovmf
swtpm
swtpm-tools
```

### Services

Automatically enables:

```text
libvirtd
```

---

# Virtual TPM Support

When enabled:

```yaml
use_tpm: true
```

The deployment installs:

* Software TPM
* UEFI firmware
* Secure Boot capable virtual machine support

Useful for:

* Windows 11 VMs
* Secure Boot testing
* Modern guest operating systems

---

## sysctl

Applies virtualization-related kernel tuning.

### IP Forwarding

```yaml
ip_forward: 1
```

Enables:

```text
net.ipv4.ip_forward
```

### Reverse Path Filtering

```yaml
rp_filter: 2
```

Useful for:

* Multi-homed hosts
* Open vSwitch deployments
* Virtual routing scenarios

---

## iommu

Enables hardware-assisted I/O virtualization.

Example:

```yaml
cpu_vendor: intel
```

Kernel parameters:

```text
intel_iommu=on iommu=pt
```

AMD systems:

```yaml
cpu_vendor: amd
```

Result:

```text
amd_iommu=on iommu=pt
```

Benefits:

* PCI passthrough
* SR-IOV
* VFIO
* GPU passthrough

---

## nested_kvm

Enables nested virtualization.

Example:

```yaml
enable_nested_kvm: true
```

Configuration:

```text
/etc/modprobe.d/kvm.conf
```

Example:

```text
options kvm_intel nested=1
```

Benefits:

* Run KVM inside virtual machines
* Kubernetes labs
* Hypervisor testing
* Nested OpenShift environments

---

## kvm_user

Grants virtualization permissions to the administrative account.

Configured groups:

```text
kvm
libvirt
```

Example:

```yaml
kvm_admin_user: sysadmin
```

---

## libvirt_qemu_bridge_access

Allows virtual machines to use Linux bridges and Open vSwitch bridges.

Creates:

```text
/etc/qemu-kvm/bridge.conf
```

Configuration:

```text
allow all
```

Automatically restarts:

```text
libvirtd
```

This role is essential for advanced networking scenarios.

---

# Host Networking Design

This project prepares the host for:

* Linux bridges
* Open vSwitch bridges
* VLAN trunking
* Virtual machine networking
* Multi-network environments

Bridge creation itself is handled by later networking projects.

---

# Typical Use Cases

This project is intended for:

* Home labs
* Enterprise labs
* KVM clusters
* Virtualization hosts
* Kubernetes infrastructure
* OpenShift testing
* Infrastructure training
* Private cloud deployments

---

# Learning Outcomes

This project provides hands-on experience with:

* Rocky Linux virtualization
* KVM administration
* Libvirt management
* Open vSwitch deployment
* TPM virtualization
* IOMMU configuration
* PCI passthrough preparation
* Nested virtualization
* Linux kernel tuning
* Infrastructure as Code

---

# Future Enhancements

Planned improvements:

* Firewalld integration
* Cockpit virtualization module
* Libvirt storage pools
* VM templates
* Cloud-init support
* Open vSwitch bridge automation
* SR-IOV automation
* GPU passthrough validation
* Cluster deployment support

---

# Related Documentation

Additional DevOps, Virtualization, and Infrastructure as Code articles:

https://itstorage.net

DevOps Portal:

https://itstorage.net/index.php/devops

---

# Author

Mahdi Bahmani

ITStorage DevOps Lab

Virtualization • KVM • Libvirt • Open vSwitch • Infrastructure as Code • Rocky Linux

