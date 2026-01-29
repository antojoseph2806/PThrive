# PThrive Setup Guide

Complete setup instructions for the PThrive full-stack application.

## Prerequisites

- Node.js v18+ and npm
- Flutter SDK 3.0+
- Supabase account
- Android Studio or Xcode (for mobile development)

## Backend Setup

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Configure Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Copy your project URL and anon key
3. Create `.env` file:
```bash
cp .env.example .env
```

4. Edit `.env`:
```
PORT=3000
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
JWT_SECRET=your_random_secret_key_here
```

### 3. Setup Database

1. Go to Supabase Dashboard → SQL Editor
2. Copy and run the SQL from `backend/database/schema.sql`
3. Verify tables are created: users, sessions, exercises, progress_reports

### 4. Start Backend Server
```bash
npm run dev
```

Server will run on `http://localhost:3000`

Test it: `curl http://localhost:3000/health`

## Frontend Setup

### 1. Install Dependencies
```bash
cd frontend
flutter pub get
```

### 2. Configure API Endpoint

Edit `frontend/lib/config/api_config.dart`:
- For Android emulator: `http://10.0.2.2:3000/api`
- For iOS simulator: `http://localhost:3000/api`
- For physical device: `http://YOUR_COMPUTER_IP:3000/api`

### 3. Setup Splash Screen Assets

1. Create a splash icon (512x512px PNG) with your design
2. Place it in `frontend/assets/images/splash_icon.png`
3. Generate native splash screens:
```bash
flutter pub get
dart run flutter_native_splash:create
```

### 4. Run the App

For Android:
```bash
flutter run
```

For iOS (Mac only):
```bash
flutter run -d ios
```

Note: Native splash screens show properly in release mode:
```bash
flutter run --release
```

## Project Structure

```
PThrive/
├── backend/
│   ├── src/
│   │   ├── config/         # Supabase config
│   │   ├── middleware/     # Auth middleware
│   │   ├── routes/         # API endpoints
│   │   └── server.js       # Express server
│   ├── database/
│   │   └── schema.sql      # Database schema
│   └── package.json
│
└── frontend/
    ├── lib/
    │   ├── config/         # API configuration
    │   ├── models/         # Data models
    │   ├── providers/      # State management
    │   ├── screens/        # UI screens
    │   ├── services/       # API services
    │   ├── utils/          # Utilities
    │   ├── widgets/        # Reusable widgets
    │   └── main.dart       # App entry
    └── pubspec.yaml
```

## Features Implemented

### Screens
✅ Splash Screen - Animated loading with branding
✅ Login Screen - Email/password + Google OAuth placeholder
✅ Register Screen - Full registration form
✅ Dashboard - Main app interface with feature cards

### Backend APIs
✅ POST /api/auth/register - User registration
✅ POST /api/auth/login - User login
✅ GET /api/user/profile - Get user profile
✅ GET /api/sessions - Get user sessions
✅ POST /api/sessions - Create session
✅ GET /api/exercises - Get exercises
✅ POST /api/exercises - Create exercise

### Database
✅ Users table with authentication
✅ Sessions table for appointments
✅ Exercises table for programs
✅ Progress reports table
✅ Row Level Security policies

## Testing

### Test Backend
```bash
# Health check
curl http://localhost:3000/health

# Register user
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Test User","email":"test@example.com","phoneNumber":"+1234567890","password":"password123"}'
```

### Test Frontend
1. Run the app
2. Navigate through splash → login → register → dashboard
3. Test form validation
4. Test authentication flow

## Troubleshooting

### Backend Issues
- **Port already in use**: Change PORT in `.env`
- **Supabase connection error**: Verify URL and keys in `.env`
- **JWT errors**: Generate new JWT_SECRET

### Frontend Issues
- **API connection failed**: Check API endpoint in `api_config.dart`
- **Dependencies error**: Run `flutter pub get` again
- **Build errors**: Run `flutter clean` then `flutter pub get`

## Next Steps

1. Implement Google OAuth integration
2. Add session booking functionality
3. Build exercise tracking features
4. Create progress reports
5. Add push notifications
6. Implement real-time updates

## Support

For issues or questions, refer to:
- Flutter docs: https://flutter.dev/docs
- Supabase docs: https://supabase.com/docs
- Express docs: https://expressjs.com
