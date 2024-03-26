#!/bin/bash

deployments=("ot-php-entity-management-dev" "ot-php-reports-service-dev" "ot-php-settings-service-dev" "ot-php-subscription-dev" "ot-php-vac-dev" "ot-php-vbo-dev" "ot-php-web-ms-dev")

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
