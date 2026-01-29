# Supabase Visual Setup Guide

## 🎯 Complete Setup in 10 Minutes

### Step 1: Sign Up (2 minutes)

1. **Go to Supabase**
   - Open browser: https://supabase.com
   - Click green **"Start your project"** button

2. **Create Account**
   - Choose sign-up method:
     - ✅ **GitHub** (recommended - fastest)
     - Google
     - Email/Password
   
3. **Authorize**
   - If using GitHub, click "Authorize Supabase"
   - You'll be redirected to Supabase dashboard

---

### Step 2: Create Project (3 minutes)

1. **New Project Button**
   - You'll see "Welcome to Supabase"
   - Click **"+ New project"** button
   - Or click **"New project"** in the organization

2. **Fill Project Details**
   ```
   ┌─────────────────────────────────────┐
   │ Create a new project                │
   ├─────────────────────────────────────┤
   │ Name: PThrive                       │
   │                                     │
   │ Database Password: **************** │
   │ [Generate a password] 🔄            │
   │                                     │
   │ Region: [Select closest region ▼]  │
   │ • US East (Ohio)                    │
   │ • US West (Oregon)                  │
   │ • Europe (Frankfurt)                │
   │ • Asia Pacific (Singapore)          │
   │                                     │
   │ Pricing Plan: Free ✓                │
   │                                     │
   │         [Create new project]        │
   └─────────────────────────────────────┘
   ```

3. **Important: Save Your Password!**
   - Click "Generate a password" for a strong password
   - **Copy and save it somewhere safe!**
   - You'll need this for database access

4. **Wait for Setup**
   - Progress bar will show: "Setting up project..."
   - Takes 2-3 minutes
   - ☕ Grab a coffee!

---

### Step 3: Get API Keys (1 minute)

1. **Navigate to Settings**
   ```
   Sidebar:
   ├── 🏠 Home
   ├── 📊 Table Editor
   ├── 🔍 SQL Editor
   ├── 📝 Database
   └── ⚙️ Settings  ← Click here
   ```

2. **Click API**
   ```
   Settings Menu:
   ├── General
   ├── Database
   ├── API  ← Click here
   ├── Auth
   └── Storage
   ```

3. **Copy Your Credentials**
   ```
   ┌─────────────────────────────────────────────────┐
   │ Project API keys                                │
   ├─────────────────────────────────────────────────┤
   │                                                 │
   │ Project URL                                     │
   │ https://abcdefghijk.supabase.co                │
   │ [Copy] 📋                                       │
   │                                                 │
   │ anon public                                     │
   │ eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...        │
   │ [Copy] 📋  ← Copy this one!                     │
   │                                                 │
   │ service_role secret                             │
   │ eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...        │
   │ [Reveal] [Copy] 📋  ← Don't use this one       │
   │                                                 │
   └─────────────────────────────────────────────────┘
   ```

4. **What to Copy:**
   - ✅ **Project URL** - Copy this
   - ✅ **anon public** key - Copy this
   - ❌ **service_role** - Don't use this (it's for admin only)

---

### Step 4: Configure Backend (2 minutes)

1. **Open Your Project**
   - Open terminal/command prompt
   - Navigate to your project:
   ```bash
   cd path/to/PThrive/backend
   ```

2. **Create .env File**
   ```bash
   # Windows
   copy .env.example .env
   
   # Mac/Linux
   cp .env.example .env
   ```

3. **Edit .env File**
   - Open `backend/.env` in any text editor
   - Replace the placeholder values:

   **Before:**
   ```env
   PORT=3000
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   JWT_SECRET=your_jwt_secret_key
   ```

   **After:**
   ```env
   PORT=3000
   SUPABASE_URL=https://abcdefghijk.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNjE2MTYxNiwiZXhwIjoxOTMxNzM3NjE2fQ.abcdefghijklmnopqrstuvwxyz1234567890
   JWT_SECRET=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6
   ```

4. **Generate JWT Secret**
   ```bash
   # Run this command:
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   
   # Output (example):
   a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6
   
   # Copy this output and paste as JWT_SECRET
   ```

---

### Step 5: Create Database Tables (2 minutes)

1. **Open SQL Editor**
   ```
   Supabase Dashboard Sidebar:
   ├── 🏠 Home
   ├── 📊 Table Editor
   ├── 🔍 SQL Editor  ← Click here
   ├── 📝 Database
   └── ⚙️ Settings
   ```

2. **New Query**
   - Click **"+ New query"** button
   - You'll see an empty SQL editor

3. **Copy Schema**
   - Open `backend/database/schema.sql` in your project
   - Select all (Ctrl+A / Cmd+A)
   - Copy (Ctrl+C / Cmd+C)

4. **Paste and Run**
   ```
   ┌─────────────────────────────────────────────┐
   │ [▶ Run] [Save] [Format]                     │
   ├─────────────────────────────────────────────┤
   │                                             │
   │ -- Paste your SQL here                      │
   │ CREATE TABLE users (                        │
   │   id UUID DEFAULT gen_random_uuid()...      │
   │                                             │
   │                                             │
   └─────────────────────────────────────────────┘
   ```
   - Paste the SQL (Ctrl+V / Cmd+V)
   - Click **"Run"** button (or press Ctrl+Enter)

5. **Verify Success**
   - You should see: ✅ **"Success. No rows returned"**
   - If you see errors, check the SQL syntax

---

### Step 6: Verify Tables (1 minute)

1. **Open Table Editor**
   ```
   Sidebar:
   ├── 🏠 Home
   ├── 📊 Table Editor  ← Click here
   ├── 🔍 SQL Editor
   └── ...
   ```

2. **Check Tables**
   ```
   ┌─────────────────────────────────────┐
   │ Tables                              │
   ├─────────────────────────────────────┤
   │ ✅ users                            │
   │ ✅ sessions                         │
   │ ✅ exercises                        │
   │ ✅ progress_reports                 │
   └─────────────────────────────────────┘
   ```

3. **Click on 'users' Table**
   - You should see columns:
     - id (uuid)
     - full_name (varchar)
     - email (varchar)
     - phone_number (varchar)
     - password (varchar)
     - created_at (timestamp)
     - updated_at (timestamp)

4. **Table Should Be Empty**
   - No rows yet - that's correct!
   - Users will be added when they register

---

### Step 7: Test Backend (1 minute)

1. **Install Dependencies**
   ```bash
   cd backend
   npm install
   ```

2. **Start Server**
   ```bash
   npm run dev
   ```

3. **Expected Output**
   ```
   ✅ Server running on port 3000
   📡 Health check: http://localhost:3000/health
   ```

4. **Test Health Check**
   - Open browser: http://localhost:3000/health
   - Or use curl:
   ```bash
   curl http://localhost:3000/health
   ```

5. **Expected Response**
   ```json
   {
     "status": "ok",
     "message": "PThrive API is running",
     "timestamp": "2024-01-29T12:34:56.789Z"
   }
   ```

---

### Step 8: Test Registration (1 minute)

1. **Test API Endpoint**
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

2. **Expected Response**
   ```json
   {
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
     "user": {
       "id": "550e8400-e29b-41d4-a716-446655440000",
       "fullName": "Test User",
       "email": "test@example.com"
     }
   }
   ```

3. **Verify in Supabase**
   - Go back to Supabase Dashboard
   - Click **Table Editor** → **users**
   - You should see your test user!
   ```
   ┌──────────────────────────────────────────────┐
   │ id          │ full_name │ email              │
   ├──────────────────────────────────────────────┤
   │ 550e8400... │ Test User │ test@example.com   │
   └──────────────────────────────────────────────┘
   ```

---

## ✅ Setup Complete!

### What You've Done:
- ✅ Created Supabase account
- ✅ Created PThrive project
- ✅ Got API credentials
- ✅ Configured backend .env
- ✅ Created database tables
- ✅ Verified tables exist
- ✅ Tested backend connection
- ✅ Tested user registration
- ✅ Verified data in database

### Next Steps:
1. Configure Flutter app (see SUPABASE_SETUP.md Step 9)
2. Test full registration flow
3. Start building features!

---

## 🎨 Visual Checklist

```
Setup Progress:
[████████████████████████] 100%

✅ Supabase account
✅ Project created
✅ API keys copied
✅ .env configured
✅ JWT secret generated
✅ Tables created
✅ Backend tested
✅ Registration works
✅ Data in database

Status: READY TO BUILD! 🚀
```

---

## 🆘 Quick Troubleshooting

### Can't find API keys?
→ Dashboard → Settings (⚙️) → API

### Tables not showing?
→ Run schema.sql again in SQL Editor

### Backend won't start?
→ Check .env file has correct values
→ Make sure no spaces around = signs
→ Verify SUPABASE_URL starts with https://

### Registration fails?
→ Check backend console for errors
→ Verify tables exist in Supabase
→ Test health endpoint first

---

**Need more help?** Check SUPABASE_SETUP.md for detailed troubleshooting!
