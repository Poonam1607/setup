#!/bin/bash

set -e  # Exit script on any error

echo "🔍 Checking for Gitleaks installation..."
export PATH="/opt/homebrew/bin:$PATH"  # Ensure Homebrew-installed binaries are found

if command -v gitleaks &>/dev/null; then
    echo "✅ Gitleaks is already installed: $(which gitleaks)"
else
    echo "⚠️ Gitleaks not found. Installing..."

    OS_TYPE=$(uname -s)
    INSTALL_SUCCESS=false

    if [[ "$OS_TYPE" == "Linux" ]]; then
        curl -sSLo gitleaks.tar.gz https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-linux-amd64.tar.gz && \
        tar -xzf gitleaks.tar.gz gitleaks && \
        chmod +x gitleaks && \
        sudo mv gitleaks /usr/local/bin/ && \
        rm -f gitleaks.tar.gz && \
        INSTALL_SUCCESS=true
    elif [[ "$OS_TYPE" == "Darwin" ]]; then
        if brew install gitleaks; then
            export PATH="/opt/homebrew/bin:$PATH"
            INSTALL_SUCCESS=true
        fi
    else
        echo "❌ Unsupported OS: $OS_TYPE"
        exit 1
    fi

    if [[ "$INSTALL_SUCCESS" == "true" ]]; then
        echo "✅ Gitleaks installed successfully!"
    else
        echo "❌ Gitleaks installation failed!"
    fi
fi

echo "🔍 Verifying Gitleaks installation..."
if command -v gitleaks &>/dev/null; then
    echo "✅ Gitleaks is available: $(which gitleaks)"
    exit 0  # Exit script if Gitleaks is installed
fi

echo "⚠️ Gitleaks installation failed. Using Docker as fallback."

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

echo "✅ Setup completed!"
