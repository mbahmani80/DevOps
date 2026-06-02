# 01 - Ansible Linux Initial Settings
This GitHub repository is closely aligned with my technical documentation website:
https://itstorage.net/index.php/devops/ansible/740-ansible-enterprise

Ansible-based initial Linux server configuration and provisioning framework.

This project was created as an introductory Infrastructure as Code (IaC) and Ansible learning exercise. The goal was to build a reusable role-based automation structure for preparing newly deployed Linux servers using Ansible.

While some roles are fully implemented and production-ready, others were intentionally created as placeholders for future development and experimentation as part of the learning process.

---

## Project Objectives

This project demonstrates:

* Ansible inventory management
* Role-based playbook design
* Multi-distribution support
* Initial Linux server provisioning
* Package deployment automation
* Service management
* Host configuration standardization
* Infrastructure as Code principles

---

## Supported Operating Systems

### Enterprise Linux

* Rocky Linux 9
* Red Hat Enterprise Linux (RHEL)
* AlmaLinux
* Oracle Linux

### Debian Family

* Ubuntu
* Debian

---

## Repository Structure

```text
01-ansible-Linux-Initial-Settings/
├── ansible.cfg
├── help
├── inventories/
│   └── production/
│       ├── hosts.yml
│       └── group_vars/
│           └── all.yml
├── playbooks/
│   ├── redhat-rocky_init.yml
│   └── debian-ubuntu_init.yml
└── roles/
    ├── admin_tools/
    ├── base_packages/
    ├── cockpit/
    ├── firewalld/
    ├── gui_workstation/
    ├── hostname/
    ├── monitoring_tools/
    ├── networkmanager/
    ├── repositories/
    ├── selinux/
    ├── snap/
    ├── ssh/
    ├── timezone/
    └── vm_guest_tools/
```

---

## Implemented Roles

### repositories

Repository preparation and package source configuration.

Features:

* EPEL installation
* CRB repository enablement
* Repository cleanup
* APT cache update
* Repository backup

---

### hostname

Automatically configures the system hostname using the inventory hostname.

Example:

```yaml
- name: Set hostname
  hostname:
    name: "{{ inventory_hostname }}"
```

---

### timezone

Configures system timezone.

Example variable:

```yaml
timezone: Europe/Berlin
```

---

### ssh

Installs and enables SSH services.

Features:

* OpenSSH installation
* SSH daemon enablement
* Cross-platform service handling

Supported services:

* sshd (RHEL/Rocky)
* ssh (Ubuntu/Debian)

---

### monitoring_tools

Installs monitoring and diagnostic utilities.

Packages include:

* htop
* iotop
* iftop
* sysstat
* dstat
* glances
* lshw

---

### admin_tools

Installs common administration packages.

Examples:

* vim
* nano
* curl
* wget
* git
* screen
* zip
* unzip
* lsof

Additional categories:

* Security tools
* Networking utilities
* Storage administration tools

---

### cockpit

Installs and enables Cockpit Web Administration.

Features:

* Cockpit installation
* Socket activation
* Automatic startup

---

## Placeholder Roles

The following roles currently exist as framework placeholders and are intended for future implementation:

```text
base_packages
firewalld
networkmanager
selinux
snap
vm_guest_tools
gui_workstation
```

These roles were added to establish the desired project structure and will be expanded in future revisions.

---

## Inventory Example

```yaml
all:
  children:

    rocky_servers:
      hosts:
        rocky9x:

    debian_servers:
      hosts:
        vml-openstack-ubuntu.lab.local:
```

---

## Global Variables

Example:

```yaml
timezone: Europe/Berlin

install_gui: false
```

Package groups are centrally managed through:

```yaml
monitoring_packages:
admin_packages:
security_network_packages:
storage_tools_packages:
```

This allows easy customization across all managed systems.

---

## SSH Preparation

Deploy SSH key to managed hosts:

```bash
ssh-copy-id \
-i ~/.ssh/id_rsa.pub \
sysadmin@server
```

Verify:

```bash
ssh sysadmin@server
```

---

## Configuration

Current Ansible configuration:

```ini
[defaults]
inventory = inventories/production/hosts.yml
roles_path = roles
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
```

---

## Connectivity Testing

Verify communication before deployment:

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

## Playbooks

### Rocky Linux / Enterprise Linux

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventories/production/hosts.yml playbooks/redhat-rocky_init.yml -u sysadmin --ask-become-pass

ansible-playbook \
-i inventories/production/hosts.yml \
playbooks/redhat-rocky_init.yml \
-u sysadmin \
--ask-become-pass

```

---

### Debian / Ubuntu

```bash
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventories/production/hosts.yml playbooks/debian-ubuntu_init.yml -u sysadmin --ask-become-pass
ansible-playbook \
-i inventories/production/hosts.yml \
playbooks/debian-ubuntu_init.yml \
-u sysadmin \
--ask-become-pass
```

---

## Learning Outcomes

This project was created to gain hands-on experience with:

* Ansible inventories
* Playbooks
* Roles
* Variables
* Privilege escalation
* Multi-distribution automation
* Linux server provisioning
* Infrastructure as Code workflows

It serves as the foundation for more advanced Ansible projects contained within this repository.

---

## Future Improvements

Planned enhancements include:

* Firewalld automation
* SELinux configuration
* VM guest integration tools
* GUI workstation deployment
* NetworkManager automation
* Security hardening
* User management
* NTP configuration
* Logging standardization
* Ansible Vault integration
* Role documentation

---

## Related Documentation

Additional Ansible articles and Infrastructure as Code documentation can be found at:

https://itstorage.net

DevOps Portal:

https://itstorage.net/index.php/devops/ansible

---

## Author
Mahdi Bahmani

ITStorage DevOps Lab

Linux • Virtualization • Automation • Infrastructure as Code

