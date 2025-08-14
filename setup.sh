#!/bin/bash

# Aflam Quick Setup Script
# This script helps new developers set up the project quickly

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
echo "🎬 Aflam Movie Discovery App - Quick Setup"
echo "=========================================="
echo -e "${NC}"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed. Please install Flutter first.${NC}"
    echo -e "${YELLOW}Visit: https://docs.flutter.dev/get-started/install${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter found${NC}"

# Check Flutter version
echo -e "${YELLOW}🔍 Checking Flutter setup...${NC}"
flutter doctor

# Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"
flutter pub get

# Generate Hive adapters
echo -e "${YELLOW}🔄 Generating Hive adapters...${NC}"
flutter packages pub run build_runner build

# Check for API key
if [ ! -f "lib/core/secrets/secrets.dart" ]; then
    echo -e "${YELLOW}⚠️  Setting up API configuration...${NC}"
    cp lib/core/secrets/secrets.dart.template lib/core/secrets/secrets.dart
    echo -e "${RED}📝 IMPORTANT: Edit lib/core/secrets/secrets.dart and add your TMDB API key${NC}"
    echo -e "${BLUE}   1. Visit: https://www.themoviedb.org/settings/api${NC}"
    echo -e "${BLUE}   2. Create an account and request an API key${NC}"
    echo -e "${BLUE}   3. Replace 'YOUR_TMDB_API_KEY_HERE' with your actual key${NC}"
else
    echo -e "${GREEN}✅ API configuration found${NC}"
fi

# Make development script executable
chmod +x scripts/dev.sh

echo -e "${GREEN}"
echo "🎉 Setup complete!"
echo "=================="
echo -e "${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "${YELLOW}1. Add your TMDB API key to lib/core/secrets/secrets.dart${NC}"
echo -e "${YELLOW}2. Run 'flutter run' to start the app${NC}"
echo -e "${YELLOW}3. Use './scripts/dev.sh' for common development tasks${NC}"
echo ""
echo -e "${BLUE}Useful commands:${NC}"
echo -e "${YELLOW}• flutter run                    # Run the app${NC}"
echo -e "${YELLOW}• flutter run --profile         # Run in profile mode${NC}"
echo -e "${YELLOW}• flutter build apk --release   # Build APK${NC}"
echo -e "${YELLOW}• ./scripts/dev.sh              # Development helper${NC}"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
