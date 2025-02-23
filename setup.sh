#!/bin/bash

set -e  # Exit script on any error

echo "🔍 Checking for Gitleaks installation..."
export PATH="/opt/homebrew/bin:$PATH"  # Ensure Homebrew-installed binaries are found

if command -v gitleaks &>/dev/null; then
    echo "✅ Gitleaks is already installed: $(which gitleaks)"
else
    echo "⚠️ Gitleaks not found. Installing..."

    OS_TYPE=$(uname -s)

    if [[ "$OS_TYPE" == "Linux" ]]; then
        curl -sSLo gitleaks.tar.gz https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-linux-amd64.tar.gz
        tar -xzf gitleaks.tar.gz gitleaks
        chmod +x gitleaks
        sudo mv gitleaks /usr/local/bin/
        rm -f gitleaks.tar.gz
    elif [[ "$OS_TYPE" == "Darwin" ]]; then
        brew install gitleaks
        export PATH="/opt/homebrew/bin:$PATH"  # Update PATH after installation
    else
        echo "❌ Unsupported OS: $OS_TYPE"
        exit 1
    fi

    echo "✅ Gitleaks installed successfully!"
fi

echo "🔍 Verifying Gitleaks installation..."
if command -v gitleaks &>/dev/null; then
    echo "✅ Gitleaks is available: $(which gitleaks)"
else
    echo "❌ Gitleaks installation failed! Check Homebrew or PATH settings."
    exit 1
fi

echo "🔍 Checking for Docker installation..."
if command -v docker &>/dev/null; then
    echo "✅ Docker is already installed: $(which docker)"
else
    echo "⚠️ Docker not found. Installing..."

    if [[ "$OS_TYPE" == "Linux" ]]; then
        sudo apt-get update
        sudo apt-get install -y docker.io
    elif [[ "$OS_TYPE" == "Darwin" ]]; then
        brew install --cask docker
    else
        echo "❌ Unsupported OS: $OS_TYPE"
        exit 1
    fi

    echo "✅ Docker installed successfully!"
fi

echo "🔍 Checking if Docker daemon is running..."
if (! docker stats --no-stream &>/dev/null); then
    echo "⚠️ Docker is not running. Attempting to start..."
    open -a Docker
    sleep 10  # Wait for Docker to start
fi

echo "🔍 Checking if Gitleaks Docker image is available..."
if docker images | grep -q "gitleaks"; then
    echo "✅ Gitleaks Docker image is already pulled."
else
    echo "⚠️ Gitleaks Docker image not found. Pulling..."
    docker pull ghcr.io/gitleaks/gitleaks:latest
    echo "✅ Gitleaks Docker image pulled successfully!"
fi

echo "🚀 Running Gitleaks scan..."
if command -v gitleaks &>/dev/null; then
    gitleaks detect --verbose
else
    echo "⚠️ Local Gitleaks installation failed. Running in Docker instead..."
    docker run --rm -v "$(pwd):/repo" ghcr.io/gitleaks/gitleaks:latest detect --source="/repo"
fi

echo "✅ Setup completed!"
