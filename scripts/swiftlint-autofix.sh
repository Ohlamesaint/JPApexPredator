#!/bin/bash

echo "🔧 Running SwiftLint AutoFix..."

# 切換到專案根目錄
cd "$(git rev-parse --show-toplevel)" || exit 1

echo "Current directory: $(pwd)"
echo "Swift files found: $(find . -name "*.swift" -type f | wc -l)"

# 先自動修正
echo "Fixing auto-correctable issues..."
swiftlint --fix --quiet

# 檢查是否還有違規
echo "Checking for remaining violations..."
LINT_OUTPUT=$(swiftlint --strict 2>&1)
LINT_RESULT=$?

if [ $LINT_RESULT -ne 0 ]; then
    echo "❌ SwiftLint found issues that cannot be auto-fixed:"
    echo "$LINT_OUTPUT"
    echo ""
    echo "Please manually fix the above issues."
    exit 1
else
    echo "✅ All SwiftLint issues resolved!"
    exit 0
fi
