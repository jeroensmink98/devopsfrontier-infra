# Hetzner

create a `test.tfvars` file and fill in your `hcloud_token`

run `./tf.sh` to initialize the terraform state from the `test` directory

## Ansible

run `ansible-playbook -i inventory.ini install_podman.yml` to install podman on the server

run command to check if podman is installed on the server

```
ansible -i inventory.ini debian_servers -a "podman --version"
```
