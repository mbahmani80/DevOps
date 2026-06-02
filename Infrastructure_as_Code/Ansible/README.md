# Infrastructure as Code (IaC) - Ansible
This GitHub repository is closely aligned with my technical documentation website:
https://itstorage.net/index.php/devops/ansible

A collection of reusable Ansible playbooks, roles, and automation tasks designed for Linux infrastructure management, server lifecycle operations, virtualization, networking, and day-to-day system administration.

The goal of this repository is to build a modular Infrastructure as Code (IaC) framework that can be reused across home labs, enterprise environments, cloud deployments, and virtualization platforms.

---

## Repository Structure

```text
Infrastructure_as_Code/
└── Ansible/
    ├── 01-ansible-Linux-Initial-Settings
    ├── 02-ansible-Linux-Initial-Settings2
    ├── 03-ansible-kvm-deployment-rocky9x
    ├── 04-ansible-kvm-networking-ovs-2nics-2br-nobond
    ├── 05-ansible-kvm-networking-ovs-6nics-3br-bond-notok
    ├── 06-ansible-Multi-Distro-Linux-Update
    ├── 07-ansible-Force-Reboot-shutdown
    └── README.md

```

---

## Current Projects

### 01 - Linux Initial Settings

Initial Linux server provisioning and baseline configuration.

Features:

* Hostname configuration
* User creation
* SSH configuration
* Package installation
* Security hardening
* Basic system preparation

---

### 02 - Linux Initial Settings v2

Extended Linux deployment automation.

Features:

* Advanced server configuration
* Additional security controls
* Service configuration
* Environment standardization

---

### 03 - KVM Deployment Rocky Linux 9.x

Automated KVM hypervisor deployment on Rocky Linux.

Features:

* KVM installation
* Libvirt configuration
* Virtualization host preparation
* Network setup
* Hypervisor validation

---

### 04 - KVM Networking Open vSwitch

Open vSwitch networking automation for KVM environments.

Features:

* Open vSwitch deployment
* Dual NIC architecture
* Dual bridge design
* No bonding configuration
* VM networking preparation

---

### 05 - Multi-Distro Linux Update

Unified operating system update framework.

Supported distributions:

* Debian
* Ubuntu
* Rocky Linux
* AlmaLinux
* RHEL
* Oracle Linux
* SUSE/OpenSUSE

Features:

* Package updates
* Security updates
* Repository refresh
* Cross-platform support

---

### 06 - Force Reboot / Shutdown

Remote reboot and shutdown automation.

Features:

* Controlled reboot
* Emergency reboot
* Shutdown operations
* Validation checks

---

# Ansible Management Server Guide

## Overview

A dedicated Ansible Management Server (Control Node) provides a centralized platform for infrastructure automation and configuration management.

Benefits include:

* Centralized automation
* Consistent deployments
* Secure SSH management
* Isolated Python environments
* Version-controlled infrastructure code
* Reusable playbooks and roles

---

## Ansible Control Node Responsibilities

The management server is responsible for:

* Running playbooks
* Managing inventories
* Maintaining SSH keys
* Storing configuration files
* Hosting Python virtual environments
* Managing Ansible collections
* Centralizing automation workflows

Managed targets may include:

* Linux servers
* Virtual machines
* KVM infrastructure
* Network devices
* Cloud resources
* Storage platforms

---

# Preparing the Ansible Management Server

## Debian / Ubuntu Systems

### Update the Operating System

```bash
sudo apt update
sudo apt upgrade -y
```

### Install Required Packages

```bash
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    libffi-dev \
    libssl-dev \
    openssh-client \
    sshpass \
    jq \
    git
```

### Package Purpose

| Package      | Purpose                             |
| ------------ | ----------------------------------- |
| python3-venv | Create isolated Python environments |
| python3-pip  | Install Python packages             |
| libssl-dev   | Cryptographic module support        |
| sshpass      | Password-based SSH automation       |
| jq           | JSON processing                     |
| git          | Source control                      |

---

## Rocky Linux / RHEL Systems

### Optional: Enable EPEL

```bash
sudo dnf install -y epel-release
```

### Update the System

```bash
sudo dnf update -y
```

### Install Required Packages

```bash
sudo dnf install -y \
    python3 \
    python3-pip \
    libffi-devel \
    openssl-devel \
    openssh-clients \
    sshpass \
    jq \
    git
```

### Virtual Environment Support

```bash
sudo dnf install -y python3-virtualenv
```

Verify:

```bash
python3 -m venv --help
```

---

# Python Virtual Environment

## Why Use Virtual Environments?

Advantages:

* Multiple Ansible versions
* Dependency isolation
* Easier upgrades
* Cleaner rollback process
* No system Python conflicts

---

## Create Environment

```bash
python3 -m venv ~/ansible-env
```

Activate:

```bash
source ~/ansible-env/bin/activate
```

Example:

```bash
(ansible-env) user@mgmt:~$
```

---

## Upgrade pip

Immediately after creating the environment:

```bash
python3 -m pip install --upgrade pip
```

Verify:

```bash
pip --version
```

Benefits:

* Security updates
* Better dependency handling
* Faster package installations
* Improved compatibility

---

# Install Ansible

```bash
pip install ansible
```

Verify:

```bash
ansible --version
```

Expected:

```text
ansible [core 2.x]
python version = 3.x
```

---

# Automatic Environment Activation

Add to:

```bash
~/.bash_profile
```

```bash
source ~/ansible-env/bin/activate
export ANSIBLE_CONFIG=~/ansible-env/ansible.cfg
```

Reload:

```bash
source ~/.bash_profile
```

---

# Configure SSH Authentication

## Generate Ed25519 Key

```bash
ssh-keygen -t ed25519 -C "ansible-control-node"
```

Legacy RSA:

```bash
ssh-keygen -t rsa -b 4096
```

---

## Deploy SSH Key

```bash
ssh-copy-id root@192.168.56.103
```

Test:

```bash
ssh root@192.168.56.103
```

Passwordless login should work.

---

# Configure ansible.cfg

Example:

```ini
[defaults]
inventory = ./inventory/lab
host_key_checking = False
retry_files_enabled = False
forks = 10
timeout = 30
stdout_callback = yaml
interpreter_python = auto_silent

[ssh_connection]
pipelining = True
```

---

# Inventory Example

```ini
[linux]
server01 ansible_host=192.168.56.101
server02 ansible_host=192.168.56.102

[linux:vars]
ansible_user=ansible
```

Location:

```text
inventory/lab
```

---

# Connectivity Test

```bash
ansible all -m ping
```

Expected:

```json
{
  "ping": "pong"
}
```

---

# Ansible Collections

## Common Collections

```bash
ansible-galaxy collection install \
    community.general \
    ansible.posix \
    community.docker
```

### VMware

```bash
ansible-galaxy collection install community.vmware
```

### Cisco

```bash
ansible-galaxy collection install cisco.ios
```

### NetApp

```bash
ansible-galaxy collection install netapp.ontap
```

---

# requirements.yml Example

```yaml
collections:
  - name: community.general
  - name: ansible.posix
  - name: community.vmware
```

Install:

```bash
ansible-galaxy collection install -r requirements.yml
```

---

# Secure Secrets with Ansible Vault

Create encrypted variables:

```bash
ansible-vault create group_vars/all/vault.yml
```

Example:

```yaml
vault_vcenter_password: SuperSecretPassword
```

Edit:

```bash
ansible-vault edit group_vars/all/vault.yml
```

Run:

```bash
ansible-playbook site.yml --ask-vault-pass
```

Or:

```bash
ansible-playbook site.yml --vault-password-file ~/.vault_pass
```

---

# Recommended Tools

| Tool         | Purpose                      |
| ------------ | ---------------------------- |
| tmux         | Persistent terminal sessions |
| htop         | System monitoring            |
| yq           | YAML processing              |
| molecule     | Role testing                 |
| ansible-lint | Linting                      |
| pre-commit   | Git automation               |

Debian / Ubuntu:

```bash
sudo apt install -y tmux htop
```

Rocky / RHEL:

```bash
sudo dnf install -y tmux htop
```

---

# Troubleshooting

## Broken Virtual Environment

Recreate environment:

```bash
deactivate 2>/dev/null
rm -rf ~/ansible-env
python3 -m venv ~/ansible-env
source ~/ansible-env/bin/activate
```

Install dependencies:

```bash
pip install ansible
```

---

## Common Issues

### Inventory Empty

```text
provided hosts list is empty
```

Verify inventory structure.

### SSH Failed

```text
UNREACHABLE! => Failed to connect
```

Test manually:

```bash
ssh user@host
```

### Python Missing

```text
/usr/bin/python not found
```

Install Python on the target host.

### Role Not Found

```text
the role 'system_update' was not found
```

Verify:

```bash
roles/system_update/
```

### Debug Mode

Always troubleshoot using:

```bash
-vvvv
```

Example:

```bash
ansible-playbook \
-i inventories/dev/hosts.yml \
playbooks/update-all.yml \
-u sysadmin \
--ask-become-pass \
-vvvv
```

---

# Production Best Practices

* Use SSH keys only
* Disable password logins
* Store secrets in Vault
* Separate dev/test/prod inventories
* Use Git version control
* Maintain project-specific virtual environments
* Update collections regularly
* Follow role-based project structures
* Validate playbooks with ansible-lint

---

# Future Development

Planned repository improvements:

* Dedicated reusable roles
* Molecule testing framework
* CI/CD integration
* GitHub Actions validation
* Dynamic inventories
* Multi-environment deployment pipelines
* Infrastructure compliance automation

---

# Final Validation Checklist

* [ ] Python virtual environment active
* [ ] Ansible installed
* [ ] SSH authentication working
* [ ] Inventory configured
* [ ] ansible.cfg configured
* [ ] Collections installed
* [ ] Vault operational
* [ ] Connectivity test successful
* [ ] Git repository initialized

---

# Summary

This repository provides reusable Infrastructure as Code (IaC) automation built around Ansible for Linux administration, virtualization, networking, patch management, and server lifecycle operations.

The objective is to maintain a modular, scalable, and production-ready automation platform that can be used across home labs, enterprise datacenters, and cloud environments while following Infrastructure as Code best practices.

