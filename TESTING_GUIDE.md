# Testing Guide - Error Handling & Performance

## 🧪 Test Scenarios

### 1. Network Error Testing

#### No Internet Connection
```bash
# Steps:
1. Turn off WiFi and mobile data
2. Try to login
3. Expected: "No internet connection" error message
4. Turn on internet
5. Click retry button
6. Expected: Login succeeds
```

#### Slow Network
```bash
# Android:
Settings → Developer Options → Network Speed → GPRS

# iOS:
Settings → Developer → Network Link Conditioner → Very Bad Network

# Expected:
- Loading indicators show immediately
- Request completes or times out after 10 seconds
- Clear timeout message if it fails
```

#### Connection Timeout
```bash
# Simulate by:
1. Start request
2. Disconnect internet mid-request
3. Expected: "Connection timeout" after 10 seconds
```

### 2. Validation Testing

#### Login Form
```
Test Case 1: Empty Email
- Input: email="", password="test123"
- Expected: "Please enter your email" (orange snackbar)

Test Case 2: Empty Password
- Input: email="test@test.com", password=""
- Expected: "Please enter your password" (orange snackbar)

Test Case 3: Invalid Credentials
- Input: email="wrong@test.com", password="wrongpass"
- Expected: "Invalid email or password" (red snackbar)
```

#### Register Form
```
Test Case 1: Empty Name
- Expected: "Please enter your full name"

Test Case 2: Invalid Email
- Input: email="notanemail"
- Expected: "Please enter a valid email"

Test Case 3: Short Password
- Input: password="123"
- Expected: "Password must be at least 6 characters"

Test Case 4: Password Mismatch
- Input: password="test123", confirm="test456"
- Expected: "Passwords do not match"

Test Case 5: Terms Not Accepted
- Expected: Button disabled

Test Case 6: Duplicate Email
- Input: existing email
- Expected: "Email already registered. Please login instead."
```

### 3. Performance Testing

#### Button Responsiveness
```
Test: Click login button
Expected:
- Button shows loading indicator immediately
- Button is disabled during loading
- No double-submission possible
- Loading completes in < 2 seconds (good network)
```

#### Screen Load Time
```
Test: Navigate between screens
Expected:
- Splash → Login: < 3 seconds
- Login → Dashboard: < 1 second
- All transitions smooth, no lag
```

#### API Response Time
```
Test: Make API calls
Expected:
- Login: < 500ms
- Register: < 800ms
- Get Profile: < 300ms
- Timeout after 10 seconds
```

### 4. Error Recovery Testing

#### Token Expiration
```
Steps:
1. Login successfully
2. Wait 7 days (or manually expire token)
3. Try to access protected resource
4. Expected: "Session expired. Please login again"
5. Redirect to login screen
```

#### Server Error
```
Steps:
1. Stop backend server
2. Try to login
3. Expected: "Network error" message
4. Start server
5. Click retry
6. Expected: Login succeeds
```

#### Database Error
```
Steps:
1. Disconnect Supabase
2. Try to register
3. Expected: "Database connection failed"
4. Reconnect Supabase
5. Retry
6. Expected: Registration succeeds
```

### 5. Loading State Testing

#### Login Loading
```
Test: Click Sign In button
Expected:
- Button text changes to spinner
- Button is disabled
- Background is slightly dimmed
- Spinner animates smoothly
- Success: Navigate to dashboard
- Error: Show error message, re-enable button
```

#### Register Loading
```
Test: Click Create Account button
Expected:
- Same as login loading
- Form stays filled on error
- Clear error message
- Retry without re-entering data
```

### 6. Cache Testing

#### User Data Caching
```
Steps:
1. Login successfully
2. Close app completely
3. Reopen app
4. Expected: User still logged in
5. Dashboard loads with cached data
6. Background refresh updates data
```

#### Cache Expiration
```
Steps:
1. Login and use app
2. Wait 1 hour
3. Pull to refresh
4. Expected: Fresh data loaded
5. Cache updated
```

### 7. Concurrent Request Testing

#### Multiple Rapid Clicks
```
Test: Click login button 5 times rapidly
Expected:
- Only one request sent
- Button disabled after first click
- No duplicate submissions
- Single response handled
```

#### Simultaneous Operations
```
Test: Start login, immediately navigate away
Expected:
- Request cancelled or completed
- No memory leaks
- No hanging requests
- Clean state management
```

---

## 🔧 Manual Testing Checklist

### Frontend (Flutter)

#### Login Screen
- [ ] Empty email shows error
- [ ] Empty password shows error
- [ ] Invalid credentials show error
- [ ] Loading indicator works
- [ ] Button disabled during loading
- [ ] Success navigates to dashboard
- [ ] Error shows snackbar
- [ ] Retry after error works
- [ ] No internet shows error
- [ ] Timeout shows error

#### Register Screen
- [ ] All validations work
- [ ] Password mismatch detected
- [ ] Terms checkbox required
- [ ] Duplicate email detected
- [ ] Loading indicator works
- [ ] Success navigates to dashboard
- [ ] Error shows snackbar
- [ ] Form persists on error
- [ ] No internet shows error
- [ ] Timeout shows error

#### Dashboard Screen
- [ ] Loads quickly
- [ ] Shows cached data first
- [ ] Background refresh works
- [ ] Pull to refresh works
- [ ] Navigation smooth
- [ ] All cards clickable
- [ ] Bottom nav works
- [ ] Logout works
- [ ] Session persists

### Backend (Node.js)

#### Auth Endpoints
- [ ] POST /api/auth/register validates input
- [ ] POST /api/auth/register checks duplicate email
- [ ] POST /api/auth/register hashes password
- [ ] POST /api/auth/register returns token
- [ ] POST /api/auth/login validates input
- [ ] POST /api/auth/login checks credentials
- [ ] POST /api/auth/login returns token
- [ ] Invalid requests return 400
- [ ] Unauthorized returns 401
- [ ] Server errors return 500

#### Error Handling
- [ ] Validation errors clear
- [ ] Network errors handled
- [ ] Database errors handled
- [ ] JWT errors handled
- [ ] Timeout errors handled
- [ ] All errors logged
- [ ] Error messages user-friendly
- [ ] Status codes correct

---

## 🚀 Automated Testing

### Backend Unit Tests

```javascript
// Example test structure
describe('Auth Routes', () => {
  test('Register with valid data', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        fullName: 'Test User',
        email: 'test@test.com',
        phoneNumber: '1234567890',
        password: 'password123'
      });
    
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('token');
  });

  test('Register with duplicate email', async () => {
    // First registration
    await registerUser();
    
    // Duplicate registration
    const response = await registerUser();
    expect(response.status).toBe(409);
    expect(response.body.error).toContain('already registered');
  });

  test('Login with invalid credentials', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'wrong@test.com',
        password: 'wrongpass'
      });
    
    expect(response.status).toBe(401);
  });
});
```

### Frontend Widget Tests

```dart
// Example test structure
testWidgets('Login button shows loading', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Find and tap login button
  final button = find.text('Sign In');
  await tester.tap(button);
  await tester.pump();
  
  // Verify loading indicator
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});

testWidgets('Shows error on invalid credentials', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Enter invalid credentials
  await tester.enterText(find.byType(TextField).first, 'wrong@test.com');
  await tester.enterText(find.byType(TextField).last, 'wrongpass');
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
  
  // Verify error message
  expect(find.text('Invalid email or password'), findsOneWidget);
});
```

---

## 📊 Performance Benchmarks

### Target Metrics

| Operation | Target | Acceptable | Poor |
|-----------|--------|------------|------|
| Login API | < 300ms | < 500ms | > 1s |
| Register API | < 500ms | < 800ms | > 1.5s |
| Screen Load | < 100ms | < 200ms | > 500ms |
| Button Response | Instant | < 50ms | > 100ms |
| Network Timeout | 10s | 15s | 30s |

### Measuring Performance

```dart
// Frontend
final stopwatch = Stopwatch()..start();
await authProvider.login(email, password);
stopwatch.stop();
print('Login took: ${stopwatch.elapsedMilliseconds}ms');
```

```javascript
// Backend
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.path} - ${duration}ms`);
  });
  next();
});
```

---

## ✅ Test Results Template

```
Test Date: ___________
Tester: ___________
Device: ___________
OS Version: ___________
App Version: ___________

Network Tests:
[ ] No internet - PASS/FAIL
[ ] Slow network - PASS/FAIL
[ ] Timeout - PASS/FAIL

Validation Tests:
[ ] Login validation - PASS/FAIL
[ ] Register validation - PASS/FAIL
[ ] Duplicate email - PASS/FAIL

Performance Tests:
[ ] Button response - PASS/FAIL
[ ] Screen load - PASS/FAIL
[ ] API response - PASS/FAIL

Error Recovery:
[ ] Token expiration - PASS/FAIL
[ ] Server error - PASS/FAIL
[ ] Database error - PASS/FAIL

Loading States:
[ ] Login loading - PASS/FAIL
[ ] Register loading - PASS/FAIL

Cache Tests:
[ ] User data cache - PASS/FAIL
[ ] Cache expiration - PASS/FAIL

Notes:
_________________________________
_________________________________
_________________________________
```

---

## 🐛 Known Issues & Fixes

### Issue: Double Submission
**Fix**: Disable button during loading
```dart
onPressed: isLoading ? null : onPressed
```

### Issue: Memory Leak
**Fix**: Dispose controllers
```dart
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

### Issue: Slow API
**Fix**: Add caching
```dart
final cached = await CacheManager.getCachedData(key);
if (cached != null) return cached;
```

---

**Status**: ✅ **READY FOR TESTING**

All error handling and performance features implemented and ready to test!
