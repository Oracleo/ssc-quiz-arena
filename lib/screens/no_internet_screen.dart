import 'package:flutter/material.dart';
import '../core/theme.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.dBg : AppColors.lBg;
    final bg2 = isDark ? AppColors.dBg2 : AppColors.lBg2;
    final text = isDark ? AppColors.dText : AppColors.lText;
    final muted = isDark ? AppColors.dMuted : AppColors.lMuted;
    final gold = isDark ? AppColors.dGold : AppColors.lGold;
    final goldBg = isDark ? AppColors.dGoldBg : AppColors.lGoldBg;
    final goldBorder = isDark ? AppColors.dGoldBorder : AppColors.lGoldBorder;
    final card = isDark ? AppColors.dCard : AppColors.lCard;
    final border = isDark ? AppColors.dBorder : AppColors.lBorder;
    final red = isDark ? AppColors.dRed : AppColors.lRed;
    final glow = isDark ? AppColors.dGlow : AppColors.lGlow;

    return Scaffold(
      backgroundColor: bg,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bg, bg2, bg],
          ),
        ),
        child: Stack(
          children: [
            // Glow orbs
            Positioned(
              top: -120,
              left: -60,
              child: _GlowOrb(color: glow.withValues(alpha: 0.18)),
            ),
            Positioned(
              top: 120,
              right: -110,
              child: _GlowOrb(
                color: red.withValues(alpha: 0.1),
                size: 260,
              ),
            ),
            Positioned(
              bottom: -170,
              left: 40,
              child: _GlowOrb(
                color: glow.withValues(alpha: 0.1),
                size: 320,
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated WiFi-off icon
                      ScaleTransition(
                        scale: _pulse,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                red.withValues(alpha: 0.15),
                                red.withValues(alpha: 0.04),
                              ],
                            ),
                            border: Border.all(
                              color: red.withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: 52,
                            color: red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Title
                      Text(
                        'No Internet Connection',
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: text,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        'SSC Quiz Arena needs an active internet connection to fetch questions and sync your progress. Please check your Wi-Fi or mobile data.',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: muted,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),
                      // Info cards
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: card.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: border),
                        ),
                        child: Column(
                          children: [
                            _CheckItem(
                              icon: Icons.wifi_rounded,
                              text: 'Check Wi-Fi connection',
                              color: gold,
                              muted: muted,
                            ),
                            const SizedBox(height: 14),
                            _CheckItem(
                              icon: Icons.cell_tower_rounded,
                              text: 'Check mobile data',
                              color: gold,
                              muted: muted,
                            ),
                            const SizedBox(height: 14),
                            _CheckItem(
                              icon: Icons.flight_rounded,
                              text: 'Turn off airplane mode',
                              color: gold,
                              muted: muted,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Retry button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: widget.onRetry,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Try Again'),
                          style: FilledButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor:
                                isDark ? const Color(0xFF0A1628) : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtle info
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: goldBg,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: goldBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 16, color: gold),
                            const SizedBox(width: 8),
                            Text(
                              'All features require internet',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem({
    required this.icon,
    required this.text,
    required this.color,
    required this.muted,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 14),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: muted,
          ),
        ),
      ],
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
