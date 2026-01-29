# ⚡ Quick Supabase Setup (5 Minutes)

## 🚀 Super Fast Setup

### 1️⃣ Create Account (30 seconds)
```
1. Go to: https://supabase.com
2. Click "Start your project"
3. Sign up with GitHub (fastest)
```

### 2️⃣ Create Project (1 minute)
```
1. Click "+ New project"
2. Name: PThrive
3. Password: Click "Generate" and SAVE IT!
4. Region: Choose closest to you
5. Click "Create new project"
6. Wait 2 minutes ☕
```

### 3️⃣ Get API Keys (30 seconds)
```
1. Click Settings (⚙️) → API
2. Copy "Project URL"
3. Copy "anon public" key
```

### 4️⃣ Configure Backend (1 minute)
```bash
cd backend
cp .env.example .env
# Edit .env file:
# - Paste Project URL
# - Paste anon key
# - Generate JWT secret: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 5️⃣ Create Tables (1 minute)
```
1. Supabase Dashboard → SQL Editor
2. Click "+ New query"
3. Copy all from backend/database/schema.sql
4. Paste and click "Run"
5. Should see: "Success. No rows returned"
```

### 6️⃣ Test (1 minute)
```bash
cd backend
npm install
npm run dev

# In another terminal:
curl http://localhost:3000/health
# Should see: {"status":"ok",...}
```

## ✅ Done!

Your backend is now connected to Supabase!

**Next:** Configure Flutter app and test registration.

---

## 📋 Your .env File Should Look Like:

```env
PORT=3000
SUPABASE_URL=https://abcdefghijk.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNjE2MTYxNiwiZXhwIjoxOTMxNzM3NjE2fQ.abcdefghijklmnopqrstuvwxyz1234567890
JWT_SECRET=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6
```

---

## 🎯 Verify Setup

```bash
# Test registration
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Test","email":"test@test.com","phoneNumber":"1234567890","password":"test123"}'

# Should return token and user data
# Check Supabase Table Editor → users → You should see the test user!
```

---

**Problems?** See SUPABASE_SETUP.md for detailed troubleshooting.
