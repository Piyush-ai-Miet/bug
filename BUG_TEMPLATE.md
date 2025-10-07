# Bug Report Template

Use this template to document new bugs found during testing of https://code-edit-lac.vercel.app/login

---

## Bug #[Number]: [Short Title]

**Severity**: [Critical/High/Medium/Low]  
**Category**: [Authentication/UI/UX/Performance/Security/Validation/Compatibility/Other]  
**Status**: [Open/In Progress/Fixed/Closed]  
**Reported By**: [Your Name]  
**Date Reported**: [YYYY-MM-DD]  
**Assigned To**: [Developer Name or "Unassigned"]

---

### Description
[Provide a clear, concise description of the bug. What is happening that shouldn't be happening?]

---

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]
4. [And so on...]

---

### Expected Behavior
[Describe what should happen when following the steps above]

---

### Actual Behavior
[Describe what actually happens instead]

---

### Screenshots/Videos
[Attach screenshots or videos if applicable]
- Screenshot 1: [Description]
- Screenshot 2: [Description]
- Video: [Link or attachment]

---

### Environment
- **URL**: https://code-edit-lac.vercel.app/login
- **Browser**: [e.g., Chrome 120.0.6099.109]
- **Operating System**: [e.g., Windows 11, macOS 14.0, iOS 17.1]
- **Device**: [e.g., Desktop, iPhone 14, Samsung Galaxy S23]
- **Screen Resolution**: [e.g., 1920x1080]
- **Network**: [e.g., WiFi, 4G, 3G]
- **Date/Time**: [When the bug occurred]

---

### Console Errors
[Copy any JavaScript errors from browser console]
```
[Paste console errors here]
```

---

### Network Request Details
[If relevant, include details about failed network requests]
- **Request URL**: [URL]
- **Status Code**: [e.g., 400, 500, timeout]
- **Response**: [Response body if relevant]

---

### Possible Causes
[List potential root causes if you have technical insight]
- [Possible cause 1]
- [Possible cause 2]
- [Possible cause 3]

---

### Suggested Fix
[If you have ideas for how to fix this bug, describe them here]

---

### Impact
**User Impact**: [How does this affect users?]
- [ ] Prevents login completely
- [ ] Degrades user experience
- [ ] Security concern
- [ ] Performance issue
- [ ] Cosmetic issue only

**Frequency**: [How often does this occur?]
- [ ] Always (100%)
- [ ] Often (>50%)
- [ ] Sometimes (10-50%)
- [ ] Rarely (<10%)

**Workaround Available**: [Yes/No]
[If yes, describe the workaround]

---

### Related Bugs
[List any related bugs]
- Related to Bug #[Number]: [Title]
- Duplicate of Bug #[Number]: [Title]
- Blocked by Bug #[Number]: [Title]

---

### Testing Notes
[Additional notes from testing]

---

### Fix Verification
[After fix is implemented, document verification steps]
- [ ] Bug fix verified in development environment
- [ ] Bug fix verified in staging environment
- [ ] Bug fix verified in production environment
- [ ] No regression issues found
- [ ] All related tests pass

---

## Severity Guidelines

### Critical
- Complete system failure
- Data loss or corruption
- Security vulnerability
- No workaround available

### High
- Major feature broken
- Significant user impact
- Difficult workaround
- Affects multiple users

### Medium
- Feature partially working
- Moderate user impact
- Easy workaround available
- Affects specific scenarios

### Low
- Minor inconvenience
- Cosmetic issue
- Minimal user impact
- Easy to avoid

---

## Category Descriptions

- **Authentication**: Login, logout, session management
- **UI/UX**: Visual design, layout, user experience
- **Performance**: Load times, responsiveness, speed
- **Security**: Vulnerabilities, data protection, access control
- **Validation**: Input validation, form validation
- **Compatibility**: Browser, device, OS compatibility
- **Functionality**: Feature behavior, business logic
- **Accessibility**: Screen readers, keyboard navigation, WCAG compliance
- **API**: Backend integration, API responses
- **Network**: Connection issues, timeouts, offline behavior
