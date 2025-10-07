#!/bin/bash
# Bug 4 Test Script: Session Fixation (Session ID not regenerated on login)
# This script tests whether the application regenerates session ID on login

echo "=========================================="
echo "BUG 4: Session Fixation Test"
echo "=========================================="
echo ""

BASE_URL="${1:-http://localhost:3000}"
echo "Testing against: $BASE_URL"
echo ""

# Test user credentials
TEST_EMAIL="session_test_$(date +%s)@example.com"
TEST_PASSWORD="TestPassword123"

echo "Step 1: Registering test user..."
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/api/register" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$TEST_EMAIL\",\"password\":\"$TEST_PASSWORD\"}")

echo "Registration: $REGISTER_RESPONSE"
echo ""

echo "Step 2: Getting initial session cookie (pre-login)..."
echo ""

# Get initial session cookie by visiting login page
INITIAL_COOKIES=$(mktemp)
curl -s -c "$INITIAL_COOKIES" "$BASE_URL/login" > /dev/null

# Extract session cookie value
PRE_LOGIN_SESSION=$(grep -oP 'connect\.sid\s+\K[^\s]+' "$INITIAL_COOKIES" || echo "not_found")
echo "Pre-login session cookie: $PRE_LOGIN_SESSION"
echo ""

echo "Step 3: Logging in with the existing session cookie..."
echo ""

# Login using the same cookie jar
POST_LOGIN_COOKIES=$(mktemp)
LOGIN_RESPONSE=$(curl -s -b "$INITIAL_COOKIES" -c "$POST_LOGIN_COOKIES" \
    -X POST "$BASE_URL/api/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$TEST_EMAIL\",\"password\":\"$TEST_PASSWORD\"}")

echo "Login response: $LOGIN_RESPONSE"
echo ""

# Extract post-login session cookie
POST_LOGIN_SESSION=$(grep -oP 'connect\.sid\s+\K[^\s]+' "$POST_LOGIN_COOKIES" || echo "not_found")
echo "Post-login session cookie: $POST_LOGIN_SESSION"
echo ""

echo "Step 4: Comparing session cookies..."
echo ""

# Clean up temp files
rm -f "$INITIAL_COOKIES" "$POST_LOGIN_COOKIES"

echo "=========================================="
echo "SESSION COMPARISON"
echo "=========================================="
echo "Pre-login session:  $PRE_LOGIN_SESSION"
echo "Post-login session: $POST_LOGIN_SESSION"
echo ""

if [ "$PRE_LOGIN_SESSION" = "$POST_LOGIN_SESSION" ]; then
    echo "🚨 VULNERABILITY CONFIRMED: Session Fixation vulnerability detected!"
    echo ""
    echo "Expected Behavior:"
    echo "- Session ID should be regenerated on successful login"
    echo "- Pre-login and post-login session IDs should be different"
    echo "- Old session should be invalidated"
    echo ""
    echo "Actual Behavior:"
    echo "- Session ID remains the same after login"
    echo "- Application vulnerable to session fixation attacks"
    echo ""
    echo "Impact:"
    echo "- Attacker can fix a session ID before victim logs in"
    echo "- Attacker can hijack authenticated session"
    echo "- Session takeover possible"
    echo ""
    echo "Attack Scenario:"
    echo "1. Attacker gets a session ID from the application"
    echo "2. Attacker tricks victim into using that session ID"
    echo "3. Victim logs in with the fixed session ID"
    echo "4. Attacker can now access victim's authenticated session"
    exit 1
elif [ "$PRE_LOGIN_SESSION" = "not_found" ] || [ "$POST_LOGIN_SESSION" = "not_found" ]; then
    echo "⚠️  Could not extract session cookies properly"
    echo "Manual verification required"
    exit 2
else
    echo "✅ PASS: Session ID properly regenerated on login"
    echo "Pre-login and post-login session IDs are different"
    exit 0
fi
