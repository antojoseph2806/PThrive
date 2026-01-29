# PThrive - Your Recovery Journey

Full-stack mobile application for physiotherapy recovery management.

## 🎯 Tech Stack
- **Frontend**: Flutter (Android & iOS)
- **Backend**: Node.js + Express
- **Database**: Supabase (PostgreSQL)

## 📱 Platform Support
- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Native splash screens (no Flutter default)
- ✅ Portrait orientation

## 🚀 Quick Start

See **QUICK_START.md** for 5-minute setup guide.

## 📂 Project Structure
- `frontend/` - Flutter mobile application
- `backend/` - Node.js REST API

## 📖 Documentation
- **QUICK_START.md** - Get started in 5 minutes
- **SETUP_GUIDE.md** - Complete setup instructions
- **PLATFORM_SETUP.md** - Android & iOS configuration
- **SPLASH_SETUP.md** - Native splash screen setup
- **CHECKLIST.md** - Build completion checklist

## ✨ Features
- Native splash screens for Android & iOS
- User authentication (Email/Password)
- Google OAuth ready (design implemented)
- Dashboard with physiotherapy management
- Session booking and tracking
- Exercise programs
- Progress reports

## 🔧 Setup

### Backend
```bash
cd backend
npm install
cp .env.example .env
# Configure Supabase credentials in .env
npm run dev
```

### Frontend
```bash
cd frontend
flutter pub get
# Add splash icon: assets/images/splash_icon.png
dart run flutter_native_splash:create
flutter run
```

### Database
Run SQL from `backend/database/schema.sql` in Supabase SQL Editor

## 🧪 Testing

Backend: `curl http://localhost:3000/health`

Frontend: `flutter run --release` (to see native splash)

---

**Built with ❤️ for physiotherapy recovery**
