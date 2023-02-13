#!/usr/bin/env bash

# NOTE: Replace the password file path when runing this script
# This file contains the password of your vm which ansible-vault uses 
host_pass_file=.super_secret_key_for_node

# Ensure file is already encrypted before running the full script. I like to make sure the vm password file is encrypted before running the script. 
ansible-vault encrypt --vault-password-file ../.FILE_THAT_STORE_ANSIBLE_VAULT_PASSWORD  $host_pass_file 2>/dev/null
ansible-vault decrypt --vault-password-file ../.FILE_THAT_STORE_ANSIBLE_VAULT_PASSWORD $host_pass_file

# If secret is decrypted then run playbook
if [ $? -eq 0 ]
then
ansible-playbook playbook.yaml -i host_list  --vault-password-file ../.FILE_THAT_STORE_ANSIBLE_VAULT_PASSWORD --become-password-file $host_pass_file
    else
   echo 'could not decrypt the secret'
   fi

sleep 5s

# Encypt the secret again
if [ $? -eq 0 ]
then
    ansible-vault encrypt --vault-password-file ../.FILE_THAT_STORE_ANSIBLE_VAULT_PASSWORD  $host_pass_file
    else
   echo 'could not encrypt the secret'
   fi