# Infra

This repository contains the infrastructure code for the project. We use Terraform to manage the infrastructure on GCP.

If you want to deploy the infrastructure on you own, please create the gcs bucket for the terraform backend first. You can find the terraform backend configuration in the `provider.tf` file.

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

## Flow

This repo targets to deploy multiple environments, but for now, we only have one environment which is `prod`.

For the `apply` and `destroy` safety, we separate the alone `domain` resources in its own folder. If you want to deploy the domain resources, please trigger it manually under the `Actions` tab in the repo.

If you want to deploy or modify the infra, please craete the PR to the `main` branch, the linter and the terraform plan will be run in the PR. If everything is ok, you can merge the PR to the `main` branch. After that, github actions will run the terraform apply command to deploy the infra automatically.

Besides, we also provide the script to trigger the apply and destroy processes manually. You can find it under the `Actions` tab in the repo. 

We also use `secrets management` to handle sensitive information securely, but we do it manually.