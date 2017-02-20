#!/bin/bash

set -e

export K8S_URL="$1"
export CLUSTER_ID="$2"
export NUM_WORKERS="$3"
export WORKER_CPU="$4"
export WORKER_MEM="$5"

export K8S_NAMESPACE="spark-ondemand-$CLUSTER_ID"
export URL_PREFIX="${K8S_URL}/api/v1/proxy/namespaces/${K8S_NAMESPACE}/services/spark-ui-proxy:80/"


echo "---------------"
echo "CLUSTER DETAILS"
echo "---------------"
echo "K8S URL: ${K8S_URL}"
echo "Cluster ID: ${CLUSTER_ID}"
echo "Workers: ${NUM_WORKERS}"
echo "CPUs per: ${WORKER_CPU}"
echo "Memory per: ${WORKER_MEM}Mi"
echo

echo "------------------"
echo "Creating Namespace"
echo "------------------"
./template/templater.sh template/namespace.yaml | kubectl -s ${K8S_URL} apply -f -

echo "---------------"
echo "Starting Master"
echo "---------------"
./template/templater.sh template/master-deployment.yaml | kubectl -s ${K8S_URL} -n ${K8S_NAMESPACE} apply -f -
./template/templater.sh template/master-svc.yaml | kubectl -s ${K8S_URL} -n ${K8S_NAMESPACE} apply -f -
sleep 30
echo

echo "-----------------"
echo "Starting Zeppelin"
echo "-----------------"
./template/templater.sh template/zeppelin-deployment.yaml | kubectl -s ${K8S_URL} -n ${K8S_NAMESPACE} apply -f -
./template/templater.sh template/zeppelin-svc.yaml | kubectl -s ${K8S_URL} -n ${K8S_NAMESPACE} apply -f -
echo

echo "-----------------"
echo "Starting Worker(s)"
echo "-----------------"
./template/templater.sh template/worker-deployment.yaml | kubectl -s ${K8S_URL} -n ${K8S_NAMESPACE} apply -f -
echo

echo "-----------------"
echo "When your cluster is up it can be seen here:"
echo "${K8S_URL}/api/v1/proxy/namespaces/${K8S_NAMESPACE}/services/spark-master:8080"
echo "${K8S_URL}/api/v1/proxy/namespaces/${K8S_NAMESPACE}/services/zeppelin:80"
echo "-----------------"
echo

kubectl -s ${K8S_URL} -n ${K8S_NAMESPACE} get po -w
