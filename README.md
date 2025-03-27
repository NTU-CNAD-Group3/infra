# Infra

This repository contains the infrastructure code for the project. We use Terraform to manage the infrastructure on GCP.

## Installation

[Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) on your local machine.

For windows users, you can download the Terrafrom by chocolatey. Run the following command in the terminal.

```bash
choco install terraform
```

For Mac users, you can download the Terraform by brew. Run the following command in the terminal.

```bash
brew install terraform
```

Then, you need to authenticate with GCP. You need to install the Google Cloud SDK. You can download the SDK from [here](https://cloud.google.com/sdk/docs/install).

After installing the SDK, you need to authenticate with GCP. Run the following command in the terminal.

```bash
gcloud auth application-default login
```

## Usage

Here are some useful Terraform commands :

```bash
terraform init      # Initialize the Terraform and download the provider plugins
terraform fmt       # Format the Terraform configuration
terraform validate  # Validate the Terraform configuration
terraform plan      # Plan the infrastructure changes
terraform apply     # Apply the infrastructure changes
terraform destroy   # Destroy the infrastructure
```

If you are first time running the Terraform, you need to set the variables and backend configuration. You can set the variables in the `terraform.tfvars` file and apply the backend configuration in the `backend.tf` file.

```bash
cd applications
cp terraform.tfvars.example terraform.tfvars
```

```bash
terraform init
terraform apply -target=google_storage_bucket.terraform_state

# modify the backend configuration
terraform init -migrate-state # reinitialize the Terraform with the new backend configuration
```

## Architecture

The components of the infrastructure are as follows:

1. Cloud DNS
2. Google Kubernetes Engine (GKE)
