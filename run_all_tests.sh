#!/bin/bash
# Master Test Runner - Runs all vulnerability tests

echo "=========================================="
echo "VULNERABILITY TEST SUITE"
echo "Security Bug Reproduction Tests"
echo "=========================================="
echo ""

BASE_URL="${1:-http://localhost:3000}"
echo "Target: $BASE_URL"
echo ""

# Check if server is running
echo "Checking if server is accessible..."
if ! curl -s -o /dev/null -w "%{http_code}" "$BASE_URL" | grep -q "200\|302\|301"; then
    echo "❌ Error: Server is not accessible at $BASE_URL"
    echo "Please start the server with: npm start"
    exit 1
fi

echo "✅ Server is accessible"
echo ""

TOTAL_TESTS=4
FAILED_TESTS=0

# Array to store failed test names
declare -a FAILED_TEST_NAMES

echo "=========================================="
echo "Running Test Suite..."
echo "=========================================="
echo ""

# Test 1: Weak Password Policy
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST 1/4: Weak Password Policy"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
./tests/test_bug1_weak_password.sh "$BASE_URL"
if [ $? -ne 0 ]; then
    FAILED_TESTS=$((FAILED_TESTS + 1))
    FAILED_TEST_NAMES+=("Bug 1: Weak Password Policy")
fi
echo ""

# Test 2: No Rate Limiting
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST 2/4: No Rate Limiting"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
./tests/test_bug2_rate_limiting.sh "$BASE_URL" 30
if [ $? -ne 0 ]; then
    FAILED_TESTS=$((FAILED_TESTS + 1))
    FAILED_TEST_NAMES+=("Bug 2: No Rate Limiting")
fi
echo ""

# Test 3: Insecure Transport
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST 3/4: Insecure Transport (HTTP)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
./tests/test_bug3_insecure_transport.sh "$BASE_URL"
if [ $? -ne 0 ]; then
    FAILED_TESTS=$((FAILED_TESTS + 1))
    FAILED_TEST_NAMES+=("Bug 3: Insecure Transport")
fi
echo ""

# Test 4: Session Fixation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST 4/4: Session Fixation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
./tests/test_bug4_session_fixation.sh "$BASE_URL"
if [ $? -ne 0 ]; then
    FAILED_TESTS=$((FAILED_TESTS + 1))
    FAILED_TEST_NAMES+=("Bug 4: Session Fixation")
fi
echo ""

echo "=========================================="
echo "FINAL TEST RESULTS"
echo "=========================================="
echo "Total Tests: $TOTAL_TESTS"
echo "Passed: $((TOTAL_TESTS - FAILED_TESTS))"
echo "Failed: $FAILED_TESTS"
echo ""

if [ $FAILED_TESTS -gt 0 ]; then
    echo "🚨 VULNERABILITIES DETECTED:"
    for test_name in "${FAILED_TEST_NAMES[@]}"; do
        echo "   ❌ $test_name"
    done
    echo ""
    echo "All failed tests indicate confirmed security vulnerabilities."
    echo "See individual test output above for detailed evidence."
    exit 1
else
    echo "✅ ALL TESTS PASSED"
    echo "No vulnerabilities detected (or all have been fixed)"
    exit 0
fi
