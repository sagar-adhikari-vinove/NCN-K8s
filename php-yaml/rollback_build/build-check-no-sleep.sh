#!/bin/bash

check_build() {
    service=$1

    curl_response=$(curl -s -o /dev/null -w "%{http_code}" "https://$service")
    echo $curl_response

    if [ "$curl_response" = "200" ] || [ "$curl_response" = "401" ]; then
        echo "php $service service is up and running"
    else
        echo "$service IS DOWN"
        exit 1
    fi
}

#sleep 5m
check_build "cpanel-ws-dev.otava.com/"
#sleep 1m
check_build "cpanel-ws-dev.otava.com/api/logs?module=entity"
#sleep 10s
check_build "cpanel-ws-dev.otava.com/api/logs?module=settings"
#sleep 15s
check_build "cpanel-ws-dev.otava.com/api/logs?module=reports"
#sleep 10s
check_build "cpanel-ws-dev.otava.com/api/logs?module=subscription"
#sleep 10s
check_build "cpanel-ws-dev.otava.com/api/logs?module=vac"
#sleep 10s
check_build "cpanel-ws-dev.otava.com/api/logs?module=vbo"
