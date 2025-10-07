# Quick Start Guide - Security Vulnerability Testing

This guide helps you quickly reproduce all four security vulnerabilities in this demonstration application.

## 🚀 Quick Setup (5 minutes)

### 1. Installation

```bash
# Install dependencies
npm install
```

### 2. Start the Server

```bash
# Start the vulnerable application
npm start
```

Expected output:
```
========================================
Vulnerable Demo Server Running
Port: 3000
========================================
KNOWN VULNERABILITIES:
1. Weak Password Policy - No complexity enforcement
2. No Rate Limiting - Unlimited login attempts
3. Insecure Transport - HTTP only (no HTTPS)
4. Session Fixation - Session ID not regenerated
========================================
Access the application at: http://localhost:3000
```

### 3. Run All Vulnerability Tests

In a new terminal:

```bash
# Run complete test suite
./run_all_tests.sh
```

Expected result: All 4 vulnerabilities will be confirmed with detailed evidence.

---

## 📋 Testing Individual Vulnerabilities

### Bug 1: Weak Password Policy

**What it tests**: Whether the app accepts weak passwords like "password", "12345678"

```bash
./tests/test_bug1_weak_password.sh http://localhost:3000
```

**Expected outcome**: All weak passwords are accepted ❌

**Manual test**:
1. Open http://localhost:3000/register
2. Try registering with password: `password`
3. Account is created successfully (vulnerability confirmed)

---

### Bug 2: No Rate Limiting

**What it tests**: Whether unlimited login attempts are allowed

```bash
./tests/test_bug2_rate_limiting.sh http://localhost:3000
```

**Expected outcome**: 30+ rapid login attempts all processed ❌

**Manual test**:
```bash
# Attempt 50 logins in rapid succession
for i in {1..50}; do
  curl -s -o /dev/null -w "%{http_code}\n" \
    -X POST http://localhost:3000/api/login \
    -H "Content-Type: application/json" \
    -d '{"email":"test@example.com","password":"wrong'$i'"}'
done
```

All attempts return 401 (no rate limiting) - vulnerability confirmed

---

### Bug 3: Insecure Transport (HTTP)

**What it tests**: Whether credentials are sent over unencrypted HTTP

```bash
./tests/test_bug3_insecure_transport.sh http://localhost:3000
```

**Expected outcome**: 
- HTTP requests accepted ❌
- No redirect to HTTPS ❌
- No HSTS header ❌

**Manual test**:
```bash
# Register over HTTP
curl -i -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test_http@example.com","password":"TestPass123"}'
```

Returns 201 Created over HTTP - vulnerability confirmed

---

### Bug 4: Session Fixation

**What it tests**: Whether session ID changes after login

```bash
./tests/test_bug4_session_fixation.sh http://localhost:3000
```

**Expected outcome**: Session ID remains the same after login ❌

**Manual test**:
1. Open browser DevTools → Application → Cookies
2. Visit http://localhost:3000/login
3. Note the `connect.sid` cookie value (pre-login)
4. Login with valid credentials
5. Check `connect.sid` cookie value again (post-login)
6. Session ID is identical - vulnerability confirmed

---

## 🔍 Web Interface Testing

### Test via Browser

1. **Start server**: `npm start`
2. **Open browser**: http://localhost:3000

### Test Bug 1 (Weak Password):
1. Click "Register here"
2. Enter email: `weak@test.com`
3. Enter password: `password`
4. Click "Register"
5. ✅ Account created (vulnerability confirmed)

### Test Bug 4 (Session Fixation):
1. Open DevTools → Application → Cookies
2. Note session ID before login
3. Login with credentials
4. Note session ID after login
5. ✅ Session ID unchanged (vulnerability confirmed)

---

## 📊 Test Results Interpretation

### Successful Vulnerability Reproduction

When tests complete, you should see:

```
FINAL TEST RESULTS
========================================
Total Tests: 4
Passed: 0
Failed: 4

🚨 VULNERABILITIES DETECTED:
   ❌ Bug 1: Weak Password Policy
   ❌ Bug 2: No Rate Limiting
   ❌ Bug 3: Insecure Transport
   ❌ Bug 4: Session Fixation
```

**This is expected!** All tests "fail" because they detect vulnerabilities (which is the goal).

---

## 📝 Collecting Evidence

### Server Logs

Watch server console output for detailed request logs:
```
[REGISTER] New user registered: test@example.com with password length: 8
[LOGIN ATTEMPT] Email: victim@example.com, Session ID: s%3A...
[LOGIN FAILED] Invalid credentials for: victim@example.com
[LOGIN SUCCESS] User logged in: test@example.com, Session ID: s%3A...
```

### Test Output

All test scripts generate detailed evidence:
- HTTP status codes
- Request/response bodies
- Timing information
- Session IDs
- Vulnerability confirmation

### Screenshots

For visual evidence:
1. Open http://localhost:3000/register
2. Enter weak password
3. Take screenshot of successful registration
4. Open dashboard to show session info
5. Take screenshot showing session ID

---

## 🛠️ Troubleshooting

### Server not starting?

```bash
# Check if port 3000 is already in use
lsof -i :3000

# Kill existing process if needed
kill -9 <PID>

# Or use a different port
PORT=3001 npm start
```

### Tests failing to connect?

```bash
# Verify server is running
curl http://localhost:3000

# If using different port
./run_all_tests.sh http://localhost:3001
```

### Permission denied on test scripts?

```bash
chmod +x run_all_tests.sh
chmod +x tests/*.sh
```

---

## 📚 Next Steps

1. ✅ Review test results in terminal
2. ✅ Check `EVIDENCE_REPORT.md` for detailed findings
3. ✅ Review `README.md` for complete documentation
4. ✅ Examine `server.js` to see vulnerable code
5. ✅ Review remediation recommendations

---

## ⚠️ Important Notes

- **This application is intentionally vulnerable**
- **Never deploy this to production**
- **Never expose this to the internet**
- **Use only in isolated test environments**
- All vulnerabilities are documented and deliberate

---

## 🎯 Success Criteria

You have successfully completed the testing when:

- [x] Server starts without errors
- [x] All 4 test scripts execute
- [x] All 4 vulnerabilities are confirmed
- [x] Evidence is collected (logs, outputs, responses)
- [x] You understand each vulnerability's impact

**Estimated time**: 5-10 minutes

**Result**: Complete evidence package for all 4 high-severity vulnerabilities
