// lib/firebase_options.dart
// ─────────────────────────────────────────────────────────────
// Auto-generated with your Firebase project credentials.
// ⚠️  For Android: paste your actual appId from google-services.json
//     OR run: flutterfire configure  (recommended)
// ─────────────────────────────────────────────────────────────

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions not configured for ${defaultTargetPlatform.name}',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDwV9qiwKq1ZcKk1EWpvgZHt-yeeAeKBWU',
    appId: '1:194870317270:web:5141280e223723b847b977',
    messagingSenderId: '194870317270',
    projectId: 'ssc-quiz-arena',
    authDomain: 'ssc-quiz-arena.firebaseapp.com',
    storageBucket: 'ssc-quiz-arena.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-wDP_Cs1cnZOHBLwHZ3i6tPFBsV2E4tg',
    appId: '1:194870317270:android:d9be3c049fad7ea947b977',
    messagingSenderId: '194870317270',
    projectId: 'ssc-quiz-arena',
    storageBucket: 'ssc-quiz-arena.firebasestorage.app',
  );
}
