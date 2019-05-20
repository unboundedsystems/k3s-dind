#!/bin/bash

while [ ! -f /kubeconfig ]; do
    sleep 1
done

if [ "$1" = "-json" ]; then
    cfg=$(kubectl config view -o json --merge=true --flatten=true)
else
    cfg=$(kubectl config view -o yaml --merge=true --flatten=true)
fi

if [ -z "$2" ]; then
    hostname="localhost"
else 
    hostname="$2"
fi

echo "$cfg" | sed -e "s/0\.0\.0\.0/$hostname/g"
