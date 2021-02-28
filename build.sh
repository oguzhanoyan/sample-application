#!/bin/bash
set -euo pipefail

if ! [ -x "$(command -v minikube)" ]; 
then
  echo 'There is no minikube on your computer, please install minikube.' >&2
  exit 1
fi

echo "There is minikube node in your computer, checking status.."

if minikube status | grep -q Running;
then
  echo "Minikube has already running "
else
  echo "Minikube has stopped starting again, please wait..."
  echo "$(minikube start)"
fi

if [ -e installation.yaml ]
then
    echo "There is a file installation.yaml, now i'll start to deploying, please wait..."
    echo "$(kubectl apply -f installation.yaml)"
    echo "#####################################"
    sleep 7
    echo "Python application exposing with minikube, please wait..."
    echo "$(minikube service sample-app-service)"
else
    echo "Missing installation file(installation.yaml)"
fi