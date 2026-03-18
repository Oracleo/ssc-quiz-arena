import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const dBg = Color(0xFF07111D);
  static const dBg2 = Color(0xFF0D1B2D);
  static const dCard = Color(0xFF102238);
  static const dCard2 = Color(0xFF16304D);
  static const dBorder = Color(0x1FFFFFFF);
  static const dText = Color(0xFFF7F5EF);
  static const dMuted = Color(0xFF9EADC4);
  static const dGold = Color(0xFFFFB74D);
  static const dGoldBg = Color(0x22FFB74D);
  static const dGoldBorder = Color(0x55FFB74D);
  static const dGreen = Color(0xFF2DD4BF);
  static const dRed = Color(0xFFFF7A7A);
  static const dNavBg = Color(0xB30A1727);
  static const dInputBg = Color(0x8012243A);
  static const dGlow = Color(0xFF24508A);

  static const lBg = Color(0xFFF6F3EC);
  static const lBg2 = Color(0xFFE8EEF7);
  static const lCard = Color(0xFFFFFBF3);
  static const lCard2 = Color(0xFFFFFFFF);
  static const lBorder = Color(0x150C1A2B);
  static const lText = Color(0xFF132235);
  static const lMuted = Color(0xFF64748B);
  static const lGold = Color(0xFFC77B16);
  static const lGoldBg = Color(0x16C77B16);
  static const lGoldBorder = Color(0x33C77B16);
  static const lGreen = Color(0xFF0F9F8A);
  static const lRed = Color(0xFFD94F5C);
  static const lNavBg = Color(0xD9FFF9EF);
  static const lInputBg = Color(0xFFF0F2F8);
  static const lGlow = Color(0xFFC8D8F4);
}

extension AppThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get bgColor => isDark ? AppColors.dBg : AppColors.lBg;
  Color get bg2Color => isDark ? AppColors.dBg2 : AppColors.lBg2;
  Color get cardColor => isDark ? AppColors.dCard : AppColors.lCard;
  Color get card2Color => isDark ? AppColors.dCard2 : AppColors.lCard2;
  Color get borderColor => isDark ? AppColors.dBorder : AppColors.lBorder;
  Color get textColor => isDark ? AppColors.dText : AppColors.lText;
  Color get mutedColor => isDark ? AppColors.dMuted : AppColors.lMuted;
  Color get goldColor => isDark ? AppColors.dGold : AppColors.lGold;
  Color get goldBgColor => isDark ? AppColors.dGoldBg : AppColors.lGoldBg;
  Color get goldBorderColor =>
      isDark ? AppColors.dGoldBorder : AppColors.lGoldBorder;
  Color get greenColor => isDark ? AppColors.dGreen : AppColors.lGreen;
  Color get redColor => isDark ? AppColors.dRed : AppColors.lRed;
  Color get navBgColor => isDark ? AppColors.dNavBg : AppColors.lNavBg;
  Color get inputBgColor => isDark ? AppColors.dInputBg : AppColors.lInputBg;
  Color get glowColor => isDark ? AppColors.dGlow : AppColors.lGlow;
}

class AppTheme {
  AppTheme._();

  static ThemeData dark() => _build(Brightness.dark);
  static ThemeData light() => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final text = isDark ? AppColors.dText : AppColors.lText;
    final muted = isDark ? AppColors.dMuted : AppColors.lMuted;
    final bg = isDark ? AppColors.dBg : AppColors.lBg;
    final card = isDark ? AppColors.dCard : AppColors.lCard;
    final border = isDark ? AppColors.dBorder : AppColors.lBorder;
    final gold = isDark ? AppColors.dGold : AppColors.lGold;
    final red = isDark ? AppColors.dRed : AppColors.lRed;

    final displayStyle = TextStyle(
      fontFamily: 'Fraunces',
      color: text,
      fontWeight: FontWeight.w600,
      height: 1.1,
      letterSpacing: -0.3,
    );
    final bodyStyle = TextStyle(
      fontFamily: 'Manrope',
      color: text,
      height: 1.3,
    );

    final textTheme = TextTheme(
      displayLarge: displayStyle.copyWith(fontSize: 30),
      displayMedium: displayStyle.copyWith(fontSize: 24),
      displaySmall: displayStyle.copyWith(fontSize: 18),
      headlineMedium:
          bodyStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
      headlineSmall:
          bodyStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
      titleLarge: bodyStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
      titleMedium:
          bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
      titleSmall: bodyStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      bodyLarge: bodyStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
      bodyMedium: bodyStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
      bodySmall: bodyStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: muted,
      ),
      labelLarge: bodyStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w800),
      labelMedium: bodyStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: muted,
      ),
      labelSmall: bodyStyle.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: muted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: gold,
        onPrimary: Colors.black,
        secondary: gold,
        onSecondary: Colors.black,
        error: red,
        onError: Colors.white,
        surface: card,
        onSurface: text,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: card,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        behavior: SnackBarBehavior.floating,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dividerColor: border,
      iconTheme: IconThemeData(color: text, size: 20),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: text),
        titleTextStyle: textTheme.titleLarge,
      ),
      splashFactory: InkSparkle.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
