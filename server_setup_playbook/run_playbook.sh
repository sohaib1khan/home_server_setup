#!/usr/bin/env bash

# Specify the path to the playbook file
PLAYBOOK_FILE="playbook.yaml"

# Specify the path to the inventory file
INVENTORY_FILE="host_list"

# Run the playbook with inventory and sudo password prompt
ansible-playbook "$PLAYBOOK_FILE" -i "$INVENTORY_FILE" --ask-become-pass
