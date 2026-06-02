Here is a clean, professional `README.md` for your **04-ansible-kvm-networking-ovs-2nics-2br-nobond** project.

You can copy/paste it directly into your repo:

---

```markdown
# Ansible KVM Networking: OVS (2 NICs, 2 Bridges, VLAN Support)

This project automates **Open vSwitch (OVS) networking configuration** for KVM hypervisor hosts using Ansible.

It provisions:
- 2 OVS bridges (management + storage)
- 2 physical NIC attachments
- VLAN trunking support
- Libvirt network integration
- Clean rollback/cleanup capability

---

## 📁 Project Structure

```

04-ansible-kvm-networking-ovs-2nics-2br-nobond
│
├── ansible.cfg
├── inventories
│   └── production
│       ├── hosts.yml
│       ├── group_vars
│       │   └── kvm_hosts.yml
│       └── host_vars
│           ├── vml-kvm01-rocky.yml
│           ├── vml-kvm02-rocky.yml
│           └── vml-kvm03-rocky.yml
│
├── playbooks
│   └── ovs-network.yml
│
├── roles
│   ├── ovs_packages
│   ├── ovs_cleanup
│   ├── ovs_br0
│   ├── ovs_br1
│   ├── ovs_vlans
│   ├── ovs_vlan_interfaces
│   ├── libvirt_add_br0_to_KVM
│   └── libvirt_add_br1_to_KVM
│
└── help

````

---

## ⚙️ Overview

This setup builds a **dual-network KVM host architecture**:

### Bridge Layout

| Bridge | Purpose      | NIC        | Notes |
|--------|-------------|------------|------|
| br0    | Management  | enp1s0/ens224 | Host management + libvirt |
| br1    | Storage / Data | enp8s0/ens256 | VLAN trunking |

---

## 🌐 VLAN Design

The system supports multiple VLAN networks over br1:

| VLAN Name | VLAN ID | Subnet        |
|----------|--------|---------------|
| vlan151  | 151    | 172.28.151.0  |
| vlan152  | 152    | 172.28.152.0  |
| vlan153  | 153    | 172.28.153.0  |
| vlan154  | 154    | 172.28.154.0  |

Each VLAN gets:
- OVS port
- OVS interface
- Dedicated IP assignment per node

---

## 📌 Inventory Structure

### Hosts

```yaml
all:
  children:
    kvm_hosts:
      hosts:
        vml-kvm01-rocky:
          ansible_host: 192.168.178.35
        vml-kvm02-rocky:
          ansible_host: 192.168.178.36
````

---

### Group Variables

Defined in:

```
inventories/production/group_vars/kvm_hosts.yml
```

Key variables:

```yaml
br0_name: br0
br0_interface: enp1s0
br0_prefix: 24
br0_gateway: 192.168.178.1

br1_name: br1
br1_interface: enp8s0

ovs_vlans:
  - name: vlan151
    id: 151
    subnet: 172.28.151
```

---

### Host Variables

Example:

```yaml
node_id: 35
br0_ip: 192.168.178.35
```

Used for:

* VLAN IP assignment
* Node-specific networking

---

## 🚀 Deployment

### 1. Ping hosts

```bash
ANSIBLE_CONFIG=ansible.cfg ansible all -i inventories/production/hosts.yml -m ping -u sysadmin
```

---

### 2. Syntax check

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook playbooks/ovs-network.yml --syntax-check
```

---

### 3. Dry run

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook playbooks/ovs-network.yml --check -u sysadmin --ask-become-pass
```

---

### 4. Apply configuration

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventories/production/hosts.yml playbooks/ovs-network.yml -u sysadmin --ask-become-pass
```

---

## 🧩 Roles Overview

### 🔹 ovs_packages

Installs:

* Open vSwitch
* NetworkManager OVS plugin

---

### 🔹 ovs_br0 / ovs_br1

Creates:

* OVS bridges
* Attaches physical NICs
* Configures IP addressing
* Applies MTU settings

---

### 🔹 ovs_vlans

Configures:

* VLAN trunking on br1
* VLAN IDs from inventory

---

### 🔹 ovs_vlan_interfaces

Creates:

* VLAN ports
* VLAN interfaces with IP assignment per node

---

### 🔹 libvirt_add_br0_to_KVM / libvirt_add_br1_to_KVM

Integrates OVS bridges into libvirt networking:

* Defines libvirt networks
* Starts and enables autostart
* Ensures VM connectivity

---

### 🔹 ovs_cleanup

Removes:

* OVS bridges
* VLAN interfaces
* NetworkManager connections
* Restores clean NIC state

---

## 🧠 Design Notes

* Uses **NetworkManager CLI (nmcli)** for OVS provisioning
* VLANs are dynamically generated from `ovs_vlans`
* Host-specific IPs derived from `node_id`
* Designed for **KVM hypervisor networking layers**
* Supports safe cleanup + re-deployment cycles

---

## ⚠️ Requirements

* Rocky Linux / RHEL 9
* NetworkManager enabled
* Open vSwitch support in kernel
* Ansible collections:

  * community.general
  * ansible.posix

Install collections:

```bash
ansible-galaxy collection install -r requirements.yml
```

---

## 🧯 Notes

* Ensure correct NIC names before deployment (`ens224`, `ens256`, etc.)
* Running OVS tasks may disrupt network connectivity
* Use console access when applying remotely
* Always test with `--check` first

---

## 📌 Author Notes

This project is part of a KVM automation stack focusing on:

* Hypervisor provisioning
* Networking abstraction
* VLAN-based multi-tenant lab design

```

---

If you want next step, I can also:
- :contentReference[oaicite:0]{index=0}
- or :contentReference[oaicite:1]{index=1}
- or :contentReference[oaicite:2]{index=2}
```

