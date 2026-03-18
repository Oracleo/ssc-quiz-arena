import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/app_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/widgets.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _saveProgress());
  }

  void _saveProgress() {
    if (_saved) return;
    _saved = true;
    final quiz = context.read<QuizProvider>();
    if (quiz.questions.isNotEmpty) {
      context.read<AppProvider>().recordQuizResult(
            quiz.topicId,
            quiz.score,
            quiz.questions.length,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.read<QuizProvider>();
    final total = quiz.questions.length;
    final score = quiz.score;
    final percentage = total == 0 ? 0.0 : score / total;
    final xpEarned = score * 10;
    final (icon, iconColor, message, title) = _resultInfo(context, percentage);

    return AppViewport(
      builder: (context, viewport) {
        final compact = viewport.isCompact;

        return Column(
          children: [
            ScreenToolbar(
              title: quiz.topicLabel,
              subtitle: 'Quiz complete',
              actions: [
                AppActionIconButton(
                  icon: Icons.home_rounded,
                  onTap: () => context.go('/'),
                ),
              ],
            ),
            SizedBox(height: compact ? 6 : 10),
            Expanded(
              child: AppGlassPanel(
                radius: viewport.panelRadius,
                padding: EdgeInsets.all(compact ? 16 : 22),
                child: Column(
                  children: [
                    const Spacer(flex: 1),

                    // Result icon
                    Container(
                      width: compact ? 64 : 76,
                      height: compact ? 64 : 76,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: iconColor.withValues(alpha: 0.25)),
                      ),
                      child: Icon(icon,
                          size: compact ? 30 : 36, color: iconColor),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: compact ? 18 : 22,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quiz.topicLabel,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: context.mutedColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),

                    // Score display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$score',
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: compact ? 36 : 44,
                            fontWeight: FontWeight.w700,
                            color: context.textColor,
                          ),
                        ),
                        Text(
                          '/$total',
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: compact ? 18 : 22,
                            fontWeight: FontWeight.w600,
                            color: context.mutedColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // XP badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.goldBgColor,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: context.goldBorderColor),
                      ),
                      child: Text(
                        '+$xpEarned XP',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: context.goldColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Message
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: context.mutedColor,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: percentage,
                        minHeight: 6,
                        backgroundColor: context.inputBgColor,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(iconColor),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Action buttons
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: FilledButton.icon(
                        onPressed: () async {
                          final q = context.read<QuizProvider>();
                          await q.startQuiz(
                            subjectId: q.subjectId,
                            partId: q.partId,
                            topicId: q.topicId,
                          );
                          if (context.mounted) {
                            context.go(
                                '/quiz/${q.subjectId}/${q.partId}/${q.topicId}');
                          }
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Retry Quiz',
                            style: TextStyle(fontSize: 13)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () {
                                final q = context.read<QuizProvider>();
                                context.go(
                                    '/subject/${q.subjectId}/${q.partId}');
                              },
                              child: const Text('Topics',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () => context.go('/'),
                              child: const Text('Home',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  (IconData, Color, String, String) _resultInfo(
      BuildContext context, double percentage) {
    if (percentage == 1.0) {
      return (
        Icons.emoji_events_rounded,
        context.goldColor,
        'Perfect score — every answer nailed. This topic is locked in.',
        'Outstanding!',
      );
    }
    if (percentage >= 0.7) {
      return (
        Icons.star_rounded,
        context.goldColor,
        'Strong result. One more pass could make this topic perfect.',
        'Great job!',
      );
    }
    if (percentage >= 0.4) {
      return (
        Icons.track_changes_rounded,
        context.greenColor,
        'Good foundation. Review the misses and try again while it\'s fresh.',
        'Nice effort',
      );
    }
    return (
      Icons.menu_book_rounded,
      context.redColor,
      'This topic needs practice. Slow down, study the answers, and retry.',
      'Keep going',
    );
  }
}
