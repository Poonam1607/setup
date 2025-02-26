#!/bin/bash

echo ""
echo "🚀 Welcome to AnythingOps Setup!"
echo "================================="

# Parse command-line arguments
if [[ "$#" -eq 0 ]]; then
  echo "❌ No options provided. Please specify --gitleaks, --docker, or another tool."
  exit 1
fi

# ---------------------------------
# 🐳 Docker Installation
# ---------------------------------
if [[ "$1" == "--docker" ]]; then
  echo ""
  echo "🔍 Checking for Docker installation..."
  echo "---------------------------------"

  if ! command -v docker &>/dev/null; then
    echo ""
    echo "⚠️ Docker not found. Installing..."
    echo ""

    if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "🍏 Detected macOS."
      brew install --cask docker
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      echo "🐧 Detected Linux."
      sudo apt-get update && sudo apt-get install -y docker.io
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
      echo "🖥️ Detected Windows OS."
      echo "🔹 Please install Docker Desktop manually: https://www.docker.com/products/docker-desktop"
      exit 1
    else
      echo "❌ Unsupported OS for automatic Docker installation. Install manually."
      exit 1
    fi

    echo ""
    echo "✅ Docker installed successfully!"
    echo "---------------------------------"
  else
    echo ""
    echo "✅ Docker is already installed: $(which docker)"
    echo "---------------------------------"
  fi

  # Docker User Guide Prompt
  echo ""
  echo "❓ Do you need a user guide for Docker? (yes/no): "
  read -r user_choice
  echo ""

  if [[ "$user_choice" == "yes" ]]; then
    echo "📖 Here is your Docker user guide:"
    echo "================================="
    echo "✅ Step 1: Open Docker Desktop"
    echo "✅ Step 2: Navigate to Your App Repository"
    echo "   Run: cd /path/to/your/app"
    echo "✅ Step 3: Build a Docker Image"
    echo "   Run: docker build -t my-app ."
    echo "✅ Step 4: Run a Docker Container"
    echo "   Run: docker run -d --name my-container -p 8080:8080 my-app"
    echo "✅ Step 5: Check Running Containers"
    echo "   Run: docker ps"
    echo "✅ Step 6: View Container Logs"
    echo "   Run: docker logs my-container"
    echo "✅ Step 7: Stop & Remove a Container"
    echo "   Run: docker stop my-container && docker rm my-container"
    echo "✅ Step 8: Remove a Docker Image"
    echo "   Run: docker rmi my-app"
    echo "🎯 Need More? Visit: https://docs.docker.com/get-started/"
    echo "================================="
  else
    echo "🐳 You're a Docker expert! Go ahead and containerize the world!"
  fi

  echo ""
  echo "✅ Setup completed!"
  echo "================================="
  exit 0
fi

# ---------------------------------
# 🔒 Gitleaks Installation
# ---------------------------------
if [[ "$1" == "--gitleaks" ]]; then
  echo ""
  echo "🔍 Checking for Gitleaks installation..."
  echo "---------------------------------"

  if ! command -v gitleaks &>/dev/null; then
    echo ""
    echo "⚠️ Gitleaks not found. Installing..."
    echo ""

    if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "🍏 Detected macOS."
      brew install gitleaks
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      echo "🐧 Detected Linux."
      sudo apt-get install -y gitleaks
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
      echo "🖥️ Detected Windows OS."
      if ! command -v choco &>/dev/null; then
        echo "❌ Chocolatey not found. Please install Chocolatey first: https://chocolatey.org/install"
        exit 1
      fi
      choco install gitleaks -y
    else
      echo "❌ Unsupported OS for automatic Gitleaks installation. Install manually."
      exit 1
    fi

    echo ""
    echo "✅ Gitleaks installation complete!"
    echo "---------------------------------"
  else
    echo ""
    echo "✅ Gitleaks is already installed: $(which gitleaks)"
    echo "---------------------------------"
  fi

  # Gitleaks User Guide Prompt
  echo ""
  echo "❓ Do you need a user guide for Gitleaks? (yes/no): "
  read -r user_choice
  echo ""

  if [[ "$user_choice" == "yes" ]]; then
    echo "📖 Here is your Gitleaks user guide:"
    echo "================================="
    echo "✅ How to Use Gitleaks CLI:"
    echo "   - Run a scan in your repo:   gitleaks detect -v"
    echo "   - Generate a report:         gitleaks detect -v --report=gitleaks_report.json"
    echo "   - Check version:             gitleaks version"
    echo "================================="
  else
    echo "😏 You're a pro! Go ahead and start saving your secrets... to get exposed by attackers! (Just kidding—stay secure!)"
  fi

  echo ""
  echo "✅ Setup completed!"
  echo "================================="
  exit 0
fi

# ---------------------------------
# 🚀 Unsupported Option
# ---------------------------------
echo ""
echo "❌ Invalid option: $1"
echo "Usage: anythingops --gitleaks | --docker"
echo "================================="
exit 1
