// lib/providers/quiz_provider.dart
// Manages the state of a single quiz session.

import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../data/subjects_data.dart';
import '../services/firebase_service.dart';

class QuizProvider extends ChangeNotifier {
  // ─── State ────────────────────────────────────────────────
  List<Question> _questions = [];
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  bool _isLoading = false;
  bool _quizDone = false;
  String _subjectId = '';
  String _partId = '';
  String _topicId = '';
  String _topicLabel = '';
  String? _errorMessage;

  // ─── Getters ─────────────────────────────────────────────
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int? get selectedAnswer => _selectedAnswer;
  bool get answered => _answered;
  int get score => _score;
  bool get isLoading => _isLoading;
  bool get quizDone => _quizDone;
  String get subjectId => _subjectId;
  String get partId => _partId;
  String get topicId => _topicId;
  String get topicLabel => _topicLabel;
  String? get errorMessage => _errorMessage;

  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  double get progressFraction =>
      _questions.isEmpty ? 0 : (_currentIndex) / _questions.length;

  bool get isLastQuestion =>
      _questions.isNotEmpty && _currentIndex == _questions.length - 1;

  // ─── Load & start ─────────────────────────────────────────
  Future<void> startQuiz({
    required String subjectId,
    required String partId,
    required String topicId,
    int limit = 20,
  }) async {
    _subjectId = subjectId;
    _partId = partId;
    _topicId = topicId;
    _currentIndex = 0;
    _selectedAnswer = null;
    _answered = false;
    _score = 0;
    _quizDone = false;
    _isLoading = true;
    _errorMessage = null;

    // Resolve label from local structure data
    final topic = getSubject(subjectId)
        ?.parts
        .firstWhere((p) => p.id == partId,
            orElse: () => getSubject(subjectId)!.parts.first)
        .topics
        .firstWhere((t) => t.id == topicId,
            orElse: () => Topic(id: topicId, label: topicId, qCount: 0));
    _topicLabel = topic?.label ?? topicId;

    notifyListeners();

    // Fetch questions from Firestore only
    final firestoreQs = await FirebaseService.instance.fetchRandomQuestions(
      subjectId,
      partId,
      topicId,
      limit: limit,
    );

    if (firestoreQs != null && firestoreQs.isNotEmpty) {
      _questions = firestoreQs;
    } else {
      _questions = [];
      _errorMessage =
          'No questions available for this topic yet. Questions will be added soon!';
    }

    _isLoading = false;
    notifyListeners();
  }

  // ─── Answer & navigate ────────────────────────────────────
  void selectAnswer(int index) {
    if (_answered) return;
    _selectedAnswer = index;
    _answered = true;
    if (index == currentQuestion?.ans) _score++;
    notifyListeners();
  }

  /// Returns true if quiz is complete (caller should go to result screen).
  bool nextQuestion() {
    if (!_answered) return false;
    if (isLastQuestion) {
      _quizDone = true;
      notifyListeners();
      return true;
    }
    _currentIndex++;
    _selectedAnswer = null;
    _answered = false;
    notifyListeners();
    return false;
  }
}
