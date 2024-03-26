#!/bin/bash

   echo "Pasco customer kubernetes rollback DEV"
  # cd /home/gitlab-runner/builds
   destdir=/home/gitlab-runner/builds/JAVAVERSION-DEV-OT-STABLE
   value=`cat /home/gitlab-runner/builds/JAVAVERSION-DEV-OT-STABLE`
   prevalue=$(echo ${value} | awk -F. -v OFS=. '{
  if ($NF == 0) {      # If the last part is 0 (e.g., 1.0.37.0)
    sub(/[0-9]+$/, "");  # Remove the last part (0 in this case)
    $(NF-1) -= 1;       # Subtract 1 from the second-to-last part
    $NF = 9;            # Set the last part to 9
  } else {             # If the last part is not 0 (e.g., 1.0.37.5)
    $NF -= 1;          # Subtract 1 from the last part
  }
  print;
}')

   echo "${value}"
#   kubectl delete -f deployment.yaml 
   sed -i "s+ot-latest+ot-$value+g" deployment.yaml
   kubectl apply -f deployment.yaml
   sed -i "s+ot-$value+ot-latest+g" deployment.yaml
   echo "end"
