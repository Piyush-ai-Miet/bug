# Bug Report Template

Use this template when documenting bugs found during testing.

---

## Bug ID: [UNIQUE-ID]

### Summary
**Title**: [Short, descriptive title]

**Severity**: [ ] Critical  [ ] High  [ ] Medium  [ ] Low

**Status**: [ ] New  [ ] In Progress  [ ] Fixed  [ ] Wont Fix

**Discovered Date**: YYYY-MM-DD

**Reporter**: [Your name]

---

### Description
[Provide a clear and concise description of the bug]

---

### Environment
- **URL**: https://code-edit-lac.vercel.app/login
- **Browser**: [e.g., Chrome 120.0.6099.109]
- **Operating System**: [e.g., Windows 11, macOS 14, Ubuntu 22.04]
- **Device**: [e.g., Desktop, iPhone 14, Samsung Galaxy S23]
- **Screen Resolution**: [e.g., 1920x1080]
- **Network**: [e.g., WiFi, 4G, Fast 3G throttled]

---

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]
4. [Additional steps...]

---

### Expected Behavior
[Describe what should happen]

---

### Actual Behavior
[Describe what actually happens]

---

### Visual Evidence
**Screenshots**:
[Attach screenshots here or describe what you see]

**Video Recording** (if applicable):
[Link to video or attach file]

**Console Errors**:
```
[Paste any console errors here]
```

**Network Errors**:
```
[Paste any network errors from DevTools]
```

---

### Reproducibility
- [ ] Always reproducible (100%)
- [ ] Sometimes reproducible (>50%)
- [ ] Rarely reproducible (<50%)
- [ ] Only happened once

---

### Additional Information
**Possible Cause**:
[If you have an idea what might be causing this]

**Suggested Fix**:
[If you have a suggestion for how to fix it]

**Related Issues**:
[Link to any related bug reports]

**Workaround**:
[If there's a way to work around the issue]

---

### Impact Assessment
**User Impact**: [How does this affect users?]

**Business Impact**: [How does this affect the business?]

**Affected Users**: [Estimated % or number of users affected]

---

### Testing Notes
[Any additional notes from testing]

---

## Example Bug Reports

### Example 1: Authentication Issue

---

## Bug ID: LOGIN-001

### Summary
**Title**: User stuck on login page after successful authentication

**Severity**: [x] Critical  [ ] High  [ ] Medium  [ ] Low

**Status**: [x] New  [ ] In Progress  [ ] Fixed  [ ] Wont Fix

**Discovered Date**: 2025-10-07

**Reporter**: Beta Tester

---

### Description
After entering valid credentials and clicking the login button, the authentication appears to succeed (no error message is shown), but the user remains on the login page instead of being redirected to the dashboard.

---

### Environment
- **URL**: https://code-edit-lac.vercel.app/login
- **Browser**: Chrome 120.0.6099.109
- **Operating System**: Windows 11
- **Device**: Desktop
- **Screen Resolution**: 1920x1080
- **Network**: WiFi

---

### Steps to Reproduce
1. Navigate to https://code-edit-lac.vercel.app/login
2. Enter valid email: test@example.com
3. Enter valid password: ********
4. Click "Login" button
5. Observe that page reloads but doesn't redirect

---

### Expected Behavior
After successful login, the user should be redirected to the main application dashboard or home page.

---

### Actual Behavior
The login page reloads or stays the same. No redirect occurs. User remains on the login page with empty form fields.

---

### Visual Evidence
**Console Errors**:
```
POST https://code-edit-lac.vercel.app/api/auth/login 200 OK
Warning: Router.push() failed - no valid redirect URL found
```

**Network Errors**:
```
Status: 200 OK
Response: { "success": true, "token": "eyJ..." }
```

---

### Reproducibility
- [x] Always reproducible (100%)
- [ ] Sometimes reproducible (>50%)
- [ ] Rarely reproducible (<50%)
- [ ] Only happened once

---

### Additional Information
**Possible Cause**:
The backend authentication is working (returns 200 and token), but the frontend redirect logic after successful authentication may not be implemented or has a bug.

**Suggested Fix**:
Add redirect logic after successful authentication response:
```javascript
if (response.success) {
  router.push('/dashboard'); // or window.location.href = '/dashboard'
}
```

---

### Impact Assessment
**User Impact**: Users cannot access the application after logging in - complete blocker

**Business Impact**: No users can use the application - prevents beta testing

**Affected Users**: 100% of users

---

### Example 2: Form Validation Issue

---

## Bug ID: LOGIN-002

### Summary
**Title**: Login form accepts invalid email format

**Severity**: [ ] Critical  [ ] High  [x] Medium  [ ] Low

**Status**: [x] New  [ ] In Progress  [ ] Fixed  [ ] Wont Fix

**Discovered Date**: 2025-10-07

**Reporter**: Beta Tester

---

### Description
The email input field accepts invalid email formats (e.g., "test", "test@", "@example.com") and attempts to submit to the server, resulting in a backend error instead of client-side validation.

---

### Environment
- **URL**: https://code-edit-lac.vercel.app/login
- **Browser**: Firefox 121.0
- **Operating System**: macOS 14.1
- **Device**: MacBook Pro
- **Screen Resolution**: 2560x1600

---

### Steps to Reproduce
1. Navigate to https://code-edit-lac.vercel.app/login
2. Enter invalid email: "test@" in email field
3. Enter any password
4. Click "Login" button
5. Observe backend error response

---

### Expected Behavior
The form should validate email format client-side before submission and show an error message like "Please enter a valid email address" without making a server request.

---

### Actual Behavior
The form submits the invalid email to the server, and a backend error is returned: "Invalid email format".

---

### Visual Evidence
**Console Errors**:
```
POST https://code-edit-lac.vercel.app/api/auth/login 400 Bad Request
Response: { "error": "Invalid email format" }
```

---

### Reproducibility
- [x] Always reproducible (100%)

---

### Additional Information
**Suggested Fix**:
Add client-side email validation:
```javascript
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
if (!emailRegex.test(email)) {
  setError("Please enter a valid email address");
  return;
}
```

---

### Impact Assessment
**User Impact**: Poor user experience - unnecessarily slow feedback

**Business Impact**: Increased server load from invalid requests

**Affected Users**: Any user who mistype their email

---
