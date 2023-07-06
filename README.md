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

To execute the playbook (assuming that we've started ansible container in root of the project) 
```bash
ansible-playbook src/ansible/main.yml
```

Access to the database with configured users:
- **Username** *\<databasename>-developer*
- **Password** *hello*


## Pre-configuration for Ansible Playbook

In order to execute locally playbook with Postgresql container there are few required steps to do manually
-   Create role named **azure_ad_user**
-   Create tables specified in [var_file](var_file.yml)
-   Update he IP address of Postgresql container in [var_file](var_file.yml)

---
## Testing Configuration
### [Test SQL](test.sql)

| User           | Test                        | Local | Azure Psql | Terraform Integration |
| -------------- | --------------------------- | ----- | ---------- | --------------------- |
| Admin          | ---                         | ---   | ---        | ---                   |
|                | Access to all DB            | x     | x          |                       |
|                | DBs ownership               | x     | x          |                       |
|                | Create Table                | x     | x          |                       |
|                | Insert data                 | x     | x          |                       |
|                | Select other user           | x     | x          |                       |
|                | Drop Table                  | x     | x          |                       |
| ReadWrite user | ---                         | ---   | ---        | ---                   |
|                | Member of **azure_ad_user** | x     | x          |                       |
|                | One DB access               | x     | x          |                       |
|                | No Drop, Create             | x     | x          |                       |
|                | Select Admin data           | x     | x          |                       |
|                | Update data                 | x     | x          |                       |
|                | Insert data                 | x     | x          |                       |
|                | Delete data                 | x     | x          |                       |
|                |                             |       |            |                       |

---
## Accessing Azure Posgresql

```bash
az login
```

```bash
az account get-access-token --resource-type oss-rdbms --query accessToken --output tsv
```

## Running playbook and providing var over CLI

```bash
ansible-playbook playbook.yml -e '{
  "database_config": {
    "login_host": "new_host", 
    "login_user": "new_user", 
    "login_password": "new_password", 
    "owner": "new_owner"
  }, 
  "keyvault_config": {
    "client_id": "new_client_id", 
    "secret": "new_secret", 
    "subscription_id": "new_subscription_id", 
    "tenant": "new_tenant", 
    "keyvault_uri": "new_uri"
  }
}'
```