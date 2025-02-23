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

# 📢 Display usage guide after successful installation
echo ""
echo "🚀 Gitleaks Installation Complete!"
echo "=================================="
echo "✅ How to Use Gitleaks CLI (installed natively):"
echo "   - Run a scan in your repo:   gitleaks detect -v"
echo "   - Generate a report:         gitleaks detect -v --report=gitleaks_report.json"
echo "   - Check version:             gitleaks version"
echo ""
echo "✅ How to Use Gitleaks with Docker:"
echo "   - Run a scan in your repo:   docker run --rm -v \$(pwd):/repo ghcr.io/gitleaks/gitleaks detect -v --source=/repo"
echo "   - Generate a report:         docker run --rm -v \$(pwd):/repo ghcr.io/gitleaks/gitleaks detect -v --source=/repo --report=gitleaks_report.json"
echo "   - Check version:             docker run --rm ghcr.io/gitleaks/gitleaks version"
echo ""
echo "🎯 Need More? Visit: https://github.com/gitleaks/gitleaks"

echo ""
echo "=================================="
echo "🚀 Docker Usage Guide"
echo "=================================="
echo "✅ Step 1: Open Docker Desktop"
echo ""
echo "✅ Step 2: Navigate to Your App Repository"
echo "   Run: cd /path/to/your/app"
echo ""
echo "✅ Step 3: Build a Docker Image"
echo "   Run: docker build -t my-app ."
echo "   (Replace 'my-app' with your preferred image name)"
echo ""
echo "✅ Step 4: Run a Docker Container"
echo "   Run: docker run -d --name my-container -p 8080:8080 my-app"
echo "   - '-d': Runs container in the background"
echo "   - '--name': Assigns a name to the container"
echo "   - '-p 8080:8080': Maps host port 8080 to container port 8080"
echo ""
echo "✅ Step 5: Check Running Containers"
echo "   Run: docker ps"
echo ""
echo "✅ Step 6: View Container Logs"
echo "   Run: docker logs my-container"
echo ""
echo "✅ Step 7: Stop & Remove a Container"
echo "   Run: docker stop my-container && docker rm my-container"
echo ""
echo "✅ Step 8: Remove a Docker Image"
echo "   Run: docker rmi my-app"
echo ""
echo "🎯 Need More? Visit: https://docs.docker.com/get-started/"
echo "=================================="
echo "✅ Setup completed!"
