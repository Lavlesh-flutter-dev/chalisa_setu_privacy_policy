#!/bin/bash
set -e  # Exit on any error

# Update packages and install dependencies
apt-get update -y
apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# Clone and set up Flutter SDK (stable channel)
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"
flutter doctor --android-licenses || true  # Accept licenses non-interactively
flutter precache --web  # Cache web-specific tools

# Get Flutter dependencies
flutter pub get

# Build the web app
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true