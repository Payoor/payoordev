#!/bin/bash

NODE_ENV="${NODE_ENV:-development}"

case "$NODE_ENV" in
  "development")
    docker_compose_file="docker-compose-development.yml"
    ;;
  "staging")
    docker_compose_file="docker-compose-staging.yml"
    ;;
  *)
    docker_compose_file="docker-compose.yml"  # Default file
    ;;
esac

if [ -f "$docker_compose_file" ]; then
  # Get a list of services from the Docker Compose file
  services=$(docker-compose -f "$docker_compose_file" config --services)

  # Loop through each service
  for service in $services; do
    # Check for existing containers
    if docker-compose -f "$docker_compose_file" ps -q $service; then
      echo "Stopping and removing container $service"
      docker-compose -f "$docker_compose_file" stop $service
      docker-compose -f "$docker_compose_file" rm -f $service
    else
      echo "No container found for service $service"
    fi

    # Check for existing images
    if docker-compose -f "$docker_compose_file" images -q $service; then
      echo "Removing image for service $service"
      docker rmi -f $service
    else
      echo "No image found for service $service"
    fi

    # Rebuild and start the service
    echo "Rebuilding and starting service $service"
    docker-compose -f "$docker_compose_file" up -d $service
  done
else
  echo "Docker Compose file not found."
fi
