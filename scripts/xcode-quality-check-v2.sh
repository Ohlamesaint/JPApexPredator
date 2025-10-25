#!/bin/bash
set -euo pipefail

# === Settings ===
PROJECT="JPApexPredators.xcodeproj"
SCHEME="Runner-dev"
SDK="iphonesimulator"
RESULT_PATH="build.xcresult"
RESULT_ERROR_REPORT="errors.json"

# === Flags ===
STRICT_MODE=false
if [[ "$*" == *"--strict"* ]] || [[ "$*" == *"-s"* ]]; then
    STRICT_MODE=true
    echo "🚫 STRICT MODE: Warnings will block commit"
fi

echo "🔨 Running Xcode build with result bundle..."

# === Clean up old build results ===
rm -rf "$RESULT_PATH"
rm -rf "$RESULT_ERROR_REPORT"

# === Build project (always produce xcresult bundle) ===
set +e
xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -sdk "$SDK" \
  -resultBundlePath "$RESULT_PATH" \
  build  > build.log 2>&1
BUILD_EXIT_CODE=$?
set -e

# === Parse result bundle for structured issues ===
if [ ! -d "$RESULT_PATH" ]; then
  echo "❌ No build result bundle found. Build likely failed before producing xcresult."
  cat build.log
  exit 1
fi

echo "📦 Extracting issues from $RESULT_PATH..."
if ! command -v jq &>/dev/null; then
  echo "⚙️ Installing jq..."
  brew install jq
fi

# # Extract and print human-readable issues
# ISSUES=$(xcrun xcresulttool get --legacy --path "$RESULT_PATH" --format json 2>/dev/null | \
#   jq -r '
#     (.issues.errorSummaries[]? | "❌ \(.issueTypeDisplayName): \(.message.text)\n→ \(.documentLocationInCreatingWorkspace.urlString // "Unknown location")\n")
#     ,
#     (.issues.warningSummaries[]? | "⚠️  \(.issueTypeDisplayName): \(.message.text)\n→ \(.documentLocationInCreatingWorkspace.urlString // "Unknown location")\n")
#   ')

# Count errors/warnings from xcresult


echo "📦 Extracting issues from $RESULT_PATH with xcresultparser..."
if ! command -v xcresultparser &>/dev/null; then
  echo "⚙️ Installing xcresultparser..."
  brew install xcresultparser
fi

xcresultparser -o errors $RESULT_PATH > $RESULT_ERROR_REPORT
jq -r '.[] | "\(.severity | ascii_upcase): \(.content.body) → File: \(.location.path):\(.location.lines.begin):\(.location.positions.begin.column)"' $RESULT_ERROR_REPORT

ERROR_COUNT=$(xcrun xcresulttool get --legacy --path "$RESULT_PATH" --format json | jq '.issues.errorSummaries | length')
WARNING_COUNT=$(xcrun xcresulttool get --legacy --path "$RESULT_PATH" --format json | jq '.issues.warningSummaries | length')

echo "📊 Build Summary:"
echo "   Errors: $ERROR_COUNT"
echo "   Warnings: $WARNING_COUNT"
echo ""
# echo "$ISSUES"

# === Decision logic ===
if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "❌ Commit blocked due to build errors!"
    exit 1
elif [ "$STRICT_MODE" = true ] && [ "$WARNING_COUNT" -gt 0 ]; then
    echo "❌ Commit blocked due to warnings (strict mode)!"
    exit 1
elif [ "$WARNING_COUNT" -gt 0 ]; then
    echo "⚠️  Build has warnings but no errors. Commit allowed."
    echo "   Use --strict to block warnings."
    exit 0
else
    echo "✅ Clean build! No errors or warnings."
    exit 0
fi
