# Assets Directory

Place your image assets here.

## Required Images

### Splash Icon
- **File**: `splash_icon.png`
- **Size**: 512x512px
- **Format**: PNG with transparency
- **Design**: White rounded square with blue heart icon (matching your splash screen design)

### App Icon (Optional)
- **File**: `app_icon.png`
- **Size**: 1024x1024px
- **Format**: PNG
- **Design**: Your app icon for home screen

## After Adding Images

Run this command to generate native splash screens:
```bash
cd frontend
flutter pub get
dart run flutter_native_splash:create
```

This will automatically create all required splash screen assets for Android and iOS.
