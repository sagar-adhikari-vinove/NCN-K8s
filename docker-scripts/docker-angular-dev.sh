#!/bin/bash

set -e
# Calculate the cutoff time (current time - 20 minutes) in seconds since Unix epoch
cutoff_time=$(date -d '5 minutes ago' '+%s')

# Define the image tag pattern
image_tag_pattern="newcloudnetworks/dev-angular*:ot-*"

# Check if there are any images that match the pattern
if [ -n "$(docker images -q "$image_tag_pattern")" ]; then
  # Iterate over the output of your Docker command for the specified image tag pattern
  docker images -q "$image_tag_pattern" | xargs docker inspect --format='{{.Id}} {{.Created}}' |
  while read -r image_id created_time; do
    # Convert the image creation time to seconds since Unix epoch
    created_time=$(date -d "$created_time" '+%s')

    # Compare the image creation time with the cutoff time
    if [ "$created_time" -lt "$cutoff_time" ]; then
      echo "Removing image: $image_id (created on $(date -d "@$created_time"))"
      docker rmi -f "$image_id"
    fi
  done
else
  echo "No matching images older than 5mins found for pattern: $image_tag_pattern"
fi
