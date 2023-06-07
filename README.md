# :whale: PySpark + MinIO + Jupyter
This project consists of running a basic and dockerized data engineering development and learning environment using a set of tools:
- PySpark (3.3.2)
- MinIO (AGPL v3) :flamingo:
- Jupyter Lab

> The only purpose of this project is learning, so never use this for production.

## :rocket: How to Execute
To execute this project, a linux OS (including WSL) and a docker compose v2 are required.

### Build and start containers
First, you need to build a docker image by typing `make build`. After that, type `make start` every time you want to start the service.

### Using Jupyter
After the build and start process is done, type `make token` and copy the result.

Access [http://localhost:8888](http://localhost:8888), paste the token in text/password field and submit. If everything is right, now you have access to Jupyter Lab and can create a python scripts normally.

### Accessing MinIO
Access [http://localhost:9000](http://localhost:9000) and sign-in using these credentials:
- username: root
- passsword: root@password

Now you can create your own buckets to save and manipulete files like a AWS S3 :wine_glass:.

### Accessing Spark Web UI
Access [http://localhost:8080](http://localhost:8080) to inspect PySpark applications and workers (by default, the `docker-compose.yml` is configured to run 2 PySpark workers with 1 vCore and 2GB of memory each).

To inspect the running stages, you can access [http://localhost:4040](http://localhost:4040) during execution.

### Stop containers
To stop all containers, type `make stop` in the terminal and wait for them all to be brought down.

### Example using Jupyter, PySpark and MinIO
An example using PySpark and MinIO through Jupyter is available at [workspace/sample.ipynb](workspace/sample.ipynb).

## :package: Volumes
When running the containers for the first time, a `workspace/` directory will be created at the root of the project. This folder is shared between host machine and jupyter workspace running inside the container. The `buckets/` directory is where MinIO persists the data that is generated.

This approach guarantees us that even if a container is restarted, all the code and data that has already been created will persist.
