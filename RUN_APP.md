# 🚀 Run PThrive App - Simple Instructions

## ✅ Everything is Ready!

Your app is configured and ready to run. Follow these simple steps:

### Step 1: Make Sure Backend is Running

Open a terminal and run:
```powershell
cd C:\Users\antom\Music\PThrive\backend
npm run dev
```

You should see:
```
✅ Server running on port 3000
🌐 Network access: http://192.168.61.96:3000/health
```

### Step 2: Run the Flutter App

Open another terminal and run:
```powershell
cd C:\Users\antom\Music\PThrive\frontend
flutter run
```

**Note**: Don't use `--release` for now. Debug mode is faster for first build.

### Step 3: Wait for Build

The first build takes **5-10 minutes**. You'll see:
```
Running Gradle task 'assembleDebug'...
```

Just wait. It's downloading dependencies and building.

### Step 4: App Launches

When build completes:
- App installs on your phone automatically
- App launches automatically
- You'll see the splash screen
- Then the login screen

### Step 5: Test Registration

1. Click "Register Now"
2. Fill in your details
3. Click "Create Account"
4. Should navigate to Dashboard!

## 🎯 Quick Commands

**Backend**:
```powershell
cd backend
npm run dev
```

**Frontend**:
```powershell
cd frontend
flutter run
```

**Check Device**:
```powershell
flutter devices
```

**Clean Build** (if needed):
```powershell
flutter clean
flutter pub get
flutter run
```

## ✅ Configuration Summary

- **Backend**: http://192.168.61.96:3000
- **Device**: RMX3771 (your Realme phone)
- **Database**: Supabase (connected)
- **API**: Configured for your IP

## 🔧 If Build Fails

1. **Stop any running builds**: Press Ctrl+C
2. **Clean**: `flutter clean`
3. **Get dependencies**: `flutter pub get`
4. **Run again**: `flutter run`

## 📱 After App Launches

Test the full flow:
1. Splash screen (3 seconds)
2. Login screen
3. Click "Register Now"
4. Fill form and register
5. Dashboard appears
6. Check Supabase - your user is there!

---

**Just run these two commands in separate terminals:**

Terminal 1:
```
cd backend && npm run dev
```

Terminal 2:
```
cd frontend && flutter run
```

That's it! 🚀
