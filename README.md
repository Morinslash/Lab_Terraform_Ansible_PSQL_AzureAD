docker run --rm -it --name ansible --entrypoint /bin/sh ansible/ansible
To work on windows with Ansible build the docker file

```bash
docker build -t ansible-image:v1.0 .
```

Once the container is locally available we can start it and exec directly into the container shell

```bash
docker run -it --rm -v ${PWD}:/src -w /src --entrypoint /bin/sh ansible-image:v1.0
```

this command will automatically remove container when we exit.

check containers network

```bash
docker network inspect bridge
```

run postgres container for tests

```bash
docker run --name mypostgres --ip 10.88.0.8 -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin -p 5432:5432 postgres:11
```

check if container is available
```bash
docker run -it --rm alpine ping 10.88.0.8
```