import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/subjects_data.dart';
import '../widgets/widgets.dart';

class PartsScreen extends StatelessWidget {
  const PartsScreen({
    super.key,
    required this.subjectId,
  });

  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final subject = subjectsData[subjectId];
    final meta = getSubjectMeta(subjectId);
    final accent = Color(meta.colorValue);
    final soft = Color(meta.bgColorValue);

    if (subject == null) {
      return const Scaffold(
        body: SafeArea(child: Center(child: Text('Subject not found'))),
      );
    }

    final totalQuestions = subject.parts.fold<int>(
      0,
      (sum, part) =>
          sum +
          part.topics.fold<int>(0, (partSum, topic) => partSum + topic.qCount),
    );
    final totalTopics =
        subject.parts.fold<int>(0, (sum, part) => sum + part.topics.length);

    return AppViewport(
      builder: (context, viewport) {
        final gap = SizedBox(height: viewport.isCompact ? 8 : 12);

        return Column(
          children: [
            // Toolbar
            ScreenToolbar(
              title: subject.label,
              subtitle: '${subject.parts.length} parts',
              accentColor: accent,
              onBack: () => context.pop(),
              badge: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: soft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(Icons.layers_rounded, color: accent, size: 18),
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
                    // Stats row
                    Row(
                      children: [
                        _InfoChip(
                          label: 'Tracks',
                          value: '${subject.parts.length}',
                          color: accent,
                        ),
                        const SizedBox(width: 8),
                        _InfoChip(
                          label: 'Topics',
                          value: '$totalTopics',
                          color: const Color(0xFF5B8DEF),
                        ),
                        const SizedBox(width: 8),
                        _InfoChip(
                          label: 'Questions',
                          value: '$totalQuestions',
                          color: const Color(0xFFF5A623),
                        ),
                      ],
                    ),
                    gap,

                    // Section label
                    Row(
                      children: [
                        Text(
                          'CHOOSE A TRACK',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
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

                    // Parts — flex wrap, compact
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final spacing = viewport.isCompact ? 6.0 : 8.0;
                          // Min 200px per tile so titles are visible
                          final cols = (constraints.maxWidth / 200).floor().clamp(1, 3);
                          final tileW = (constraints.maxWidth - spacing * (cols - 1)) / cols;

                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: subject.parts.map((part) {
                                final qTotal = part.topics.fold<int>(
                                  0,
                                  (sum, topic) => sum + topic.qCount,
                                );
                                return SizedBox(
                                  width: tileW,
                                  child: _PartTile(
                                    label: part.label,
                                    topicsCount: part.topics.length,
                                    questionTotal: qTotal,
                                    accent: accent,
                                    soft: soft,
                                    onTap: () => context.push(
                                        '/subject/$subjectId/${part.id}'),
                                  ),
                                );
                              }).toList(),
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
// Info chip (stats)
// ════════════════════════════════════════════════════════════════

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// Part tile
// ════════════════════════════════════════════════════════════════

class _PartTile extends StatelessWidget {
  const _PartTile({
    required this.label,
    required this.topicsCount,
    required this.questionTotal,
    required this.accent,
    required this.soft,
    required this.onTap,
  });

  final String label;
  final int topicsCount;
  final int questionTotal;
  final Color accent;
  final Color soft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              soft.withValues(alpha: 0.2),
              soft.withValues(alpha: 0.05),
            ],
          ),
          border:
              Border.all(color: accent.withValues(alpha: 0.2), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(Icons.layers_rounded, color: accent, size: 14),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: context.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$topicsCount topics · $questionTotal Qs',
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
            Icon(
              Icons.arrow_forward_rounded,
              color: accent.withValues(alpha: 0.3),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
