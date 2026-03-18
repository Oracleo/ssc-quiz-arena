import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme.dart';
import '../providers/app_provider.dart';
import '../services/firebase_service.dart';

typedef AppViewportBuilder = Widget Function(
    BuildContext context, AppViewportInfo viewport);

const double kAppPageMaxWidth = 720.0;

class AppViewportInfo {
  const AppViewportInfo({
    required this.width,
    required this.height,
    required this.topZoneHeight,
    required this.bottomGapHeight,
    required this.contentWidth,
    required this.horizontalPadding,
  });

  final double width;
  final double height;
  final double topZoneHeight;
  final double bottomGapHeight;
  final double contentWidth;
  final double horizontalPadding;

  bool get isCompact => width < 700;
  bool get isMedium => width >= 700 && width < 1100;
  bool get isWide => width >= 1100;
  double get sectionGap => isCompact ? 8 : 12;
  double get panelRadius => isCompact ? 18 : 24;

  int columns({
    required int compact,
    required int medium,
    required int wide,
  }) {
    if (isWide) return wide;
    if (isMedium) return medium;
    return compact;
  }
}

class AppViewport extends StatelessWidget {
  const AppViewport({super.key, required this.builder});

  final AppViewportBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.bgColor, context.bg2Color, context.bgColor],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -60,
              child: _GlowOrb(color: context.glowColor.withValues(alpha: 0.18)),
            ),
            Positioned(
              top: 120,
              right: -110,
              child: _GlowOrb(
                color: context.goldColor.withValues(alpha: 0.12),
                size: 260,
              ),
            ),
            Positioned(
              bottom: -170,
              left: 40,
              child: _GlowOrb(
                color: context.glowColor.withValues(alpha: 0.1),
                size: 320,
              ),
            ),
            SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding =
                      constraints.maxWidth < 720 ? 16.0 : 24.0;
                  final contentWidth = math.min(
                    constraints.maxWidth - (horizontalPadding * 2),
                    kAppPageMaxWidth,
                  );
                  final topZoneHeight = constraints.maxHeight * 0.80;
                  final viewport = AppViewportInfo(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    topZoneHeight: topZoneHeight,
                    bottomGapHeight: constraints.maxHeight - topZoneHeight,
                    contentWidth: contentWidth,
                    horizontalPadding: horizontalPadding,
                  );

                  return Column(
                    children: [
                      SizedBox(
                        height: viewport.topZoneHeight,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: viewport.horizontalPadding,
                              vertical: viewport.isCompact ? 12 : 18,
                            ),
                            child: SizedBox(
                              width: viewport.contentWidth,
                              child: builder(context, viewport),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: viewport.bottomGapHeight),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppGlassPanel extends StatelessWidget {
  const AppGlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 28,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.cardColor.withValues(alpha: 0.98),
            context.card2Color.withValues(alpha: 0.94),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.18 : 0.08),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class ScreenToolbar extends StatelessWidget {
  const ScreenToolbar({
    super.key,
    required this.title,
    this.subtitle,
    this.accentColor,
    this.badge,
    this.onBack,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final Color? accentColor;
  final Widget? badge;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 760;
    final titleColor = accentColor ?? context.textColor;

    return AppGlassPanel(
      radius: 18,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 10 : 12,
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (onBack != null) ...[
                      AppActionIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: onBack,
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Spacer(),
                    ..._spacedRowChildren(actions),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badge != null) ...[
                      badge!,
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: titleColor,
                                ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: context.mutedColor,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                if (onBack != null) ...[
                  AppActionIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: onBack,
                  ),
                  const SizedBox(width: 10),
                ],
                if (badge != null) ...[
                  badge!,
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: titleColor,
                                ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          subtitle!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: context.mutedColor,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (actions.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  ..._spacedRowChildren(actions),
                ],
              ],
            ),
    );
  }
}

class AppActionIconButton extends StatelessWidget {
  const AppActionIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.inputBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.borderColor),
        ),
        child: Icon(icon, size: 16, color: color ?? context.textColor),
      ),
    );
  }
}

class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(onPressed: onTap, child: Text(label)),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  const GhostButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(onPressed: onTap, child: Text(label)),
    );
  }
}

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: context.goldColor,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 14),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.mutedColor,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class LeaderboardModal extends StatefulWidget {
  const LeaderboardModal({super.key});

  @override
  State<LeaderboardModal> createState() => _LeaderboardModalState();
}

class _LeaderboardModalState extends State<LeaderboardModal> {
  List<LeaderboardEntry>? _entries;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final app = context.read<AppProvider>();
    final entries = await FirebaseService.instance.getCommunityLeaderboard(
      userXp: app.xp,
      userStreak: app.streak,
      userTopics: app.progress.length,
      userName: app.user?.name ?? 'You',
      userPhoto: app.user?.photoUrl,
    );
    if (mounted) {
      setState(() {
        _entries = entries;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: AppGlassPanel(
          radius: 30,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.82,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 46,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.borderColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(Icons.emoji_events_rounded,
                        color: context.goldColor, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Community Leaderboard',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Top 100 quiz champions ranked by XP.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.mutedColor,
                      ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.goldBgColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: context.goldBorderColor),
                  ),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _InlineMetric(
                        label: 'YOUR XP',
                        value: '${app.xp}',
                        color: context.goldColor,
                      ),
                      _InlineMetric(
                        label: 'Streak',
                        value: '${app.streak} days',
                        color: const Color(0xFFFF8A65),
                      ),
                      _InlineMetric(
                        label: 'Topics',
                        value: '${app.progress.length} done',
                        color: context.textColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: LoadingSpinner(message: 'Loading leaderboard...'),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _entries?.length ?? 0,
                      itemBuilder: (context, index) {
                        final entry = _entries![index];
                        final rankColor = index == 0
                            ? context.goldColor
                            : index == 1
                                ? const Color(0xFF8AA0B8)
                                : index == 2
                                    ? const Color(0xFFDE8A5A)
                                    : context.textColor;
                        final isUser = entry.isCurrentUser;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? context.goldColor.withValues(alpha: 0.12)
                                  : rankColor == context.textColor
                                      ? context.inputBgColor
                                      : rankColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isUser
                                    ? context.goldColor.withValues(alpha: 0.35)
                                    : rankColor == context.textColor
                                        ? context.borderColor
                                        : rankColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Rank badge
                                SizedBox(
                                  width: 34,
                                  child: index < 3
                                      ? Icon(
                                          Icons.emoji_events_rounded,
                                          size: 22,
                                          color: rankColor,
                                        )
                                      : Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                    color: context.mutedColor),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 10),
                                // Avatar
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: rankColor.withValues(alpha: 0.14),
                                    image: entry.photoUrl != null
                                        ? DecorationImage(
                                            image:
                                                NetworkImage(entry.photoUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: entry.photoUrl == null
                                      ? Center(
                                          child: Text(
                                            entry.name.isNotEmpty
                                                ? entry.name[0].toUpperCase()
                                                : '?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(color: rankColor),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                // Name + stats
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              isUser
                                                  ? '${entry.name} (You)'
                                                  : entry.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: isUser
                                                        ? FontWeight.w800
                                                        : FontWeight.w600,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isUser) ...[
                                            const SizedBox(width: 6),
                                            Icon(Icons.star_rounded,
                                                size: 14,
                                                color: context.goldColor),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${entry.topicsCompleted} topics · ${entry.streak}d streak',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: context.mutedColor),
                                      ),
                                    ],
                                  ),
                                ),
                                // XP
                                Text(
                                  '${entry.xp}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: isUser
                                            ? context.goldColor
                                            : rankColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'XP',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: context.mutedColor),
                                ),
                              ],
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
      ),
    );
  }
}

class ProfilePanel extends StatelessWidget {
  const ProfilePanel({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: AppGlassPanel(
          radius: 30,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.78,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.borderColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: context.goldBgColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: context.goldBorderColor),
                        ),
                        child: Center(
                          child: app.user?.photoUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    app.user!.photoUrl!,
                                    width: 68,
                                    height: 68,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  (app.user?.name.characters.first ?? 'G')
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: context.goldColor),
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    app.user?.name ?? 'Guest Learner',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ),
                                if (app.isLoggedIn)
                                  SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: IconButton(
                                      onPressed: () => _showEditNameDialog(context, app),
                                      padding: EdgeInsets.zero,
                                      iconSize: 16,
                                      icon: Icon(
                                        Icons.edit_rounded,
                                        color: context.mutedColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              app.user?.email ?? 'Offline progress mode',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: context.mutedColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _NavMetricPill(
                        icon: Icons.bolt_rounded,
                        label: '${app.xp} XP',
                        color: context.goldColor,
                        background: context.goldBgColor,
                        border: context.goldBorderColor,
                      ),
                      _NavMetricPill(
                        icon: Icons.local_fire_department_rounded,
                        label: '${app.streak} day streak',
                        color: const Color(0xFFFF8A65),
                        background: const Color(0x19FF8A65),
                        border: const Color(0x33FF8A65),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _PanelAction(
                    icon: app.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    label: app.isDarkMode
                        ? 'Switch to light mode'
                        : 'Switch to dark mode',
                    onTap: () {
                      app.toggleTheme();
                    },
                  ),
                  const SizedBox(height: 10),
                  _PanelAction(
                    icon: Icons.support_agent_rounded,
                    label: 'Contact Support',
                    onTap: () => _showSupportDialog(context),
                  ),
                  const SizedBox(height: 10),
                  _PanelAction(
                    icon: Icons.share_rounded,
                    label: 'Share this app',
                    onTap: () => _shareApp(context),
                  ),
                  const SizedBox(height: 10),
                  if (app.isLoggedIn)
                    _PanelAction(
                      icon: Icons.logout_rounded,
                      label: 'Sign out',
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text(
                                'Are you sure you want to sign out?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await app.signOut();
                          onClose();
                        }
                      },
                      isDestructive: true,
                    )
                  else
                    _PanelAction(
                      icon: Icons.login_rounded,
                      label: 'Sign in with Google',
                      onTap: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Sign In'),
                            content: const Text(
                                'Sign in with your Google account to sync progress across devices.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Sign In'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed != true) return;
                        final messenger = ScaffoldMessenger.of(context);
                        onClose();
                        final success = await app.signInWithGoogle();
                        if (!success && context.mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Google Sign-In is not configured yet.'),
                            ),
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, AppProvider app) {
    final controller = TextEditingController(text: app.user?.name ?? '');
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Display Name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 30,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(dialogContext);
              final success = await app.updateDisplayName(name);
              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update name.')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.mail_outline_rounded,
                size: 20, color: Theme.of(dialogContext).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Contact Support'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'John Doe',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subjectCtrl,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Bug report / Suggestion / Other',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Describe your issue or suggestion...',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final subject = subjectCtrl.text.trim();
              final message = messageCtrl.text.trim();
              if (message.isEmpty) return;

              final body = 'Name: $name\n\n$message';
              final mailUri = Uri(
                scheme: 'mailto',
                path: 'devnetra@zohomail.in',
                queryParameters: {
                  'subject': subject.isEmpty
                      ? 'SSC Quiz Arena Support'
                      : 'SSC Arena: $subject',
                  'body': body,
                },
              );

              Navigator.pop(dialogContext);
              if (await canLaunchUrl(mailUri)) {
                await launchUrl(mailUri);
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Could not open email app. Please email us at devnetra@zohomail.in'),
                  ),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _shareApp(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(
        text:
            'Check out SSC Quiz Arena — free SSC exam practice with 10 subjects!\nhttps://ssc-quiz-arena-web.vercel.app',
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, this.size = 280});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _NavMetricPill extends StatelessWidget {
  const _NavMetricPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
    required this.border,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style:
                Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.mutedColor,
                letterSpacing: 1,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _PanelAction extends StatelessWidget {
  const _PanelAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? context.redColor : context.textColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: context.inputBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: color),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: context.mutedColor),
          ],
        ),
      ),
    );
  }
}

List<Widget> _spacedRowChildren(List<Widget> widgets) {
  final output = <Widget>[];
  for (var index = 0; index < widgets.length; index++) {
    output.add(widgets[index]);
    if (index != widgets.length - 1) {
      output.add(const SizedBox(width: 8));
    }
  }
  return output;
}
