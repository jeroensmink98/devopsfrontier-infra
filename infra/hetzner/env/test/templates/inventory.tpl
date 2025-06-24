[debian_servers]
${server_name} ansible_host=${server_ip} ansible_user=root

# Alternative with hostname
# ${server_name} ansible_host=${server_hostname} ansible_user=root

[all:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args='-o StrictHostKeyChecking=no' 