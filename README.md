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

To authenticate with GCP in github actions, you need to create a service account, download the JSON key file and save it in the github secrets (`GCP_CREDENTIALS_PROD`).

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

For now, we only have one environment, which is the prod environment. If you want to modify the infrastructure, you can do it in the `prod` folder and craeate a pull request. Once the pull request is merged, it will be automatically deployed to the prod environment.
