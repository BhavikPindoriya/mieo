# Mieo — Figma design review

Review of the Figma file for implementation: where everything is, every screen with its **Light and Dark**
node IDs, the component library mapped to the Flutter widgets to build, and open questions. The rules live in
[CLAUDE.md](../CLAUDE.md); every token is listed in [design_tokens.md](design_tokens.md).

- **File:** [Mieo — Language Learning](https://www.figma.com/design/mWILt2PBmTonssE3Z7uSgU/Mieo---Language-Learning?node-id=2158-14549&m=dev)
  (file key `mWILt2PBmTonssE3Z7uSgU`)
- **Product:** a kid-friendly ("100% Kids Safe") language-learning app with game mechanics (hearts, gems, XP,
  streaks, leagues). The mascot is Mieo, an orange bear.
- **Reference frame:** 375 × 812 @1x (iPhone 11 Pro / 13 mini). Taller frames (996–1169) are scrolling screens.

## 1. File structure

| Page | ID | Contents |
|---|---|---|
| `Cover 📒` | `0:1` | Marketing cover only |
| `📱Light Theme` | `19:149` | All 46 screens and overlays, in 14 sections |
| `📱Dark Theme` | `2159:12104` | The same 46 screens at the same canvas positions. It is a copy of the light page with the `Colors` variable collection set to **Dark** at page level (same 32,287 nodes), so only variable-bound colours differ |
| `Style Guide 🎨` | `4:7527` | **Colors** `2158:14549` (every semantic token with its Light and Dark value, plus the Shades palette) and **Typography** `19:24` (17 `Mieo/*` text styles) |
| `Components 📂` | `19:150` | 21 component sets and 62 components (icons included). This page renders in Dark mode; the components themselves are token-bound and adapt to either mode |

The `get_metadata` page list over MCP can show only `Cover 📒`; the other pages are still reachable by node ID.

## 2. Visual language

| Element | Spec (Figma) → code |
|---|---|
| Typeface | Nunito: Medium 500, SemiBold 600, Bold 700, ExtraBold 800, Black 900. Line height **Auto** everywhere (natural 1.364 × size) → `textTheme.<role>` |
| Page background | `Surface/Body` (#FAFAFA / #171A1C). Most screens add a **sky backdrop**: gradient `Surface/Sky/Top` → `Surface/Sky/Bottom` (light #B3E6FF → #FFFFFF; dark white 8% → 0% glow) ending about 42% down, with clouds in `Cloud Color/1–3` (white/blue in light, greys in dark). Draw the clouds in code |
| 3D buttons | Fill + solid **hard shadow** 4px in the family's `Shadow/*` colour, radius 16, padding 24 × 14, label `title/medium`. Filled buttons carry two glossy diagonal white stripes on the start side (30% and 20% white, 119°) → draw in code |
| Button component | Variants **Filled / Outlined / Shaded / Disabled**. Screens recolour Filled into families: primary (`Surface/Primary` + `Shadow/Primary/Darker`), green, red, secondary/yellow |
| Text field | Height 52, radius 12, 1.5 outline outside, padding 12 × 14, 24px leading icon, text `label/large - prominent`. Rest: `Stroke/Extra Dim/Nuturel` outline + 2px `Shadow/Nutural/Extra Light`. Focused: `Stroke/Primary` + 2px `Shadow/Primary/Full` |
| Cards / tiles | `Surface/Background Nuturel`, 1.5 outline, 2–4px hard shadow in the matching `Shadow/*/Lighter` or `Nutural/Extra Light` |
| Answer tiles | Rest neutral; selected = primary outline on `Surface/Dim/primary`; correct green; wrong red; disabled dim |
| Feedback sheet | Bottom panel with a **cloud-shaped top edge** (draw in code), tinted `Surface/Dim/success` / `Surface/Dim/error`, emoji art, title, subtitle, full-width CTA |
| Bottom nav | Floating pill (340 wide), 5 icon tabs; the active tab gets a circular `Surface/Dim/primary` highlight |
| Home map | Winding cobblestone **path** through a forest scene with level nodes (flag, dumbbell with progress ring, locked puzzle) and the mascot at the current node → CustomPainter, unlimited levels (CLAUDE.md §11) |
| Illustrations | Mascot poses, scene backgrounds, story art, gems, hearts, flame, league/rank badges, achievements, avatars, flags → the only image assets. A pose whose Figma effects flutter_svg can't draw (soft-light or inner shadows) is drawn in code from its exported geometry instead: the Onboarding Mieo (§8) |

## 3. Screen inventory — Light and Dark twins

Frame names in Figma are unreliable ("Loading" = Home map, "Streak" = level detail, "Survey" = question
screens), so **target screens by node ID** and confirm with a screenshot. Every row is one screen: build it from
the Light node and check it against the Dark node (CLAUDE.md §6). Suggested feature folders follow each heading.

### Entry Flow — Light `149:34273` · Dark `2159:12105` → `splash`, `onboarding`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `22:5` | `2159:12106` | 375×812 | Splash: mascot on a plane, "Learning with Mieo" — **built** (`features/splash`, see §8) |
| `25:1919` | `2159:12444` | 375×812 | Onboarding welcome: "Learn any Language…", Fresh Start / Resume Journey — **built** (`features/onboarding`, see §8) |

### New Account Progress — Light `2016:11772` · Dark `2159:37579` → `onboarding`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `62:3649` | `2159:37580` | 375×812 | "Hi! I'm Mieo" — **built** (`features/onboarding`, `HelloScreen`, see §8) |
| `62:8081` | `2159:37689` | 375×812 | "I just want to ask you some questions" — **built** (`features/onboarding`, `QuestionsIntroScreen`, see §8) |
| `62:8472` | `2159:37809` | 375×812 | Native-language picker — **built** (`features/onboarding`, `NativeLanguageScreen`, see §8) |
| `62:10515` | `2159:37925` | 375×812 | Learning-language picker — **built** (`LearningLanguageScreen`, see §8) |
| `62:9688` | `2159:38042` | 375×812 | Proficiency level — **built** (`ProficiencyScreen`, see §8) |
| `62:9100` | `2159:38157` | 375×812 | Daily goal time picker — **built** (`DailyGoalScreen`, see §8) |
| `62:12681` | `2159:38306` | 375×812 | "Loading your course" |
| `277:6001` | `2159:38336` | 375×812 | "Save your journey" sign-up prompt |
| `2016:11880` | `2159:38426` | 375×812 | Create Account form (continue with email) |

### Login — Light `2016:11773` · Dark `2159:38491` → `auth`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `364:14961` | `2159:38555` | 375×812 | Login: "Welcome Back", email/password, Google/Apple — **built** (`features/auth`, see §8) |
| `366:15263` | `2159:38492` | 375×812 | Create Profile after social login — **built** (`features/auth`, see §8) |

### Home — Light `408:17137` · Dark `2159:21422` → `home`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `429:34434` | `2159:22457` | 375×812 | Home level map: greeting, language switcher, stat chips, current unit card, **path** (CustomPainter, unlimited levels) |
| `408:10297` | `2159:21423` | 375×996 | Explore Levels: timeline list (scrolls) |
| `408:16310` | `2159:22300` | 375×812 | Level detail: performance stats, Re-Start |
| `408:16810` | `2159:22367` | 375×812 | Locked level: Unlock with 💎350 |

### Game Play — Light `246:15988` · Dark `2159:12555` → `lesson`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `149:34400` | `2159:12556` | 375×812 | Choose the right option |
| `149:34931` | `2159:12732` | 375×812 | Correct answer + success feedback sheet |
| `204:3638` | `2159:12974` | 375×812 | "Nice.!" cheer |
| `149:35178` | `2159:12908` | 375×812 | Build a sentence from blocks + error feedback sheet |

### Live Questions — Light `421:11770` · Dark `2159:24815` → `lesson` / `ai_talk`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `421:10166` | `2159:24816` | 375×812 | Talk with Mieo (speaking prompt) |
| `421:10724` | `2159:25018` | 375×812 | Speaking answer correct |
| `421:11123` | `2159:25225` | 375×812 | Speaking answer wrong + Try Again |

### Result — Light `429:36773` · Dark `2159:37172` → `rewards`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `204:3755` | `2159:37173` | 375×812 | Play result: XP / accuracy / time |
| `204:4197` | `2159:37301` | 375×812 | Streak completed (week dots) |
| `229:14410` | `2159:37383` | 375×812 | Reward: "Got 12 diamonds" (day grid) |
| `246:15735` | `2159:37450` | 375×812 | Set Streak Goal (day picker) |

### Streak & Mieo Talk — Light `275:2011` · Dark `2159:13059` → `streak`, `ai_talk`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `246:18355` | `2159:13060` | 375×1070 | My Streak: calendar, streak-goal progress, bottom nav (scrolls) |
| `255:3557` | `2159:13247` | 375×812 | AI video call with Mieo |

### Stories — Light `429:34343` · Dark `2159:25648` → `stories`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `429:8892` | `2159:25649` | 375×812 | Stories list (Listen / Unlock) |
| `429:11254` | `2159:25655` | 375×812 | Story scene with a speech bubble |
| `2088:13951` | `2159:31403` | 375×812 | Story question sheet |

### Review Mistakes — Light `429:8891` · Dark `2159:25463` → `review_mistakes`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `429:7288` | `2159:25464` | 375×812 | Mistakes list (Review All 💎200) |
| `429:8667` | `2159:25475` | 375×812 | Review test question |

### Leaderboard — Light `408:8230` · Dark `2159:18589` → `leaderboard`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `375:6341` | `2159:18590` | 375×812 | League, week in progress: podium + list, bottom nav |
| `408:5035` | `2159:19882` | 375×1060 | League expired: error feedback sheet (scrolls) |

### Profile — Light `329:7942` · Dark `2159:18064` → `profile`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `304:2746` | `2159:18065` | 375×1169 | Profile: stats, mistakes & practice, achievements (scrolls) |
| `304:6117` | `2159:18256` | 375×1059 | Settings: avatar picker, toggles incl. **Dark Mode** (scrolls) |
| `329:9009` | `2159:18543` | 375×812 | Edit Profile |

### Shop — Light `408:8287` · Dark `2159:21176` → `shop`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `329:10628` | `2159:21177` | 375×812 | Shop: hearts refill, gem packs, Pro upsell |
| `2088:24806` | `2159:21230` | 375×812 | Subscription: Pro features, pricing |

### Overlays — Light `408:17352` · Dark `2159:24685` → `commons` / `home`

| Light | Dark | Frame | Shows |
|---|---|---|---|
| `408:17145` | `2159:24692` | 375×594 | Course language switcher sheet |
| `408:17404` | `2159:24725` | 375×390 | Hearts refill sheet |
| `149:34134` | `2159:24739` | 340×420 | Bottom nav bar, 5 states (component set) |
| `117:13725` | `2159:24686` | 345×151 | Quick Play popover: "Hanging in Garden", Start +25 XP |

## 4. Component review → Flutter widgets

The 21 component sets and standalone components on `Components 📂`, what they are and what to build.
"Code" = drawn with widgets / CustomPainter; "SVG" = exported artwork. Shared widgets go in
`lib/commons/widgets/` from the start (two or more features use them); the rest start in their feature.

| Figma component | Variants / properties | Flutter widget (location) | Build notes |
|---|---|---|---|
| **Button** `53:1086` | Filled / Outlined / Shaded / Dissabled · Label | `AppButton` (commons) — **built** | `AppButtonVariant` (filled, outlined, shaded); disabled when `onPressed` is null; glossy stripes on filled (code); press sinks into the hard shadow (`AppPressable`, shared by every 3D tappable). Still to add when a screen needs it: a `tone` enum (secondary, success, error) |
| **Coin Spend Button** `445:8361` | Label, Amount | `AppButton` outlined + trailing gem amount | "Or Use 💎150" |
| **Play Button** `429:9197` | Unlocked true/false | `AppButton` compact size (stories) | "Listen" filled + speaker icon; "Unlock" neutral + lock. The Unlock fill stays white in dark mode in Figma: confirm (§6) |
| **Back Button** `53:1329` | Default | `AppBackButton` (commons) — **built** | 48 × 48, radius 12, outline + hard shadow 2, `Get.back()` by default; the arrow mirrors in RTL |
| **Back Button/Speak** `182:11189` | — | `AppIconButton` (commons) — **built** | The same shell around any icon (lesson audio; the Style Guide's theme and language switches) |
| **Input Field** `277:5682` | Default / Focused / Selected · Placeholder, Value, Icon, Show icon, Extra Icon | `AppTextField`, `AppDropdownField` (commons/widgets/fields) — **built** | The box is `AppFieldBox` (`AppFieldStatus` idle / focused / filled + error), the inline label and validation message `AppFieldLayout`. Text: FormField with an InputValidators check, optional leading icon, password eye (`obscurable`). Dropdown: the options open in a menu under the box |
| **Input Option** `37:7612` | Checked true/false · Label, Icon (flag), Icon2 | `SelectableOptionTile` (commons) — **built** | Onboarding language/level pickers, settings; a 24 icon, the label, `AppRadio` at the end; selected = `Stroke/Primary` outline, `Surface/Extra Dim/Primary` fill and a hard shadow 4 (2 when off); one merged screen-reader node (button, label, selected) |
| **Radio Button'** `37:7589` | true/false | `AppRadio` (commons) — **built** | Code: outlined circle on a hard shadow 2 when off, `Surface/Primary` with a popping dot when on |
| **Toggle** `329:7867` | true/false | `AppToggle` (commons) | Code; animated thumb (Settings → Dark Mode drives `ThemeCubit`) |
| **Option Block** `182:11271` | Checked / Dissabled / False / True / Uncheked | `AnswerOptionTile` (lesson) | Rest, selected, correct, wrong, disabled |
| **Option Block/Indicator** `182:11735` | — | `StatChip` (commons) | Gem / heart / XP counter pill with primary outline and hard shadow |
| **Fill Block** `182:11385` | Filled / Unfilled / Wrong / RIght | `WordSlot` (lesson) | Empty underline slot, filled word chip, wrong (red), right (green) |
| **Bottom Action** `182:11629` | Check / Correct / Wrong | `LessonCheckBar` + `FeedbackSheet` (commons) | Cloud top edge in code; success/error tint; emoji art (SVG); CTA |
| **Talk Bubble** `53:1337` | Face: Bottom / Top / Left / Right / Face5 | `SpeechBubble` (commons) — Bottom and Left **built** | Tail drawn in code; one line (129, widens) or a set `width` the text wraps in; `SpeechBubbleFace.bottom` (centred text) or `.start` (Figma Left: the tail halfway down the start edge, start-aligned text, mirrored in RTL); Top and Right join the enum when a screen needs them. `SpeechBubbleEntrance.typing` (code-only motion, no Figma prototype): pops up from the tail, then types the words out (`TypewriterText`) |
| **Tool Tip** `440:7620` | — | `AppTooltipBubble` (commons) — **built** | "Nice 👍" pill with a 20 × 7 tail under its middle; code |
| **Info Icon** `100:13101` | diamond / fire / flash / heart | stat artwork | 3D emoji-style icons → SVG |
| **Streak** `204:4091` | — | `StreakStatCard` (rewards) | Flame art + "25 XP" |
| **Streak Check** `445:8482` | true/false | `StreakDayCheck` (streak, rewards) | Code (circle + check) |
| **Streak Goal Status Card** `445:8420` | true/false · Day's | `StreakGoalCard` (streak) | Selected / unselected day card |
| **Level anue** `285:27855` | — | `CurrentUnitCard` (home) | "Level 5, Unit 2 / The Unpredictable Park" + unit badge + list button |
| **Review Mistakes** `429:8276` | — | `MistakeTile` (review_mistakes) | Heart count, title, unit, +XP |
| **Story Card** `429:9142` | — | `StoryCard` (stories) | Story art (raster → WebP), title, duration, Listen button |
| **Upgrade Premium** `2088:31022` | — | `UpgradeProCard` (commons) | Mascot art + secondary button; profile and shop |
| **Get Pro Heading Badge** `441:9155` | — | `ProBadge` (commons) | "Get Pro" pill |
| **Language** `440:8757` | — | `CourseProgressTile` (language sheet) | Flag + name + `GlossyProgressBar` (commons, **built** with the setup questions) |
| **Gem Pack Card** `445:8565` | — | `GemPackCard` (shop) | Gem art + amount + price footer |
| **Badge** `445:9916` + **Badges** `445:10252` | true/false · Title, Badge Image | `AchievementBadge` (profile) | Earned / locked (desaturated) art |
| **L bage** `391:15633` | Active / Locked / Lost | `LeagueBadge` (leaderboard) | Hexagon league badge: SVG art per state |
| **Rank Badge** `391:14778` | Gold / Bronse / Silver · Rank | `RankBadge` (leaderboard) | Hexagon medal with a **dynamic** rank number → shape in code (or SVG base) + Text |
| **Leadeboard Member** `391:5358` | Name, Course, Score, XP, Avatar | `LeaderboardTile` (leaderboard) | Rank badge, avatar, flag + score, XP |
| **Section Heading** `445:8302` | Title, Show View All | `SectionHeader` (commons) | |
| **TopAppBar** `441:7763` | General / Home · Title, Show Title, Show Side Actions | `HomeHeader` (home) + `AppTopBar` (commons) — General **built** | Home: greeting, language, stat chips. General: back button, optional title (or a `center` widget in its place, like the setup questions' progress bar) and side actions; `AppTopBarBackground.none` (most screens) or `.card` (Surface/Background Nuturel, bottom radius 24: Explore Levels, Stories) |
| **Bottom App Bar** `149:34134` (Light Overlays) | 5 states | `AppBottomNavBar` (commons) | Floating pill, animated active highlight |
| **Heart** `427:9233` | — | heart artwork | SVG |
| **Icons** `37:11465` (30), **Bottombar Icons** `149:34241` (5), **Other Icons** `204:4179` (6) | — | `assets/icons/ic_*.svg`, or Material `Icons.*` when a faithful match | Line icons tinted with `icon.*` tokens; multi-colour ones (Google, calendar, goal) raw |
| **Dummy Avatars** `375:5489` | 6 avatars | avatar art | SVG / WebP |

Also shared, not a Figma component (commons, **built** with Login / Create Profile unless noted):

| Widget | What it is |
|---|---|
| `SkyBackdrop` + `CloudGroups.formHeader` | Full-bleed sky gradient (to 42.4% of the screen height) with the form screens' six-cloud group, drawn in code |
| `SkyFormScaffold` | Page of the form screens: sky, optional `AppTopBar`, the form centred on the screen, scrolling and keyboard handling |
| `PageHeading` | Figma "Heading" of the forms: headline/large title + body/large description, centred |
| `ProfileFormFields` + `ProfileFormController` | Full name, email, Gender + Age: Create Profile now, Create Account ("Continue with Email", `2016:11880`) next |
| `AppSocialButton` | The sign-in choice tiles (Google / Apple on Login; "Sign Up with Google" / "Create New Account" on Save your journey): 52 high, 2px inside border |
| `LabeledDivider` | Hairline with a centred label ("Or Continue With") |
| `MeadowBackdrop` + `MeadowStage` + `MeadowPainter` | Sky panel of the New Account Progress screens: sky, meadow clouds, hills and trees, back button; the screen adds its bubble and Mieo in frame coordinates |
| `AppTextLink` | Underlined tappable text ("Forgot Password .?") |
| `AppTapTarget` | Gives a small child (text link, the password eye) a 48 tap target without changing the layout |
| `AppIcon` | The Figma line icons (`assets/icons`), tinted by token, brand logos in their own colours |

`GlossyProgressBar` (Figma "Progress Bar" 2016:14397) is **built** with the setup questions: a 26-high pill, the fill
with its white inner shade and two glossy stripes, growing from the step before; the lesson top bar, streak goal and
language tiles reuse it. Still to build: `LessonTopBar` (back + progress + hearts), `AppBottomSheet` (language, hearts and question sheets), `LevelMap` + `LevelPathPainter` (home).

## 5. Suggested build order

Shared components (§4) → Splash → Welcome → New Account Progress → Login / Create Profile → Home (map, levels,
level detail) → Game Play + Result → Streak → Leaderboard → Profile / Settings → Shop / Subscription → Stories →
Review Mistakes → Live Questions → AI Talk. Each screen is built light + dark in one pass.

## 6. Design inconsistencies to keep in mind

- **Same component, different sizes:** on Login and Create Profile the text fields are 345 wide (15px gutter)
  while the button is 343 (16px gutter). The code uses the 16px gutter for both. Likewise Login's "Or Continue With"
  row is a fixed 337 wide starting at 16, so its label sits 3px left of centre; the code spans the full 343 and
  centres it.
- **Instance overrides:** the Back Button inside the TopAppBar binds its outline to `Surface/Extra Dim/Nuturel`
  instead of the master's `Stroke/Extra Dim/Nuturel`. Both are #E3E6E8 / #464E53, so the code keeps the master's
  stroke token. The Input Field instances leave the placeholder at the component default ("Email Address"), even on
  the name, gender and age fields, so the code gives each field its own hint.
- **Social buttons** are plain frames rather than a component: 2px `Stroke/Extra Dim/Nuturel` border *inside*
  (the components use 1.5 outside), radius 16, hard shadow 4. `AppSocialButton` matches them.
- **Misleading names:** frames ("Loading" = Home map, "Chears" = cheer, "Rewpord" = reward) and components
  ("L bage" = league badge, "Level anue" = current unit card, "Radio Button'"), variant names ("Property 1",
  "Dissabled", "Uncheked", "RIght", "Bronse") and variables ("Nuturel", "Nutural", "Primacy"). Code uses correct
  English; match on node IDs and variable names.
- **Device chrome:** frames draw an iOS status bar (9:41, Inter Semi Bold 17) and rounded corners. Never draw
  them; content starts inside `SafeArea` (Figma y-positions include the 44px status bar).
- **Duplicate tokens:** `Stroke/Green 2` equals `Stroke/Green`; `Shadow/Secondary` equals the light value of
  `Shadow/Secondary/Darker` but not the dark one. Both are mirrored so every variable maps 1:1.
- **Unbound colours:** a few UI fills use raw hex instead of variables (e.g. `#DFF4FF` frames, the white
  "Unlock" play button). Because the dark page only switches variables, these stay light in dark mode. Check each
  one against the dark screenshot when its screen is built, and add a token if it should change (CLAUDE.md §6).

## 7. Open questions (for the project lead / designer)

1. **Bottom nav, third tab (video icon):** does it open AI Talk (`255:3557`) or Stories?
2. **UI languages:** English (LTR) + Urdu (RTL), following the reference project. Confirm, or swap Urdu for Arabic.
3. **Orientation:** lock phones to portrait (the design is portrait-only) and allow both on tablets?
4. **Copy typos in Figma.** Fix them in the translation files or keep them verbatim? "Faster then ever",
   "Opps.!", "Humans Make's Mistakes", "Privacy Policy's", "Forgot Password .?", "You just completed you 25 Days",
   "Provide us your some details so we store your all data carefully", "Yey..! I just want to Ask you some
   Questions. Please...!", "Sure.! Continue". On the splash: "Learning  with" has a
   double space and the footer credit a trailing space. The double space is kept (it sets the gap in the
   design); the trailing space is dropped (it only shifts Figma's centring by half a space). On Onboarding,
   "Faster then ever." is kept verbatim for now, and the filled button's label "Let’s Get a Fresh Start" drops
   the two trailing spaces of the component's default text (they pull Figma's centred label 4.5px to the left).
5. **Default theme:** the app opens in light (Figma `Logics/Dark Mode` = false). Follow the system setting instead?
6. **Stale text layers on the splash, Onboarding, Login and Create Profile** (§8): refresh them in Figma so the
   design shows the real Nunito.
7. **Forgot password:** there is no design for it. "Forgot Password .?" opens a placeholder route
   (`Routes.forgotPassword`) until one exists.
8. **Field error state:** the Input Field component has no error variant. The code shows a failed check with a
   `Stroke/Red` outline, a `Shadow/Red/Lighter` shadow and the message in label/medium `Texts/Red` 8 under the box.
   Confirm or supply a design.
9. **Dropdown menu:** the Gender field's open state isn't designed. The code opens a card under the box (Surface/
   Background Nuturel, `Stroke/Extra Dim/Nuturel` outline, hard shadow 4), the chosen option on `Surface/Dim/primary`.
10. **Age on Create Profile:** the screen shows 8 while the `Logics` variable says 6. The dummy data follows the screen.

Answered: **dark theme** — the Figma file now has a full `📱Dark Theme` page and Light/Dark values for every
colour token; the code mirrors them exactly. **Splash animation** — the mascot plays from the Rive file
(`assets/animations/mascot_splash.riv`) with the `rive` package; the sky and clouds are drawn in code.

## 8. Build notes per screen

### Splash — Light `22:5` · Dark `2159:12106` → `features/splash`

- **Light vs Dark:** identical geometry (every cloud vector's path data matches between the twins); only
  variable-bound colours change: sky gradient (`Surface/Sky/*` over `Surface/Body`), clouds (`Cloud Color/1–3`),
  texts (`Texts/Heading`, `Texts/Body Text`). No raw colours outside the mascot artwork.
- **Layers (bottom → top, Figma order):** frame fill = `Surface/Body` + linear gradient `Surface/Sky/Top` →
  `Surface/Sky/Bottom` from y 0 to y 344; App Name group ("Learning  with" body/large at 122,222 and "Mieo"
  display/large centred at top 238); "Cloudes" group (8 clouds, 41 vectors, drawn in code from the exact Figma
  paths); "Mieo Charachter" (the Rive artboard, same 375 × 812 coordinates); Footer (58 high, pinned bottom, text
  16 below its top).
- **Verified:** the sky and clouds rendered through Skia from the project's code differ from the Figma render by
  < 1 level on average (99th percentile ≤ 3/255) in both themes; the tagline and footer baselines match to
  0.1px.
- **Stale text layers in Figma:** the splash's three text layers were laid out with a different Nunito build
  than the Google Fonts version the app bundles (the Style Guide typography samples already use the current
  one). You can see it in their box heights (Mieo 72, tagline 20, footer 18, where the current font gives 78,
  22 and 19) and in the "Mieo" glyphs: the stored render has a wider **M** and sits 1.5px higher. The app uses the
  real Nunito at the Figma layout values, which is what Figma shows once those layers are refreshed (select them,
  re-apply their text styles).
- **Responsive:** the scene keeps the design size on phones, centred (more sky on taller screens); it shrinks
  only when the mascot frame wouldn't fit (narrow phones, landscape) and scales up on tablets to fill the height.
  The footer stays at 1× on the bottom edge, lifted above a navigation bar but not a home indicator.
- **RTL:** the tagline mirrors to the start edge; the wordmark is centred; clouds and mascot are artwork and
  don't mirror.
- **Clouds:** the eight cloud designs live in `lib/commons/widgets/clouds/` (shared with Onboarding); the splash
  places all eight.

### Onboarding — Light `25:1919` · Dark `2159:12444` → `features/onboarding`

- **Light vs Dark:** identical geometry; only variable-bound colours change: page and sky (`Surface/Body`,
  `Surface/Sky/*`), clouds, pedestal columns (`Surface/Extra Dim/Primary` → `Surface/Sky/Top`, translucent in
  dark), pedestal tops (`Surface/Primary`) and their rims (`Shadow/Primary/Lighter`, #C9EDFF → #464E53), the tag
  (`Surface/Extra Dim/Primary`, `Stroke/Dim/primary`), texts and buttons. Raw colours: the mascot artwork
  (`ArtworkColors`, black, white), the pedestal lettering's 16% black shadow and the buttons' white gloss. The
  lettering is bound to `Shades/primary/300` and `/200`. The highlighted heading word is a raw #1AB3FF, which is
  `Texts/primary` in both modes, so the code uses that token.
- **Layout:** sky panel "Body" (593 high on the reference, y 50 → 643, clipped) = `Surface/Body` + gradient
  `Surface/Sky/Bottom` at 12.8% → `Surface/Sky/Top` at 111%. Intro "Container" at 18, 54 (340 wide: 18 from the
  start, 17 from the end) = tag (padding 12 × 8, 16 icon, 8 gap, label/medium - prominent in `Texts/primary`,
  1px inside outline, radius 8) + 8 + heading (headline/large). A 9 gap, then the actions "Container": two
  `AppButton`s (filled, outlined) 16 apart, with 24 above and below.
- **Scene, drawn in code:** "Steps Path" (three columns with oval tops on hard-shadow rims, plus the "Aa" and
  "ગુજ" lettering from the Figma vectors: `LanguagePedestalsPainter`), "Cloudes" (seven of the shared cloud
  shapes) and "Mieo Charachter" (`WelcomeMascotPainter`). Mieo is code instead of an SVG because his Figma
  effects (two soft-light drop shadows, three inner shadows) can't be rendered by flutter_svg: the painter draws
  each hard effect as a path (the shape shifted by the offset, minus the shape) with Figma's blend mode, from the
  exported geometry at 0.001px. The tag's shield icon is code too, since its two parts follow two theme tokens.
  The glyph paths (Aa, ગુજ, shield, check) hash-match the Figma vectors.
- **Verified:** rendered through Skia from the project's code, the sky, clouds, pedestals and Mieo differ from the
  Figma render by ≤ 2.2/255 on average per region in both themes (99th percentile ≤ 18, anti-aliased edges at
  1x).
- **Stale text layers (as on the splash):** the heading box is 80 high (2 × 40) and the tag and button labels
  15 and 20: the metrics of the older Nunito build. The current font gives 87.3, 16.4 and 21.8, so in the app the
  heading's second line sits 5px lower than in the stored render and the tag is 0.4px taller. The scene is
  anchored to the panel's bottom edge, so nothing else moves.
- **Responsive:** the scene is laid out in the Body frame's coordinates (`OnboardingStage`) in the space under the
  intro, bottom-anchored and centred: the identity on the reference, more sky on taller phones. On shorter screens
  it first moves down so Mieo's ears stay ≥ 24 below the heading, then shrinks (to 0.8 at most); below that the
  sky panel scrolls while the buttons stay pinned. Tablets scale the scene up to the 560 content-column width,
  where the intro and buttons also sit. The buttons lift above a navigation bar, not above a home indicator.
- **RTL:** the intro mirrors to the start edge; the scene, its lettering and the button gloss are artwork and
  don't mirror.
- **Navigation:** Let’s Get a Fresh Start → `Routes.accountSetup` (New Account Progress, placeholder for now);
  Resume Journey → `Routes.login` (Login). The splash cross-fades into this screen.

### Hi! I'm Mieo — Light `62:3649` · Dark `2159:37580` → `features/onboarding`

- **Light vs Dark:** identical geometry (node-by-node compare); only variable-bound colours change: page and sky
  (`Surface/Body`, `Surface/Sky/*`), clouds, the talk bubble (`Surface/Background Nuturel`, `Stroke/Dim/neutral`,
  `Texts/Heading`), the top bar and the button. The meadow is bound to `Shades/Success/*` and `Shades/error/950`
  primitives, so it is the same in both. Raw colours: the mascot artwork (`ArtworkColors`, black, white, the new
  `mieoTongue` #FF5555), one crown green #55D374 (= `Shades/Success/300`, used as that) and the button gloss.
- **Layout:** sky panel "BOdy" (716 high on the reference, y 0 → 716, edge to edge behind the status bar, bottom
  corners 24) = gradient `Surface/Sky/Top` → `Surface/Sky/Bottom` over the page. TopAppBar (General, back button
  only) at y 50. "Action" below it: one filled `AppButton` with 24 above and below, on the page's sky
  (`SkyBackdrop`, no clouds).
- **Shared meadow (commons, `widgets/meadow/`):** the sky panel, "Cloudes" and "Ground" are the same on the next
  frames ("Ask you some Questions" 62:8081 and on), so they are one widget: `MeadowBackdrop` (sky gradient, bottom
  radius 24, back button, `CloudGroups.meadow`, `MeadowPainter`: three hill ovals, Mieo's shadow, four trees),
  fitted by `MeadowStage`. A screen adds its own layers in the BOdy frame's coordinates and names the top of its
  must-see band (the bubble's top as laid out). Cloud 62:4034 is cloud 5 at 83/172.713, hence `CloudPlacement.scale`.
- **Shared talk page (`features/onboarding/widgets/meadow_talk_scaffold.dart`):** this screen and the next one
  differ only in the bubble's text, Mieo's animation and the button's label, so `MeadowTalkScaffold` builds the page:
  the meadow, Mieo in his box, the bubble over him (centred on its Figma box and sitting on its bottom edge, so the
  tail stays on Mieo while a longer text grows upwards; painted last, as on the questions frame, so an animation that
  lifts Mieo never covers it), and the Action button. The must-see band starts at the bubble's real top: its Figma
  bottom edge less `SpeechBubble.boxHeight` (the text measured in the current text scale and language), so a
  bubble that grows upwards still keeps 16 below the top bar. `RiveMascot` plays one artboard of a mascot's Rive
  file, by name, with its still pose as the fallback.
- **Mieo talking (motion, not in Figma):** the Figma file has no typing design, so this is code-only motion built
  from the tokens. Both talk bubbles use `SpeechBubbleEntrance.typing`: once the page has slid in
  (`bubbleEntranceDelay`), the bubble pops up from its tail (0.6 → 1, `easeOutBack`, fading in), and as soon as
  it is open the words type out, 40 ms a character and a beat after a phrase ("Yey..!", "Hi!"), with no loading
  state in between. The text is laid out in full from the start (the untyped rest transparent), so the bubble
  never changes size or reflows, and a screen reader reads the whole line at once. With animations turned off,
  the bubble and its words are simply there.
- **This screen's layers:** the one-line talk bubble (`SpeechBubble`) and Mieo waving (`HelloMascot`): the Rive animation `assets/animations/mieo_hi.riv` (artboard "Mieo",
  state machine "MieoSM": one wave, then breathing and blinking), with the static pose `HelloMascotPainter` (same
  technique as `WelcomeMascotPainter`; both share `MascotEffects`) while it loads or when Rive can't run. The
  artboard is 289 × 256: the Figma group (289 × 239) with 20px above the ears for the wave, so its box starts at
  y 431 and the character lands on the Figma group at (27, 451). The Rive character is drawn flat: it has no
  white top rims or soft-light shadows, which the Figma artwork and the static pose have. The static pose's
  tongue is Figma's "Mask group": an oval intersected with the mouth.
- **Verified:** rendered through Skia from the project's code, the top bar, clouds, meadow and Mieo differ from
  the Figma render by ≤ 0.8/255 on average per region in both themes.
- **Stale text layer:** the bubble's text layer is 20 high (older Nunito metrics); the current font gives 22, so
  the bubble is 46 high instead of 44: its top is 2px higher and its tail on its Figma pixel. The Talk Bubble
  component is a fixed 129 wide: the code keeps 129 as a minimum so Urdu or large text widens it instead of
  wrapping.
- **Responsive:** the scene is laid out in the BOdy frame's coordinates (`MeadowStage`), bottom-anchored and
  centred: the identity on the reference, more sky on taller phones. It shrinks (to 0.8 at most) to keep the
  bubble 16 below the top bar; below that the panel scrolls while the button stays pinned (landscape phones).
  Tablets scale the scene up to the 560 content-column width.
- **RTL:** the back button mirrors; the scene is artwork and doesn't.
- **Navigation:** onboarding's Let’s Get a Fresh Start → here (`Routes.accountSetup`); Say “Hi” to Mieo →
  `Routes.setupQuestions` ("I just want to ask you some questions").

### I just want to ask you some Questions — Light `62:8081` · Dark `2159:37689` → `features/onboarding`

- **Light vs Dark:** identical geometry; only variable-bound colours change, as on Hi! I'm Mieo. The accent word
  "Questions" is raw #1AB3FF in Figma, the value of `Texts/primary` in both modes, so it uses that token. Raw
  colours: the mascot artwork (`ArtworkColors`, black, white, and two new shadow fills: `mieoCheekShadow` #CC6C27,
  `mieoArmShadow` #D46515) and the button gloss.
- **Layout:** the same sky panel, clouds, meadow, top bar and Action as Hi! I'm Mieo (`MeadowTalkScaffold`). The
  talk bubble is a detached Talk Bubble 283 wide at (43, 366) whose text layer is a fixed 251 wide, so the line
  wraps inside (`SpeechBubble(width: 283)`); Mieo ("Mieo Charachter" 62:12012, 227 × 236 at (73, 450)) presses his
  paws to his cheeks.
- **Mieo:** `PleaseMascot` plays `assets/animations/mieoPlease.riv` (`RiveMascot`): artboard "MieoPlease",
  state machine "PleaseSM" (Entry → "Please", a gentle sway with pulsing eye glints, looping; layer 2 blinks). The
  artboard is 250 × 288 and holds the Figma group at (12, 44) (every shape matches the Figma vectors at that
  offset), so the box is (61, 406) 250 × 288 and Mieo lands on the Figma group at (73, 450). The file's "happy"
  trigger (a jump) isn't wired: rive 0.14 deprecates state-machine inputs in favour of data binding, and the
  file's view models have no properties yet. The file also holds a copy of mieo_hi's "Mieo" artboard, unused. The
  still pose `PleaseMascotPainter` is drawn from the Figma vectors like the other poses (body rim and soft-light
  shadow, cheeks with an upward #CC6C27 shadow, arms over everything with a #D46515 shadow and a top rim).
- **Verified:** Skia render vs Figma: top bar, clouds, Mieo and the meadow ≤ 0.8/255 on average per region in both
  themes. The dark clouds match Figma's pixel for pixel inside the shapes (flat `Cloud Color/1–3` fills, no blur or
  effect in Figma).
- **Stale text layer:** two lines of 20 in Figma, 22 with the current font, so the bubble is 68 high instead of 64;
  it sits on its Figma bottom edge, so its top is 4px higher.
- **Responsive:** as on Hi! I'm Mieo. At text scale 1.3 the bubble grows upwards; the stage shrinks or the panel
  scrolls to keep it 16 below the top bar (tested on short, landscape and tablet screens, in English and Urdu).
- **Navigation:** Say “Hi” to Mieo → here (`Routes.setupQuestions`); Sure.! Continue → `Routes.setupNativeLanguage`
  (the first question, "So.! What is your Native Language", see below).

### Setup questions — native language `62:8472` / `2159:37809`, learning language `62:10515` / `2159:37925`, level `62:9688` / `2159:38042`, daily goal `62:9100` / `2159:38157` → `features/onboarding`

- **Light vs Dark:** identical geometry; only variable-bound colours change: page and sky, clouds, top bar and
  progress bar, bubble, tiles and radios, the goal card and the button. Mieo's fur, face and pencil are raw artwork;
  his notebook (`Surface/Primary`) and pencil lead (`Surface/Nuturel`) are bound, so they follow the theme. The level
  icons bind `Shades/neutral/*` and `Shades/primary/*` primitives and the goal strip's unpicked "Min"
  `Shades/neutral/400`, so they are the same in both themes. The flags are raw artwork. The picked tile's
  `Surface/Extra Dim/Primary` is translucent in dark mode; Figma never draws the tile's shadow through it, so the code
  flattens it onto the page colour.
- **One page for four questions:** `SetupQuestionScaffold` builds the page; a screen passes its `SetupStep`, Mieo's
  question and the answers. Top to bottom: the sky with the "Cloudes" group (`CloudGroups.setupHeader`, laid out
  from under the status bar); `AppTopBar` with a `GlossyProgressBar` in its centre slot, filled to the Figma widths
  87, 146, 221 and 243 of 279 and growing from the step before; the header (`PerchedMieo` 16 in and 16 below the bar,
  the bubble 12 after him, filling the row, Figma face Left = `SpeechBubbleFace.start`, centred on him); the answers
  32 below Mieo; Next pinned 24 above the bottom.
- **Answers:** `SetupChoiceList` (a column of `SelectableOptionTile`s, 18 apart), as `LanguageChoiceList` (flags
  `flag_india`, `flag_usa`, `flag_france`, `flag_uk`) and `ProficiencyChoiceList` (`SignalStrengthIcon`: a dot and
  two arcs, lit from the dot, 0 to 3). The daily goal is `DailyGoalCard`: a minute strip that snaps a goal under a
  fixed frame, the "Nice 👍" `AppTooltipBubble` over it, and the Morning / Afternoon / Evening tabs with a sliding
  pill (each tab takes taps 48 high). Choices and first picks come from `OnboardingRepository`, as Figma shows them:
  Hindi, English (UK), "Know some basic words", 15 minutes, Morning.
- **Mieo:** `PerchedMieo` paints `NotebookMascotPainter` (the Figma vectors, with rims, the notebook's inner shadow and
  the soft-light shadows from `MascotEffects`) between the tilted "Upper Cloud" (cloud 4 at −10.348°) and "Lover
  Cloud" (the new cloud 9 at −4.6°, `CloudPlacement.rotation`), all in one picture so the soft light blends with the
  cloud. There is no Rive file for this pose, so it is a still.
- **Motion (code-only, not in Figma):** the bubble pops out of its tail and types the question, the progress bar
  grows, tiles sink when pressed and the radio dot pops in, the strip snaps with a selection tick while the tooltip
  ducks away and pops back, and the tab pill slides.
- **Verified:** Skia renders at 375 × 812 vs the Figma renders (native light, learning dark, level light, daily goal
  light and dark): 2.1 to 3.1/255 mean difference over the page. What remains is text: the stale layers below and the
  test font's rendering.
- **Stale text layers:** the bubbles' lines are 20 high in Figma and 22 with the current Nunito, so a two-line bubble
  is 68 high instead of 64 and a three-line one 90 instead of 84, still centred on Mieo. The goal numbers are 27 high
  in Figma and 30 now: the strip keeps its 58 and each goal scales down to fit only when it must (larger text).
- **Figma inconsistencies:** the goal card is 345 wide (a 15 gutter); the code uses the 16 gutter like every other
  full-width element. Tile outlines bind `Surface/Extra Dim/Nuturel` on some instances and `Stroke/Extra Dim/Nuturel`
  on others (same values); the code uses the stroke token. The level question says "English(UK)" while the tile says
  "English (UK)"; the question uses the tile's name. "Learn" is accented but, unlike "Native" and the language name,
  not underlined; kept as designed. The tooltip's text ends with a space, dropped. The strip's layers past the five
  visible goals repeat "45" as placeholders; the repository offers the five visible goals.
- **Responsive:** the header and answers sit in the content column (`ResponsiveContent`) and scroll; Next floats over
  them (the learning list runs under it, as in Figma), with room at the end so the last answer stops 24 above it.
  Tested on the Device Preview matrix in light LTR at text scale 1.0 and dark RTL at 1.3.
- **RTL:** the page mirrors: Mieo moves to the end with the bubble's tail pointing at him, the bar fills from the
  right, and the goals run from the right. Mieo, the clouds and the flags don't mirror.
- **Navigation:** Sure.! Continue → native language (`Routes.setupNativeLanguage`) → learning language
  (`Routes.setupLearningLanguage`) → level (`Routes.setupProficiency`, handed the picked language as the route's
  arguments) → daily goal (`Routes.setupDailyGoal`) → `Routes.setupLoading`, handed a `DailyGoal` (a placeholder until
  "Loading your course" is built).

### Login — Light `364:14961` · Dark `2159:38555` → `features/auth`

- **Light vs Dark:** identical geometry (node-by-node compare); only variable-bound colours change. Raw colours: the
  Google logo (multi-colour artwork) and the button gloss (white). The Apple logo is bound to `Icons/Nuturel`, so it
  is tinted.
- **Layout:** the frame fill is the sky (`Surface/Body` + `Surface/Sky/Top` → `Surface/Sky/Bottom` to y 344) with the
  six-cloud "Cloudes" group at (-85, -140), three of whose clouds reach into the frame (`SkyBackdrop`,
  `CloudGroups.formHeader`). The "Container" (y 113–699, 113 from both edges) centres, 28 apart: Heading
  (headline/large title, body/large description, both `Texts/Heading`); Input Fields (email Focused, password
  Default with the eye, 16 apart, then "Forgot Password .?" underlined at the end 16 below); Bottom Action (24 around
  the filled button); Social Login (24 padding, "Or Continue With" between two 1px `Stroke/Extra Dim/Nuturel` lines,
  18, then Google and Apple 16 apart).
- **Built:** `SkyFormScaffold` centres the form on the screen with equal insets (status bar and top bar vs the
  bottom inset), scrolls when it doesn't fit, hides the keyboard on drag or on a tap outside the fields. The email is
  filled in from `AuthRepository.getLastEmail()` without autofocus, so on arrival it shows the Selected look (Figma
  shows it Focused) and the keyboard doesn't cover the social buttons. Login Now and the password's Done key check both
  fields (`InputValidators.email` / `.required`) and go home; Google / Apple open Create Profile; the link opens
  `Routes.forgotPassword`. The link and the eye take taps in a 48 target without changing the Figma spacing
  (`AppTapTarget`).
- **Verified:** rendered through Skia from the project's values at the Figma element positions, the sky and clouds
  differ from the Figma render by < 1/255 on average (99th percentile ≤ 3) in both themes, the password field, button
  and social buttons by ≤ 2.8 on average. The remaining differences are text: the stale layers below and the 345-wide
  Figma fields.
- **Stale text layers (as on Onboarding):** the heading is 80 high in Figma (40 + 2 × 20) and each 14px label 18;
  the real Nunito makes them 87.3 and 19.1. Centred like Figma, the block starts 4.7 higher and the social buttons end
  4.7 lower than in the stored render.
- **RTL:** everything mirrors (the link moves to the left edge); the logos and the gloss don't.

### Create Profile — Light `366:15263` · Dark `2159:38492` → `features/auth`

- **Light vs Dark:** identical geometry; only variable-bound colours change. Raw colour: the button gloss.
- **Layout:** the same sky and cloud group as Login. TopAppBar General at y 50 with no fill and no title (only the Back
  Button, 16 in). The "Container" (y 113–699) centres, 28 apart: Heading; Input Fields (name Selected, email Focused,
  then Gender and Age side by side: the "Gender" label 16 before a dropdown box with a chevron, and "Age" 16 before a
  64 box with the value centred; the groups are 223 and 106 wide); Bottom Action (Submit).
- **Built:** `AppTopBar` (transparent) + `ProfileFormFields` filled in from `AuthRepository.getSocialProfile()`
  (Jenny Frost, jennyfrost@gmail.com, Female, 8). Gender opens a menu (Female, Male, Other); Age takes digits only, up
  to 3. Submit checks every field (`required`, `email`, `selection`, `age` 1–120) and goes home. The Gender and Age
  groups share the row by Figma's 223 : 106, so the boxes scale with the width and the labels' language. Centred on the
  screen with the top bar counted in the top inset: the heading starts 3.6 higher and the fields 3.6 lower than in the
  stored render (stale text heights).
- **Verified:** Skia render vs Figma at the element positions: sky and clouds < 1/255 on average, back button 0.7,
  button ≤ 2, fields ≤ 5 (text weight of the stale layers).
