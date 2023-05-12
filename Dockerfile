FROM openjdk:11-slim

# Install essential dependencies
RUN apt-get update && \
    apt-get install -y \
    software-properties-common curl vim ssh net-tools ca-certificates python3 python3-pip

# Setup Python version
ENV PYTHONHASHSEED 1
ENV PYSPARK_PYTHON python3

RUN update-alternatives --install "/usr/bin/python" "python" "$(which python3)" 1

# Download and setup Spark
ENV SPARK_HOME /opt/spark

RUN mkdir -p ${SPARK_HOME} && \
    curl -o /tmp/spark.tgz "https://dlcdn.apache.org/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz" && \
    tar -xf /tmp/spark.tgz -C ${SPARK_HOME} --strip-components=1 && \
    rm /tmp/spark.tgz

ENV PATH       ${PATH}:${SPARK_HOME}/bin
ENV PATH       ${PATH}:${SPARK_HOME}/sbin
ENV PYTHONPATH ${PYTHONPATH}:${SPARK_HOME}/python
ENV PYTHONPATH ${PYTHONPATH}:${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip

## Default workload configurations
ENV SPARK_WORKLOAD          master
ENV SPARK_MASTER_HOST       spark-master-container
ENV SPARK_MASTER_PORT       7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_WORKER_WEBUI_PORT 8081

## Log configurations
ENV SPARK_LOG_DIR    ${SPARK_HOME}/logs
ENV SPARK_MASTER_LOG ${SPARK_LOG_DIR}/spark-master.out
ENV SPARK_WORKER_LOG ${SPARK_LOG_DIR}/spark-worker.out

RUN mkdir -p ${SPARK_LOG_DIR} && \
    touch ${SPARK_MASTER_LOG} && \
    touch ${SPARK_WORKER_LOG} && \
    ln -sf /dev/stdout ${SPARK_MASTER_LOG} && \
    ln -sf /dev/stdout ${SPARK_WORKER_LOG}

## Expose mandatory ports
EXPOSE 4040 6066 7077 8080 8081

# Install Jupyter
ENV JUPYTERLAB_PORT      8888
ENV JUPYTERLAB_WORKSPACE /root/.jupyter/workspace
ENV JUPYTERLAB_PID       /root/.jupyter/pid

RUN pip3 install jupyterlab && \
    jupyter lab --generate-config

## Log configurations
ENV JUPYTERLAB_LOG_DIR   /root/.jupyter/logs
ENV JUPYTERLAB_LOG       ${JUPYTERLAB_LOG_DIR}/jupyter.out

RUN mkdir -p ${JUPYTERLAB_LOG_DIR} && \
    touch ${JUPYTERLAB_LOG} && \
    ln -sf /dev/stdout ${JUPYTERLAB_LOG}

# Ignore WARN MetricsConfig
RUN touch ${SPARK_HOME}/conf/hadoop-metrics2-s3a-file-system.properties

# Start master or worker
COPY --chmod=0755 start-spark.sh .

CMD ["/start-spark.sh"]
