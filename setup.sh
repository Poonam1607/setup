#!/bin/bash

echo ""
echo "🚀 Welcome to AnythingOps Setup!"
echo "================================="

# Function to display help menu
show_help() {
  echo ""
  echo "📖 Usage: anythingops [OPTION]"
  echo "---------------------------------"
  echo "Available options:"
  echo "  --help         Show this help menu"
  echo "  --gitleaks     Install and guide for Gitleaks (Secret Detection)"
  echo "  --gitleaks scan  Run Gitleaks to scan for secrets and generate a report"
  echo "  --docker       Install and guide for Docker (Containerization)"
  echo "---------------------------------"
  echo ""
  exit 0
}

# If no arguments are provided, show help
if [[ "$#" -eq 0 ]]; then
  echo "❌ No options provided. Use --help to see available commands."
  exit 1
fi

# ---------------------------------
# 📖 Show Help Menu
# ---------------------------------
if [[ "$1" == "--help" ]]; then
  show_help
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
      echo "⚡ Downloading Docker Desktop..."
      curl -L -o Docker.dmg "https://desktop.docker.com/mac/main/arm64/Docker.dmg"

      echo "📂 Mounting the DMG file..."
      hdiutil attach Docker.dmg

      echo "🚀 Installing Docker..."
      sudo cp -R "/Volumes/Docker/Docker.app" /Applications

      echo "⏳ Unmounting and cleaning up..."
      hdiutil detach "/Volumes/Docker"
      rm Docker.dmg

      echo "✅ Docker installed successfully! Open it from Applications and allow permissions."
      
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
    echo "✅ Build an image: docker build -t my-app ."
    echo "✅ Run a container: docker run -d --name my-container -p 8080:8080 my-app"
    echo "✅ Stop a container: docker stop my-container"
    echo "✅ Remove a container: docker rm my-container"
    echo "✅ View logs: docker logs my-container"
    echo "🎯 More info: https://docs.docker.com/get-started/"
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
# 🔍 Gitleaks Scan for Secrets
# ---------------------------------
if [[ "$1" == "--gitleaks" && "$2" == "scan" ]]; then
  SCAN_PATH="${3:-.}"  # If a third argument is given, use it; otherwise, default to "."

  echo ""
  echo "🔍 Running Gitleaks scan for secrets in: $SCAN_PATH"
  echo "---------------------------------"

  if ! command -v gitleaks &>/dev/null; then
    echo "❌ Gitleaks not found. Please run: anythingops --gitleaks"
    exit 1
  fi

  gitleaks detect -v --source="$SCAN_PATH" --report-path=gitleaks_report.json --report-format=json

  echo ""
  echo "✅ Scan completed! Report saved as 'gitleaks_report.json'."
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
        echo "❌ Chocolatey not found. Install Chocolatey first: https://chocolatey.org/install"
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
    echo "✅ Check version: gitleaks version"
    echo "✅ Run anythingops --gitleaks scan"
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
# 🔍 Gitleaks Scan for Input Text
# ---------------------------------
if [[ "$1" == "--gitleaks" && "$2" == "scan-text" ]]; then
  INPUT_TEXT="$3"

  if [[ -z "$INPUT_TEXT" ]]; then
    echo "❌ No input text provided. Usage: anythingops --gitleaks scan-text 'your text here'"
    exit 1
  fi

  echo ""
  echo "🔍 Scanning provided text for secrets..."
  echo "---------------------------------"

  if ! command -v gitleaks &>/dev/null; then
    echo "❌ Gitleaks not found. Please run: anythingops --gitleaks"
    exit 1
  fi

  # Create a temporary file to scan the text
  TEMP_FILE=$(mktemp)
  echo "$INPUT_TEXT" > "$TEMP_FILE"

  # Run gitleaks on the temporary file
  gitleaks detect -v --source="$TEMP_FILE" --report-path=gitleaks_text_report.json --report-format=json

  # Clean up
  rm "$TEMP_FILE"

  echo ""
  echo "✅ Scan completed! Report saved as 'gitleaks_text_report.json'."
  echo "================================="
  exit 0
fi

# ---------------------------------
# 🚀 Unsupported Option
# ---------------------------------
echo ""
echo "❌ Invalid option: $1"
echo "Use --help to see available commands."
echo "================================="
exit 1

# ---------------------------------
# 🚀 Unsupported Option
# ---------------------------------
echo ""
echo "❌ Invalid option: $1"
echo "Use --help to see available commands."
echo "================================="
exit 1
