#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# check_rules.sh — project-rule checks that `flutter analyze` can't express.
#
# Scans lib/**/*.dart (comment lines skipped, except for the TODO check) and
# the asset folders, prints every violation as `file:line: code`, and exits 1
# if any were found. Run it via tool/preflight.sh, or on its own:
#
#   bash tool/check_rules.sh
#
# A line that genuinely needs an exception carries a trailing comment with a
# reason:   someCall(); // check-rules: ignore — <why this is the exception>
# ─────────────────────────────────────────────────────────────────────────────
set -uo pipefail
cd "$(dirname "$0")/.."

readonly COLORS_FILE='lib/core/theme/colors.dart'
readonly FONTS_FILE='lib/core/theme/fonts.dart'
readonly THEME_DIR='lib/core/theme/'
readonly CONSTANTS_DIR='lib/core/constants/'
readonly LOCALIZATION_CONSTANTS='lib/core/constants/localization_constants.dart'
readonly ASSETS_CONSTANTS='lib/core/constants/assets_constants.dart'
readonly MAX_RASTER_KB=300

violations=0

# check <id> <message> <pattern> [allowed-path-regex] [exclude-regex] [scan-comments]
check() {
  local id="$1" message="$2" pattern="$3" allowed="${4:-}" exclude="${5:-}" scan_comments="${6:-}"
  local hits
  hits=$(grep -rnE --include='*.dart' -e "$pattern" lib 2>/dev/null | grep -v 'check-rules: ignore' || true)
  if [[ -z "$scan_comments" ]]; then
    hits=$(printf '%s\n' "$hits" | grep -vE '^[^:]+:[0-9]+:[[:space:]]*(//|\*|/\*)' || true)
  fi
  if [[ -n "$allowed" ]]; then
    hits=$(printf '%s\n' "$hits" | grep -vE "^(${allowed})" || true)
  fi
  if [[ -n "$exclude" ]]; then
    hits=$(printf '%s\n' "$hits" | grep -vE "$exclude" || true)
  fi
  hits=$(printf '%s\n' "$hits" | sed '/^$/d')
  if [[ -n "$hits" ]]; then
    local count
    count=$(printf '%s\n' "$hits" | wc -l | tr -d ' ')
    violations=$((violations + count))
    printf '\n✗ %s (%s) — %s\n' "$id" "$count" "$message"
    printf '%s\n' "$hits" | sed 's/^/    /'
  fi
}

# ── Colors & typography ──────────────────────────────────────────────────────
check RAW_COLOR 'Literal colors belong in core/theme/colors.dart only' \
  'Color\(0x|Color\.from(ARGB|RGBO)\(' "$COLORS_FILE"
check MATERIAL_COLORS 'Use Theme.of(context).colorScheme / context.colors / AppColors, not Material Colors.*' \
  '(^|[^A-Za-z_.])Colors\.[a-z]' "$COLORS_FILE" 'Colors\.transparent'
check FONT_SIZE 'Font sizes are defined once in AppFonts.textTheme (core/theme/fonts.dart)' \
  'fontSize:' "$FONTS_FILE"
check FONT_WEIGHT 'Font weights come from the Figma text style roles (textTheme.* / AppFonts), never overridden' \
  'fontWeight:' "$FONTS_FILE"
check LETTER_SPACING 'Letter spacing comes from the Figma text style roles (textTheme.* / AppFonts)' \
  'letterSpacing:' "$FONTS_FILE"
check BRIGHTNESS_BRANCH 'Use context.colors tokens (they resolve per theme) instead of branching on brightness' \
  '(brightness|isDark(Mode)?)[[:space:]]*==[[:space:]]*(Brightness\.|true|false)|Brightness\.(dark|light)[[:space:]]*\?' "$THEME_DIR"

# ── RTL safety ───────────────────────────────────────────────────────────────
check LTR_EDGE_INSETS 'Use EdgeInsetsDirectional (start/end) — even for all()/symmetric()' \
  '(^|[^A-Za-z_])EdgeInsets\.'
check LTR_ALIGNMENT 'Use AlignmentDirectional (centerStart/centerEnd…)' \
  '(^|[^A-Za-z_])Alignment\.(topLeft|topRight|centerLeft|centerRight|bottomLeft|bottomRight)'
check LTR_TEXT_ALIGN 'Use TextAlign.start / TextAlign.end' \
  'TextAlign\.(left|right)'
check LTR_POSITIONED 'Use PositionedDirectional (start/end)' \
  '(^|[^A-Za-z_])Positioned\('
check LTR_BORDER_RADIUS 'Use BorderRadiusDirectional for asymmetric corners' \
  'BorderRadius\.(only|horizontal)\('
check FORCED_DIRECTION 'Hardcoded text direction — only for content that must keep one direction (add an ignore reason)' \
  'TextDirection\.(ltr|rtl)'

# ── No magic literals ────────────────────────────────────────────────────────
check RAW_STRING 'UI strings must be LangKeys.xxx.tr' \
  "(Text\\([[:space:]]*|(hintText|labelText|helperText|errorText|tooltip|semanticsLabel|semanticLabel|message):[[:space:]]*)['\"]"
check RAW_DURATION 'Durations belong in core/constants/animation_constants.dart' \
  '(^|[^A-Za-z_])Duration\(' "$CONSTANTS_DIR"
check RAW_ASSET_PATH 'Asset paths belong in core/constants/assets_constants.dart' \
  "['\"]assets/" "$CONSTANTS_DIR"
check RAW_LOCALE 'Locales belong in core/constants/localization_constants.dart' \
  '(^|[^A-Za-z_])Locale\(' "$LOCALIZATION_CONSTANTS"
check RAW_ROUTE 'Navigate with Routes.xxx constants, not a path string' \
  "Get\\.(toNamed|offNamed|offAllNamed|offAndToNamed|offNamedUntil)\\([[:space:]]*['\"]"
check MAGIC_NUMBER 'Spacing/sizing/radius/alpha numbers must be named constants (ThemeConstants, AnimationConstants…)' \
  '((height|width|size|spacing|runSpacing|elevation|blurRadius|spreadRadius|thickness|indent|endIndent|strokeWidth|horizontal|vertical|start|end|left|right|top|bottom|radius|iconSize|maxWidth|maxHeight|minWidth|minHeight|alpha|opacity|scale):[[:space:]]*-?[0-9]*\.?[0-9]*[1-9]|(EdgeInsetsDirectional\.all|Radius\.circular|BorderRadius\.circular|BorderRadiusDirectional\.circular|SizedBox\.square)\([[:space:]]*-?[0-9]*\.?[0-9]*[1-9]|Offset\([^)]*[1-9])' \
  "${THEME_DIR}|${CONSTANTS_DIR}"

# ── Architecture ─────────────────────────────────────────────────────────────
check GETX_STATE 'GetX is for routing + translations only — state lives in Cubits' \
  'GetxController|GetxService|Obx\(|GetBuilder<|GetX<|\.obs([^A-Za-z_]|$)|Get\.(put|find|lazyPut|putAsync)\(|extends Bindings'
check GETX_CONTEXT_HELPERS 'Use Theme.of(context) / MediaQuery.sizeOf / project context extensions, not GetX context helpers' \
  'context\.(isTablet|isPhone|isSmallTablet|isLargeTablet|textTheme|theme|width|height|isDarkMode|mediaQuery|responsiveValue|isLandscape|isPortrait)([^A-Za-z_]|$)'
check WIDGET_METHOD 'Extract a private widget class (_MyRow) instead of a Widget-returning method' \
  'Widget[[:space:]]+_[A-Za-z0-9]+\('
check MEDIAQUERY_OF 'Use MediaQuery.sizeOf / paddingOf / viewInsetsOf… (rebuild only on the value you read)' \
  'MediaQuery\.of\([^)]*\)\.(size|padding|viewInsets|viewPadding|textScaler|orientation|platformBrightness)'
check DEBUG_OUTPUT 'Remove print/debugPrint before submission' \
  '(^|[^A-Za-z_])(print|debugPrint)\('
check TODO_LEFT 'Deliverable code carries no TODO/FIXME/HACK comments' \
  '(TODO|FIXME|HACK)([^A-Za-z_]|$)' '' '' scan-comments

# ── Assets ───────────────────────────────────────────────────────────────────
asset_issues=''
while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  name=$(basename "$file")
  if ! grep -q "$name" "$ASSETS_CONSTANTS"; then
    asset_issues+="    $file — not referenced in AssetsConstants (unused asset?)"$'\n'
  fi
  case "$name" in
    *.png | *.jpg | *.jpeg | *.webp)
      size_kb=$(( $(wc -c < "$file") / 1024 ))
      if (( size_kb > MAX_RASTER_KB )); then
        asset_issues+="    $file — ${size_kb}KB raster (> ${MAX_RASTER_KB}KB): optimise / convert to WebP"$'\n'
      fi
      ;;
  esac
done < <(find assets/icons assets/images assets/animations -type f ! -name '.*' 2>/dev/null)
if [[ -n "$asset_issues" ]]; then
  count=$(printf '%s' "$asset_issues" | grep -c .)
  violations=$((violations + count))
  printf '\n✗ ASSETS (%s) — every asset is referenced and optimised\n%s' "$count" "$asset_issues"
fi

# ── Result ───────────────────────────────────────────────────────────────────
if (( violations > 0 )); then
  printf '\n%s rule violation(s). Fix them, or add `// check-rules: ignore — <reason>` for a genuine exception.\n' "$violations"
  exit 1
fi
printf '✓ Project rules: no violations\n'
