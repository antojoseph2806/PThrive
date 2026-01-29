# PThrive Frontend

Flutter mobile application for PThrive - Your Recovery Journey.

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode
- Dart SDK

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Configure API endpoint:
Edit `lib/config/api_config.dart` and set your backend URL.

3. Run the app:
```bash
flutter run
```

## Project Structure
```
lib/
├── config/         # API configuration
├── providers/      # State management
├── screens/        # UI screens
├── services/       # API services
├── widgets/        # Reusable widgets
└── main.dart       # Entry point
```

## Features
- Splash screen with branding
- User authentication (login/register)
- Dashboard with physiotherapy features
- Session booking
- Exercise tracking
- Progress reports
