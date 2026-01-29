# Platform-Specific Setup Guide

This guide covers Android and iOS specific configurations for PThrive.

## Android Setup

### Prerequisites
- Android Studio installed
- Android SDK (API 21+)
- Java JDK 11 or higher

### Configuration

1. **Permissions** (Already configured in AndroidManifest.xml):
   - Internet access
   - Network state access

2. **Splash Screen**:
   - Native splash with blue gradient (#2196F3 to #00BCD4)
   - Centered white heart icon
   - Android 12+ adaptive splash screen support
   - Portrait orientation locked

3. **Build Configuration**:
   - Min SDK: 21 (Android 5.0)
   - Target SDK: 34 (Android 14)
   - Compile SDK: 34

### Testing on Android

```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Run in release mode (to see native splash)
flutter run --release

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### Android Emulator Setup

1. Open Android Studio
2. Tools → Device Manager
3. Create Virtual Device
4. Select Pixel 5 or similar
5. Download system image (API 33 recommended)
6. Start emulator
7. Run `flutter run`

## iOS Setup

### Prerequisites (Mac only)
- Xcode 14.0 or higher
- CocoaPods installed
- iOS 12.0+ deployment target

### Configuration

1. **Install CocoaPods** (if not installed):
```bash
sudo gem install cocoapods
```

2. **Setup iOS project**:
```bash
cd frontend/ios
pod install
```

3. **Splash Screen**:
   - Native LaunchScreen.storyboard
   - Blue background (#2196F3)
   - Centered white heart icon
   - No Flutter default splash

4. **Info.plist Configuration** (Already set):
   - Portrait orientation only
   - Display name: PThrive
   - Bundle identifier: com.pthrive.app

### Testing on iOS

```bash
# List available iOS simulators
flutter devices

# Run on iOS simulator
flutter run -d ios

# Run in release mode
flutter run --release -d ios

# Build for iOS
flutter build ios --release
```

### iOS Simulator Setup

1. Open Xcode
2. Xcode → Open Developer Tool → Simulator
3. File → Open Simulator → Choose device (iPhone 14 recommended)
4. Run `flutter run -d ios`

### Testing on Physical iOS Device

1. Connect iPhone/iPad via USB
2. Open Xcode
3. Open `frontend/ios/Runner.xcworkspace`
4. Select your device in Xcode
5. Sign the app with your Apple Developer account
6. Run `flutter run`

## Native Splash Screen Setup

### Step 1: Create Splash Icon

Create a 512x512px PNG image:
- White rounded square background
- Blue heart icon in center
- Transparent padding around edges
- Save as: `frontend/assets/images/splash_icon.png`

### Step 2: Generate Native Assets

```bash
cd frontend
flutter pub get
dart run flutter_native_splash:create
```

This automatically generates:
- Android splash screens (all densities: mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- iOS splash screens (1x, 2x, 3x)
- Android 12+ adaptive splash
- Launch backgrounds for both platforms

### Step 3: Verify

**Android**: Check these files were created:
- `android/app/src/main/res/drawable*/splash_icon.png`
- `android/app/src/main/res/drawable*/launch_background.xml`

**iOS**: Check these files were created:
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- `ios/Runner/Base.lproj/LaunchScreen.storyboard`

## App Icons

### Generate App Icons for Both Platforms

1. Create 1024x1024px app icon
2. Save as: `frontend/assets/images/app_icon.png`
3. Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#2196F3"
  adaptive_icon_foreground: "assets/images/app_icon.png"
  remove_alpha_ios: true
```

4. Generate icons:
```bash
flutter pub get
dart run flutter_launcher_icons
```

## Platform-Specific Features

### Android

**Status Bar**:
- Transparent status bar
- Light icons on splash (blue background)
- Dark icons on app (white background)

**Navigation Bar**:
- White background
- Dark icons

**Orientation**:
- Portrait only (locked in AndroidManifest.xml)

### iOS

**Status Bar**:
- Light content on splash
- Dark content on app

**Safe Area**:
- Automatically handled by Flutter
- Respects notch on iPhone X+

**Orientation**:
- Portrait only (set in Info.plist)

## Troubleshooting

### Android Issues

**Gradle build fails**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Splash screen not showing**:
- Only shows in release mode or on physical devices
- Run: `flutter run --release`

**SDK version errors**:
- Update `android/app/build.gradle`
- Ensure compileSdk and targetSdk are 34

### iOS Issues

**Pod install fails**:
```bash
cd ios
pod deintegrate
pod install --repo-update
```

**Xcode build fails**:
- Open `ios/Runner.xcworkspace` in Xcode
- Product → Clean Build Folder
- Try building from Xcode first

**Splash screen not showing**:
- Check LaunchScreen.storyboard exists
- Verify LaunchImage assets are present
- Clean and rebuild

**Signing errors**:
- Open project in Xcode
- Select Runner target
- Signing & Capabilities tab
- Select your team/account

## Release Builds

### Android Release

```bash
# Generate signing key (first time only)
keytool -genkey -v -keystore ~/pthrive-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pthrive

# Create key.properties file
# android/key.properties:
storePassword=<password>
keyPassword=<password>
keyAlias=pthrive
storeFile=<path-to-jks>

# Build release APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS Release

```bash
# Build for release
flutter build ios --release

# Open in Xcode for archiving
open ios/Runner.xcworkspace

# In Xcode:
# Product → Archive
# Distribute App → App Store Connect
```

## Performance Optimization

### Both Platforms

- Native splash screens load instantly
- No Flutter engine initialization delay on splash
- Smooth transition from native to Flutter
- Optimized asset loading

### Testing Performance

```bash
# Profile mode (performance profiling)
flutter run --profile

# Release mode (production performance)
flutter run --release
```

## Next Steps

1. Add your splash icon image
2. Generate native splash screens
3. Test on both Android and iOS
4. Customize app icons
5. Test release builds
6. Prepare for app store submission
