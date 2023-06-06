# :whale: PySpark + MinIO + Jupyter
This project consists of running a basic and dockerized data engineering development and learning environment using a set of tools:
- PySpark (3.3.2)
- MinIO :flamingo:
- Jupyter Lab

> The only purpose of this project is learning, so never use this for production.

## :rocket: How to Execute
To execute this project, a linux OS (including WSL) is required.

### Build and execute the containers
To instantiate the environment, type `make` and press enter at Linux terminal.

### Using Jupyter
After the build and start process terminated, type `make token` and copy the result.

Access [http://localhost:8888](http://localhost:8888), paste the copied token into text/password field and submit then. If everything is right, now you have access to Jupyter Lab and can create a python scripts normaly.

### Accessing the MinIO
Access [http://localhost:9000](http://localhost:9000) and sign-in using this credentials:
- username: root
- passsword: root@password

Now you can create your own buckets to save and manipulete files like a AWS S3 :wine_glass:.

### Inspecting PySpark UI
Access [http://localhost:8080](http://localhost:8080) to inspect PySpark applications and workers (by default, the `docker-compose.yml` is configured to run 2 PySpark workers with 1 vCore and 2GB of memory each).

To inspect the running stages, you can access [http://localhost:4040](http://localhost:4040) during execution.

### Example using Jupyter, PySpark and MinIO
An example using PySpark and MinIO through Jupyter is available at [workspace/sample.ipynb](workspace/sample.ipynb).
