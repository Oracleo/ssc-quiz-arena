import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme.dart';
import '../widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppViewport(
      builder: (context, viewport) {
        final gap = SizedBox(height: viewport.isCompact ? 10 : 16);

        return Column(
          children: [
            ScreenToolbar(
              title: 'About',
              subtitle: 'SSC Quiz Arena',
              onBack: () => context.pop(),
            ),
            gap,

            Expanded(
              child: AppGlassPanel(
                radius: viewport.panelRadius,
                padding: EdgeInsets.all(viewport.isCompact ? 14 : 22),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // App icon
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF6B6B),
                              Color(0xFFFFD93D),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B6B)
                                  .withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.bolt_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        'SSC Quiz Arena',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version 1.0.0',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: context.mutedColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your essential companion for SSC exam preparation.\n10 subjects · 1000+ questions · Track your progress.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: context.mutedColor),
                      ),

                      gap,
                      Divider(color: context.borderColor),
                      gap,

                      // Developed by
                      Text(
                        'DEVELOPED BY',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              letterSpacing: 1.5,
                              color: context.mutedColor,
                            ),
                      ),
                      const SizedBox(height: 12),

                      // Devnetra Consultancy card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.goldBgColor,
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: context.goldBorderColor),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    context.goldColor,
                                    context.goldColor
                                        .withValues(alpha: 0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.business_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Devnetra Consultancy',
                              style: TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: context.goldColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(Icons.email_outlined,
                                    size: 14,
                                    color: context.mutedColor),
                                const SizedBox(width: 6),
                                Text(
                                  'devnetra@zohomail.in',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.mutedColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      gap,
                      Divider(color: context.borderColor),
                      gap,

                      // Legal
                      Text(
                        'LEGAL',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              letterSpacing: 1.5,
                              color: context.mutedColor,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _LegalTile(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy Policy',
                        subtitle:
                            'We take your privacy seriously.',
                        onTap: () => _showPrivacy(context),
                      ),
                      const SizedBox(height: 8),
                      _LegalTile(
                        icon: Icons.description_outlined,
                        label: 'Terms of Use',
                        subtitle:
                            'Educational purpose only.',
                        onTap: () {},
                      ),

                      gap,

                      Text(
                        '© ${DateTime.now().year} Devnetra Consultancy. All rights reserved.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color:
                                  context.mutedColor.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: context.cardColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Text(
                    'SSC Quiz Arena respects your privacy.\n\n'
                    '• We use Firebase Authentication for Google Sign-In.\n'
                    '• Your quiz progress is stored in Cloud Firestore.\n'
                    '• We do not sell or share your personal data.\n'
                    '• Analytics are used only to improve the app experience.\n'
                    '• You can delete your account data at any time by contacting us.\n\n'
                    'Contact: devnetra@zohomail.in',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: context.mutedColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  const _LegalTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.inputBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: context.mutedColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: context.mutedColor),
                  ),
                ],
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
