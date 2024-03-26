#!/bin/bash

rollback() {
    deployment_name=$1
    service_name=$2
    container_name=$3

        echo "$service_name service is Down && Kubernetes rollback initiating DEV"
        cd "/home/gitlab-runner/builds"
        STABLE=$(cat /home/gitlab-runner/builds/PHPVERSION-DEV-OT-STABLE)
        echo "${STABLE}"
        kubectl set image "deployment/$deployment_name" "$container_name=newcloudnetworks/php-dev-$service_name:ot-$STABLE" -n dev
        kubectl rollout restart "deployment/$deployment_name" -n dev
        echo "Done rolling back"
}

#sleep 30s
rollback "ot-php-web-ms-dev" "web-ms" "php-web-ms-dev"
#sleep 15s
rollback "ot-php-reports-service-dev" "reports-service" "ncn-php-reports-service-dev"
#sleep 30s
rollback "ot-php-subscription-dev" "subscription" "ncn-php-subscription-dev"
#sleep 15s
rollback "ot-php-vbo-dev" "vbo" "ncn-php-vbo-dev"
#sleep 10s
rollback "ot-php-entity-management-dev" "entity-management" "ncn-php-entity-management-dev"
#sleep 10s
rollback "ot-php-settings-service-dev"  "settings-service" "ncn-php-settings-service-dev"
#sleep 10s
