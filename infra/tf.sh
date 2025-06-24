#!/bin/bash

path=$(pwd)

# Only run terraform init if .terraform directory doesn't exist or if it's empty
if [ ! -d ".terraform" ] || [ -z "$(ls -A .terraform)" ]; then
    terraform init
fi

terraform validate

terraform plan -var-file="main.tfvars" -out="plan.tfplan"

if [ "$1" = "apply" ]; then
    terraform apply "plan${now}.tfplan"
fi
