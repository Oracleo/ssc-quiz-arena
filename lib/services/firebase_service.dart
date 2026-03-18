// lib/services/firebase_service.dart
// All Firebase Auth + Firestore interactions in one place.

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/models.dart';
import 'announcement_config.dart' as announcement;

class LeaderboardEntry {
  final String name;
  final String? photoUrl;
  final int xp;
  final int streak;
  final int topicsCompleted;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.name,
    this.photoUrl,
    required this.xp,
    required this.streak,
    required this.topicsCompleted,
    this.isCurrentUser = false,
  });
}

class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // ─── Auth ─────────────────────────────────────────────────

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        return await _auth.signInWithPopup(provider);
      } else {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null;
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }

  AppUser? get currentAppUser {
    final u = _auth.currentUser;
    if (u == null) return null;
    return AppUser(
      uid: u.uid,
      name: u.displayName ?? 'User',
      email: u.email,
      photoUrl: u.photoURL,
    );
  }

  Future<void> updateDisplayName(String name) async {
    final u = _auth.currentUser;
    if (u == null) return;
    await u.updateDisplayName(name);
    await u.reload();
  }

  // ─── User Progress ────────────────────────────────────────

  Future<void> saveProgress(
    String uid, {
    required Map<String, TopicProgress> progress,
    required int xp,
    required int streak,
    required String? lastActiveDate,
    required bool isDarkMode,
  }) async {
    try {
      await _db.doc('users/$uid').set({
        'xp': xp,
        'streak': streak,
        'lastActiveDate': lastActiveDate,
        'isDarkMode': isDarkMode,
        'progress': progress.map((k, v) => MapEntry(k, v.toMap())),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('saveProgress error: $e');
    }
  }

  Future<Map<String, dynamic>?> loadProgress(String uid) async {
    try {
      final doc = await _db.doc('users/$uid').get();
      return doc.data();
    } catch (e) {
      debugPrint('loadProgress error: $e');
      return null;
    }
  }

  // ─── Questions ────────────────────────────────────────────

  /// Fetches [limit] random questions from Firestore.
  /// Falls back to null if Firestore is unavailable.
  Future<List<Question>?> fetchRandomQuestions(
    String subjectId,
    String partId,
    String topicId, {
    int limit = 20,
  }) async {
    try {
      final snap = await _db
          .collection(
              'subjects/$subjectId/parts/$partId/topics/$topicId/questions')
          .limit(100) // fetch more than needed, then randomise
          .get();

      if (snap.docs.isEmpty) return null;

      final all = snap.docs.map((d) => Question.fromMap(d.data())).toList();

      all.shuffle(Random());
      return all.take(limit).toList();
    } catch (e) {
      debugPrint('fetchRandomQuestions error: $e');
      return null;
    }
  }

  // ─── Community Leaderboard ────────────────────────────────

  /// Fetches announcement config from JS (web) or Firestore fallback.
  /// Returns a map with: enabled, type, icon, title, subtitle, badge
  Future<Map<String, dynamic>?> getAnnouncementConfig() async {
    // On web, try the JS global first
    if (kIsWeb) {
      try {
        final jsConfig = _getJsAnnouncementConfig();
        if (jsConfig != null) return jsConfig;
      } catch (_) {}
    }
    // Fallback to Firestore
    return _getFirestoreAnnouncement();
  }

  Map<String, dynamic>? _getJsAnnouncementConfig() {
    return announcement.getJsAnnouncementConfig();
  }

  Future<Map<String, dynamic>?> _getFirestoreAnnouncement() async {
    try {
      final snap = await _db
          .collection('announcements')
          .where('active', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return null;
      final data = snap.docs.first.data();
      return {
        'enabled': true,
        'type': (data['type'] as String?) ?? 'promo',
        'icon': (data['icon'] as String?) ?? '📢',
        'title': (data['title'] as String?) ?? data['text'] as String? ?? '',
        'subtitle': (data['subtitle'] as String?) ?? '',
        'badge': (data['badge'] as String?) ?? '',
      };
    } catch (e) {
      debugPrint('getAnnouncementConfig error: $e');
      return null;
    }
  }

  /// Fetches the latest active announcement text from Firestore (legacy).
  Future<String?> getLatestAnnouncement() async {
    try {
      final snap = await _db
          .collection('announcements')
          .where('active', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) return null;
      return snap.docs.first.data()['text'] as String?;
    } catch (e) {
      debugPrint('getLatestAnnouncement error: $e');
      return null;
    }
  }

  /// Generates a community leaderboard blending real users from Firestore
  /// with simulated participants so the board always feels alive.
  Future<List<LeaderboardEntry>> getCommunityLeaderboard({
    required int userXp,
    required int userStreak,
    required int userTopics,
    required String? userName,
    required String? userPhoto,
  }) async {
    final entries = <LeaderboardEntry>[];

    // Try to load real users first
    try {
      final snap = await _db
          .collection('users')
          .orderBy('xp', descending: true)
          .limit(50)
          .get();

      final currentUid = _auth.currentUser?.uid;

      for (final doc in snap.docs) {
        final data = doc.data();
        final xp = (data['xp'] as num?)?.toInt() ?? 0;
        final streak = (data['streak'] as num?)?.toInt() ?? 0;
        final progressMap = data['progress'] as Map<String, dynamic>?;
        final topics = progressMap?.length ?? 0;
        final name = data['displayName'] as String? ?? 'User';
        final photo = data['photoUrl'] as String?;
        entries.add(LeaderboardEntry(
          name: name,
          photoUrl: photo,
          xp: xp,
          streak: streak,
          topicsCompleted: topics,
          isCurrentUser: doc.id == currentUid,
        ));
      }
    } catch (e) {
      debugPrint('getCommunityLeaderboard error: $e');
    }

    // Generate simulated participants to fill the board
    entries.addAll(_generateSimulatedUsers(entries.length, userXp));

    // Always include current user if logged in
    final hasCurrentUser = entries.any((e) => e.isCurrentUser);
    if (!hasCurrentUser && userName != null) {
      entries.add(LeaderboardEntry(
        name: userName,
        photoUrl: userPhoto,
        xp: userXp,
        streak: userStreak,
        topicsCompleted: userTopics,
        isCurrentUser: true,
      ));
    }

    // Sort by XP descending
    entries.sort((a, b) => b.xp.compareTo(a.xp));

    return entries.take(100).toList();
  }

  List<LeaderboardEntry> _generateSimulatedUsers(
      int existingCount, int userXp) {
    final rng = Random(42); // fixed seed for stable names
    const names = [
      'Aarav S.', 'Priya M.', 'Rohit K.', 'Sneha P.', 'Vikram J.',
      'Ananya R.', 'Karthik N.', 'Divya L.', 'Arjun B.', 'Meera T.',
      'Sanjay G.', 'Pooja D.', 'Rahul V.', 'Neha A.', 'Amit C.',
      'Kavita H.', 'Suresh M.', 'Ritu S.', 'Manish P.', 'Swati K.',
      'Deepak R.', 'Anjali T.', 'Rajesh N.', 'Sunita B.', 'Vijay L.',
      'Pallavi G.', 'Nikhil D.', 'Sakshi V.', 'Aditya A.', 'Tanvi C.',
      'Gaurav H.', 'Shruti M.', 'Pankaj S.', 'Nidhi P.', 'Akash K.',
      'Bhavna R.', 'Tarun T.', 'Simran N.', 'Harsh B.', 'Jyoti L.',
      'Ashok G.', 'Komal D.', 'Vivek V.', 'Isha A.', 'Saurabh C.',
      'Megha H.', 'Prakash M.', 'Rashi S.', 'Naveen P.', 'Tina K.',
      'Ajay R.', 'Geeta T.', 'Mohit N.', 'Chetna B.', 'Kunal L.',
      'Madhuri G.', 'Ravi D.', 'Sonali V.', 'Anand A.', 'Priti C.',
      'Dinesh H.', 'Varsha M.', 'Hemant S.', 'Karishma P.', 'Lalit K.',
      'Poonam R.', 'Tushar T.', 'Ankita N.', 'Manoj B.', 'Seema L.',
      'Girish G.', 'Rekha D.', 'Nilesh V.', 'Aparna A.', 'Santosh C.',
      'Vandana H.', 'Umesh M.', 'Richa S.', 'Yogesh P.', 'Sonal K.',
      'Chetan R.', 'Hema T.', 'Brijesh N.', 'Kirti B.', 'Pramod L.',
      'Aarti G.', 'Dev D.', 'Lata V.', 'Ramesh A.', 'Usha C.',
      'Naresh H.', 'Shilpa M.', 'Govind S.', 'Manju P.', 'Rakesh K.',
      'Anita R.', 'Bharat T.', 'Kamla N.', 'Sunil B.', 'Pushpa L.',
    ];

    final count = 100 - existingCount;
    if (count <= 0) return [];

    // Create a spread of XP values around current user
    final maxXp = (userXp * 2.5).clamp(500, 50000).toInt();
    final entries = <LeaderboardEntry>[];

    for (var i = 0; i < count && i < names.length; i++) {
      final xp = rng.nextInt(maxXp) + 50;
      final streak = rng.nextInt(30) + 1;
      final topics = rng.nextInt(40) + 1;
      entries.add(LeaderboardEntry(
        name: names[i],
        xp: xp,
        streak: streak,
        topicsCompleted: topics,
      ));
    }

    return entries;
  }
}
