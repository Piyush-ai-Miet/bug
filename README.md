# Security Vulnerability Demonstration Project

This repository contains a deliberately vulnerable web application designed to demonstrate and reproduce four high-severity security vulnerabilities as specified in the issue tracker.

## 🚨 WARNING

**This application is intentionally insecure and should NEVER be deployed to production or exposed to the internet.**

This is a demonstration/educational project for security testing purposes only.

## Overview

This project demonstrates the following security vulnerabilities:

1. **BUG-HIGH-001**: Weak Password Policy - No password complexity enforcement
2. **BUG-HIGH-002**: No Rate Limiting on Login Endpoint
3. **BUG-HIGH-003**: Credentials Sent Over HTTP (Insecure Transport)
4. **BUG-HIGH-004**: Session Fixation - Session ID not regenerated on login

## Prerequisites

- Node.js (v14 or higher)
- npm
- curl (for running tests)
- bash (for running test scripts)

## Installation

```bash
# Clone the repository
git clone https://github.com/Piyush-ai-Miet/bug.git
cd bug

# Install dependencies
npm install
```

## Running the Application

```bash
# Start the vulnerable server
npm start
```

The server will start on `http://localhost:3000`

You can then access:
- Login page: http://localhost:3000/login
- Registration page: http://localhost:3000/register
- Dashboard (requires login): http://localhost:3000/dashboard

## Running Vulnerability Tests

### Run All Tests

```bash
# Run all vulnerability tests
./run_all_tests.sh
```

### Run Individual Tests

```bash
# Test 1: Weak Password Policy
./tests/test_bug1_weak_password.sh http://localhost:3000

# Test 2: No Rate Limiting
./tests/test_bug2_rate_limiting.sh http://localhost:3000

# Test 3: Insecure Transport
./tests/test_bug3_insecure_transport.sh http://localhost:3000

# Test 4: Session Fixation
./tests/test_bug4_session_fixation.sh http://localhost:3000
```

## Vulnerability Details

### Bug 1: Weak Password Policy (BUG-HIGH-001)

**Severity**: High - CVSS 7.5

**Description**: The application accepts weak passwords without any complexity enforcement.

**How to Reproduce**:
1. Start the server: `npm start`
2. Navigate to http://localhost:3000/register
3. Try registering with weak passwords: "password", "12345678", "qwerty123"
4. All weak passwords are accepted ❌

**Expected Behavior**: Server should reject passwords that don't meet complexity requirements (min 10 chars, uppercase, lowercase, number, special char).

**Actual Behavior**: Any password is accepted, including common weak passwords.

**Evidence**: Run `./tests/test_bug1_weak_password.sh` to see automated proof.

**Impact**: 
- Accounts vulnerable to brute-force attacks
- Easy credential stuffing
- Low authentication security

---

### Bug 2: No Rate Limiting (BUG-HIGH-002)

**Severity**: High - CVSS 7.5

**Description**: The login endpoint allows unlimited login attempts without any rate limiting or account lockout.

**How to Reproduce**:
1. Start the server: `npm start`
2. Run the test script: `./tests/test_bug2_rate_limiting.sh`
3. Script will attempt 30-50 rapid login attempts
4. All attempts are processed without throttling ❌

**Expected Behavior**: After 5-10 failed attempts, server should:
- Return HTTP 429 (Too Many Requests)
- Implement temporary account lockout
- Apply exponential backoff

**Actual Behavior**: Unlimited attempts are allowed.

**Evidence**: Run `./tests/test_bug2_rate_limiting.sh` to see automated proof.

**Impact**:
- Brute-force attacks possible
- Credential stuffing attacks enabled
- No protection against automated attacks

---

### Bug 3: Insecure Transport (BUG-HIGH-003)

**Severity**: High - CVSS 8.1

**Description**: The application transmits credentials over HTTP without enforcing HTTPS.

**How to Reproduce**:
1. Start the server: `npm start`
2. Application runs on HTTP (not HTTPS)
3. All credentials are sent in plaintext
4. No HSTS header present ❌

**Expected Behavior**: 
- All traffic should be over HTTPS
- HTTP should redirect to HTTPS
- HSTS header should be present

**Actual Behavior**: Application accepts HTTP connections and transmits credentials in plaintext.

**Evidence**: Run `./tests/test_bug3_insecure_transport.sh` to see automated proof.

**Impact**:
- Man-in-the-Middle (MITM) attacks possible
- Credentials can be intercepted
- Session hijacking possible

---

### Bug 4: Session Fixation (BUG-HIGH-004)

**Severity**: High - CVSS 8.8

**Description**: Session ID is not regenerated upon successful authentication.

**How to Reproduce**:
1. Start the server: `npm start`
2. Open browser DevTools → Application → Cookies
3. Note the session cookie value before login
4. Login with valid credentials
5. Check session cookie value after login
6. Session ID remains the same ❌

**Expected Behavior**: Session ID should be regenerated on successful login, and old session should be invalidated.

**Actual Behavior**: Session ID persists across authentication state change.

**Evidence**: Run `./tests/test_bug4_session_fixation.sh` to see automated proof.

**Manual Testing**:
```bash
# Get initial session
curl -i -c cookies.txt http://localhost:3000/login

# Login with same session
curl -i -b cookies.txt -c cookies.txt -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Check cookies.txt - session ID will be identical
cat cookies.txt
```

**Impact**:
- Attacker can fix session before victim login
- Session hijacking after authentication
- Complete account takeover possible

## Test Evidence and Reports

All test scripts generate detailed evidence reports including:
- HTTP request/response details
- Status codes
- Response bodies
- Timing information
- Vulnerability confirmation

### Example Test Output

When you run `./run_all_tests.sh`, you will see:

```
VULNERABILITY TEST SUITE
Security Bug Reproduction Tests
========================================

Target: http://localhost:3000

Running Test Suite...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TEST 1/4: Weak Password Policy
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Testing password: 'password'
   Email: test_weak_1@example.com
   HTTP Status: 201
   Response: {"success":true,"message":"Registration successful"...}
   ❌ VULNERABLE: Weak password 'password' was ACCEPTED!

[... more test output ...]

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

## Project Structure

```
bug/
├── server.js                          # Vulnerable Express.js server
├── package.json                       # Node.js dependencies
├── README.md                          # This file
├── run_all_tests.sh                   # Master test runner
├── public/                            # Web interface
│   ├── login.html                     # Login page
│   ├── register.html                  # Registration page
│   └── dashboard.html                 # Protected dashboard
└── tests/                             # Vulnerability test scripts
    ├── test_bug1_weak_password.sh     # Test for weak password policy
    ├── test_bug2_rate_limiting.sh     # Test for rate limiting
    ├── test_bug3_insecure_transport.sh # Test for HTTP/HTTPS
    └── test_bug4_session_fixation.sh  # Test for session fixation
```

## API Endpoints

### POST /api/register
Register a new user account.

**Request**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response** (201 Created):
```json
{
  "success": true,
  "message": "Registration successful",
  "user": {
    "email": "user@example.com"
  }
}
```

### POST /api/login
Authenticate user and create session.

**Request**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "email": "user@example.com"
  }
}
```

### GET /api/user
Get current authenticated user information.

**Response** (200 OK):
```json
{
  "success": true,
  "user": {
    "email": "user@example.com",
    "sessionId": "s%3A..."
  }
}
```

### POST /api/logout
Logout and destroy session.

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Logout successful"
}
```

## Remediation Guidelines

### For Bug 1: Weak Password Policy
- Implement password complexity validation
- Minimum 10-12 characters
- Require uppercase, lowercase, number, special character
- Check against common password lists
- Use libraries like `zxcvbn` or `owasp-password-strength-test`

### For Bug 2: No Rate Limiting
- Implement rate limiting middleware (e.g., `express-rate-limit`)
- Set threshold: 5 failed attempts per 15 minutes per account
- Implement account lockout after threshold
- Add CAPTCHA after multiple failures
- Log and alert on suspicious activity

### For Bug 3: Insecure Transport
- Enforce HTTPS only
- Redirect all HTTP to HTTPS (301/302)
- Add HSTS header: `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`
- Disable HTTP listener in production
- Use secure cookies with `secure: true` flag

### For Bug 4: Session Fixation
- Call `req.session.regenerate()` on successful login
- Invalidate old session after regeneration
- Ensure session IDs are unpredictable
- Use secure session configuration

## Testing Against Remote Deployments

If you deploy this to a remote server (for testing purposes only):

```bash
# Test against remote URL
./run_all_tests.sh https://your-test-domain.com
```

Or individual tests:
```bash
./tests/test_bug1_weak_password.sh https://your-test-domain.com
```

## Security Notes

⚠️ **CRITICAL REMINDERS**:

1. This application is intentionally vulnerable
2. NEVER deploy this to production
3. NEVER expose this to the internet
4. Use only in isolated test environments
5. All vulnerabilities are documented and deliberate
6. This is for educational and demonstration purposes only

## License

This is a demonstration project for security testing purposes.

## Contact

For questions about this demonstration project, please refer to the issue tracker in the repository.
