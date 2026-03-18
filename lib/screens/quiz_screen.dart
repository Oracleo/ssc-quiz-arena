import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/quiz_provider.dart';
import '../widgets/widgets.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({
    super.key,
    required this.subjectId,
    required this.partId,
    required this.topicId,
  });

  final String subjectId;
  final String partId;
  final String topicId;

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    if (quiz.quizDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/result');
      });
    }

    return AppViewport(
      builder: (context, viewport) {
        return Column(
          children: [
            ScreenToolbar(
              title: quiz.topicLabel,
              subtitle: quiz.questions.isEmpty
                  ? 'Loading…'
                  : 'Question ${quiz.currentIndex + 1} of ${quiz.questions.length}',
              onBack: () => _confirmExit(context),
              actions: [
                AppActionIconButton(
                  icon: Icons.close_rounded,
                  onTap: () => _confirmExit(context),
                ),
              ],
            ),
            SizedBox(height: viewport.isCompact ? 6 : 10),
            Expanded(
              child: AppGlassPanel(
                radius: viewport.panelRadius,
                padding: EdgeInsets.all(viewport.isCompact ? 12 : 18),
                child: quiz.isLoading
                    ? const LoadingSpinner(message: 'Loading questions…')
                    : quiz.questions.isEmpty
                        ? _EmptyState(onBack: () => context.pop())
                        : _QuizBody(
                            quiz: quiz,
                            compact: viewport.isCompact,
                          ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit quiz?'),
        content: Text(
          'Your current attempt will be lost.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.mutedColor,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.pop();
            },
            child: Text('Exit', style: TextStyle(color: context.redColor)),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// QUIZ BODY
// ════════════════════════════════════════════════════════════════

class _QuizBody extends StatelessWidget {
  const _QuizBody({required this.quiz, required this.compact});

  final QuizProvider quiz;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final question = quiz.currentQuestion!;
    final total = quiz.questions.length;
    final progress = (quiz.currentIndex + 1) / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Progress row ──
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: context.inputBgColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(context.goldColor),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Q${quiz.currentIndex + 1}/$total',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: context.goldColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Score: ${quiz.score}',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: context.mutedColor,
              ),
            ),
          ],
        ),
        SizedBox(height: compact ? 6 : 8),

        // ── Question card — shrinks to content, can grow if needed ──
        Flexible(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 14,
              vertical: compact ? 8 : 10,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [context.goldBgColor, context.cardColor],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.goldBorderColor),
            ),
            child: Text(
              question.q,
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: compact ? 13 : 15,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: context.textColor,
              ),
            ),
          ),
        ),
        SizedBox(height: compact ? 6 : 8),

        // ── Options — fixed height, no stretch ──
        for (int i = 0; i < question.opts.length; i++) ...[
          if (i > 0) const SizedBox(height: 4),
          _OptionButton(
            index: i,
            text: question.opts[i],
            answered: quiz.answered,
            selected: quiz.selectedAnswer,
            correctIndex: question.ans,
            compact: compact,
            onTap: () =>
                context.read<QuizProvider>().selectAnswer(i),
          ),
        ],

        // ── Feedback + Next ──
        if (quiz.answered) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                quiz.selectedAnswer == question.ans
                    ? Icons.check_circle_rounded
                    : Icons.info_rounded,
                size: 14,
                color: quiz.selectedAnswer == question.ans
                    ? context.greenColor
                    : context.redColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  quiz.selectedAnswer == question.ans
                      ? 'Correct!'
                      : 'Answer: ${question.opts[question.ans]}',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: quiz.selectedAnswer == question.ans
                        ? context.greenColor
                        : context.redColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: FilledButton.icon(
              onPressed: () {
                final done =
                    context.read<QuizProvider>().nextQuestion();
                if (done && context.mounted) context.go('/result');
              },
              icon: Icon(
                quiz.isLastQuestion
                    ? Icons.emoji_events_rounded
                    : Icons.arrow_forward_rounded,
                size: 16,
              ),
              label: Text(
                quiz.isLastQuestion ? 'See Results' : 'Next',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
// OPTION BUTTON (compact)
// ════════════════════════════════════════════════════════════════

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.index,
    required this.text,
    required this.answered,
    required this.selected,
    required this.correctIndex,
    required this.compact,
    required this.onTap,
  });

  final int index;
  final String text;
  final bool answered;
  final int? selected;
  final int correctIndex;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var background = context.inputBgColor;
    var border = context.borderColor;
    var accent = context.mutedColor;
    IconData? trailingIcon;

    if (answered) {
      if (index == correctIndex) {
        background = const Color(0x162DD4BF);
        border = const Color(0x552DD4BF);
        accent = context.greenColor;
        trailingIcon = Icons.check_circle_rounded;
      } else if (index == selected) {
        background = const Color(0x16FF7A7A);
        border = const Color(0x55FF7A7A);
        accent = context.redColor;
        trailingIcon = Icons.cancel_rounded;
      }
    }

    final badgeSize = compact ? 24.0 : 28.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: answered ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 10,
            vertical: compact ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    ['A', 'B', 'C', 'D'][index],
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: compact ? 10 : 11,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: compact ? 11 : 12,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: context.textColor,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: 16, color: accent),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// EMPTY STATE
// ════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final quiz = context.read<QuizProvider>();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, size: 44, color: context.mutedColor),
          const SizedBox(height: 12),
          Text(
            'No questions yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              quiz.errorMessage ??
                  'Questions for this topic haven\'t been added yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: context.mutedColor),
            ),
          ),
          const SizedBox(height: 16),
          GhostButton(label: 'Go Back', onTap: onBack),
        ],
      ),
    );
  }
}
