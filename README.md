# Automation of setting up Azure Postgresql integration with AzureAD

Purpose of lab is to provide automated way to setup integration between managed instance of Postgresql in Azure and Azure Active Directory.

This should provide users access to database when they are member of proper group in AzureAD to the database with controlled permissions.

## Tools
- Terraform
- Ansible

## Setting up local environment  
### Ansible
Building local image for Ansible with all required dependencies

Check [Dockerfile](dockerfile)

```bash
docker build -t ansible-image:v1.0 .
```

Run container and get instantly into bash

*This container will auto-dispose when shell exited*

```bash
docker run -it --rm -v ${PWD}:/src -w /src --entrypoint /bin/bash ansible-image:v1.0
```
### Postgres
Local Posgresql instance for development Ansible Script
```bash
docker run --name mypostgres -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin -p 5432:5432 postgres:11
```
inspect network to find IP of the database container
```bash
docker network inspect bridge
```

To check if container is reachable inside docker network, run
```bash
docker run -it --rm alpine ping <postgres-ip>
```

## Pre-configuration for Ansible Playbook for local experiments

In order to execute locally playbook with Postgresql container there are few required steps to do manually
-   Create role named **azure_ad_user**
-   Create databases for which we want to create users

## Pre-configuration for Ansible Playbook for Azure PosgreSQL Single Server

In order to execute playbook with Postgresql Single Server in Azure there are few required steps to do manually
-   Set the **Active Directory admin** to a group
-   Create databases for which we want to create users
-   Create Azure AD Groups with names following pattern \<database-name>-developer
-   Create Key Vault
-   Create Service Principal with permissions to Key Vault

---
## Testing Configuration
### [Test SQL](test.sql)

| User           | Test                         | Local | Azure Psql |
| -------------- | ---------------------------- | ----- | ---------- |
| Admin          | ---                          | ---   | ---        |
|                | Access to all DB             | x     | x          |
|                | DBs ownership                | x     | x          |
|                | Create Table                 | x     | x          |
|                | Insert data                  | x     | x          |
|                | Select other user            | x     | x          |
|                | Drop Table                   | x     | x          |
| ReadWrite user | ---                          | ---   | ---        |
|                | Member of **azure_ad_user**  | x     | x          |
|                | One DB access                | x     | x          |
|                | No Drop, Create              | x     | x          |
|                | Select Admin data            | x     | x          |
|                | Update data                  | x     | x          |
|                | Insert data                  | x     | x          |
|                | Delete data                  | x     | x          |
| ReadWrite app  | ---                          |       |            |
|                | Auto-generate password in KV | x     | x          |

---
## Accessing Azure Posgresql

Login to Azure
```bash
az login
```

Obtain token to connect to PosgreSQL
```bash
az account get-access-token --resource-type oss-rdbms --query accessToken --output tsv
```

## Running playbook and providing var over CLI

```bash
ansible-playbook playbook.yml -e '{
  "database_config": {
    "login_host": "<posgres-host>", 
    "login_user": "<admin-group-name>@<server-name>", 
    "login_password": "<az-cli-token>", 
    "owner": "<admin-group-name>"
  }, 
  "keyvault_config": {
    "client_id": "<sp-client-id>", 
    "secret": "<sp-secret>", 
    "subscription_id": "<sp-subscription>-id", 
    "tenant": "<sp-tenant-id>", 
    "keyvault_uri": "<vault-url>"
  }
}'
```