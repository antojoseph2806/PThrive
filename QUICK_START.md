# PThrive - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Backend Setup (2 minutes)

1. **Install dependencies**:
```bash
cd backend
npm install
```

2. **Configure Supabase**:
```bash
cp .env.example .env
```
Edit `.env` and add your Supabase credentials from [supabase.com](https://supabase.com)

3. **Setup database**:
- Go to Supabase Dashboard → SQL Editor
- Copy and run SQL from `backend/database/schema.sql`

4. **Start server**:
```bash
npm run dev
```
✅ Backend running on http://localhost:3000

---

### Frontend Setup (3 minutes)

1. **Install dependencies**:
```bash
cd frontend
flutter pub get
```

2. **Add splash icon** (Required):
- Create a 512x512px PNG with your splash design
- Save as: `frontend/assets/images/splash_icon.png`
- Or use a placeholder for now

3. **Generate native splash screens**:
```bash
dart run flutter_native_splash:create
```

4. **Run the app**:

**For Android**:
```bash
flutter run
```

**For iOS** (Mac only):
```bash
cd ios
pod install
cd ..
flutter run -d ios
```

✅ App running on your device/emulator!

---

## 📱 Platform-Specific Notes

### Android
- **Min SDK**: Android 5.0 (API 21)
- **Target SDK**: Android 14 (API 34)
- **Orientation**: Portrait only
- **Native splash**: Blue gradient with centered icon
- **Android 12+**: Adaptive splash screen support

### iOS
- **Min Version**: iOS 12.0
- **Orientation**: Portrait only
- **Native splash**: LaunchScreen.storyboard with blue background
- **Requires**: Xcode 14+ (Mac only)

---

## 🎨 Native Splash Screen (No Flutter Default)

This app uses **native splash screens** for both platforms:

✅ **Android**: Native splash with gradient background
✅ **iOS**: LaunchScreen.storyboard with custom design
❌ **No Flutter default splash** - Removed for better UX

### To customize splash:
1. Add your icon: `frontend/assets/images/splash_icon.png`
2. Run: `dart run flutter_native_splash:create`
3. Done! Native splash screens generated for both platforms

---

## 🧪 Testing

### Test Backend API:
```bash
curl http://localhost:3000/health
```

### Test on Android Emulator:
```bash
flutter emulators --launch <emulator_id>
flutter run
```

### Test on iOS Simulator:
```bash
open -a Simulator
flutter run -d ios
```

### Test Release Build (to see native splash):
```bash
flutter run --release
```

---

## 📂 Project Structure

```
PThrive/
├── backend/              # Node.js API
│   ├── src/
│   │   ├── routes/      # Auth, User, Sessions, Exercises
│   │   ├── config/      # Supabase config
│   │   └── middleware/  # JWT auth
│   └── database/        # SQL schema
│
└── frontend/            # Flutter app
    ├── lib/
    │   ├── screens/     # Splash, Login, Register, Dashboard
    │   ├── providers/   # State management
    │   ├── services/    # API calls
    │   └── widgets/     # Reusable components
    ├── android/         # Android native config
    └── ios/             # iOS native config
```

---

## 🔧 Troubleshooting

### Backend won't start?
- Check `.env` file exists and has valid Supabase credentials
- Verify Node.js version: `node --version` (need v18+)
- Check port 3000 is not in use

### Flutter build fails?
```bash
flutter clean
flutter pub get
flutter run
```

### Splash screen not showing?
- Native splash only shows in release mode or on physical devices
- Run: `flutter run --release`
- Verify splash icon exists: `frontend/assets/images/splash_icon.png`

### iOS pod install fails?
```bash
cd ios
pod deintegrate
pod install --repo-update
```

---

## 📚 Documentation

- **SETUP_GUIDE.md** - Complete setup instructions
- **PLATFORM_SETUP.md** - Android & iOS specific configuration
- **SPLASH_SETUP.md** - Native splash screen details
- **CHECKLIST.md** - Build completion checklist

---

## ✨ What's Included

✅ Native splash screens (Android & iOS)
✅ User authentication (register/login)
✅ JWT token management
✅ Supabase database integration
✅ State management with Provider
✅ Form validation
✅ Google OAuth design (ready for implementation)
✅ Portrait orientation locked
✅ Status bar configuration
✅ Material Design UI

---

## 🎯 Next Steps

1. ✅ Setup backend and database
2. ✅ Run Flutter app
3. 🔄 Add your splash icon
4. 🔄 Test on both Android and iOS
5. 🔄 Implement Google OAuth
6. 🔄 Add session booking features
7. 🔄 Build exercise tracking
8. 🔄 Create progress reports

---

**Need help?** Check the documentation files or create an issue.

**Ready to build?** Start with `cd backend && npm run dev` 🚀
