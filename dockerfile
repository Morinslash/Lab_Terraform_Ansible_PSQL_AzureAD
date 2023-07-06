# Use a base image with Python and necessary dependencies
FROM python:3.10

# Install Ansible
RUN pip install ansible
RUN pip install psycopg2
# RUN pip install msrestazure
# RUN pip install azure-cli
RUN ansible-galaxy collection install azure.azcollection
RUN pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
RUN ansible-galaxy collection install community.postgresql
RUN ansible-galaxy collection install azure.azcollection --force


# Set the working directory
WORKDIR /ansible

# Set the entrypoint to an empty command (to keep the container running)
ENTRYPOINT ["tail", "-f", "/dev/null"]
