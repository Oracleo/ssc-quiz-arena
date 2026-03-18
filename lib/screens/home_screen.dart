import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/subjects_data.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../services/firebase_service.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _announcementConfig;
  bool _announcementDismissed = false;

  @override
  void initState() {
    super.initState();
    _loadAnnouncement();
  }

  Future<void> _loadAnnouncement() async {
    // Try JS config first (web), then Firestore
    final config =
        await FirebaseService.instance.getAnnouncementConfig();
    if (mounted && config != null && config['enabled'] == true) {
      setState(() => _announcementConfig = config);
    }
  }

  void _showProfile() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => ProfilePanel(
        onClose: () => Navigator.pop(sheetContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppViewport(
      builder: (context, viewport) {
        final app = context.watch<AppProvider>();
        final totalQuestions = getTotalQuestions();
        final totalTopics = getAllTopicIds().length;
        final completedTopics = app.progress.length;
        final donePercent = totalTopics == 0
            ? 0
            : ((completedTopics / totalTopics) * 100).round();
        final gap = SizedBox(height: viewport.isCompact ? 8 : 12);

        return Column(
          children: [
            // ═══ TOP BAR ═══
            _TopBar(
              app: app,
              viewport: viewport,
              onProfile: _showProfile,
              onAbout: () => context.push('/about'),
            ),

            // ═══ ANNOUNCEMENT (under top bar) ═══
            if (_announcementConfig != null && !_announcementDismissed) ...[
              SizedBox(height: viewport.isCompact ? 6 : 8),
              _AnnouncementBanner(
                config: _announcementConfig!,
                onDismiss: () =>
                    setState(() => _announcementDismissed = true),
              ),
            ],
            gap,

            // ═══ MAIN CONTENT PANEL ═══
            Expanded(
              child: AppGlassPanel(
                radius: viewport.panelRadius,
                padding: EdgeInsets.all(viewport.isCompact ? 14 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Text(
                      'Welcome back,',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${app.user?.name ?? 'Aspirant'}! 🎯',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: viewport.isCompact ? 16 : 20,
                          ),
                    ),
                    gap,

                    // Stats row
                    Row(
                      children: [
                        const _MiniStat(
                          value: '10',
                          label: 'SUBJECTS',
                          color: Color(0xFFE05252),
                        ),
                        const SizedBox(width: 8),
                        _MiniStat(
                          value: '$totalQuestions',
                          label: 'QUESTIONS',
                          color: const Color(0xFF5B8DEF),
                        ),
                        const SizedBox(width: 8),
                        _MiniStat(
                          value: '$donePercent%',
                          label: 'DONE',
                          color: const Color(0xFF34C77B),
                        ),
                      ],
                    ),
                    gap,

                    // Progress bar
                    Row(
                      children: [
                        Text(
                          'Overall Progress',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const Spacer(),
                        Text(
                          '$completedTopics / $totalTopics topics',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: context.goldColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: totalTopics == 0
                            ? 0
                            : completedTopics / totalTopics,
                        minHeight: 5,
                        backgroundColor: context.inputBgColor,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(context.goldColor),
                      ),
                    ),
                    gap,

                    // SUBJECTS label
                    Row(
                      children: [
                        Text(
                          'SUBJECTS',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    letterSpacing: 1.5,
                                    color: context.mutedColor,
                                  ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Divider(
                            color: context.borderColor,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: viewport.isCompact ? 8 : 12),

                    // Subject grid — responsive, compact
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const cols = 5;
                          const rows = 2;
                          final hSpacing = constraints.maxWidth * 0.015;
                          final vSpacing = constraints.maxHeight * 0.02;
                          final availW =
                              constraints.maxWidth - (hSpacing * (cols - 1));
                          final availH =
                              constraints.maxHeight - (vSpacing * (rows - 1));
                          final tileW = availW / cols;
                          final rawTileH = availH / rows;
                          // On wide screens (desktop browser) use full height;
                          // on narrow screens (mobile/Chrome) cap to near-square
                          final isNarrow = constraints.maxWidth < 600;
                          final tileH = isNarrow
                              ? math.min(rawTileH, tileW * 1.15)
                              : rawTileH;

                          return Wrap(
                            spacing: hSpacing,
                            runSpacing: vSpacing,
                            children: List.generate(kSubjectMetas.length,
                                (index) {
                              final meta = kSubjectMetas[index];
                              final subject = subjectsData[meta.id];
                              final topicIds = subject?.parts
                                      .expand((part) => part.topics)
                                      .map((topic) => topic.id)
                                      .toList() ??
                                  [];
                              final doneCount = topicIds
                                  .where(
                                      (id) => app.progress.containsKey(id))
                                  .length;
                              final fraction = topicIds.isEmpty
                                  ? 0.0
                                  : doneCount / topicIds.length;

                              return SizedBox(
                                width: tileW,
                                height: tileH,
                                child: _SubjectTile(
                                  meta: meta,
                                  fraction: fraction,
                                  onTap: () =>
                                      context.push('/subject/${meta.id}'),
                                ),
                              );
                            }),
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
// TOP BAR
// ════════════════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.app,
    required this.viewport,
    required this.onProfile,
    required this.onAbout,
  });

  final AppProvider app;
  final AppViewportInfo viewport;
  final VoidCallback onProfile;
  final VoidCallback onAbout;

  @override
  Widget build(BuildContext context) {
    return AppGlassPanel(
      radius: 16,
      padding: EdgeInsets.symmetric(
        horizontal: viewport.isCompact ? 10 : 14,
        vertical: viewport.isCompact ? 8 : 10,
      ),
      child: Row(
        children: [
          // App logo image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/branding/ssc_quiz_arena_mark.png',
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'SSC Arena',
            style: TextStyle(
              fontFamily: 'Fraunces',
              fontSize: viewport.isCompact ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const Spacer(),

          // XP pill
          _PillBadge(
            icon: Icons.bolt_rounded,
            label: '${app.xp}',
            color: context.goldColor,
            bg: context.goldBgColor,
            border: context.goldBorderColor,
          ),
          const SizedBox(width: 6),

          // Streak pill
          _PillBadge(
            icon: Icons.local_fire_department_rounded,
            label: '${app.streak}',
            color: const Color(0xFFFF8A65),
            bg: const Color(0x19FF8A65),
            border: const Color(0x33FF8A65),
          ),
          const SizedBox(width: 6),

          // About — explicit size so it doesn't get hidden
          SizedBox(
            width: 28,
            height: 28,
            child: IconButton(
              onPressed: onAbout,
              padding: EdgeInsets.zero,
              iconSize: 17,
              icon: Icon(
                Icons.info_outline_rounded,
                color: context.mutedColor,
              ),
            ),
          ),

          // Profile avatar
          GestureDetector(
            onTap: onProfile,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.inputBgColor,
                border: Border.all(color: context.borderColor),
                image: app.user?.photoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(app.user!.photoUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: app.user?.photoUrl == null
                  ? Center(
                      child: Text(
                        (app.user?.name.characters.first ?? 'G').toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: context.mutedColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.border,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// MINI STAT CARD
// ════════════════════════════════════════════════════════════════

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
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
              label,
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
// ANNOUNCEMENT BANNER
// ════════════════════════════════════════════════════════════════

class _AnnouncementBanner extends StatelessWidget {
  const _AnnouncementBanner({
    required this.config,
    required this.onDismiss,
  });

  final Map<String, dynamic> config;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final type = config['type'] as String? ?? 'info';
    final icon = config['icon'] as String? ?? '📢';
    final title = config['title'] as String? ?? '';
    final subtitle = config['subtitle'] as String? ?? '';
    final badge = config['badge'] as String? ?? 'NEW';

    // Theme colors per announcement type
    final Color accent;
    final Color bgStart;
    final Color bgEnd;
    switch (type) {
      case 'promo':
        accent = const Color(0xFFAB47BC);
        bgStart = const Color(0xFFE8D5F5).withValues(alpha: 0.3);
        bgEnd = const Color(0xFFF3E5F5).withValues(alpha: 0.15);
      case 'success':
        accent = const Color(0xFF4CAF50);
        bgStart = const Color(0xFFD5F5E0).withValues(alpha: 0.3);
        bgEnd = const Color(0xFFE8F5E9).withValues(alpha: 0.15);
      case 'warning':
        accent = const Color(0xFFFFA726);
        bgStart = const Color(0xFFFFF3E0).withValues(alpha: 0.3);
        bgEnd = const Color(0xFFFFF8E1).withValues(alpha: 0.15);
      default: // info
        accent = const Color(0xFF42A5F5);
        bgStart = const Color(0xFFD5E8F5).withValues(alpha: 0.3);
        bgEnd = const Color(0xFFE3F2FD).withValues(alpha: 0.15);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [bgStart, bgEnd]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Badge + dismiss
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: accent.withValues(alpha: 0.4)),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: accent,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close_rounded,
                    size: 14, color: context.mutedColor.withValues(alpha: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: context.mutedColor,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// SUBJECT TILE (compact square)
// ════════════════════════════════════════════════════════════════

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({
    required this.meta,
    required this.fraction,
    required this.onTap,
  });

  final SubjectMeta meta;
  final double fraction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(meta.colorValue);
    final soft = Color(meta.bgColorValue);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        // Use the smaller dimension so icon + text always fits
        final base = w < h ? w : h;
        final iconSize = (base * 0.26).clamp(12.0, 24.0);
        final fontSize = (base * 0.13).clamp(7.0, 11.0);
        final iconBoxSize = iconSize + (base * 0.10).clamp(3.0, 10.0);
        final iconRadius = (base * 0.08).clamp(4.0, 8.0);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all((base * 0.06).clamp(2.0, 8.0)),
            decoration: BoxDecoration(
              color: soft.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular((base * 0.1).clamp(6.0, 14.0)),
              border: Border.all(color: accent.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: iconBoxSize,
                  height: iconBoxSize,
                  decoration: BoxDecoration(
                    color: soft,
                    borderRadius: BorderRadius.circular(iconRadius),
                  ),
                  child: Icon(_subjectIcon(meta.id), color: accent, size: iconSize),
                ),
                SizedBox(height: (base * 0.04).clamp(1.0, 4.0)),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: (base * 0.04).clamp(1.0, 4.0)),
                    child: Text(
                      meta.label,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: fontSize,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (fraction > 0) ...[  
                  SizedBox(height: (base * 0.04).clamp(1.0, 4.0)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: (base * 0.08).clamp(2.0, 8.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: fraction,
                        minHeight: 2,
                        backgroundColor: context.inputBgColor,
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static IconData _subjectIcon(String id) {
    switch (id) {
      case 'history':
        return Icons.account_balance_rounded;
      case 'geography':
        return Icons.public_rounded;
      case 'polity':
        return Icons.gavel_rounded;
      case 'economy':
        return Icons.trending_up_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'maths':
        return Icons.functions_rounded;
      case 'english':
        return Icons.text_fields_rounded;
      case 'reasoning':
        return Icons.extension_rounded;
      case 'computer':
        return Icons.computer_rounded;
      case 'current':
        return Icons.newspaper_rounded;
      default:
        return Icons.bookmark_rounded;
    }
  }
}
