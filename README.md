# Hashistack on AWS

Deploy the HashiStack onto Amazon Web Services.  This repo creates a Kubernetes based runtime with Amazon EKS using Terraform, connects and manages services via HashiCorp Consul, enables centralized secrets management with HashiCorp Vault, scalable access control with HashiCorp Boundary, and one-click new applications with HashiCorp Waypoint.

## Setup

Deploying this stack requires the following both an [AWS Account](https://aws.amazon.com/) and a [HashiCorp Cloud Platform Account](https://portal.cloud.hashicorp.com/sign-up).  You must create both of these first before proceeding.

### HCP Prerequisites

1. Read instructions and Documentation on [creating an HCP Account](https://developer.hashicorp.com/hcp/docs/hcp).
2. Create an [HCP Organization](https://developer.hashicorp.com/hcp/docs/hcp/admin/orgs)
3. Create an [HCP Project](https://developer.hashicorp.com/hcp/docs/hcp/admin/projects)
4. Create an [HCP Service Principal for the aforementioned Project](https://developer.hashicorp.com/hcp/docs/hcp/admin/iam/service-principals)
5. Generate [Keys for the previous Service Principal](https://developer.hashicorp.com/hcp/docs/hcp/admin/iam/service-principals#generate-a-service-principal-key)

The organization is required to create any resources with HCP.  The project encapsulates all HashiCorp Cloud Platform tools that this project uses.  The Service Principle is the credentials that HCP Terraform will use to create and manage resources within HCP.  By the end of this you should have 3 things:

1. The Client ID of your Service Principal
2. The Client Secret of your Service Principal
3. The Project ID of your HCP Project

### HCP Terraform Prerequisites (Part 1)

1. Read instruction and setup for [HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs)
2. Follow this tutorial to setup [an HCP Terraform Account and Organization](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-sign-up)
3. Follow this tutorial to create a [Variable Set](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-create-variable-set) for your Client ID, Secret, and Project ID from HCP (previous section).
4. Create a [Project](https://developer.hashicorp.com/terraform/tutorials/cloud/projects) in HCP Terraform.  This will hold all of our terraform workspaces.
5. Apply the Variable Set from step #3 to the project created in step #4.  [See this tutorial for help](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-multiple-variable-sets#create-a-credentials-variable-set)
  - this will make it so all new workspaces created in this project will be able to interact with other HCP services
6. Create 4 Version Control Workflow Workspaces from this one repo, each mapping to one of the 4 different directories (`infrastructure`, `packages`, `services`, `dns`).  For each workspace, select this repo (assuming you've forked or cloned it).  [How to create Workspaces in the HCP Terraform UI](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/creating#create-a-workspace).  In the creation process make the following changes to the workspace settings:
  - change the workspace name to `hashistack-<name_of_directory>`, i.e. `hashistack-infrastructure`
  - under "Workspace Settings" -> "Terraform Working Directory" input the correct directory i.e. `infrastructure`
  - under "VCS Triggers" select "Only trigger runs when files in specified paths change" and add two patterns:
    - `/modules/**/*`
    - `/<name_of_directory>/*` (i.e. `/infrastructure/*`)
  - click Create
7. Leave the variables alone for now, and do not trigger any runs on the workspace

This step connects HCP Terraform to our Hashistack git repo, but enables us to treat each of our 4 directories (`infrastructure`, `packages`, `services`, and `dns`) as separate execution environments.  This means that changes in one will not trigger `terraform` runs in the others.

### AWS Prerequisites

1. Install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. Create an [IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) for yourself. This will be used to assume the role in the next step.
3. Create an [IAM Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html).  This will be used by HCP Terraform to provision infrastructure and by your user to interact with your EKS cluster via `kubectl`.
4. Follow these instructions on creating [Dynamic Credentials with the AWS Provider](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration).  This amounts to [configuring OIDC with HCP Terraform](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html) and attaching a trust policy to the IAM role created in #3.
    <details>
    <summary>An example trust policy would look like:</summary>
        ```json
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Federated": "arn:aws:iam::<aws_account_id>:oidc-provider/app.terraform.io"
                    },
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Condition": {
                        "StringEquals": {
                            "app.terraform.io:aud": "aws.workload.identity"
                        },
                        "StringLike": {
                            "app.terraform.io:sub": "organization:<your_hcp_terraform_org_name>:project:<your_hcp_tf_project_name>:workspace:hashistack-infrastructure:run_phase:*"
                        }
                    }
                },
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Federated": "arn:aws:iam::<aws_account_id>:oidc-provider/app.terraform.io"
                    },
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Condition": {
                        "StringEquals": {
                            "app.terraform.io:aud": "aws.workload.identity"
                        },
                        "StringLike": {
                            "app.terraform.io:sub": "organization:<your_hcp_terraform_org_name>:project:<your_hcp_tf_project_name>:workspace:hashistack-packages:run_phase:*"
                        }
                    }
                },
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Federated": "arn:aws:iam::<aws_account_id>:oidc-provider/app.terraform.io"
                    },
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Condition": {
                        "StringEquals": {
                            "app.terraform.io:aud": "aws.workload.identity"
                        },
                        "StringLike": {
                            "app.terraform.io:sub": "organization:<your_hcp_terraform_org_name>:project:<your_hcp_tf_project_name>:workspace:hashistack-services:run_phase:*"
                        }
                    }
                },
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Federated": "arn:aws:iam::<aws_account_id>:oidc-provider/app.terraform.io"
                    },
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Condition": {
                        "StringEquals": {
                            "app.terraform.io:aud": "aws.workload.identity"
                        },
                        "StringLike": {
                            "app.terraform.io:sub": "organization:<your_hcp_terraform_org_name>:project:<your_hcp_tf_project_name>:workspace:hashistack-dns:run_phase:*"
                        }
                    }
                },
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "arn:aws:iam::<aws_account_id>:user/<your_aws_user>"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
        ```
    </details>
5. Add the `PowerUserAccess` permissions policy to your role from step #3 (the one we also attached the trust policy too.).
6. Either attach the `IAMFullAccess` permissions policy to the role from step #3, or create an inline permissions policy that allows for `iam:*` permissions on `*` resources.  This is because Terraform will be creating and managing IAM resources.
7. Setup a named profile for your user in the AWS CLI.  [See Instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-using-profiles)
8. Configure the AWS CLI so that your IAM User, which was configured as a named profile in #5, can assume the role created in #3. [See Instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html)
9. Get the ARN of the role from #3.

This section creates an OIDC connection between HCP Terraform and your AWS Account such that it can use the Role configured in step #3 to provision infrastructure.  This saves us from having to create individual users and copy and paste access keys around.

The user created in step #2, while not required, will be used to configure both `kubectl` and `helm` in the case that you'd like to interact with the EKS cluster outside of terraform.

### HCP Terraform Prerequisites (Part 2)

1. Create another [Variable Set](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-create-variable-set) for your for your IAM role from the previous section.  It should consist of two variables:
  - `TFC_AWS_PROVIDER_AUTH` = `true`, of category type `env`
  - `TFC_AWS_RUN_ROLE_ARN` = `your_IAM_role_ARN`, of category type `env`
  - these are explained in the [Dynamic Credentials with the AWS Provider](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration) article
2. Apply this new variable set to your HCP Terraform Project.  [See this tutorial for help](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-multiple-variable-sets#create-a-credentials-variable-set)

This will make it so that each workspace created within your HCP Terraform Project will be able to provision resources inside of your AWS Account.

### Install and Setup Kubectl and Helm

1. [Install Kubectl](https://kubernetes.io/docs/tasks/tools/)
2. [Install Helm](https://helm.sh/docs/intro/install/)

### Decide on DNS & SSL

If you'd like to setup this project with a domain name and HTTPS, you'll need to do two things:

1. Manually purchase a [domain via Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html) in your account.
2. Manually create a [hosted zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) for your purchased domain.

If you don't want to do that, you can ignore the `dns` directory and `dns` HCP Terraform workspaces.

## First Time Deploy

There are 5 directories in this project, each representing their own "`terraform apply`" execution environment.

1. `modules` - reusable configuration that may or may not be used across any of the other directories
2. `infrastructure` - the base infrastructure resources including, networks, EKS cluster, HCP clusters
3. `packages` - setup and installation of helm packages and other EKS addons
4. `services` - manifests and settings relating to deployed applications into EKS
5. `dns` - the optional configuration that fronts your `services` with HTTPS and a domain name

This numbered list also represents the order of operations in which these must be `terraform apply`'d.  In otherwords, you must deploy the `infrastructure` workspace and then the `packages` workspace, and so on.

### Enable Workspace Remote Sharing (Optional)

If you'd prefer to opt out of passing values between workspaces manually, you can take advantage of remote state.  To do so you'll need to enable workspace remote state sharing:

1. In the `infrastructure` workspace -> Settings -> Remote state sharing -> Share with specific workspaces -> add your `packages`, `services`, and `dns` workspaces.
2. In the `services` workspace -> Settings -> Remote state sharing -> Share with specific workspaces -> add your `dns` workspaces.

### `infrastructure` workspace deployment

1. In AWS, and in the region you intend to deploy in (defaults to `us-east-1`), create an ec2 keypair.
2. Add the following HCP Terraform Variables to your `infrastructure` workspace:
  - `ec2_kepair_name` = name value from previous step.  Type = Terraform Variable, and mark it as HCL.
    - be sure to surround the value with double quotes.
3. Click `+ New Run` at the top and deploy your infrastructure.  New EKS clusters can take 15 - 25 minutes to provision.
4. Note all of the outputs from the run.  These will need to be passed to subsequent workspaces if you have not enabled workspace remote state sharing.
5. [Configure Kubectl and Helm for EKS](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

This will deploy all needed base resources for everything else.

### `packages` workspace deployment

1. Add the following HCP Terraform Variables to your `packages` workspace:
  - `hcp_terraform_infrastructure_workspace_name` = `<hcp_terraform_infrastructure_workspace>`, Type = Terraform Variable, and mark as HCL.
    - be sure to surround the value with double quotes.
  - `hcp_terraform_organization_name` = `<hcp_terraform_organization_name>`, Type = Terraform Variable, mark as HCL.
2. If you have not enabled remote state sharing between workspaces, you'll need to gather the outputs from the `infrastructure` workspace deployment, match ones required in the `packages` workspace, and add them.  
  - i.e. the `infrastructure` workspace outputs an `eks_cluster_name` value, and the `packages` workspace requires `eks_cluster_name` input variable.  Copy the output from the `infrastructure` workspace into the `packages` workspace.
3. Repeat #2 for all required variables for the `packages` workspace.
4. In the "Overview" screen click `+ New Run`.

This will setup the EKS cluster with all required helm packages and EKS Addons.

### `services` workspace deployment

1. Add the following HCP Terraform Variables to your `services` workspace:
  - `hcp_terraform_infrastructure_workspace_name` = `<hcp_terraform_infrastructure_workspace>`, Type = Terraform Variable, and mark as HCL.
    - be sure to surround the value with double quotes.
  - `hcp_terraform_organization_name` = `<hcp_terraform_organization_name>`, Type = Terraform Variable, mark as HCL.
2. If you have not enabled remote state sharing between workspaces, you'll need to gather the outputs from the `infrastructure` workspace deployment, match ones required in the `services` workspace, and add them.  This workspace requires two:
  - `eks_cluster_name`
  - `public_subnet_ids`
3. In the "Overview" screen click `+ New Run`.

This will deploy the user facing services into the EKS cluster.

There is another input variable `acm_certificate_arn` that is used in setting up DNS and SSL for the user facing service.  However, this doesn't need to be specified until the `dns` workspace is deployed.

### `dns` workspace deployment

1. Add the following HCP Terraform Variables to your `dns` workspace:
  - `hcp_terraform_infrastructure_workspace_name` = `<hcp_terraform_infrastructure_workspace>`, Type = Terraform Variable, and mark as HCL.
    - be sure to surround the value with double quotes.
  - `hcp_terraform_services_workspace_name` = `<hcp_terraform_services_workspace>`, Type = Terraform Variable, and mark as HCL.
  - `hcp_terraform_organization_name` = `<hcp_terraform_organization_name>`, Type = Terraform Variable, mark as HCL.
  - `public_domain_name` = `<domain_acquired_through_route53>`, Type = Terraform Variable, mark as HCL.
  - `public_subdomain_name` = `<desired_subdomain_to_point_to>`, Type = Terraform Variable, mark as HCL.
2. If you have not enabled remote state sharing between workspaces, you'll need to gather the outputs from the `infrastructure` workspace deployment, match ones required in the `dns` workspace, and add them.  This workspace requires one:
  - `eks_cluster_name`
3. In the "Overview" screen click `+ New Run`.

Once the run is completed, note the output titled `acm_certificate_arn`: 

1. Copy the value of the `acm_certificate_arn`.
2. Return to the `services` workspace and add another variable `acm_certificate_arn` and add the value, Type = Terraform Variable, and mark as HCL.

## Tear Down

When tearing down the infrastructure, you must do so in reverse order.  Workspaces should be `terraform destroy`'d and removed in this order:

1. `dns`
2. `services`
3. `packages`
4. `infrastructure`

## Resources

1. [HashiCorp Developer Resources](https://developer.hashicorp.com/)
2. [HashiCorp Cloud Platform](https://www.hashicorp.com/)