#!/bin/bash

# Spider Asset Generation Script
# This script generates type-safe asset classes using Spider

echo "🕷️  Starting Spider asset generation..."

# Check if flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run Spider to generate assets
echo "🕷️  Running Spider..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check if assets were generated
if [ -f "lib/core/assets/assets.dart" ]; then
    echo "✅ Assets generated successfully!"
    echo "📁 Generated file: lib/core/assets/assets.dart"
    
    # Show generated assets count
    asset_count=$(grep -c "static const String" lib/core/assets/assets.dart 2>/dev/null || echo "0")
    echo "🎯 Generated $asset_count asset references"
    
    echo ""
    echo "🚀 Usage examples:"
    echo "   Assets.iconsUser.toSvgIcon()"
    echo "   Assets.logosAppLogo.toSvg()"
    echo "   Assets.imagesProfile.toImage()"
    echo ""
    echo "✨ Asset generation complete!"
else
    echo "⚠️  Assets file not generated. Check for errors above."
    echo ""
    echo "🔧 Troubleshooting:"
    echo "   1. Make sure you have assets in the assets/ folder"
    echo "   2. Check build.yaml configuration"
    echo "   3. Verify spider package is installed"
    exit 1
fi