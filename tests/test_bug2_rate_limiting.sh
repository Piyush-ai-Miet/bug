#!/bin/bash
# Bug 2 Test Script: No Rate Limiting on Login Endpoint
# This script tests whether the application rate limits login attempts

echo "=========================================="
echo "BUG 2: No Rate Limiting Test"
echo "=========================================="
echo ""

BASE_URL="${1:-http://localhost:3000}"
ATTEMPTS="${2:-50}"
echo "Testing against: $BASE_URL"
echo "Number of attempts: $ATTEMPTS"
echo ""

# First, register a test user
TEST_EMAIL="victim@example.com"
TEST_PASSWORD="CorrectPassword123"

echo "Step 1: Registering test user..."
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/api/register" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$TEST_EMAIL\",\"password\":\"$TEST_PASSWORD\"}")

echo "Registration response: $REGISTER_RESPONSE"
echo ""

echo "Step 2: Attempting $ATTEMPTS rapid login attempts with wrong passwords..."
echo ""

START_TIME=$(date +%s)
BLOCKED_COUNT=0
SUCCESS_COUNT=0
FAILED_COUNT=0

for i in $(seq 1 $ATTEMPTS); do
    WRONG_PASSWORD="wrongpass$i"
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$TEST_EMAIL\",\"password\":\"$WRONG_PASSWORD\"}")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    
    if [ "$HTTP_CODE" = "429" ]; then
        BLOCKED_COUNT=$((BLOCKED_COUNT + 1))
    elif [ "$HTTP_CODE" = "401" ]; then
        FAILED_COUNT=$((FAILED_COUNT + 1))
    elif [ "$HTTP_CODE" = "200" ]; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    fi
    
    # Show progress every 10 attempts
    if [ $((i % 10)) -eq 0 ]; then
        echo "  Progress: $i/$ATTEMPTS attempts (HTTP $HTTP_CODE)"
    fi
done

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "=========================================="
echo "TEST SUMMARY"
echo "=========================================="
echo "Total attempts: $ATTEMPTS"
echo "Duration: ${DURATION} seconds"
echo "Rate: $((ATTEMPTS / DURATION)) requests/second"
echo ""
echo "Results:"
echo "  - HTTP 429 (Rate Limited): $BLOCKED_COUNT"
echo "  - HTTP 401 (Failed Login): $FAILED_COUNT"
echo "  - HTTP 200 (Successful): $SUCCESS_COUNT"
echo ""

if [ $BLOCKED_COUNT -eq 0 ]; then
    echo "🚨 VULNERABILITY CONFIRMED: No rate limiting detected!"
    echo ""
    echo "Expected Behavior:"
    echo "- After 5-10 failed attempts, server should return HTTP 429"
    echo "- Should implement exponential backoff"
    echo "- Should temporarily lock account or require CAPTCHA"
    echo ""
    echo "Actual Behavior:"
    echo "- All $ATTEMPTS attempts were processed"
    echo "- No rate limiting or throttling detected"
    echo "- Application is vulnerable to brute-force attacks"
    echo ""
    echo "Impact:"
    echo "- Attackers can perform unlimited login attempts"
    echo "- Vulnerable to credential stuffing attacks"
    echo "- Vulnerable to password brute-forcing"
    exit 1
else
    echo "✅ PASS: Rate limiting is working"
    echo "Blocked after: $((ATTEMPTS - FAILED_COUNT)) attempts"
    exit 0
fi
