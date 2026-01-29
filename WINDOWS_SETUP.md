# Windows Development Setup

## 🎯 You Have 3 Options to Run PThrive on Windows

### Option 1: Web Browser (Easiest - Already Running!) ✅

**Status**: ✅ Already configured and running!

```bash
cd frontend
flutter run -d chrome
```

**Pros:**
- ✅ No additional setup needed
- ✅ Fast development
- ✅ Works immediately
- ✅ Good for testing

**Cons:**
- ⚠️ Not a native mobile app
- ⚠️ Different UI behavior than mobile

---

### Option 2: Android Emulator (Recommended for Mobile Testing)

**Setup Steps:**

1. **Install Android Studio**
   - Download: https://developer.android.com/studio
   - Run installer
   - Follow setup wizard

2. **Install Android SDK**
   - Open Android Studio
   - Tools → SDK Manager
   - Install:
     - Android SDK Platform (API 34)
     - Android SDK Build-Tools
     - Android Emulator

3. **Create Virtual Device**
   - Tools → Device Manager
   - Create Device
   - Select: Pixel 5 or Pixel 7
   - Download system image (API 33 or 34)
   - Finish setup

4. **Run App**
   ```bash
   cd frontend
   flutter run
   ```

**Update API Config for Android Emulator:**
```dart
// frontend/lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String authEndpoint = '$baseUrl/auth';
  static const String userEndpoint = '$baseUrl/user';
}
```

---

### Option 3: Windows Desktop (Native Windows App)

**Setup Steps:**

1. **Install Visual Studio 2022**
   - Download: https://visualstudio.microsoft.com/downloads/
   - Choose: "Community" (free)

2. **During Installation, Select:**
   - ✅ Desktop development with C++
   - ✅ Windows 10 SDK (10.0.17763.0 or later)

3. **Verify Installation**
   ```bash
   flutter doctor
   ```

4. **Run App**
   ```bash
   cd frontend
   flutter run -d windows
   ```

**Note:** Visual Studio download is ~7GB and installation takes 30-60 minutes.

---

## 🚀 Quick Start (Current Setup)

### Your App is Running on Web! 🎉

The Flutter app should now be opening in Chrome browser.

**What You'll See:**
1. ✅ Splash screen with blue gradient
2. ✅ Login screen
3. ✅ Can click "Register Now"
4. ✅ Can test registration

**Test the Flow:**
1. Wait for app to load in browser
2. Click "Register Now"
3. Fill in the form:
   - Full Name: Test User
   - Email: test@example.com
   - Phone: +1234567890
   - Password: password123
   - Confirm Password: password123
   - Check "Terms & Conditions"
4. Click "Create Account"
5. Should navigate to Dashboard!

**Verify in Supabase:**
- Go to Supabase Dashboard
- Table Editor → users
- You should see your test user!

---

## 🔧 Troubleshooting

### Web App Not Loading?

**Check Backend is Running:**
```bash
# In another terminal
cd backend
npm run dev
```

**Check Browser Console:**
- Press F12 in Chrome
- Look for errors
- Common issue: CORS (already configured)

### CORS Errors?

Backend already has CORS enabled, but if you see errors:
```javascript
// backend/src/server.js
app.use(cors({
  origin: '*', // For development
  credentials: true
}));
```

### Network Errors?

**Check API URL:**
```dart
// frontend/lib/config/api_config.dart
static const String baseUrl = 'http://localhost:3000/api';
```

**Test Backend:**
```bash
curl http://localhost:3000/health
```

---

## 📱 Recommended Setup for Mobile Development

### For Best Mobile Testing Experience:

1. **Install Android Studio** (Option 2 above)
2. **Create Android Emulator**
3. **Update API config to use `10.0.2.2`**
4. **Run on emulator**

This gives you:
- ✅ Real mobile UI/UX
- ✅ Touch interactions
- ✅ Mobile-specific features
- ✅ Accurate testing

---

## 🎯 Current Status

✅ **Backend**: Running on http://localhost:3000
✅ **Supabase**: Connected and working
✅ **Frontend**: Running on Chrome (web)
✅ **API**: Configured for localhost

### Next Steps:

1. **Test on Web** (current setup)
   - Register a user
   - Test login
   - Verify in Supabase

2. **Install Android Studio** (optional, for mobile testing)
   - Better mobile experience
   - More accurate testing

3. **Or Use Physical Android Device**
   - Enable USB debugging
   - Connect via USB
   - Update API config with your PC's IP

---

## 🔍 Check Flutter Setup

```bash
flutter doctor
```

**Expected Output:**
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[!] Android toolchain - develop for Android devices
    ✗ Android Studio not found
[✓] Chrome - develop for the web
[!] Visual Studio - develop Windows apps
    ✗ Visual Studio not installed
[✓] VS Code (version x.x.x)
[✓] Connected device (2 available)
[✓] Network resources
```

**What You Need:**
- ✅ Flutter: Already installed
- ✅ Chrome: Already working
- ⚠️ Android Studio: Optional (for mobile testing)
- ⚠️ Visual Studio: Optional (for Windows desktop)

---

## 💡 Tips

### For Web Development:
```bash
# Hot reload works!
# Just save your files and see changes instantly
flutter run -d chrome
```

### For Android Emulator:
```bash
# List devices
flutter devices

# Run on specific device
flutter run -d emulator-5554
```

### For Physical Device:
```bash
# Enable USB debugging on phone
# Connect via USB
flutter devices
flutter run
```

---

## ✅ Summary

**Current Setup:**
- ✅ Backend running on port 3000
- ✅ Supabase connected
- ✅ Flutter app running on Chrome
- ✅ Ready to test!

**For Mobile Testing:**
- 🔄 Install Android Studio
- 🔄 Create emulator
- 🔄 Update API config
- 🔄 Run on emulator

**For Windows Desktop:**
- 🔄 Install Visual Studio 2022
- 🔄 Install C++ tools
- 🔄 Run on Windows

---

**Your app is running! Test it in the Chrome browser that just opened.** 🚀
