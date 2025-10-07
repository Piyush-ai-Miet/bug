const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// In-memory user storage (for demonstration purposes)
const users = new Map();
// Store failed login attempts
const loginAttempts = new Map();

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// BUG 4: Session Fixation - Session not regenerated on login
app.use(session({
  secret: 'insecure-secret-key',
  resave: false,
  saveUninitialized: true,
  cookie: { 
    secure: false, // BUG 3: Not enforcing secure cookies
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }
}));

// Serve static files
app.use(express.static('public'));

// Root route
app.get('/', (req, res) => {
  if (req.session.userId) {
    res.redirect('/dashboard');
  } else {
    res.redirect('/login');
  }
});

// Login page
app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

// Registration page
app.get('/register', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'register.html'));
});

// Dashboard page (protected)
app.get('/dashboard', (req, res) => {
  if (!req.session.userId) {
    return res.redirect('/login');
  }
  res.sendFile(path.join(__dirname, 'public', 'dashboard.html'));
});

// BUG 1: Weak Password Policy - No password complexity enforcement
// API: Register endpoint
app.post('/api/register', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ 
      success: false, 
      message: 'Email and password are required' 
    });
  }

  // Check if user already exists
  if (users.has(email)) {
    return res.status(400).json({ 
      success: false, 
      message: 'User already exists' 
    });
  }

  // BUG 1: NO PASSWORD COMPLEXITY CHECK - accepts any password including "password", "12345678"
  // Missing: password length check, complexity requirements, common password check
  
  // Store user (in production, password should be hashed)
  users.set(email, {
    email,
    password, // BUG: Storing plain text password (additional security issue)
    createdAt: new Date()
  });

  console.log(`[REGISTER] New user registered: ${email} with password length: ${password.length}`);

  res.status(201).json({ 
    success: true, 
    message: 'Registration successful',
    user: { email }
  });
});

// BUG 2: No Rate Limiting on Login Endpoint
// API: Login endpoint
app.post('/api/login', (req, res) => {
  const { email, password } = req.body;

  console.log(`[LOGIN ATTEMPT] Email: ${email}, Session ID: ${req.sessionID}`);

  if (!email || !password) {
    return res.status(400).json({ 
      success: false, 
      message: 'Email and password are required' 
    });
  }

  // BUG 2: NO RATE LIMITING - unlimited login attempts allowed
  // Missing: IP-based throttling, account-based lockout, exponential backoff
  
  const user = users.get(email);

  if (!user || user.password !== password) {
    console.log(`[LOGIN FAILED] Invalid credentials for: ${email}`);
    return res.status(401).json({ 
      success: false, 
      message: 'Invalid email or password' 
    });
  }

  // BUG 4: SESSION FIXATION - Session ID not regenerated on successful login
  // Missing: req.session.regenerate() call
  req.session.userId = email;

  console.log(`[LOGIN SUCCESS] User logged in: ${email}, Session ID: ${req.sessionID}`);

  res.json({ 
    success: true, 
    message: 'Login successful',
    user: { email }
  });
});

// API: Logout endpoint
app.post('/api/logout', (req, res) => {
  const email = req.session.userId;
  req.session.destroy((err) => {
    if (err) {
      console.error('[LOGOUT ERROR]', err);
      return res.status(500).json({ success: false, message: 'Logout failed' });
    }
    console.log(`[LOGOUT] User logged out: ${email}`);
    res.json({ success: true, message: 'Logout successful' });
  });
});

// API: Get current user
app.get('/api/user', (req, res) => {
  if (!req.session.userId) {
    return res.status(401).json({ 
      success: false, 
      message: 'Not authenticated' 
    });
  }

  const user = users.get(req.session.userId);
  res.json({ 
    success: true, 
    user: { 
      email: user.email,
      sessionId: req.sessionID // Exposing session ID for demonstration
    }
  });
});

// API: Get server stats (for testing purposes)
app.get('/api/stats', (req, res) => {
  res.json({
    totalUsers: users.size,
    userEmails: Array.from(users.keys())
  });
});

// BUG 3: Insecure Transport - Server accepts HTTP connections
// This server runs on HTTP by default, not HTTPS
app.listen(PORT, () => {
  console.log(`========================================`);
  console.log(`Vulnerable Demo Server Running`);
  console.log(`Port: ${PORT}`);
  console.log(`========================================`);
  console.log(`KNOWN VULNERABILITIES:`);
  console.log(`1. Weak Password Policy - No complexity enforcement`);
  console.log(`2. No Rate Limiting - Unlimited login attempts`);
  console.log(`3. Insecure Transport - HTTP only (no HTTPS)`);
  console.log(`4. Session Fixation - Session ID not regenerated`);
  console.log(`========================================`);
  console.log(`Access the application at: http://localhost:${PORT}`);
});

module.exports = app;
