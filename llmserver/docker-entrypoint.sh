#!/bin/bash
set -e

if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: API_KEY environment variable is required"
    exit 1
fi

exec "$@"
