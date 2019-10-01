<p align="center"><img src="https://github.com/unboundedsystems/k3s-dind/raw/master/k3s-dind.png" /></p>

# k3s-dind

Lightweight k3s Kubernetes inside a Docker-in-Docker container

## Quick Start

```bash
docker run -d --privileged --name k3s --hostname k3s -p 8443:8443 unboundedsystems/k3s-dind
docker exec k3s get-kubeconfig.sh > ./k3sconfig
export KUBECONFIG=./k3sconfig

kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
k3s       Ready     <none>    1m        v1.14.1-k3s.4

kubectl create ...

```


## What is k3s-dind?

k3s-dind allows you to quickly create a [lightweight local Kubernetes cluster](https://k3s.io/),
self-contained inside a single Docker-in-Docker (DinD) container.

## What would I use it for?

k3s-dind is awesome for:

* Quickly running automated unit tests in Kubernetes
* Running your containerized app locally for easier debugging
* Testing out automation or changes to a Kubernetes cluster
* Ensuring you're starting with a fresh cluster every time
* Doing all that stuff in only 512MB of RAM!

## Exposing network services

### Docker host networking

The Quick Start example above uses Docker's [host networking](https://docs.docker.com/network/host/), using the `-p 8443:8443` option to `docker run` to expose the Kubernetes API port.
To run Kubernetes [services](https://kubernetes.io/docs/concepts/services-networking/service/) and make them available outside the cluster, you would need to use additional `-p` options to `docker run`, because Docker doesn't support exposing additional host networking ports after the container has been started.

For example, to allow your Docker host to connect to a [Kubernetes service running on port 8080](https://kubernetes.io/docs/tasks/access-application-cluster/service-access-application-cluster/), you'd need to start k3s-dind like this:

```bash
docker run -d --privileged --name k3s --hostname k3s -p 8443:8443 -p 8080:8080 unboundedsystems/k3s-dind
```

### Docker named networks

For more dynamic environments, you can also use k3s-dind with named Docker networks, such as a [bridge network](https://docs.docker.com/network/bridge/).
Then, any other containers on the same named network with k3s-dind can access any Kubernetes services exposed by the k3s-dind cluster.

First, create a Docker network, then run k3s-dind attached to that network:

```bash
docker network create mynetwork
docker run -d --privileged --name k3s --hostname k3s --network mynetwork unboundedsystems/k3s-dind

# The second argument to get-kubeconfig.sh is the container name of k3s-dind
docker exec k3s get-kubeconfig.sh -yaml k3s > ./k3sconfig
```

Now, any container on `mynetwork` can access any service exposed by the k3s-dind cluster:

```bash
# Run a container that's on mynetwork and mount the kubeconfig
docker run --rm -it -v ${PWD}/k3sconfig:/k3sconfig --network mynetwork k3integrations/kubectl

# Now we're inside the container we just ran
export KUBECONFIG=/k3sconfig

kubectl get all
NAME             CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
svc/kubernetes   10.43.0.1    <none>        443/TCP   10m
```

## You made Kubernetes that small??

Nope! The awesome folks over at [Rancher Labs](https://rancher.com/) did all
the hard work of creating [k3s](https://k3s.io/). We just packaged it into
a Docker-in-Docker container.
