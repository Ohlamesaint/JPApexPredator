#!/bin/bash

# 檢查參數
STRICT_MODE=false
if [[ "$*" == *"--strict"* ]] || [[ "$*" == *"-s"* ]]; then
    STRICT_MODE=true
    echo "🚫 STRICT MODE: Warnings will block commit"
fi

echo "🔨 Checking for warnings and errors..."

# 執行 build
BUILD_OUTPUT=$(xcodebuild -project JPApexPredators.xcodeproj -scheme Runner-dev -sdk iphonesimulator build 2>&1)

# 分析結果
ERRORS=$(echo "$BUILD_OUTPUT" | grep "error:" || true)
WARNINGS=$(echo "$BUILD_OUTPUT" | grep "warning:" || true)

ERROR_COUNT=$(echo "$ERRORS" | grep -c "error:" || true)
WARNING_COUNT=$(echo "$WARNINGS" | grep -c "warning:" || true)

echo "📊 Build analysis:"
echo "   Errors: $ERROR_COUNT"
echo "   Warnings: $WARNING_COUNT"

# 顯示錯誤和警告
if [ $ERROR_COUNT -gt 0 ]; then
    echo ""
    echo "❌ BUILD ERRORS:"
    echo "$ERRORS"
fi

if [ $WARNING_COUNT -gt 0 ]; then
    echo ""
    echo "⚠️ BUILD WARNINGS:"
    echo "$WARNINGS"
fi

# 決定退出碼
if [ $ERROR_COUNT -gt 0 ]; then
    echo ""
    echo "❌ Commit blocked due to errors!"
    exit 1
elif [ "$STRICT_MODE" = true ] && [ $WARNING_COUNT -gt 0 ]; then
    echo ""
    echo "❌ Commit blocked due to warnings (strict mode)!"
    exit 1
elif [ $WARNING_COUNT -gt 0 ]; then
    echo ""
    echo "⚠️ Build has warnings but no errors. Commit allowed."
    echo "   Use --strict to block commits with warnings."
    exit 0
else
    echo ""
    echo "✅ Clean build! No errors or warnings."
    exit 0
fi
