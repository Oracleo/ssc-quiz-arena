// lib/models/models.dart
// All data models for SSC Quiz Arena

// ─── Question ────────────────────────────────────────────────
class Question {
  final String q;
  final List<String> opts;
  final int ans; // 0-3

  const Question({required this.q, required this.opts, required this.ans});

  factory Question.fromMap(Map<String, dynamic> map) => Question(
        q: map['q'] as String,
        opts: List<String>.from(map['opts'] as List),
        ans: (map['ans'] as num).toInt(),
      );
}

// ─── Topic ───────────────────────────────────────────────────
class Topic {
  final String id;
  final String label;
  final int qCount;

  const Topic({
    required this.id,
    required this.label,
    required this.qCount,
  });
}

// ─── Part ────────────────────────────────────────────────────
class Part {
  final String id;
  final String label;
  final String desc;
  final List<Topic> topics;

  const Part({
    required this.id,
    required this.label,
    required this.desc,
    required this.topics,
  });
}

// ─── Subject ─────────────────────────────────────────────────
class Subject {
  final String id;
  final String label;
  final List<Part> parts;

  const Subject({required this.id, required this.label, required this.parts});
}

// ─── Subject metadata (color + display) ─────────────────────
class SubjectMeta {
  final String id;
  final String label;
  final int colorValue;
  final int bgColorValue;

  const SubjectMeta({
    required this.id,
    required this.label,
    required this.colorValue,
    required this.bgColorValue,
  });
}

// ─── Topic progress ──────────────────────────────────────────
class TopicProgress {
  final int bestScore;
  final int totalQ;

  const TopicProgress({required this.bestScore, required this.totalQ});

  bool get completed => totalQ > 0;
  double get percentage => totalQ > 0 ? bestScore / totalQ : 0.0;

  factory TopicProgress.fromMap(Map<String, dynamic> map) => TopicProgress(
        bestScore: (map['bestScore'] as num?)?.toInt() ?? 0,
        totalQ: (map['totalQ'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => {'bestScore': bestScore, 'totalQ': totalQ};
}

// ─── Signed-in user ──────────────────────────────────────────
class AppUser {
  final String uid;
  final String name;
  final String? email;
  final String? photoUrl;

  const AppUser({
    required this.uid,
    required this.name,
    this.email,
    this.photoUrl,
  });
}


