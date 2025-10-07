# Quick Bug Testing Checklist for code-edit-lac.vercel.app/login

## 🔴 Critical Priority

### Authentication & Security
- [ ] HTTPS is enforced (no HTTP access)
- [ ] CSRF protection is implemented
- [ ] OAuth redirect URIs are correctly configured for production
- [ ] Rate limiting prevents brute force attacks
- [ ] Passwords are never logged or displayed in plain text

## 🟡 High Priority

### Core Functionality
- [ ] Login with valid credentials works and redirects properly
- [ ] Login with invalid credentials shows appropriate error
- [ ] Session persists after successful login
- [ ] Logout functionality works correctly
- [ ] "Forgot Password" link exists and works

### OAuth Integration
- [ ] Google OAuth login works (if implemented)
- [ ] GitHub OAuth login works (if implemented)  
- [ ] OAuth callback handling is correct
- [ ] OAuth errors are handled gracefully

## 🟢 Medium Priority

### Form Validation
- [ ] Email field validates email format
- [ ] Password field has minimum requirements
- [ ] Required fields cannot be empty
- [ ] Error messages are clear and helpful
- [ ] Form cannot be submitted multiple times

### User Experience
- [ ] Page is responsive on mobile devices
- [ ] Loading indicator shows during authentication
- [ ] Submit button is disabled during processing
- [ ] Password visibility toggle works
- [ ] Form fields are keyboard accessible

### Accessibility
- [ ] Form labels are properly associated with inputs
- [ ] ARIA attributes are present
- [ ] Color contrast meets WCAG standards
- [ ] Page can be navigated with keyboard only
- [ ] Screen readers can understand the form

## 🔵 Low Priority

### Polish & Performance
- [ ] Login completes within 2-3 seconds
- [ ] No console errors appear
- [ ] Page loads quickly (check Lighthouse score)
- [ ] Images and assets are optimized
- [ ] Animations are smooth

## Testing Tools

### Browser DevTools
```
# Check console for errors
F12 > Console

# Inspect network requests
F12 > Network > Filter by Fetch/XHR

# Test mobile view
F12 > Toggle device toolbar (Ctrl+Shift+M)

# Check accessibility
F12 > Lighthouse > Run audit
```

### Manual Testing Scenarios

**Test 1: Valid Login**
```
1. Enter valid email and password
2. Click "Login" button
3. Expected: Redirect to dashboard/home page
```

**Test 2: Invalid Login**
```
1. Enter wrong email or password
2. Click "Login" button
3. Expected: Error message displayed, stay on login page
```

**Test 3: Empty Form**
```
1. Leave all fields empty
2. Click "Login" button
3. Expected: Validation errors for required fields
```

**Test 4: OAuth Flow**
```
1. Click "Login with Google/GitHub"
2. Complete OAuth authorization
3. Expected: Return to app and be logged in
```

**Test 5: Session Persistence**
```
1. Log in successfully
2. Close and reopen browser
3. Expected: Still logged in (if "Remember me" was checked)
```

## Quick Bug Report Template

When you find a bug, document it like this:

```markdown
## Bug: [Short description]

**Severity**: Critical/High/Medium/Low

**Steps to Reproduce**:
1. Step one
2. Step two
3. Step three

**Expected Behavior**:
What should happen

**Actual Behavior**:
What actually happens

**Screenshots**:
(Attach if applicable)

**Environment**:
- Browser: Chrome 120
- OS: Windows 11
- Device: Desktop

**Additional Notes**:
Any other relevant information
```

## Common Fixes Reference

### Stuck After Login
```javascript
// Check if redirect is implemented
// Should be something like:
if (loginSuccessful) {
  router.push('/dashboard');
  // or
  window.location.href = '/dashboard';
}
```

### OAuth Not Working in Production
```javascript
// Verify environment variables are set in Vercel:
// - GOOGLE_CLIENT_ID
// - GOOGLE_CLIENT_SECRET
// - NEXTAUTH_URL (should be production URL)
// - NEXTAUTH_SECRET

// Check callback URL in OAuth provider settings
// Should be: https://code-edit-lac.vercel.app/api/auth/callback/google
```

### Form Validation Not Working
```javascript
// Basic validation example
const validateEmail = (email) => {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
};

const validatePassword = (password) => {
  return password.length >= 8;
};
```

### CSRF Protection
```javascript
// Ensure CSRF tokens are included in forms
// For Next.js with NextAuth, this is handled automatically
// For custom auth, use a CSRF library like 'csurf'
```

## Report Your Findings

After testing, create individual issues for each bug found with:
- Clear title
- Severity level
- Detailed reproduction steps
- Screenshots or videos
- Proposed solution (if known)

---

**Ready to Start Testing?**
Go through each checklist item systematically and document any issues found.
