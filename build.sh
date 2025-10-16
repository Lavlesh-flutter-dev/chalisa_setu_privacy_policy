#!/bin/bash
set -e  # Exit on any error

echo "Starting Flutter install and build..."

# Enable non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# Try with sudo; fallback message if fails (Vercel may not need it)
if command -v sudo >/dev/null 2>&1; then
  echo "Using sudo for apt..."
  sudo apt-get update -y
  sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
else
  echo "Sudo not available; trying without sudo..."
  apt-get update -y || apt update -y
  apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev || apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
fi

echo "Dependencies installed. Cloning Flutter..."

# Clone Flutter (pin to a specific stable version for consistency, e.g., latest as of Oct 2025; check flutter.dev for updates)
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

echo "Flutter cloned. Accepting licenses..."

# Better auto-accept: Use 'yes' for unlimited y
yes | flutter doctor --android-licenses || true
flutter precache --web

echo "Running pub get..."

# Get deps
flutter pub get

echo "Building web app..."

# Build (add --web-renderer canvaskit for better compatibility if needed)
flutter build web --release

echo "Build completed successfully!"