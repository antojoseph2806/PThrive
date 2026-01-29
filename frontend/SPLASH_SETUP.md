# Native Splash Screen Setup

This app uses native splash screens for both Android and iOS (no Flutter default splash).

## Required Assets

You need to create a splash icon image and place it in the assets folder:

### Create the splash icon:
1. Create a white rounded square icon with a blue heart (matching your design)
2. Size: 512x512px PNG with transparency
3. Save as: `frontend/assets/images/splash_icon.png`

## Generate Native Splash Screens

After adding the splash icon image, run:

```bash
cd frontend
flutter pub get
dart run flutter_native_splash:create
```

This will automatically generate:
- Android splash screens (all densities)
- iOS splash screens (all sizes)
- Android 12+ splash screen
- Proper launch backgrounds

## Manual Asset Placement (Alternative)

If you want to manually add splash icons:

### Android
Place splash icon in these folders:
- `android/app/src/main/res/drawable/splash_icon.png` (192x192)
- `android/app/src/main/res/drawable-mdpi/splash_icon.png` (128x128)
- `android/app/src/main/res/drawable-hdpi/splash_icon.png` (192x192)
- `android/app/src/main/res/drawable-xhdpi/splash_icon.png` (256x256)
- `android/app/src/main/res/drawable-xxhdpi/splash_icon.png` (384x384)
- `android/app/src/main/res/drawable-xxxhdpi/splash_icon.png` (512x512)

### iOS
Place splash icon in:
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png` (100x100)
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png` (200x200)
- `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png` (300x300)

## Design Specifications

### Colors
- Background gradient: #2196F3 to #00BCD4 (top to bottom)
- Icon: White rounded square with blue heart
- Status bar: Transparent with light icons

### Behavior
1. Native splash shows immediately on app launch
2. Blue gradient background with centered icon
3. Transitions to Flutter splash screen (with animation)
4. Then navigates to login screen

## Testing

### Android
```bash
flutter run --release
```

### iOS
```bash
flutter run --release -d ios
```

Note: Splash screens only show properly in release mode or on physical devices.

## App Icons

To generate app icons for both platforms:

1. Create app icon: 1024x1024px PNG
2. Save as: `assets/images/app_icon.png`
3. Add to pubspec.yaml:
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#2196F3"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
```
4. Run: `dart run flutter_launcher_icons`
