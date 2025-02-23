#!/bin/bash

echo "🔍 Checking for Docker installation..."
if ! command -v docker &>/dev/null; then
  echo "⚠️ Docker not found. Installing..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install --cask docker
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get update && sudo apt-get install -y docker.io
  else
    echo "❌ Unsupported OS for automatic Docker installation. Install it manually."
    exit 1
  fi
  echo "✅ Docker installed successfully!"
else
  echo "✅ Docker is installed: $(which docker)"
fi

echo "🔍 Checking for Gitleaks installation..."
if ! command -v gitleaks &>/dev/null; then
  echo "⚠️ Gitleaks not found. Installing..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install gitleaks
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get install -y gitleaks
  else
    echo "❌ Unsupported OS for automatic Gitleaks installation. Install it manually."
    exit 1
  fi

  # Verify installation success
  if command -v gitleaks &>/dev/null; then
    echo "✅ Gitleaks installed successfully!"
  else
    echo "❌ Gitleaks installation failed!"
    echo "⚠️ Using Docker as fallback."

    # Only start Docker if Gitleaks installation failed and we need Docker
    if (! docker info >/dev/null 2>&1); then
      echo "⚠️ Docker is not running. Attempting to start..."
      if [[ "$OSTYPE" == "darwin"* ]]; then
        open -a Docker && sleep 10  # macOS: Start Docker and wait for it to initialize
      elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo systemctl start docker
      fi
    fi

    echo "🔍 Checking if Gitleaks Docker image is available..."
    if ! docker images | grep -q "gitleaks"; then
      echo "⚠️ Gitleaks Docker image not found. Pulling..."
      docker pull ghcr.io/gitleaks/gitleaks:latest
    fi

    echo "✅ Gitleaks is ready to use via Docker!"
    echo "Run: docker run --rm ghcr.io/gitleaks/gitleaks version"
  fi
else
  echo "✅ Gitleaks is available: $(which gitleaks)"
fi
