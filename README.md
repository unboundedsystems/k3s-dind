<p align="center"><img src="./k3s-dind.png" /></p>

# k3s-dind
Lightweight k3s Kubernetes inside a Docker-in-Docker container

## Quick Start
```console
docker network create k3s
docker run -d --privileged --name k3s --hostname k3s --network k3s unboundedsystems/k3s-dind
docker exec k3s cat /kubeconfig > ./k3sconfig
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

## You made Kubernetes that small??
Nope! The awesome folks over at [Rancher Labs](https://rancher.com/) did all
the hard work of creating [k3s](https://k3s.io/). We just packaged it into
a Docker-in-Docker container.
