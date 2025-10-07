#!/bin/bash
# Bug 3 Test Script: Credentials Sent Over HTTP (Insecure Transport)
# This script tests whether the application accepts credentials over HTTP

echo "=========================================="
echo "BUG 3: Insecure Transport Test"
echo "=========================================="
echo ""

BASE_URL="${1:-http://localhost:3000}"
echo "Testing against: $BASE_URL"
echo ""

# Extract protocol from URL
PROTOCOL=$(echo "$BASE_URL" | grep -oP '^https?')

echo "Step 1: Checking if application is accessible over HTTP..."
echo ""

# Test if HTTP endpoint is accessible
HTTP_URL="http://localhost:3000"
HTTPS_URL="https://localhost:3000"

echo "Testing HTTP endpoint: $HTTP_URL/api/register"
HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$HTTP_URL/api/register" \
    -H "Content-Type: application/json" \
    -d '{"email":"http_test@example.com","password":"TestPassword123"}' 2>&1)

HTTP_CODE=$(echo "$HTTP_RESPONSE" | tail -n1)
echo "HTTP Status Code: $HTTP_CODE"
echo ""

# Check if it's a redirect or actual response
if [[ "$HTTP_CODE" =~ ^(301|302|307|308)$ ]]; then
    echo "✅ SECURE: HTTP redirects to HTTPS (Status: $HTTP_CODE)"
    REDIRECTS_TO_HTTPS=true
elif [[ "$HTTP_CODE" =~ ^(200|201|400|401)$ ]]; then
    echo "❌ VULNERABLE: HTTP accepts requests without redirect!"
    HTTP_ACCEPTS_REQUESTS=true
    BODY=$(echo "$HTTP_RESPONSE" | head -n-1)
    echo "Response body: $BODY"
else
    echo "⚠️  Connection failed or server not running on HTTP"
fi

echo ""
echo "Step 2: Testing credential submission over HTTP..."
echo ""

# Try to login over HTTP
TEST_EMAIL="http_login_test@example.com"
TEST_PASSWORD="TestPassword123"

echo "Registering user over HTTP..."
REGISTER_HTTP=$(curl -s -w "\n%{http_code}" -X POST "$HTTP_URL/api/register" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$TEST_EMAIL\",\"password\":\"$TEST_PASSWORD\"}" 2>&1)

REGISTER_CODE=$(echo "$REGISTER_HTTP" | tail -n1)
echo "Registration Status: $REGISTER_CODE"

if [[ "$REGISTER_CODE" == "201" ]]; then
    echo "❌ Account created over insecure HTTP connection!"
    echo ""
    echo "Attempting login over HTTP..."
    LOGIN_HTTP=$(curl -s -w "\n%{http_code}" -X POST "$HTTP_URL/api/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$TEST_EMAIL\",\"password\":\"$TEST_PASSWORD\"}" 2>&1)
    
    LOGIN_CODE=$(echo "$LOGIN_HTTP" | tail -n1)
    echo "Login Status: $LOGIN_CODE"
    
    if [[ "$LOGIN_CODE" == "200" ]]; then
        echo "❌ Login successful over insecure HTTP connection!"
        CREDENTIALS_OVER_HTTP=true
    fi
fi

echo ""
echo "Step 3: Checking for HSTS (HTTP Strict Transport Security) header..."
echo ""

HSTS_HEADER=$(curl -s -I "$HTTP_URL" 2>&1 | grep -i "strict-transport-security")

if [ -z "$HSTS_HEADER" ]; then
    echo "❌ HSTS header NOT found"
    NO_HSTS=true
else
    echo "✅ HSTS header found: $HSTS_HEADER"
fi

echo ""
echo "=========================================="
echo "TEST SUMMARY"
echo "=========================================="

VULNERABILITY_FOUND=false

if [ "$HTTP_ACCEPTS_REQUESTS" = true ]; then
    echo "❌ HTTP accepts requests (no redirect to HTTPS)"
    VULNERABILITY_FOUND=true
fi

if [ "$CREDENTIALS_OVER_HTTP" = true ]; then
    echo "❌ Credentials can be sent over HTTP"
    VULNERABILITY_FOUND=true
fi

if [ "$NO_HSTS" = true ]; then
    echo "❌ HSTS header is missing"
    VULNERABILITY_FOUND=true
fi

echo ""

if [ "$VULNERABILITY_FOUND" = true ]; then
    echo "🚨 VULNERABILITY CONFIRMED: Insecure transport detected!"
    echo ""
    echo "Expected Behavior:"
    echo "- HTTP requests should redirect to HTTPS (301/302)"
    echo "- HSTS header should be present"
    echo "- Credentials should only be transmitted over HTTPS"
    echo ""
    echo "Actual Behavior:"
    echo "- Application accepts HTTP connections"
    echo "- Credentials transmitted in plaintext"
    echo "- No HSTS enforcement"
    echo ""
    echo "Impact:"
    echo "- Man-in-the-Middle (MITM) attacks possible"
    echo "- Credentials can be intercepted"
    echo "- Session hijacking possible"
    exit 1
else
    echo "✅ PASS: Application properly enforces HTTPS"
    exit 0
fi
