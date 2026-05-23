# 05-ansible-Multi-Distro-Linux-Update
Enterprise Ansible automation framework for updating multiple Linux distributions.

# More Information
For the full step-by-step article and detailed explanations, see:
https://itstorage.net/index.php/devops/ansible/811-ansible-article-12-multi-distro-linux-system-update-automation-with-ansible

Supported systems:

- Rocky Linux / RHEL / AlmaLinux
- Debian / Ubuntu
- OpenSUSE

---

# Features

- Multi-distro system updates
- Optional cache cleanup
- Automatic reboot detection
- Optional automatic reboot
- Hostname management
- Idempotent automation

---

# Final Enterprise Project Structure
05-ansible-Multi-Distro-Linux-Update
├── ansible.cfg
├── help
├── inventories
│   └── dev
│       ├── all_hosts.yml
│       ├── group_vars
│       │   └── all.yml
│       ├── hosts.yml
│       └── templates_hosts.yml
├── playbooks
│   └── update-all.yml
└── roles
    ├── cleanup_cache
    ├── reboot_system
    ├── set_hostname
    └── system_update

---

# Configure SSH Access
Generate SSH key:
ssh-keygen

Copy key to managed systems:
ssh-copy-id sysadmin@server-ip

Test SSH:
ssh sysadmin@server-ip

---

# ansible.cfg

[defaults]

inventory = inventories/dev/hosts.yml
roles_path = roles
host_key_checking = False
retry_files_enabled = False
stdout_callback = yaml
timeout = 30

---

# Test Connectivity
ANSIBLE_CONFIG=ansible.cfg ansible all -i inventories/dev/hosts.yml -m ping -u sysadmin

Expected:
server-name | SUCCESS

---

# Main Playbook

File:
playbooks/update-all.yml

---
- name: Multi-Distro System Update
  hosts: all
  become: true

  roles:
    - { role: cleanup_cache, when: enable_cache_cleanup }
    - system_update
    - { role: reboot_system, when: enable_reboot }
    - set_hostname

---

# Run Automation
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventories/dev/hosts.yml playbooks/update-all.yml -u sysadmin --ask-become-pass

---

# Run Against Specific Groups
Rocky Linux:
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventories/dev/hosts.yml playbooks/update-all.yml -u sysadmin --limit rocky_servers --ask-become-pass

Debian / Ubuntu:
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventories/dev/hosts.yml playbooks/update-all.yml -u sysadmin --limit debian_servers --ask-become-pass

OpenSUSE:
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventories/dev/hosts.yml playbooks/update-all.yml -u sysadmin --limit suse_servers --ask-become-pass

---

# Global Variables

File:
inventories/dev/group_vars/all.yml

---
admin_user: sysadmin
timezone: Europe/Berlin
update_retry: 2

report_updates: true

enable_cache_cleanup: false
enable_reboot: false

Enable automatic reboot:
enable_reboot: true

Enable cache cleanup:
enable_cache_cleanup: true

---

# Verify Updates
Debian / Ubuntu:
sudo apt list --upgradable

Rocky / RHEL:
sudo dnf check-update

OpenSUSE:
sudo zypper list-updates

---

# Test Idempotency

Run the playbook again:
ANSIBLE_CONFIG=ansible.cfg ansible-playbook -i inventories/dev/hosts.yml playbooks/update-all.yml -u sysadmin --ask-become-pass

Expected:
changed=0

