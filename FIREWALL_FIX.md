# 🔥 Fix Windows Firewall for PThrive

## Problem
Your phone cannot reach the backend because Windows Firewall is blocking port 3000.

## Solution

### Option 1: Run the Firewall Script (Easiest)

1. **Right-click** on `fix-firewall.bat` in your project folder
2. **Select** "Run as administrator"
3. **Click** "Yes" when prompted
4. **Wait** for "Done!" message
5. **Test** again on your phone

### Option 2: Manual Firewall Configuration

1. **Open Windows Defender Firewall**
   - Press `Win + R`
   - Type: `wf.msc`
   - Press Enter

2. **Click** "Inbound Rules" on the left

3. **Click** "New Rule..." on the right

4. **Select** "Port" → Click Next

5. **Select** "TCP"
   - Enter port: `3000`
   - Click Next

6. **Select** "Allow the connection"
   - Click Next

7. **Check all boxes** (Domain, Private, Public)
   - Click Next

8. **Name**: `PThrive Backend`
   - Click Finish

### Option 3: Temporarily Disable Firewall (Not Recommended)

1. Open Windows Security
2. Go to Firewall & network protection
3. Turn off firewall for Private network
4. Test your app
5. **Remember to turn it back on!**

## After Fixing Firewall

### Test from Phone Browser:
Open: `http://192.168.61.96:3000/health`

**Expected Result:**
```json
{
  "status": "ok",
  "message": "PThrive API is running",
  "timestamp": "..."
}
```

### Test from App:
1. Open PThrive app
2. Go to Register screen
3. Fill in details
4. Click "Create Account"
5. Should work! ✅

## Verify Backend is Running

Make sure backend is still running:
```powershell
cd backend
npm run dev
```

You should see:
```
✅ Server running on port 3000
🌐 Network access: http://192.168.61.96:3000/health
```

## Alternative: Use Different Port

If firewall issues persist, you can use a different port:

1. Edit `backend/.env`:
   ```
   PORT=8080
   ```

2. Edit `frontend/lib/config/api_config.dart`:
   ```dart
   static const String baseUrl = 'http://192.168.61.96:8080/api';
   ```

3. Restart backend:
   ```powershell
   cd backend
   npm run dev
   ```

4. Hot reload Flutter app (press `r`)

## Troubleshooting

### Still Not Working?

**Check if both devices are on same WiFi:**
- Phone WiFi: Settings → WiFi → Check network name
- Laptop WiFi: Settings → Network → Check network name
- They must match!

**Check your IP address:**
```powershell
ipconfig
```
Look for "IPv4 Address" under your WiFi adapter.
If it's different from `192.168.61.96`, update the API config.

**Test localhost first:**
```powershell
curl http://localhost:3000/health
```
If this works but network doesn't, it's definitely a firewall issue.

## Quick Fix Command (Run as Administrator)

Open PowerShell as Administrator and run:
```powershell
netsh advfirewall firewall add rule name="PThrive Backend Port 3000" dir=in action=allow protocol=TCP localport=3000
```

---

**After fixing firewall, test on phone browser first, then try the app!** 🚀
