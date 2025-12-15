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

# Check if we have persistent storage
if mountpoint -q "$COLLECTION_DIR" 2>/dev/null; then
  echo "✅ Persistent storage detected at $COLLECTION_DIR"
elif [ -w "$COLLECTION_DIR" ]; then
  echo "⚠️  WARNING: Using container filesystem (data will be lost on restart)"
  echo "   Configure Railway Volume at $COLLECTION_DIR for data persistence"
else
  echo "❌ ERROR: Cannot write to $COLLECTION_DIR"
  exit 1
fi

# Check collection version and update if needed
COLLECTION_VERSION_FILE="$COLLECTION_DIR/.collection-version"
CONTAINER_VERSION="v1"

if [ -f "$COLLECTION_VERSION_FILE" ]; then
  CURRENT_VERSION=$(cat "$COLLECTION_VERSION_FILE")
  if [ "$CURRENT_VERSION" != "$CONTAINER_VERSION" ]; then
    echo "Collection version mismatch. Current: $CURRENT_VERSION, Container: $CONTAINER_VERSION"
    echo "Updating collection to learning content..."
    rm -f "$COLLECTION_DIR"/*.md 2>/dev/null || true
    cp -r /app/prod-collection/* "$COLLECTION_DIR/"
    echo "$CONTAINER_VERSION" >"$COLLECTION_VERSION_FILE"
    echo "Prod learning collection updated successfully!"
  else
    echo "Collection is up to date (version: $CONTAINER_VERSION)"
  fi
else
  echo "No collection version found. Installing learning collection..."
  rm -f "$COLLECTION_DIR"/*.md 2>/dev/null || true
  cp -r /app/prod-collection/* "$COLLECTION_DIR/"
  echo "$CONTAINER_VERSION" >"$COLLECTION_VERSION_FILE"
  echo "Learning collection installed successfully!"
fi

# Set logging level if not already set
export RUST_LOG=${RUST_LOG:-info}

echo "Starting hashcards drill session..."
echo "Web interface will be available at http://localhost:$PORT"
echo "Collection directory: $COLLECTION_DIR"

# List available decks for debugging
echo "Available decks:"
ls -la "$COLLECTION_DIR"/*.md 2>/dev/null || echo "No .md files found"

# Execute hashcards with proper arguments for server deployment
# --open-browser false: Disable browser auto-opening for headless server
# exec: Replace shell process for proper signal handling
exec /app/hashcards drill "$COLLECTION_DIR" \
  --port "$PORT" \
  --open-browser false

