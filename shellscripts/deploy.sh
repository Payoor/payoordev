#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [-c container1,container2,...] [-i image1,image2,...]"
    echo "  -c    Comma-separated list of containers to stop and remove"
    echo "  -i    Comma-separated list of images to remove"
    exit 1
}

# Parse command line options
while getopts ":c:i:" opt; do
    case $opt in
        c) CONTAINERS=$OPTARG
           echo "Containers to remove: $OPTARG" ;;
        i) IMAGES=$OPTARG
           echo "Images to remove: $OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
    esac
done

# Check if CONTAINERS and IMAGES are set
if [ -z "$CONTAINERS" ] && [ -z "$IMAGES" ]; then
    echo "No containers or images specified. Nothing to do."
    usage
fi

# Convert comma-separated strings to arrays
if [ -n "$CONTAINERS" ]; then
    IFS=',' read -ra CONTAINER_ARRAY <<< "$CONTAINERS"
    echo "Stopping and removing existing containers..."
    for container in "${CONTAINER_ARRAY[@]}"; do
        docker stop $container
        docker rm $container
    done
fi

if [ -n "$IMAGES" ]; then
    IFS=',' read -ra IMAGE_ARRAY <<< "$IMAGES"
    echo "Removing existing images..."
    for image in "${IMAGE_ARRAY[@]}"; do
        docker rmi $image
    done
fi

echo "Starting deployment..."

docker-compose up -d

echo "Deployment completed."