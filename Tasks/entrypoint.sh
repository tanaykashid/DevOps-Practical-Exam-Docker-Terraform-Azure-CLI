#!/bin/bash
set -e

# Function: login to Azure CLI using Service Principal
function azure_login() {
  if [[ -n "$AZURE_CLIENT_ID" && -n "$AZURE_CLIENT_SECRET" && -n "$AZURE_TENANT_ID" ]]; then
    echo "Logging in to Azure with Service Principal..."
    az login --service-principal \
      --username "$AZURE_CLIENT_ID" \
      --password "$AZURE_CLIENT_SECRET" \
      --tenant "$AZURE_TENANT_ID" > /dev/null
    echo "Azure login successful."
  else
    echo "Azure Service Principal credentials missing. Please set AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, and AZURE_TENANT_ID."
    echo "Attempting az login interactively..."
    az login
  fi
}

# Login to Azure first
azure_login

# If first argument is "destroy", run terraform destroy if .tf files found
if [[ "$1" == "destroy" ]]; then
  if ls *.tf 1> /dev/null 2>&1; then
    echo "Terraform destroy in progress..."
    terraform init
    terraform destroy -auto-approve
  else
    echo "No .tf files found in /workspace to destroy."
  fi
  exit 0
fi

# If terraform files present, run init & apply, else start bash
if ls *.tf 1> /dev/null 2>&1; then
  echo "Terraform files detected. Running terraform init and apply..."
  terraform init
  terraform apply -auto-approve
  exec "$@"
else
  echo "No terraform files found. Starting bash shell."
  exec "$@"
fi
