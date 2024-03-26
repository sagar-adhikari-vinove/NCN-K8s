#!/bin/bash

rollback() {
    deployment_name=$1
    service_name=$2
    container_name=$3

        echo "$service_name service is Down && Kubernetes rollback initiating DEV"
        cd "/home/gitlab-runner/builds"
        value=$(cat /home/gitlab-runner/builds/ANVERSION-DEV)
        echo "${value}"
        kubectl set image "deployment/$deployment_name" "$container_name=newcloudnetworks/dev-angular:ot-$value" -n dev
        kubectl rollout restart "deployment/$deployment_name" -n dev
        echo "Done rolling back"
}

#sleep 30s
rollback "otangular-dev-deployment" "ot-angular-dev" "ot-angular-dev"
