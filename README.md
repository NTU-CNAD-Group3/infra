# Infra

This repository contains the infrastructure code for the project. We use Terraform to manage the infrastructure on GCP.

If you want to deploy the infrastructure on your own, please create the gcs bucket for the terraform backend first. You can find the terraform backend configuration in the `provider.tf` file.

## Installation

[Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) on your local machine.

For windows users, you can download the Terraform by chocolatey. Run the following command in the terminal.

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

## Environment

For now, we only have one environment, which is `prod`. The `prod` environment is defined in the `prod` folder and the domain is in the `domain/prod` folder.

There are three things you need to care about when you are working on reproducing the infrastructure.

- We recommend not managing domain resources via Terraform, because its lifecycle is very hard to maintain.
- You should not use terraform to create the network endpoint groups for k8s, you should use k8s built in tools to manage the network endpoint groups. Because k8s can add or remove the endpoints automatically, but terraform cannot. So you need to use k8s to manage the network endpoint groups. Please see [terrafrom-neg](https://github.com/NTU-CNAD-Group3/infra/blob/93f0a0b02c80e544eaf8010793f3efab31ecdb29/modules/lb/main.tf#L30) and [k8s-neg](https://github.com/NTU-CNAD-Group3/k8s/blob/a79b1798c80457ed648795a92be64b2dc2dd5ea5/prod/gateway/service.yaml#L7)
- I use `google-secret-manager` to manage the secrets in the GCP rather than using `k8s-secret`. Because `k8s-secret` is not a good way to manage the secrets. The secrets are stored in the etcd and they are not encrypted. Make sure that you have created the corresponding secrets and service accounts in both gcp and k8s. You can find the demo in [terraform](https://github.com/NTU-CNAD-Group3/infra/blob/main/modules/secretmanager/main.tf), [k8s-sa](https://github.com/NTU-CNAD-Group3/k8s/blob/main/prod/gateway/service-account.yaml) and [k8s-secret-provider](https://github.com/NTU-CNAD-Group3/k8s/blob/main/prod/gateway/secret-provider.yaml).

The following is the module list of the project.

- `apis` : Enable all the apis for the project.
- `vpc` : Create the vpc and subnets for the project.
- `gcs` : Store the frontend code (React)
- `secretmanager` : Create the secret manager for the project.
- `gke` : Create the GKE cluster for the project. (backend)
- `loadbalancer` : Create the load balancer to navigate the traffic to the gcs (frontend) and gke (backend).
- `dns` : Create the dns for the domain.
