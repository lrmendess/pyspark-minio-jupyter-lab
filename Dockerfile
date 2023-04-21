FROM openjdk:11-slim

# Install essential dependencies
RUN apt-get update && \
    apt-get install -y \
    software-properties-common curl vim ssh net-tools ca-certificates python3 python3-pip

# Setup Python version
RUN update-alternatives --install "/usr/bin/python" "python" "$(which python3)" 1
ENV PYSPARK_PYTHON python3
ENV PYTHONHASHSEED 1

# Download and setup Spark
ENV SPARK_HOME /opt/spark/
RUN mkdir -p ${SPARK_HOME}

RUN curl -o spark.tgz "https://dlcdn.apache.org/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz" && \
    tar -xf spark.tgz -C ${SPARK_HOME} --strip-components=1 && \
    rm spark.tgz

ENV PATH ${PATH}:${SPARK_HOME}/bin
ENV PATH ${PATH}:${SPARK_HOME}/sbin

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

EXPOSE 4040 6066 7077 8080 8081

# Start master or worker
COPY --chmod=0755 start-spark.sh .

CMD ["/start-spark.sh"]
