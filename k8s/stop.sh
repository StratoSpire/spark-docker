#!/bin/bash

export K8S_URL="$1"
export CLUSTER_ID="$2"
export KUBE_NAMESPACE="spark-ondemand-$CLUSTER_ID"


kubectl -s $K8S_URL delete ns $KUBE_NAMESPACE
