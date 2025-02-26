#!/bin/bash

# Function to prompt user for guide with custom messages
show_guide_prompt() {
  local tool_name=$1
  local guide_function=$2
  local decline_message=$3

  read -p "❓ Do you need a user guide for $tool_name? (yes/no): " response
  case "$response" in
    [yY][eE][sS]|[yY])
      echo ""
      "$guide_function"  # Call the guide function dynamically
      ;;
    [nN][oO]|[nN])
      echo ""
      echo "$decline_message"
      echo ""
      ;;
    *)
      echo "❌ Invalid response. Skipping guide."
      ;;
  esac
}

# Function to display Docker usage guide
docker_usage_guide() {
  echo "=================================="
  echo "🚀 Docker Usage Guide"
  echo "=================================="
  echo "✅ Step 1: Open Docker Desktop"
  echo "✅ Step 2: Navigate to Your App Repository"
  echo "✅ Step 3: Build & Run Containers"
  echo "🎯 Need More? Visit: https://docs.docker.com/get-started/"
  echo "=================================="
}

# Function to display Gitleaks usage guide
gitleaks_usage_guide() {
  echo "=================================="
  echo "🚀 Gitleaks Usage Guide"
  echo "=================================="
  echo "✅ Run a scan in your repo:   gitleaks detect -v"
  echo "✅ Generate a report:         gitleaks detect -v --report=gitleaks_report.json"
  echo "🎯 Need More? Visit: https://github.com/gitleaks/gitleaks"
  echo "=================================="
}

# Function to display Nginx Scan usage guide
nginx_scan_usage_guide() {
  echo "=================================="
  echo "🚀 Nginx Security Scan Guide"
  echo "=================================="
  echo "✅ Scan for vulnerabilities:  nginx -t"
  echo "✅ Check Nginx config:        nginx -T"
  echo "🎯 Need More? Visit: https://nginx.org/en/docs/"
  echo "=================================="
}

# Function to install Docker
install_docker() {
  echo "🔍 Checking for Docker installation..."
  if ! command -v docker &>/dev/null; then
    echo "⚠️ Docker not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "🍏 Detected macOS."
      brew install --cask docker
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      echo "🐧 Detected Linux."
      sudo apt-get update && sudo apt-get install -y docker.io
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
      echo "🖥️ Detected Windows OS."
      if ! command -v choco &>/dev/null; then
        echo "❌ Chocolatey not found. Please install Chocolatey first: https://chocolatey.org/install"
        exit 1
      fi
      choco install docker-desktop -y
    else
      echo "❌ Unsupported OS for automatic Docker installation. Install it manually."
      exit 1
    fi
    echo "✅ Docker installed successfully!"
  else
    echo "✅ Docker is installed: $(which docker)"
  fi

  show_guide_prompt "Docker" docker_usage_guide "🐳 You skipped the guide! But remember, a ship without a captain sinks. Set sail and deploy your containers wisely!"
}

# Function to install Gitleaks
install_gitleaks() {
  echo "🔍 Checking for Gitleaks installation..."
  if ! command -v gitleaks &>/dev/null; then
    echo "⚠️ Gitleaks not found. Installing..."
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
      echo "❌ Unsupported OS for automatic Gitleaks installation. Install it manually."
      exit 1
    fi
  fi

  echo "✅ Gitleaks installation complete!"
  show_guide_prompt "Gitleaks" gitleaks_usage_guide "😏 You're a pro! Go ahead and start saving your secrets... to get exposed by attackers! (Just kidding—stay secure!)"
}

# Function to install Nginx Scan
install_nginx_scan() {
  echo "🔍 Checking for Nginx installation..."
  if ! command -v nginx &>/dev/null; then
    echo "⚠️ Nginx not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "🍏 Detected macOS."
      brew install nginx
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      echo "🐧 Detected Linux."
      sudo apt-get install -y nginx
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
      echo "🖥️ Detected Windows OS."
      if ! command -v choco &>/dev/null; then
        echo "❌ Chocolatey not found. Please install Chocolatey first: https://chocolatey.org/install"
        exit 1
      fi
      choco install nginx -y
    else
      echo "❌ Unsupported OS for automatic Nginx installation. Install it manually."
      exit 1
    fi
  fi

  echo "✅ Nginx installation complete!"
  show_guide_prompt "Nginx Scan" nginx_scan_usage_guide "🚀 You skipped the guide! Hope your web server doesn’t turn into a bonfire! Stay safe and secure your Nginx."
}

# Check if no arguments are passed
if [[ $# -eq 0 ]]; then
  echo "❌ No arguments provided. Use --help to see available options."
  exit 1
fi

# Parse arguments
for arg in "$@"; do
  case $arg in
    --docker)
      install_docker
      ;;
    --gitleaks)
      install_gitleaks
      ;;
    --nginx)
      install_nginx_scan
      ;;
    --all)
      install_docker
      install_gitleaks
      install_nginx_scan
      ;;
    --help)
      echo "Usage: anythingops [OPTIONS]"
      echo "  --docker       Install Docker"
      echo "  --gitleaks     Install Gitleaks"
      echo "  --nginx        Install Nginx Scan"
      echo "  --all          Install everything"
      echo "  --help         Show this message"
      exit 0
      ;;
    *)
      echo "❌ Invalid option: $arg"
      exit 1
      ;;
  esac
done

echo "✅ Setup completed!"
