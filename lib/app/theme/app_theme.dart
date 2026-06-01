import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF43B94E);
  static const darkGreen = Color(0xFF0B7A33);

  static const background = Color(0xFFF7FFF7);
  static const card = Colors.white;

  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);

  static const border = Color(0xFFE5E7EB);

  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);

  // Splash screen (Figma frame 2:2)
  static const splashBackground = Color(0xFFFFFFFF);
  static const splashTitle = Color(0xFF1B1C1C);
  static const splashTagline = Color(0xFF6F7A6B);
  static const splashLogoSurface = Color(0xFFF5F3F3);
  static const splashGlow = Color(0xFF4CAF50);
  static const splashTrack = Color(0xFFE3E2E2);
  static const splashGradientStart = Color(0xFFBDEFBE);
  static const splashGradientEnd = Color(0xFF006E1C);
  static const splashStatus = Color(0xFF006E1C);

  // Login screen (Figma frame 2:20)
  static const loginBackground = Color(0xFFFBF9F9);
  static const loginLabel = Color(0xFF3F4A3C);
  static const loginInputFill = Color(0xFFFBF9F9);
  static const loginInputBorder = Color(0xFFBECAB9);
  static const loginHint = Color(0xFF6F7A6B);
  static const loginLink = Color(0xFF006E1C);
  static const loginButton = Color(0xFF4CAF50);
  static const loginIllustrationBg = Color(0xFFE3E2E2);

  // Register screen (Figma frame 2:72)
  static const registerHintMuted = Color(0xB3BECAB9);

  // Home box list (Figma frame 2:140)
  static const boxCardBorder = Color(0xFFDBDAD9);
  static const statusOnlineBackground = Color(0xFFBDEFBE);
  static const statusOnlineText = Color(0xFF426E47);
  static const metricIconBackground = Color(0xFFEFEDED);
  static const navActiveBackground = Color(0xFFBDEFBE);
  static const navActiveText = Color(0xFF426E47);
  static const avatarBorder = Color(0xFFEFEDED);

  // Box overview (Figma frame 2:244)
  static const optimalBadgeText = Color(0xFF003C0B);
  static const chartHumidityLine = Color(0xFFA2D3A4);
}

class AppTextStyles {
  AppTextStyles._();

  static TextStyle splashTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: AppColors.splashTitle,
        ) ??
        const TextStyle(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: AppColors.splashTitle,
        );
  }

  static const splashTagline = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.splashTagline,
  );

  static const splashStatus = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.splashStatus,
  );

  static TextStyle loginTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.64,
          color: AppColors.splashTitle,
        ) ??
        const TextStyle(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.64,
          color: AppColors.splashTitle,
        );
  }

  static const loginSubtitle = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.loginLabel,
  );

  static const loginFieldLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.loginLabel,
  );

  static const loginFieldText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.loginLabel,
  );

  static const loginFieldHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.loginHint,
  );

  static const loginButton = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const loginLink = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.loginLink,
  );

  static const loginFooter = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.loginLabel,
  );

  static const registerTitle = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    color: AppColors.splashTitle,
  );

  static const registerHelper = TextStyle(
    fontSize: 10,
    height: 15 / 10,
    fontWeight: FontWeight.w400,
    color: AppColors.loginHint,
  );

  static const registerFooterLink = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.loginLink,
  );

  static const homeAppBarTitle = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    color: AppColors.loginLink,
  );

  static const homeGreeting = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.64,
    color: AppColors.splashTitle,
  );

  static const boxCardTitle = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.splashTitle,
  );

  static const metricLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.loginLabel,
  );

  static const metricValue = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    color: AppColors.splashTitle,
  );

  static const statusBadge = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.statusOnlineText,
  );

  static const navActiveLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.navActiveText,
  );

  static const navInactiveLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.loginLabel,
  );

  static const activeGrowLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.loginLabel,
  );

  static const optimalBadge = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.optimalBadgeText,
  );

  static const boxTabActive = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.loginLink,
  );

  static const boxTabInactive = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.loginLabel,
  );

  static const sensorLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.loginLabel,
  );

  static const sensorLargeValue = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.64,
    color: AppColors.splashTitle,
  );

  static const sensorUnit = TextStyle(
    fontSize: 20,
    height: 40 / 20,
    fontWeight: FontWeight.w700,
    color: AppColors.loginLabel,
  );

  static const sensorTrend = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.loginLink,
  );

  static const deviceChipActive = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.loginLink,
  );

  static const deviceChipInactive = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.loginHint,
  );

  static const activityTime = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: AppColors.loginLink,
  );
}

ThemeData appTheme = ThemeData(
  useMaterial3: true,

  scaffoldBackgroundColor: AppColors.background,

  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
  ),

  cardTheme: CardThemeData(
    color: AppColors.card,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(
        color: AppColors.border,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: AppColors.border,
      ),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: AppColors.border,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: 1.5,
      ),
    ),
  ),
);
