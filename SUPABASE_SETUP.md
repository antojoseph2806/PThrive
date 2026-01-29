# Supabase Setup Guide for PThrive

## 📋 Step-by-Step Setup

### Step 1: Create Supabase Account

1. Go to [https://supabase.com](https://supabase.com)
2. Click **"Start your project"** or **"Sign In"**
3. Sign up with:
   - GitHub account (recommended)
   - Google account
   - Email/password

### Step 2: Create New Project

1. After signing in, click **"New Project"**
2. Fill in the project details:
   ```
   Name: PThrive
   Database Password: [Create a strong password - SAVE THIS!]
   Region: Choose closest to your location
   Pricing Plan: Free (for development)
   ```
3. Click **"Create new project"**
4. Wait 2-3 minutes for project setup to complete

### Step 3: Get Your API Credentials

1. Once project is ready, go to **Settings** (gear icon in sidebar)
2. Click **"API"** in the settings menu
3. You'll see:
   ```
   Project URL: https://xxxxxxxxxxxxx.supabase.co
   anon public key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
4. **Copy these values** - you'll need them next!

### Step 4: Configure Backend Environment

1. Open your project folder
2. Navigate to `backend/` directory
3. Copy the example environment file:
   ```bash
   cd backend
   cp .env.example .env
   ```

4. Open `backend/.env` file and add your credentials:
   ```env
   PORT=3000
   SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   JWT_SECRET=your_random_secret_key_here_make_it_long_and_random
   ```

5. Generate a JWT secret (use one of these methods):
   ```bash
   # Method 1: Using Node.js
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   
   # Method 2: Using OpenSSL
   openssl rand -hex 32
   
   # Method 3: Online generator
   # Visit: https://randomkeygen.com/
   ```

### Step 5: Create Database Tables

1. In Supabase Dashboard, click **"SQL Editor"** in the sidebar
2. Click **"New query"**
3. Copy the entire SQL from `backend/database/schema.sql`
4. Paste it into the SQL editor
5. Click **"Run"** (or press Ctrl+Enter)
6. You should see: **"Success. No rows returned"**

### Step 6: Verify Tables Created

1. Click **"Table Editor"** in the sidebar
2. You should see 4 tables:
   - ✅ users
   - ✅ sessions
   - ✅ exercises
   - ✅ progress_reports

3. Click on **"users"** table to verify columns:
   - id (uuid)
   - full_name (varchar)
   - email (varchar)
   - phone_number (varchar)
   - password (varchar)
   - created_at (timestamp)
   - updated_at (timestamp)

### Step 7: Test Backend Connection

1. Start your backend server:
   ```bash
   cd backend
   npm install
   npm run dev
   ```

2. You should see:
   ```
   ✅ Server running on port 3000
   📡 Health check: http://localhost:3000/health
   ```

3. Test the connection:
   ```bash
   curl http://localhost:3000/health
   ```

4. Expected response:
   ```json
   {
     "status": "ok",
     "message": "PThrive API is running",
     "timestamp": "2024-01-29T..."
   }
   ```

### Step 8: Test User Registration

1. Test registration endpoint:
   ```bash
   curl -X POST http://localhost:3000/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{
       "fullName": "Test User",
       "email": "test@example.com",
       "phoneNumber": "+1234567890",
       "password": "password123"
     }'
   ```

2. Expected response:
   ```json
   {
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
     "user": {
       "id": "uuid-here",
       "fullName": "Test User",
       "email": "test@example.com"
     }
   }
   ```

3. Verify in Supabase:
   - Go to **Table Editor** → **users**
   - You should see your test user!

### Step 9: Configure Frontend

1. Open `frontend/lib/config/api_config.dart`
2. Update the base URL based on your setup:

   **For Android Emulator:**
   ```dart
   class ApiConfig {
     static const String baseUrl = 'http://10.0.2.2:3000/api';
     static const String authEndpoint = '$baseUrl/auth';
     static const String userEndpoint = '$baseUrl/user';
   }
   ```

   **For iOS Simulator:**
   ```dart
   class ApiConfig {
     static const String baseUrl = 'http://localhost:3000/api';
     static const String authEndpoint = '$baseUrl/auth';
     static const String userEndpoint = '$baseUrl/user';
   }
   ```

   **For Physical Device (same WiFi):**
   ```dart
   class ApiConfig {
     static const String baseUrl = 'http://YOUR_COMPUTER_IP:3000/api';
     static const String authEndpoint = '$baseUrl/auth';
     static const String userEndpoint = '$baseUrl/user';
   }
   ```

   To find your computer's IP:
   ```bash
   # Windows
   ipconfig
   # Look for "IPv4 Address"
   
   # Mac/Linux
   ifconfig
   # Look for "inet" under your network interface
   ```

### Step 10: Test Full Stack

1. Make sure backend is running:
   ```bash
   cd backend
   npm run dev
   ```

2. Run Flutter app:
   ```bash
   cd frontend
   flutter pub get
   flutter run
   ```

3. Test the flow:
   - ✅ Splash screen appears
   - ✅ Navigate to login screen
   - ✅ Click "Register Now"
   - ✅ Fill registration form
   - ✅ Click "Create Account"
   - ✅ Should navigate to dashboard
   - ✅ Check Supabase - user should be in database!

---

## 🔧 Troubleshooting

### Issue: "Failed to connect to Supabase"

**Solution:**
1. Verify your `SUPABASE_URL` in `.env` is correct
2. Check your `SUPABASE_ANON_KEY` is correct
3. Make sure there are no extra spaces in `.env` file
4. Restart your backend server after changing `.env`

### Issue: "Invalid API key"

**Solution:**
1. Go to Supabase Dashboard → Settings → API
2. Copy the **anon public** key (not service_role)
3. Update `SUPABASE_ANON_KEY` in `.env`
4. Restart backend server

### Issue: "Table does not exist"

**Solution:**
1. Go to Supabase Dashboard → SQL Editor
2. Run the schema.sql again
3. Check Table Editor to verify tables exist
4. Make sure you're in the correct project

### Issue: "Row Level Security policy violation"

**Solution:**
1. The schema.sql includes RLS policies
2. For development, you can temporarily disable RLS:
   ```sql
   ALTER TABLE users DISABLE ROW LEVEL SECURITY;
   ALTER TABLE sessions DISABLE ROW LEVEL SECURITY;
   ALTER TABLE exercises DISABLE ROW LEVEL SECURITY;
   ALTER TABLE progress_reports DISABLE ROW LEVEL SECURITY;
   ```
3. **Important:** Re-enable RLS before production!

### Issue: Backend can't connect from Flutter app

**Solution:**
1. Check if backend is running: `curl http://localhost:3000/health`
2. For Android emulator, use `10.0.2.2` instead of `localhost`
3. For physical device, use your computer's IP address
4. Make sure firewall allows port 3000
5. Check if both devices are on same WiFi network

### Issue: "CORS error"

**Solution:**
1. CORS is already configured in `backend/src/server.js`
2. If still having issues, update CORS config:
   ```javascript
   app.use(cors({
     origin: '*', // For development only
     credentials: true
   }));
   ```

---

## 📊 Verify Setup Checklist

- [ ] Supabase account created
- [ ] New project created
- [ ] API credentials copied
- [ ] `.env` file configured
- [ ] JWT secret generated
- [ ] Database tables created
- [ ] Tables visible in Table Editor
- [ ] Backend server starts without errors
- [ ] Health check endpoint works
- [ ] Test user registration works
- [ ] User appears in Supabase database
- [ ] Frontend API config updated
- [ ] Flutter app connects to backend
- [ ] Full registration flow works

---

## 🎯 Quick Reference

### Supabase Dashboard URLs

```
Dashboard: https://app.supabase.com
Project: https://app.supabase.com/project/YOUR_PROJECT_ID
SQL Editor: https://app.supabase.com/project/YOUR_PROJECT_ID/sql
Table Editor: https://app.supabase.com/project/YOUR_PROJECT_ID/editor
API Settings: https://app.supabase.com/project/YOUR_PROJECT_ID/settings/api
```

### Important Files

```
Backend Config: backend/.env
Database Schema: backend/database/schema.sql
Frontend Config: frontend/lib/config/api_config.dart
```

### Test Commands

```bash
# Test backend health
curl http://localhost:3000/health

# Test registration
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Test","email":"test@test.com","phoneNumber":"1234567890","password":"test123"}'

# Test login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123"}'
```

---

## 🔐 Security Notes

### For Development
- ✅ Use `anon` key (public key)
- ✅ RLS policies enabled
- ✅ JWT secret is random and long

### For Production
- ⚠️ Never commit `.env` file
- ⚠️ Use environment variables on server
- ⚠️ Enable RLS on all tables
- ⚠️ Use strong database password
- ⚠️ Rotate JWT secret regularly
- ⚠️ Use HTTPS only
- ⚠️ Enable rate limiting

---

## 📱 Next Steps

After successful setup:

1. ✅ Test registration from Flutter app
2. ✅ Test login from Flutter app
3. ✅ Verify data in Supabase
4. ✅ Test error scenarios
5. ✅ Test on physical device
6. 🔄 Implement remaining features
7. 🔄 Add more tables as needed
8. 🔄 Setup production environment

---

## 🆘 Need Help?

### Supabase Resources
- Documentation: https://supabase.com/docs
- Discord: https://discord.supabase.com
- GitHub: https://github.com/supabase/supabase

### Common Issues
- Check Supabase status: https://status.supabase.com
- Review error logs in Supabase Dashboard → Logs
- Check backend console for error messages
- Verify network connectivity

---

**Status**: Ready to setup! Follow the steps above. 🚀
