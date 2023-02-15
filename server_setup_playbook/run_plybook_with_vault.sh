#!/usr/bin/env bash

# Set the path to the password file
host_pass_file=.super_secret_key_for_node

# Decrypt the password file
ansible-vault decrypt --vault-password-file ../.FILE_THAT_STORE_ANSIBLE_VAULT_PASSWORD $host_pass_file

# If secret is decrypted then run playbook
if [ $? -eq 0 ]; then
    ansible-playbook playbook.yaml -i host_list --vault-password-file ../.FILE_THAT_STORE_ANSIBLE_VAULT_PASSWORD --extra-vars "ansible_become_pass=$(cat $host_pass_file)"
else
   echo 'Could not decrypt the secret'
   exit 1
fi

# Wait for 5 seconds before encrypting the password file
sleep 5s

# Encrypt the password file again
ansible-vault encrypt --vault-password-file ../.FILE_THAT_STORE_ANSIBLE_VAULT_PASSWORD $host_pass_file
