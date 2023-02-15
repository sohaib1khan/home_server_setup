This guide will demonstrate my personal home lab setup and my ongoing efforts to improve it. I like to experiment with new technologies and incorporate them into my infrastructure whenever possible. Currently, I am utilizing containers (docker/podman) to host my favorite applications.

## Server Configuration:

I have a dedicated PC running Proxmox operating system. This setup provides enough resources for me to host multiple virtual machines without encountering resource constraints. One of the virtual machines, named "cloudserver," is specifically dedicated to host applications using docker and podman (primarily docker, with plans to fully migrate to podman in the future). I have had no issues with either platform, and I recommend installing Proxmox on a desktop or laptop, and then creating a VM with sufficient resources. In the near future, I plan to add an additional step for provisioning VMs on Proxmox using Terraform. At the time of writing this guide, I created the VM through the Proxmox GUI.

## Setting up the Virtual Machine:

Once the VM is set up on the Proxmox server, obtain its IP address. Then, log into your router and open ports 80, 443, and 51820. These ports will be used to host Wireguard (port 51820) and webapps (ports 443/80). I have created Ansible playbooks (found at [https://github.com/sohaib1khan/Ansible\_To\_Go/tree/master/Playbook2-Update-install-apps](https://github.com/sohaib1khan/Ansible_To_Go/tree/master/Playbook2-Update-install-apps)) to install applications such as docker, Kubernetes, and Helm, which can serve as inspiration or be modified to your specific needs.

## Installing Applications:

I created a folder for each application that I installed using docker. For example, I am currently hosting Bitwarden, Joplin server, Nextcloud, Portainer, Wireguard, Duplicati, and Nginx proxy manager. I use Portainer to deploy the applications using docker-compose files. I customize the docker-compose file in VScode for each application (e.g. Nextcloud, Bitwarden), upload it to Portainer, and then deploy the stack. Once the application is deployed, I verify its functionality by logging in to the application using the local IP address specified in its installation documentation. For example, if Nextcloud is installed on port 8080, I would verify its functionality by visiting `192.168.1.100:8080` in my browser. Finally, I use Nginx proxy manager to expose the application and add SSL for extra security. I repeat this process for all desired applications.

## Maintenance and Backups:

I use Ansible playbooks and bash scripts to automate maintenance tasks. For example, I have created three playbooks to update and backup three separate virtual machines. The playbooks include the following tasks:

1.  Stopping the containers before making a backup and then restarting them once the backup is completed.
2.  Backing up the docker containers and mounted volumes with the current date to `/home/cloudserver/backup`.
3.  Deleting existing backups from the remote server and copying the current backup to the remote server `remote_machine@192.168.1.00:/remote/path/for/clouderserver` using rsync.
4.  Copying the backup from `/home/cloudserver/backup` to the remote server `remote_machine@192.168.1.00:/remote/path/for/clouderserver`.
5.  Copying all directories from `/home/cloudserver

To run playbook for each VM, i created a small bash script that uses ansible-vault to take care of any root/sudo tasks without any user interaction. Once i have created playbook for each VM and a script that runs those VMs, Then i create another 'master' script that calls each of the VM's playbook script into 1 script. I use that master in a cronjob so that ways all playbooks gets run from a one script.

Diagram of my setup:
![homelab-setup](https://github.com/sohaib1khan/home_server_setup/blob/main/imgs/home_lab.png)
