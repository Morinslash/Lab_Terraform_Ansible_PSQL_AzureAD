# Use a base image with Python and necessary dependencies
FROM python:3.11

# Install Ansible
RUN pip install ansible
RUN pip install psycopg2
RUN ansible-galaxy collection install community.postgresql

# Set the working directory
WORKDIR /ansible

# Set the entrypoint to an empty command (to keep the container running)
ENTRYPOINT ["tail", "-f", "/dev/null"]
