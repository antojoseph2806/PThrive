# App Icon Setup Guide

## Quick Setup (Recommended)

The easiest way to generate all icon sizes is to use an online tool or Flutter package.

### Option 1: Using flutter_launcher_icons package (Recommended)

1. Add to `pubspec.yaml` under `dev_dependencies`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

2. Add configuration at the end of `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#5B4E9F"
  adaptive_icon_foreground: "assets/images/app_icon.png"
```

3. Save your icon as `frontend/assets/images/app_icon.png` (1024x1024 recommended)

4. Run in terminal:
```bash
cd frontend
flutter pub get
flutter pub run flutter_launcher_icons
```

### Option 2: Manual Setup

Save your icon in different sizes to these locations:

**Android Icon Locations:**
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)

## Online Icon Generator

You can use these free tools to generate all sizes:
- https://icon.kitchen/
- https://appicon.co/
- https://easyappicon.com/

Upload your logo and download the Android icon pack, then replace the files in the mipmap folders.

## Current Icon Files

Your current icon files are located at:
- frontend/android/app/src/main/res/mipmap-*/ic_launcher.png

Replace these files with your new icon in the appropriate sizes.
