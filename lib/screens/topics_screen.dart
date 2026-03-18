import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/subjects_data.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/widgets.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({
    super.key,
    required this.subjectId,
    required this.partId,
  });

  final String subjectId;
  final String partId;

  @override
  Widget build(BuildContext context) {
    final subject = subjectsData[subjectId];
    final meta = getSubjectMeta(subjectId);
    final accent = Color(meta.colorValue);
    final soft = Color(meta.bgColorValue);
    final app = context.watch<AppProvider>();

    if (subject == null) {
      return const Scaffold(
        body: SafeArea(child: Center(child: Text('Subject not found'))),
      );
    }

    final part = subject.parts.firstWhere(
      (item) => item.id == partId,
      orElse: () => subject.parts.first,
    );

    final completedCount = part.topics
        .where((topic) => app.progress[topic.id]?.completed ?? false)
        .length;

    return AppViewport(
      builder: (context, viewport) {
        final gap = SizedBox(height: viewport.isCompact ? 8 : 12);

        return Column(
          children: [
            // Toolbar
            ScreenToolbar(
              title: part.label,
              subtitle: '${part.topics.length} topics',
              accentColor: accent,
              onBack: () => context.pop(),
              badge: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: soft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.grid_view_rounded,
                    color: accent, size: 18),
              ),
            ),
            gap,

            // Main content
            Expanded(
              child: AppGlassPanel(
                radius: viewport.panelRadius,
                padding: EdgeInsets.all(viewport.isCompact ? 10 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            soft.withValues(alpha: 0.2),
                            soft.withValues(alpha: 0.05),
                          ],
                        ),
                        border: Border.all(
                            color: accent.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$completedCount/${part.topics.length}',
                            style: TextStyle(
                              fontFamily: 'Fraunces',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Completed Topics',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: context.mutedColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: part.topics.isEmpty
                                        ? 0
                                        : completedCount /
                                            part.topics.length,
                                    minHeight: 4,
                                    backgroundColor:
                                        context.inputBgColor,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            accent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    gap,

                    // Section label
                    Row(
                      children: [
                        Text(
                          'TOPICS',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                letterSpacing: 1.5,
                                color: context.mutedColor,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Divider(
                              color: context.borderColor, height: 1),
                        ),
                      ],
                    ),
                    gap,

                    // Topics — flex wrap layout
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const spacing = 6.0;
                          // Min 250px per topic so names are readable
                          final cols = (constraints.maxWidth / 250).floor().clamp(1, 3);
                          final tileW = cols == 1
                              ? constraints.maxWidth
                              : (constraints.maxWidth - spacing * (cols - 1)) / cols;

                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: List.generate(
                                part.topics.length,
                                (index) {
                                  final topic = part.topics[index];
                                  final progress = app.progress[topic.id];
                                  return SizedBox(
                                    width: tileW,
                                    child: _TopicRow(
                                      index: index + 1,
                                      topic: topic,
                                      progress: progress,
                                      liveCount: app.liveCountsLoaded
                                          ? app.liveTopicCount(
                                              subjectId, partId, topic.id)
                                          : topic.qCount,
                                      accent: accent,
                                      soft: soft,
                                      onTap: () async {
                                        final quiz =
                                            context.read<QuizProvider>();
                                        await quiz.startQuiz(
                                          subjectId: subjectId,
                                          partId: partId,
                                          topicId: topic.id,
                                          limit: 20,
                                        );
                                        if (context.mounted) {
                                          context.push(
                                              '/quiz/$subjectId/$partId/${topic.id}');
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
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
}

// ════════════════════════════════════════════════════════════════
// Topic Row
// ════════════════════════════════════════════════════════════════

class _TopicRow extends StatelessWidget {
  const _TopicRow({
    required this.index,
    required this.topic,
    required this.progress,
    required this.liveCount,
    required this.accent,
    required this.soft,
    required this.onTap,
  });

  final int index;
  final Topic topic;
  final TopicProgress? progress;
  final int liveCount;
  final Color accent;
  final Color soft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDone = progress?.completed ?? false;
    final statusColor = isDone ? context.greenColor : accent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              soft.withValues(alpha: 0.15),
              soft.withValues(alpha: 0.02),
            ],
          ),
          border:
              Border.all(color: accent.withValues(alpha: 0.15), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.label,
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: context.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isDone
                        ? '$liveCount Qs · ${progress?.bestScore}/${progress?.totalQ}'
                        : '$liveCount Qs · Ready',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: context.mutedColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isDone ? 'Done' : 'Start',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
