#!/bin/bash

# Aflam Development Helper Script
# This script provides common development commands for the Aflam project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

# Function to print section headers
print_header() {
    echo ""
    print_color $BLUE "📱 $1"
    echo "----------------------------------------"
}

# Function to run command with status
run_command() {
    print_color $YELLOW "Running: $1"
    if eval $1; then
        print_color $GREEN "✅ Success!"
    else
        print_color $RED "❌ Failed!"
        exit 1
    fi
}

# Main menu
show_menu() {
    print_header "Aflam Development Helper"
    echo "1. 🏗️  Setup project (first time)"
    echo "2. 🧹 Clean and rebuild"
    echo "3. 🔄 Generate code (Hive adapters)"
    echo "4. 🚀 Run app (debug)"
    echo "5. 🏃 Run app (profile)"
    echo "6. 📱 Build APK (release)"
    echo "7. 🧪 Run tests"
    echo "8. 🔍 Analyze code"
    echo "9. 📊 Check dependencies"
    echo "10. 📖 Generate documentation"
    echo "11. 🔧 Fix common issues"
    echo "0. 👋 Exit"
    echo ""
    read -p "Choose an option: " choice
}

# Setup project
setup_project() {
    print_header "Setting up Aflam project"
    run_command "flutter doctor"
    run_command "flutter pub get"
    run_command "flutter packages pub run build_runner build"
    print_color $GREEN "🎉 Project setup complete!"
    print_color $YELLOW "⚠️  Don't forget to add your TMDB API key in lib/core/secrets/secrets.dart"
}

# Clean and rebuild
clean_rebuild() {
    print_header "Cleaning and rebuilding project"
    run_command "flutter clean"
    run_command "flutter pub get"
    run_command "flutter packages pub run build_runner build --delete-conflicting-outputs"
}

# Generate code
generate_code() {
    print_header "Generating Hive adapters"
    run_command "flutter packages pub run build_runner build --delete-conflicting-outputs"
}

# Run app debug
run_debug() {
    print_header "Running app in debug mode"
    run_command "flutter run --debug"
}

# Run app profile
run_profile() {
    print_header "Running app in profile mode"
    run_command "flutter run --profile"
}

# Build APK
build_apk() {
    print_header "Building release APK"
    run_command "flutter build apk --release"
    print_color $GREEN "📱 APK built successfully!"
    print_color $BLUE "Location: build/app/outputs/flutter-apk/app-release.apk"
}

# Run tests
run_tests() {
    print_header "Running tests"
    run_command "flutter test"
}

# Analyze code
analyze_code() {
    print_header "Analyzing code"
    run_command "flutter analyze"
}

# Check dependencies
check_dependencies() {
    print_header "Checking dependencies"
    run_command "flutter pub deps"
    echo ""
    print_color $YELLOW "Outdated packages:"
    flutter pub outdated
}

# Generate documentation
generate_docs() {
    print_header "Generating documentation"
    run_command "dart doc"
    print_color $GREEN "📚 Documentation generated in doc/api/"
}

# Fix common issues
fix_issues() {
    print_header "Fixing common issues"
    print_color $YELLOW "1. Cleaning build cache..."
    flutter clean
    
    print_color $YELLOW "2. Getting dependencies..."
    flutter pub get
    
    print_color $YELLOW "3. Regenerating code..."
    flutter packages pub run build_runner clean
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    print_color $YELLOW "4. Checking for Flutter issues..."
    flutter doctor
    
    print_color $GREEN "🔧 Common issues fixed!"
}

# Main script execution
while true; do
    show_menu
    case $choice in
        1) setup_project ;;
        2) clean_rebuild ;;
        3) generate_code ;;
        4) run_debug ;;
        5) run_profile ;;
        6) build_apk ;;
        7) run_tests ;;
        8) analyze_code ;;
        9) check_dependencies ;;
        10) generate_docs ;;
        11) fix_issues ;;
        0) print_color $GREEN "👋 Goodbye!"; exit 0 ;;
        *) print_color $RED "❌ Invalid option. Please try again." ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
