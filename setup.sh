#!/bin/bash

set -e  # Exit on any error

### STEP 1: CHECK & INSTALL DOCKER (WITHOUT STARTING IT) ###
echo "🔍 Checking for Docker installation..."
if command -v docker &>/dev/null; then
    echo "✅ Docker is installed: $(which docker)"
else
    echo "⚠️ Docker not found. Installing..."
    
    OS_TYPE=$(uname -s)
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

### STEP 2: CHECK & INSTALL GITLEAKS ###
echo "🔍 Checking for Gitleaks installation..."
export PATH="/opt/homebrew/bin:$PATH"

if command -v gitleaks &>/dev/null; then
    echo "✅ Gitleaks is already installed: $(which gitleaks)"
    exit 0  # Exit since Gitleaks is already installed
fi

echo "⚠️ Gitleaks not found. Installing..."
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
fi

if [[ "$INSTALL_SUCCESS" == "true" ]]; then
    echo "✅ Gitleaks installed successfully!"
    exit 0  # Exit if Gitleaks is installed
else
    echo "❌ Gitleaks installation failed!"
fi

### STEP 3: FALLBACK TO DOCKER IF GITLEAKS INSTALLATION FAILED ###
echo "⚠️ Gitleaks installation failed. Using Docker as fallback."

echo "🔍 Checking if Gitleaks Docker image is available..."
if docker images | grep -q "gitleaks"; then
    echo "✅ Gitleaks Docker image is already pulled."
    exit 0
fi

echo "⚠️ Gitleaks Docker image not found. Checking if Docker daemon is running..."
if ! docker info &>/dev/null; then
    echo "⚠️ Docker daemon is not running. Attempting to start..."
    
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        open -a Docker
        sleep 10  # Give Docker some time to start
    else
        sudo systemctl start docker
    fi

    # Wait for Docker to be ready
    for i in {1..10}; do
        if docker info &>/dev/null; then
            echo "✅ Docker daemon started successfully!"
            break
        fi
        echo "⏳ Waiting for Docker to start... ($i/10)"
        sleep 3
    done

    if ! docker info &>/dev/null; then
        echo "❌ Docker failed to start. Please start it manually."
        exit 1
    fi
fi

echo "🔍 Pulling Gitleaks Docker image..."
if docker pull ghcr.io/gitleaks/gitleaks:latest; then
    echo "✅ Gitleaks Docker image pulled successfully!"
else
    echo "❌ Failed to pull Gitleaks Docker image!"
    exit 1
fi

echo "✅ Setup completed!"
