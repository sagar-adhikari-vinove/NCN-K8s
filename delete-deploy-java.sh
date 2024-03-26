#!/bin/bash

deployments=("ot-java-cloud-gateway-deployment-dev" "ot-java-config-server-deployment-dev" "ot-java-hystrix-dashboard-deployment-dev" "ot-java-pasco-contact-web-deployment-dev" "ot-java-service-registry-deployment-dev" "ot-pasco-customer-web-deployment-dev" "ot-pasco-partner-web-deployment-dev" "ot-pasco-product-web-deployment-dev" "ot-pasco-subscription-web-deployment-dev" "ot-zipkin-deployment-dev")

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
