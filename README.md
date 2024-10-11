# mini-project1

## Three-Tier Architecture (Provisioned 2 Frontend Nodes, 2 Backend Nodes, 1 EC2 Database Server and 1 RDS MYSQL DB)

### Installations
-   export AWS_ACCESS_KEY_ID=, export AWS_SECRET_KEY_ID=
-   terraform init for initialisation of plugins
-   terraform plan -var-file Project.tfvars
-   terraform apply -var-file Project.tfvars
-   SSH into VMs using the ssh key and public IP or public DNS address outputted from the provisioned Terraform infrastructure
-   Test configured port accessibility/connectivity using the Netcat, Ping & Telnet commands

# Run terraform destroy to terminate all provisioned instances
