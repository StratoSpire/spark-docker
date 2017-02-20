# Spark Docker

spark:
[![DockerStars](https://img.shields.io/docker/stars/stratospire/spark.svg)](https://registry.hub.docker.com/u/stratospire/spark/)
[![DockerPulls](https://img.shields.io/docker/pulls/stratospire/spark.svg)](https://registry.hub.docker.com/u/stratospire/spark/)

zeppelin:
[![DockerStars](https://img.shields.io/docker/stars/stratospire/zeppelin.svg)](https://registry.hub.docker.com/u/stratospire/zeppelin/)
[![DockerPulls](https://img.shields.io/docker/pulls/stratospire/zeppelin.svg)](https://registry.hub.docker.com/u/stratospire/zeppelin/)

These Spark Docker images are for running on-demand Spark clusters on Docker and Kubernetes.

Here's how to use them:

## Docker Compose

### Start the Cluster

```
cd docker
docker-compose up -d
```

The Zeppelin URL will then be available at:
[http://localhost:8080/](http://localhost:8080/)

### Stop the Cluster

```
docker-compose down
```

## Kubernetes

### Start the Cluster

```
cd k8s
./start.sh <K8S_URL> <CLUSTER_ID> <NUMBER_OF_WORKERS> <CPUS_PER_WORKER> <MB_MEMORY_PER_WORKER>
```

The Zeppelin URL will print as part of the start script and will look like:
```
<K8S_URL>/api/v1/proxy/namespaces/spark-ondemand-<CLUSTER_ID>/services/spark-master:8080
```

### Stop the Cluster
```
./stop.sh <K8S_URL> <CLUSTER_ID>
```

### Example
```
./start.sh http://localhost:8080 testola 1 1 1024
```
The example would then be available at:  [http://localhost:8080/api/v1/proxy/namespaces/spark-ondemand-testola/services/spark-master:8080](http://localhost:8080/api/v1/proxy/namespaces/spark-ondemand-testola/services/spark-master:8080)


## Run a job

Once you have a cluster setup in your preferred method, you can run a job via the Zeppelin UI.

Click 'Notebook' > 'Create new note' > Name it 'Test' > Click 'Create Note'

Paste the following into the notebook and the hit 'Shift' + 'Enter' or click the Play button to run the job.
```
%pyspark
from math import sqrt; from itertools import count, islice

def isprime(n):
    return n > 1 and all(n%i for i in islice(count(2), int(sqrt(n)-1)))

nums = sc.parallelize(xrange(10000000))
print nums.filter(isprime).count()
```
