#!/bin/bash
set -e

# Entrypoint script for hashcards Railway deployment
# Handles environment variable configuration for production deployment

echo "Starting hashcards server..."

# Use PORT environment variable if set by Railway, default to 8000
PORT=${PORT:-8000}
echo "Using port: $PORT"

# Use COLLECTION_DIR environment variable if set, default to /data
COLLECTION_DIR=${COLLECTION_DIR:-/data}
echo "Using collection directory: $COLLECTION_DIR"

# Create collection directory if it doesn't exist
if [ ! -d "$COLLECTION_DIR" ]; then
    echo "Creating collection directory: $COLLECTION_DIR"
    mkdir -p "$COLLECTION_DIR"
fi

# Check if collection directory has any markdown files
if [ -z "$(find "$COLLECTION_DIR" -name "*.md" -type f 2>/dev/null)" ]; then
    echo "Warning: No markdown files found in $COLLECTION_DIR"
    echo "The collection directory should contain .md files with flashcards"
    echo "Example format:"
    echo "  Q: What is the capital of France?"
    echo "  A: Paris"
    echo ""
    echo "  C: The [mitochondria] is the powerhouse of the [cell]."
fi

# Set logging level if not already set
export RUST_LOG=${RUST_LOG:-info}

echo "Starting hashcards drill session..."
echo "Web interface will be available at http://localhost:$PORT"

# Execute hashcards with proper arguments for server deployment
# --open-browser false: Disable browser auto-opening for headless server
# exec: Replace shell process for proper signal handling
exec /app/hashcards drill "$COLLECTION_DIR" \
    --port "$PORT" \
    --open-browser false