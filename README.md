# SSC Quiz Arena — Flutter App
**India's best SSC CGL MCQ practice app. Web + Android.**

---

## Project Structure
```
ssc_quiz_arena/
├── lib/
│   ├── main.dart                    ← App entry point
│   ├── firebase_options.dart        ← Firebase credentials
│   ├── core/
│   │   ├── theme.dart               ← All colors, dark/light themes
│   │   ├── router.dart              ← GoRouter navigation
│   │   └── constants.dart           ← Subjects, leaderboard, announcement
│   ├── models/
│   │   └── models.dart              ← Question, Topic, Part, Subject, User
│   ├── data/
│   │   └── subjects_data.dart       ← All 10 subjects, local fallback questions
│   ├── services/
│   │   └── firebase_service.dart    ← Auth + Firestore operations
│   ├── providers/
│   │   ├── app_provider.dart        ← Global state (user, XP, theme, progress)
│   │   └── quiz_provider.dart       ← Quiz session state
│   ├── screens/
│   │   ├── home_screen.dart         ← Subject grid + stats + announcement
│   │   ├── parts_screen.dart        ← Parts list for a subject
│   │   ├── topics_screen.dart       ← Topics with done/new badges
│   │   ├── quiz_screen.dart         ← MCQ quiz with live feedback
│   │   └── result_screen.dart       ← Trophy/star/medal + XP earned
│   └── widgets/
│       └── widgets.dart             ← All reusable widgets
├── android/                         ← Android project
├── web/                             ← Web project (PWA)
├── pubspec.yaml                     ← Dependencies
└── README.md
```

---

## STEP-BY-STEP SETUP

### STEP 1 — Install Flutter (if not done)
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract to `C:\flutter`
3. Add `C:\flutter\bin` to your system PATH
4. Run: `flutter doctor` — fix all issues shown

### STEP 2 — Place this project
Put the `ssc_quiz_arena` folder anywhere, e.g. `C:\projects\ssc_quiz_arena`

### STEP 3 — Fix firebase_options.dart for Android
Open `lib/firebase_options.dart`.

Find this line:
```
appId: '1:194870317270:android:REPLACE_WITH_VALUE_FROM_GOOGLE_SERVICES_JSON',
```

Open your `google-services.json` (saved on Desktop/backup/).
Find the value of `"mobilesdk_app_id"` — it looks like:
`1:194870317270:android:abc123def456`

Replace the placeholder with your actual value.

### STEP 4 — Copy google-services.json
Copy `google-services.json` from your Desktop/backup/ to:
```
ssc_quiz_arena/android/app/google-services.json
```
⚠️ This file MUST be here. Without it, the Android build fails.

### STEP 5 — Get dependencies
Open VS Code terminal in the project folder, run:
```
flutter pub get
```

### STEP 6 — Run on your Realme 8
1. Enable Developer Options on your phone:
   Settings → About Phone → tap Build Number 7 times
2. Enable USB Debugging in Developer Options
3. Connect phone via USB cable
4. Run: `flutter devices` — your phone should appear
5. Run: `flutter run` — app installs and starts on your phone

### STEP 7 — Run on Web
```
flutter run -d chrome
```

### STEP 8 — Build Release APK
```
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

Copy it to your phone and install, OR upload to Play Store.

---

## ADDING MORE QUESTIONS

When you get new questions from Claude:
1. Add them to `lib/data/subjects_data.dart` in the correct topic's `localQuestions` list
2. Also run the web upload script to add them to Firestore:
   ```
   node scripts/uploadQuestions.js
   ```
3. The app fetches from Firestore live; local questions are offline fallback

---

## CHANGING THE ANNOUNCEMENT BANNER

Open `lib/core/constants.dart`, edit `kAnnouncement`:
```dart
const kAnnouncement = Announcement(
  enabled: true,                         // set false to hide
  type: AnnouncementType.promo,          // info / success / warning / promo
  badge: 'NEW',
  icon: '🎯',
  title: 'Your announcement title',
  subtitle: 'Your announcement subtitle text here.',
);
```

---

## FIRESTORE SECURITY RULES
Paste these rules in Firebase Console → Firestore → Rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Questions are public read
    match /subjects/{subject}/parts/{part}/topics/{topic}/questions/{q} {
      allow read: if true;
      allow write: if false;
    }

    // Topic metadata is public read
    match /subjects/{subject}/parts/{part}/topics/{topic} {
      allow read: if true;
      allow write: if false;
    }

    // User progress: only the user themselves can read/write
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## COMMON ERRORS & FIXES

**`google-services.json` not found**
→ Copy it to `android/app/google-services.json`

**`appId` placeholder error**
→ Update `firebase_options.dart` with real Android appId from google-services.json

**`flutter doctor` shows Android SDK missing**
→ Open Android Studio → SDK Manager → install Android SDK

**`minSdkVersion` error**
→ Already set to 23 in `android/app/build.gradle` — should work fine

**Google Sign-In not working on Android**
→ Go to Firebase Console → Authentication → Sign-in method → Google
→ Make sure your SHA-1 fingerprint is added:
```
cd android
./gradlew signingReport
```
Copy the SHA-1 value and add it in Firebase Console → Project Settings → Your Apps → Android app

**Build fails with Gradle error**
→ Run: `flutter clean` then `flutter pub get` then build again

---

## SCREENS OVERVIEW

| Screen | Route | Description |
|--------|-------|-------------|
| Home | `/` | 5-col subject grid, stats, announcement, XP/streak |
| Parts | `/subject/:id` | Parts grid for chosen subject |
| Topics | `/subject/:id/:partId` | Topic list with done/new badges + best score |
| Quiz | `/quiz/:subject/:part/:topic` | MCQ quiz with live feedback |
| Result | `/result` | Score, XP earned, trophy/star/medal |

---

## DESIGN TOKENS

| Token | Dark | Light |
|-------|------|-------|
| Background | `#080E1C` | `#F0F4FF` |
| Card | `#101C30` | `#FFFFFF` |
| Gold | `#F5A623` | `#D4870A` |
| Text | `#EDF2FF` | `#0D1526` |
| Muted | `#6B7FA3` | `#6B7FA3` |
| Green | `#22C55E` | `#16A34A` |
| Red | `#EF4444` | `#DC2626` |

Fonts: **DM Serif Display** (headings, questions) + **Plus Jakarta Sans** (body)
