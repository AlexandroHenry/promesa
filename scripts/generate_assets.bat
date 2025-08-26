@echo off
echo 🕷️  Starting Spider asset generation...

REM Check if flutter is available
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    pause
    exit /b 1
)

REM Clean previous builds
echo 🧹 Cleaning previous builds...
flutter clean

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Run Spider to generate assets
echo 🕷️  Running Spider...
flutter packages pub run build_runner build --delete-conflicting-outputs

REM Check if assets were generated
if exist "lib\core\assets\assets.dart" (
    echo ✅ Assets generated successfully!
    echo 📁 Generated file: lib\core\assets\assets.dart
    echo.
    echo 🚀 Usage examples:
    echo    Assets.iconsUser.toSvgIcon()
    echo    Assets.logosAppLogo.toSvg()
    echo    Assets.imagesProfile.toImage()
    echo.
    echo ✨ Asset generation complete!
) else (
    echo ⚠️  Assets file not generated. Check for errors above.
    echo.
    echo 🔧 Troubleshooting:
    echo    1. Make sure you have assets in the assets/ folder
    echo    2. Check build.yaml configuration
    echo    3. Verify spider package is installed
    pause
    exit /b 1
)

pause