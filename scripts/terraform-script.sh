#!/bin/bash

# Check if Terraform command is available
if command -v terraform >/dev/null 2>&1; then
    echo "Terraform is installed."
    terraform version
else
    echo "Terraform is not installed."
fi
