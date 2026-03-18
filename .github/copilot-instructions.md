# SSC Quiz Arena — Copilot Instructions

## Project
- Flutter app (SDK >=3.3.0) targeting **Android** and **Web**
- State management: **Provider**
- Routing: **go_router**
- Backend: **Firebase** (Auth, Firestore)
- Fonts: Fraunces, Manrope (variable)

## Architecture
- `lib/core/` — constants, router, theme
- `lib/models/` — data models
- `lib/providers/` — Provider state classes
- `lib/screens/` — UI screens
- `lib/services/` — Firebase service layer
- `lib/widgets/` — reusable widgets
- `lib/data/` — static data (subjects)

## Conventions
- Use Provider for state; avoid setState where possible
- Use go_router for navigation
- Follow Material 3 design
- Keep widgets small and composable
- Use const constructors wherever possible

## Build Commands
- Run: `flutter run`
- Build Android APK: `flutter build apk --release`
- Build Android Bundle: `flutter build appbundle --release`
- Build Web: `flutter build web --release`
- Analyze: `flutter analyze`
- Test: `flutter test`
