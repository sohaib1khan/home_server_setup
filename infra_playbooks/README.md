# **Infra Maintenance**

This repository contains several Ansible playbooks designed for the maintenance and management of my homelab. Each playbook serves a unique function, ensuring the stability and operability of the systems.

```
├── cloudserver_backup
│   ├── ansible.cfg
│   ├── containerserver_backup
│   ├── host_list
│   ├── playbook.yaml
│   ├── run_playbook.sh
│   └── scripts
│       ├── bkup_containers_data
│       ├── nextcloud_data_ownership_change
│       └── steps
├── commonVMs
│   ├── ansible.cfg
│   ├── comm_upgrade
│   ├── host_list
│   └── playbook.yaml
├── container_server_logs
├── daily_backup_logs
├── devops_vm_fedora
│   ├── ansible.cfg
│   ├── host_list
│   ├── playbook.yaml
│   ├── run_playbook.sh
│   └── tasks
│       └── backup.yaml
├── LabVM
│   ├── ansible.cfg
│   ├── host_list
│   ├── playbook.yaml
│   ├── run_playbook.sh
│   └── tasks
│       └── backup.yaml
├── media_server
│   ├── ansible.cfg
│   ├── host_list
│   ├── playbook.yaml
│   └── run_playbook.sh
├── new_install_configs
│   ├── fedora_setup
│   │   ├── ansible.cfg
│   │   ├── host_list
│   │   ├── playbook.yaml
│   │   └── run.sh
│   ├── opensuse_server
│   │   ├── ansible.cfg
│   │   ├── host_list
│   │   ├── playbook.yaml
│   │   └── run.sh
│   └── Playbook2.1-Ubuntu-server-setup
│       ├── ansible.cfg
│       ├── host_list
│       ├── playbook.yaml
│       ├── run.sh
│       └── tasks
│           └── k9s_install.yaml
├── README.md
├── skwrkstn
│   ├── ansible.cfg
│   ├── host_list
│   ├── playbook.yaml
│   ├── run_playbook.sh
│   └── tasks
│       └── backup.yaml
└── stack_update
```

In addition to the main playbooks, this repository also contains template playbooks that can be quickly utilized for setting up various environments.

### **Playbook Descriptions:**

#### **1. CloudServer_backup**:

This playbook focuses on backing up cloud server data. The key components of this playbook are:

- `ansible.cfg`, `host_list`, `playbook.yaml`: These are the standard Ansible files parsed during the playbook's execution.
- `containerserver_backup`: A script leveraging `ansible-vault` for authentication to the target node and executing the playbook. It ensures sensitive information is encrypted after use.
- `scripts`: This directory contains various scripts for Ansible operations and post-installation tasks.

```
├── cloudserver_backup
│   ├── ansible.cfg
│   ├── containerserver_backup
│   ├── host_list
│   ├── playbook.yaml
│   ├── run_playbook.sh
│   └── scripts
│       ├── bkup_containers_data
│       ├── nextcloud_data_ownership_change
│       └── steps
```

### **2. commonVMs**:

Within my Proxmox hypervisor server, there's an option to create and manage LXCs (Linux Containers). I maintain several LXCs for testing and lab purposes. This playbook is tailored for their management.

Key components:

- **Standard Ansible Files**: `ansible.cfg`, `host_list`, and `playbook.yaml`. These are processed during the playbook's execution.
- **comm_upgrade**: A script that triggers the Ansible playbook execution.

```
├── commonVMs
│   ├── ansible.cfg
│   ├── comm_upgrade
│   ├── host_list
│   └── playbook.yaml
```

### **3. LabVM**:

This playbook adopts a similar concept to the aforementioned, with its core objective being system updates, maintenance, and backups.

```
├── LabVM
│   ├── ansible.cfg
│   ├── host_list
│   ├── playbook.yaml
│   ├── run_playbook.sh
│   └── tasks
│       └── backup.yaml
```

### **4. MediaServer**:

Dedicated to managing my Plex media server, this playbook ensures it undergoes regular updates for optimal performance.

```
── media_server
│   ├── ansible.cfg
│   ├── host_list
│   ├── playbook.yaml
│   └── run_playbook.sh
```

### **5. stack_update**:

This is a consolidated script, `stack_update`, which sequentially invokes each of the aforementioned playbooks to execute their specific actions. To automate the execution and capture the results/logs, I've integrated this script into a cronjob. The results are written into a dedicated log file, as illustrated:

```
59 23 * * *  /usr/bin/stack_update >> /Path/To/daily_backup_logs 2>&1
```

### **6. Cronjob Logs**:

To monitor the output of the scheduled cronjob tasks, refer to the logs available in:

- **container_server_logs**
- **daily_backup_logs**

These files capture all relevant details and provide insights into each execution.