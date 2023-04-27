#!/bin/bash

if [ "${SPARK_WORKLOAD}" == "master" ];
then
    nohup jupyter lab --ip 0.0.0.0 --port ${JUPYTERLAB_PORT} --notebook-dir ${JUPYTERLAB_WORKSPACE} --allow-root --no-browser >> ${JUPYTERLAB_LOG} & echo $!> ${JUPYTERLAB_PID}
    spark-class org.apache.spark.deploy.master.Master --ip ${SPARK_MASTER_HOST} --port ${SPARK_MASTER_PORT} --webui-port ${SPARK_MASTER_WEBUI_PORT} >> ${SPARK_MASTER_LOG}
elif [ "${SPARK_WORKLOAD}" == "worker" ];
then
    spark-class org.apache.spark.deploy.worker.Worker --webui-port ${SPARK_WORKER_WEBUI_PORT} spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> ${SPARK_WORKER_LOG}
elif [ "${SPARK_WORKLOAD}" == "submit" ];
then
    echo "Submit spark process"
else
    echo "Undefined Workload Type ${SPARK_WORKLOAD}, must specify: master, worker, submit"
fi
