#!/bin/bash

deployments=("otangular-dev-deployment")

for deployment in "${deployments[@]}"
do
    # Check if deployment exists
    if kubectl get deployment "$deployment" -n dev &> /dev/null; then
        echo "Deployment $deployment exists. Deleting it..."
       kubectl delete deployment "$deployment" -n dev
    else
        echo "Deployment $deployment does not exist. Skipping..."
    fi
done
