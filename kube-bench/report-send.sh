#!/bin/bash

# Define recipients' email addresses (comma-separated)
recipients="bsinkule@otava.com,dpupeza@otava.com,pchandra@otava.tech,sadhikari@otava.tech"


#kubectl apply -f kube-bench-master.yaml
#kubectl apply -f kube-bench-worker.yaml

#kubectl wait --for=condition=complete job/kube-bench-master
#kubectl wait --for=condition=complete job/kube-bench-node

#kubectl logs job/kube-bench-master > in1-dev-master-report.log
#kubectl logs job/kube-bench-node > in1-dev-worker-report.log
 # Define email subject and body
subject="IN1 DEV K8S Cluster Kube-Bench Report"
body="Please find the attached IN1-DEV K8S Cluster Kube-Bench Vulnerability Latest Report"


  # Send the email with the report as an attachment
echo "$body" | mutt -s "$subject" "$recipients"  -a  in1-dev-master-report.log -a in1-dev-worker-report.log 

#kubectl delete -f kube-bench-master.yaml
#kubectl delete -f kube-bench-worker.yaml
