#!/bin/bash
# Bug 1 Test Script: Weak Password Policy
# This script tests whether the application accepts weak passwords

echo "=========================================="
echo "BUG 1: Weak Password Policy Test"
echo "=========================================="
echo ""

BASE_URL="${1:-http://localhost:3000}"
echo "Testing against: $BASE_URL"
echo ""

# Array of weak passwords to test
WEAK_PASSWORDS=(
    "password"
    "12345678"
    "qwerty123"
    "welcome1"
    "abc123"
    "test"
    "admin"
)

echo "Testing weak passwords during registration..."
echo ""

COUNTER=1
SUCCESSFUL_REGISTRATIONS=0

for WEAK_PASS in "${WEAK_PASSWORDS[@]}"; do
    EMAIL="test_weak_${COUNTER}@example.com"
    
    echo "[$COUNTER] Testing password: '$WEAK_PASS'"
    echo "   Email: $EMAIL"
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/register" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$EMAIL\",\"password\":\"$WEAK_PASS\"}")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)
    
    echo "   HTTP Status: $HTTP_CODE"
    echo "   Response: $BODY"
    
    if [ "$HTTP_CODE" = "201" ]; then
        echo "   ❌ VULNERABLE: Weak password '$WEAK_PASS' was ACCEPTED!"
        SUCCESSFUL_REGISTRATIONS=$((SUCCESSFUL_REGISTRATIONS + 1))
    elif [ "$HTTP_CODE" = "400" ]; then
        echo "   ✅ SECURE: Weak password was REJECTED"
    else
        echo "   ⚠️  Unexpected response code"
    fi
    
    echo ""
    COUNTER=$((COUNTER + 1))
done

echo "=========================================="
echo "TEST SUMMARY"
echo "=========================================="
echo "Total weak passwords tested: ${#WEAK_PASSWORDS[@]}"
echo "Accepted (VULNERABLE): $SUCCESSFUL_REGISTRATIONS"
echo "Rejected (SECURE): $((${#WEAK_PASSWORDS[@]} - SUCCESSFUL_REGISTRATIONS))"
echo ""

if [ $SUCCESSFUL_REGISTRATIONS -gt 0 ]; then
    echo "🚨 VULNERABILITY CONFIRMED: Application accepts weak passwords!"
    echo ""
    echo "Expected Behavior:"
    echo "- Server should reject weak passwords with HTTP 400"
    echo "- Should enforce minimum 10+ characters"
    echo "- Should require: uppercase, lowercase, number, special char"
    echo "- Should check against common password list"
    echo ""
    echo "Actual Behavior:"
    echo "- Server accepted $SUCCESSFUL_REGISTRATIONS weak password(s)"
    echo "- No password complexity enforcement detected"
    exit 1
else
    echo "✅ PASS: All weak passwords were properly rejected"
    exit 0
fi
