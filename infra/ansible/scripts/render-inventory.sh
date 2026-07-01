#!/usr/bin/env bash
set -euo pipefail

terraform_dir="../terraform/environments/dev"
output_file="inventory.yml"

/mnt/c/ProgramData/chocolatey/bin/terraform.exe -chdir="$terraform_dir" output -raw ansible_inventory > "$output_file"
ansible-inventory -i "$output_file" --graph
