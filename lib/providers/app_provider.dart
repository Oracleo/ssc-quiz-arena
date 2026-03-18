import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../services/firebase_service.dart';

class AppProvider extends ChangeNotifier {
  static const _themeKey = 'isDarkMode';
  static const _guestStateKey = 'guestProgressState';

  AppUser? _user;
  bool _isDarkMode = true;
  int _xp = 0;
  int _streak = 0;
  String? _lastActiveDate;
  Map<String, TopicProgress> _progress = {};
  bool _loadingUser = true;
  StreamSubscription? _authSub;

  AppUser? get user => _user;
  bool get isDarkMode => _isDarkMode;
  int get xp => _xp;
  int get streak => _streak;
  Map<String, TopicProgress> get progress => Map.unmodifiable(_progress);
  bool get loadingUser => _loadingUser;
  bool get isLoggedIn => _user != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? true;
    await _restoreGuestState(prefs);
    notifyListeners();

    _authSub = FirebaseService.instance.authStateChanges.listen((user) async {
      _loadingUser = false;
      if (user != null) {
        _user = FirebaseService.instance.currentAppUser;
        await _loadCloudProgress(user.uid, prefs);
      } else {
        _user = null;
        await _restoreGuestState(prefs);
      }
      notifyListeners();
    });
  }

  Future<void> _loadCloudProgress(String uid, SharedPreferences prefs) async {
    final data = await FirebaseService.instance.loadProgress(uid);
    if (data == null) {
      final guestState = _readGuestState(prefs);
      if (guestState != null) {
        _applyState(guestState);
        _persistToCloud();
      }
      return;
    }

    _xp = (data['xp'] as num?)?.toInt() ?? 0;
    _streak = (data['streak'] as num?)?.toInt() ?? 0;
    _lastActiveDate = data['lastActiveDate'] as String?;
    if (!prefs.containsKey(_themeKey)) {
      _isDarkMode = (data['isDarkMode'] as bool?) ?? true;
    }

    final rawProgress = data['progress'] as Map<String, dynamic>?;
    _progress = rawProgress == null
        ? {}
        : rawProgress.map(
            (k, v) => MapEntry(
              k,
              TopicProgress.fromMap(Map<String, dynamic>.from(v as Map)),
            ),
          );
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    await _persistLocalState(prefs);
    notifyListeners();
    _persistToCloud();
  }

  Future<bool> signInWithGoogle() async {
    try {
      final cred = await FirebaseService.instance.signInWithGoogle();
      return cred != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    await FirebaseService.instance.signOut();
  }

  Future<bool> updateDisplayName(String name) async {
    try {
      await FirebaseService.instance.updateDisplayName(name);
      _user = FirebaseService.instance.currentAppUser;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void recordQuizResult(String topicId, int score, int totalQ) {
    final existing = _progress[topicId];
    if (existing == null || score > existing.bestScore) {
      _progress = {
        ..._progress,
        topicId: TopicProgress(bestScore: score, totalQ: totalQ),
      };
    } else if (existing.totalQ == 0) {
      _progress = {
        ..._progress,
        topicId: TopicProgress(bestScore: existing.bestScore, totalQ: totalQ),
      };
    }

    _xp += score * 10;
    _updateStreak();
    notifyListeners();
    _persistLocalState();
    _persistToCloud();
  }

  void _updateStreak() {
    final now = DateTime.now();
    final today = _formatDate(now);

    if (_lastActiveDate == today) return;

    final yesterday = _formatDate(now.subtract(const Duration(days: 1)));
    _streak = _lastActiveDate == yesterday ? _streak + 1 : 1;
    _lastActiveDate = today;
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _persistLocalState([SharedPreferences? prefs]) async {
    final sharedPrefs = prefs ?? await SharedPreferences.getInstance();
    await sharedPrefs.setString(_guestStateKey, jsonEncode(_toLocalState()));
  }

  Future<void> _restoreGuestState([SharedPreferences? prefs]) async {
    final sharedPrefs = prefs ?? await SharedPreferences.getInstance();
    final guestState = _readGuestState(sharedPrefs);
    if (guestState == null) {
      _xp = 0;
      _streak = 0;
      _lastActiveDate = null;
      _progress = {};
      return;
    }
    _applyState(guestState);
  }

  Map<String, dynamic>? _readGuestState(SharedPreferences prefs) {
    final raw = prefs.getString(_guestStateKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _toLocalState() => {
        'xp': _xp,
        'streak': _streak,
        'lastActiveDate': _lastActiveDate,
        'progress': _progress.map((k, v) => MapEntry(k, v.toMap())),
      };

  void _applyState(Map<String, dynamic> data) {
    _xp = (data['xp'] as num?)?.toInt() ?? 0;
    _streak = (data['streak'] as num?)?.toInt() ?? 0;
    _lastActiveDate = data['lastActiveDate'] as String?;

    final rawProgress = data['progress'] as Map<String, dynamic>?;
    _progress = rawProgress == null
        ? {}
        : rawProgress.map(
            (k, v) => MapEntry(
              k,
              TopicProgress.fromMap(Map<String, dynamic>.from(v as Map)),
            ),
          );
  }

  void _persistToCloud() {
    if (_user == null) return;
    FirebaseService.instance.saveProgress(
      _user!.uid,
      progress: _progress,
      xp: _xp,
      streak: _streak,
      lastActiveDate: _lastActiveDate,
      isDarkMode: _isDarkMode,
    );
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
