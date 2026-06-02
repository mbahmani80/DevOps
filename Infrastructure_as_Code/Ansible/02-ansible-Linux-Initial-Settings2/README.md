# 02 - Ansible Linux Initial Settings v2

Enterprise-style Linux server provisioning and standardization using Ansible.

This project is the second iteration of the Linux Initial Settings framework and represents a significant improvement over the original implementation. The objective is to create a reusable, scalable, and role-based automation platform capable of preparing Debian, Ubuntu, Rocky Linux, and other Enterprise Linux systems using Infrastructure as Code (IaC) principles.

Unlike the first project, this version introduces a cleaner enterprise repository structure, environment separation, reusable variables, Ansible collections, system hardening components, VM awareness, administrative user management, and standardized server deployment workflows.

---

# Project Goals

This project aims to:

* Standardize Linux deployments
* Automate initial server provisioning
* Support multiple Linux distributions
* Build reusable Ansible roles
* Apply Infrastructure as Code principles
* Create a scalable enterprise repository structure
* Reduce manual server configuration tasks

---

# Supported Operating Systems

## Enterprise Linux

* Rocky Linux 9
* Red Hat Enterprise Linux (RHEL)
* AlmaLinux
* Oracle Linux

## Debian Family

* Ubuntu
* Debian

---

# Key Improvements Over Project 01

Features added in Version 2:

* Enterprise repository structure
* Environment separation (dev/stage/prod)
* Ansible Galaxy collections support
* Administrative user deployment
* Firewalld automation
* SELinux management
* VM-aware guest tools installation
* Snap package deployment
* GUI workstation deployment
* Network recovery script generation
* Site playbook orchestration
* Reboot automation role

---

# Repository Structure

```text
02-ansible-Linux-Initial-Settings2/
├── ansible.cfg
├── README.md
├── requirements.yml
│
├── inventories
│   ├── dev
│   │   ├── hosts.yml
│   │   └── group_vars
│   │       └── all.yml
│   ├── stage
│   └── prod
│
├── playbooks
│   ├── site.yml
│   ├── redhat-rocky_init.yml
│   └── debian-ubuntu_init.yml
│
├── roles
│   ├── repositories
│   ├── base_packages
│   ├── hostname
│   ├── timezone
│   ├── ssh
│   ├── firewalld
│   ├── selinux
│   ├── networkmanager
│   ├── monitoring_tools
│   ├── admin_tools
│   ├── admin_user
│   ├── cockpit
│   ├── snap
│   ├── vm_guest_tools
│   ├── gui_workstation
│   └── force_reboot
│
└── files
```

---

# Ansible Collections

This project uses external collections.

requirements.yml

```yaml
collections:
  - community.general
  - ansible.posix
```

Install collections:

```bash
ansible-galaxy collection install -r requirements.yml
```

---

# Using Project-Specific Configuration

Each project contains its own Ansible configuration file.

Commands are executed using:

```bash
ANSIBLE_CONFIG=ansible.cfg
```

This ensures:

* Project isolation
* Consistent execution
* No dependency on global configuration
* Easy portability

---

# Connectivity Test

```bash
ANSIBLE_CONFIG=ansible.cfg ansible all \
-i inventories/dev/hosts.yml \
-m ping \
-u sysadmin
```

---

# Run Rocky Linux Deployment

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook \
-i inventories/dev/hosts.yml \
playbooks/redhat-rocky_init.yml \
-u sysadmin \
--ask-become-pass
```

---

# Run Debian / Ubuntu Deployment

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook \
-i inventories/dev/hosts.yml \
playbooks/debian-ubuntu_init.yml \
-u sysadmin \
--ask-become-pass
```

---

# Environment Structure

The project supports multiple deployment environments.

```text
inventories/
├── dev/
├── stage/
└── prod/
```

Current development inventory example:

```yaml
all:
  children:

    rocky_servers:
      hosts:
        rocky9x:
          ansible_host: 192.168.178.135

    debian_servers:
      hosts:
```

---

# Global Variables

Centralized variables are managed through:

```text
inventories/dev/group_vars/all.yml
```

Examples:

```yaml
admin_user: sysadmin
admin_shell: /bin/bash

timezone: Europe/Berlin

install_gui: false
```

---

# Implemented Roles

## repositories

Repository management framework.

Future location for:

* EPEL
* CRB
* Custom repositories
* Internal mirrors

---

## base_packages

Installs essential system packages.

Examples:

* dmidecode
* gpm

---

## hostname

Automatically configures hostnames using inventory values.

---

## timezone

Configures system timezone.

Example:

```yaml
timezone: Europe/Berlin
```

Uses:

```yaml
community.general.timezone
```

---

## ssh

Installs and enables SSH services.

Features:

* OpenSSH installation
* Automatic service enablement
* Cross-platform compatibility

---

## monitoring_tools

Installs monitoring utilities.

Examples:

* htop
* iotop
* iftop
* sysstat
* glances
* dstat

---

## admin_tools

Installs administration and troubleshooting utilities.

Examples:

* vim
* nano
* curl
* wget
* git
* screen
* tcpdump
* lvm2
* rsync

---

## admin_user

Creates and configures a privileged administrative account.

Features:

* User creation
* Home directory creation
* Shell assignment
* sudo configuration
* wheel group management
* su permissions

Supported Platforms:

* Debian/Ubuntu
* Rocky/RHEL

---

## cockpit

Installs and enables Cockpit Web Administration.

Packages:

* cockpit
* cockpit-storaged
* cockpit-networkmanager
* cockpit-packagekit

---

## firewalld

Automates firewall configuration.

Features:

* Firewalld installation
* Service enablement
* SSH access
* HTTP access
* HTTPS access
* Cockpit access

---

## selinux

SELinux management role.

Current implementation:

* Disable SELinux configuration
* Add kernel boot parameter
* Trigger reboot if required

Intended primarily for lab and learning environments.

---

## networkmanager

Creates network recovery scripts.

Features:

* Deploys host-specific recovery scripts
* Creates:

```text
/root/bin/net.sh
```

Useful for remote network recovery.

---

## vm_guest_tools

Virtualization-aware guest tools deployment.

Automatically detects:

### VMware

Installs:

```text
open-vm-tools
open-vm-tools-desktop
```

### KVM / QEMU

Installs:

```text
qemu-guest-agent
```

Automatically enables required services.

---

## snap

Snap package automation.

Features:

* GUI detection
* Snapd installation
* Snap initialization
* Application deployment

Example packages:

* Asbru Connection Manager
* SimpleScreenRecorder

---

## gui_workstation

Converts a server into a graphical workstation.

Features:

* GNOME Workstation installation
* Graphical target enablement
* Additional fonts
* GNOME Tweaks
* Extension management
* X11 configuration

Controlled through:

```yaml
install_gui: true
```

---

## force_reboot

Performs controlled reboots.

Example:

```yaml
- name: Force system reboot
  ansible.builtin.reboot:
```

Useful after:

* Kernel updates
* SELinux changes
* Major configuration modifications

---

# Site Playbook

Execute all supported operating system deployments through:

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook \
-i inventories/dev/hosts.yml \
playbooks/site.yml \
-u sysadmin \
--ask-become-pass
```

---

# Learning Outcomes

This project provided practical experience with:

* Enterprise Ansible structures
* Role development
* Variable management
* Inventory design
* Ansible Galaxy collections
* Linux administration automation
* User management
* Firewall management
* SELinux administration
* Virtualization integration
* Infrastructure as Code methodologies

---

# Future Improvements

Planned enhancements:

* Vault integration
* Dynamic inventories
* Molecule testing
* Role linting
* CI/CD validation
* Repository management automation
* Multi-distribution package mapping
* Logging and auditing
* Security hardening profiles
* Production deployment workflows

---

# Related Documentation

Additional Ansible and Infrastructure as Code documentation:

https://itstorage.net

DevOps Portal:

https://itstorage.net/index.php/devops

---

# Author
Mahdi Bahmani

ITStorage DevOps Lab

Linux • Automation • Virtualization • Infrastructure as Code • Ansible

