// ─────────────────────────────────────────────────────────────────────────────
// ASSETS CONSTANTS
//
// The only place an asset path string may appear. Widgets reference
// `AssetsConstants.xxx`, never a literal 'assets/...' path.
//
//   assets/icons/   — single-glyph SVG icons (tinted at render time via
//                     colorFilter unless noted as multi-color).
//   assets/images/  — illustrations, logos, photos. SVG preferred; raster
//                     (optimised .webp/.png) only where SVG can't reproduce
//                     the artwork (blurs, photos).
//   assets/animations/ — Rive (.riv) character animations. Each constant
//                     names the artboard, state machine and events it uses.
//
// Group constants under `// ── Feature/Area ──` headers, one line per asset,
// with a short note on where it's used and whether it's tinted.
// ─────────────────────────────────────────────────────────────────────────────
class AssetsConstants {
  AssetsConstants._();

  static const String iconsPath = 'assets/icons';
  static const String imagesPath = 'assets/images';
  static const String animationsPath = 'assets/animations';

  // ── Splash ──
  /// Mieo flies in on his plane, waves, then zooms towards the camera. Rive,
  /// multi-colour. Artboard "Splash" (the 375 × 812 Figma frame), state
  /// machine "SplashSM", event "splashDone" at the end.
  static const String mascotSplash = '$animationsPath/mascot_splash.riv';

  // ── Onboarding — new account ──
  /// Mieo waving hello on the "Hi! I’m Mieo" screen. Rive, multi-colour.
  /// Artboard "Mieo" (289 × 256: his Figma group plus 20px above it for the
  /// wave), state machine "MieoSM" (waves once, then breathes and blinks).
  static const String mascotHi = '$animationsPath/mieo_hi.riv';

  /// Mieo asking nicely, paws on his cheeks, on the "I just want to ask you
  /// some Questions" screen. Rive, multi-colour. Artboard "MieoPlease"
  /// (250 × 288: his Figma group at (12, 44) inside), state machine "PleaseSM"
  /// (sways and blinks on a loop; its "happy" trigger plays a jump). The file
  /// also carries a copy of the "Mieo" artboard of mieo_hi.riv, unused here.
  static const String mascotPlease = '$animationsPath/mieoPlease.riv';

  // ── Onboarding — language flags (24 × 24, multi-colour, not tinted) ──
  /// India: Gujarati, Marathi, Hindi, Tamil and Telugu on the language
  /// pickers.
  static const String flagIndia = '$imagesPath/flag_india.svg';

  /// United States: English (USA) on the language pickers.
  static const String flagUsa = '$imagesPath/flag_usa.svg';

  /// France: French on the native-language picker.
  static const String flagFrance = '$imagesPath/flag_france.svg';

  /// United Kingdom: English (UK) on the learning-language picker.
  static const String flagUk = '$imagesPath/flag_uk.svg';

  // ── Icons — Figma "Icons" (37:11465), 24 × 24 line glyphs ──
  /// Arrow pointing back (Figma "left 1"): the back button. Tinted; mirrored
  /// in RTL.
  static const String icArrowLeft = '$iconsPath/ic_arrow_left.svg';

  /// Envelope (Figma "mail 1"): email fields. Tinted.
  static const String icMail = '$iconsPath/ic_mail.svg';

  /// Padlock (Figma "lock 1"): password fields. Tinted.
  static const String icLock = '$iconsPath/ic_lock.svg';

  /// Eye (Figma "eye 1"): the show-password toggle. Tinted.
  static const String icEye = '$iconsPath/ic_eye.svg';

  /// Person (Figma "user 1"): name fields. Tinted.
  static const String icUser = '$iconsPath/ic_user.svg';

  /// Chevron pointing down (Figma "down-2 1"): dropdown fields. Tinted.
  static const String icChevronDown = '$iconsPath/ic_chevron_down.svg';

  // ── Icons — sign-in brands ──
  /// Google "G" (Figma "google-color 1"): sign in with Google. Multi-colour.
  static const String icGoogle = '$iconsPath/ic_google.svg';

  /// Apple logo (Figma "apple-173 1"): sign in with Apple. Tinted.
  static const String icApple = '$iconsPath/ic_apple.svg';
}
