# Use a base image with Python and necessary dependencies
FROM python:3.10

# Install Ansible
RUN pip install ansible
RUN pip install psycopg2
RUN ansible-galaxy collection install azure.azcollection
RUN pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
RUN ansible-galaxy collection install community.postgresql
RUN ansible-galaxy collection install azure.azcollection --force
RUN pip install azure-cli


# Set the working directory
WORKDIR /ansible

# Set the entrypoint to an empty command (to keep the container running)
ENTRYPOINT ["tail", "-f", "/dev/null"]
