# Quick Reference: Top 10 Bugs to Find

**Website:** https://code-edit-lac.vercel.app/login

This is a quick reference card for the most critical bugs to test for during the beta testing round. For complete testing instructions, see [TESTING_GUIDE.md](TESTING_GUIDE.md).

---

## 🚨 CRITICAL - Test First (5 minutes)

### 1. SQL Injection
**Test:** Enter `admin' OR '1'='1` in username field  
**Bug If:** Login succeeds or shows database error  
**Impact:** 🔴 Complete database compromise

### 2. XSS (Cross-Site Scripting)
**Test:** Enter `<script>alert('XSS')</script>` in username field  
**Bug If:** Alert popup appears  
**Impact:** 🔴 Session hijacking possible

### 3. HTTP (Not HTTPS)
**Test:** Open DevTools → Network → Try login → Check URL  
**Bug If:** Request uses `http://` instead of `https://`  
**Impact:** 🔴 Credentials can be intercepted

---

## ⚠️ HIGH PRIORITY - Test Next (10 minutes)

### 4. No Rate Limiting
**Test:** Enter wrong password 15 times rapidly  
**Bug If:** No CAPTCHA, no lockout, no slowdown  
**Impact:** 🟡 Vulnerable to brute force attacks

### 5. User Enumeration
**Test:** Try valid email with wrong password vs invalid email  
**Bug If:** Different error messages reveal if email exists  
**Impact:** 🟡 Attackers can find valid usernames

### 6. Weak Password Policy
**Test:** Try password `123` or `abc`  
**Bug If:** Accepts weak passwords  
**Impact:** 🟡 Easy to crack accounts

---

## 🔍 IMPORTANT - Functional Tests (10 minutes)

### 7. Valid Login Broken
**Test:** Use valid credentials  
**Bug If:** Login fails or stays on same page  
**Impact:** 🟠 Users cannot access application

### 8. No Loading Indicator
**Test:** Click Login button and observe  
**Bug If:** No spinner, button stays enabled  
**Impact:** 🔵 Users might click multiple times

### 9. Not Mobile-Friendly
**Test:** Open on mobile or use DevTools Device Mode  
**Bug If:** Layout broken, buttons too small, horizontal scroll  
**Impact:** 🟠 Poor user experience on mobile

### 10. No Keyboard Navigation
**Test:** Use only Tab and Enter keys (no mouse)  
**Bug If:** Cannot complete login without mouse  
**Impact:** 🟠 Accessibility issue

---

## 📋 Quick Testing Checklist

Print this and check off as you test:

**Security (5 min)**
- [ ] SQL Injection test
- [ ] XSS test
- [ ] HTTPS verification
- [ ] Rate limiting test

**Functionality (5 min)**
- [ ] Valid login works
- [ ] Invalid login shows error
- [ ] Empty fields validated
- [ ] Loading indicator present

**Compatibility (5 min)**
- [ ] Works on mobile
- [ ] Works with keyboard only
- [ ] Test in Chrome
- [ ] Test in Firefox

---

## 🎯 Quick Bug Report Template

```markdown
## Bug: [Title]

**Severity:** 🔴/🟡/🟠/🔵

**Steps:**
1. Go to login page
2. [Do this]
3. [Observe this]

**Expected:** [What should happen]
**Actual:** [What happens]

**Browser:** Chrome 120
**Device:** Desktop
**Screenshot:** [Attach]
```

---

## 🚀 Next Steps

1. **Test these 10 bugs first** (25 minutes)
2. **Document any findings** using template above
3. **Continue with full testing** using [TESTING_GUIDE.md](TESTING_GUIDE.md)
4. **Report all bugs found** via GitHub issues

---

## 📊 What Makes a Good Bug Report?

✅ **Good Example:**
```
Bug: SQL Injection vulnerability in login form

Severity: 🔴 Critical

Steps to Reproduce:
1. Open https://code-edit-lac.vercel.app/login
2. Enter admin' OR '1'='1 in username field
3. Enter anything in password field
4. Click Login

Expected: Should reject input and show error
Actual: Login succeeds without valid credentials

Browser: Chrome 120.0.6099.129
OS: Windows 11
Screenshot: [attached]
Console: No errors shown
```

❌ **Bad Example:**
```
Bug: Login doesn't work

It's broken. Fix it.
```

---

## 💡 Pro Tips

1. **Test in order** - Start with Critical bugs first
2. **Take screenshots** - Visual proof is important
3. **Check console** - Press F12, look for red errors
4. **Try it twice** - Ensure bug is reproducible
5. **Be specific** - "Button doesn't work" vs "Login button shows no response when clicked"

---

## ⏱️ Time Estimates

- **Quick scan:** 15 minutes (these 10 bugs)
- **Thorough test:** 80 minutes (all 27 tests)
- **Full analysis:** 2-3 hours (including documentation)

---

**Start testing now! Open the login page and try Bug #1 (SQL Injection) first.**

**Need more details? → [TESTING_GUIDE.md](TESTING_GUIDE.md)**
