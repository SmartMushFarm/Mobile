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

  // Shop screen (Figma frame 2:840)
  static const shopSearchFill = Color(0xFFEFEDED);
  static const shopCategoryBorder = Color(0xFFBECAB9);
  static const shopCardBorder = Color(0xFFBECAB9);
  static const shopCardImageBg = Color(0xFFF5F3F3);
  static const shopTextPrimary = Color(0xFF1B1C1C);
  static const shopTextSecondary = Color(0xFF3F4A3C);
  static const shopPrice = Color(0xFF006E1C);
  static const shopCartBg = Color(0xFF006E1C);
  static const shopAlertBadge = Color(0xFFBA1A1A);
  static const shopDetailHeader = Color(0xFFFBF9F9);
  static const shopProBadge = Color(0xFF426E47);
  static const shopProBadgeBg = Color(0xFFBDEFBE);
  static const shopProductImageBg = Color(0xFFF5F3F3);
  static const shopFeatureChipBorder = Color(0xFFBECAB9);
  static const shopQuantitySelectorBg = Color(0xFFF5F3F3);
  static const shopRecommendedCardBorder = Color(0x33BECAB9);
  static const shopBuyNowBtn = Color(0xFF4CAF50);
  static const shopAddToCartBorder = Color(0xFF006E1C);

  // Cart screen (Figma frame 2:1101)
  static const cartCardShadow = Color(0x1F4CAF50);
  static const cartCardBorder = Color(0xFFBECAB9);
  static const cartImageBg = Color(0xFFF5F3F3);
  static const cartSummaryBg = Color(0xFFF5F3F3);
  static const cartDivider = Color(0xFFBECAB9);
  static const cartQtySelectorBg = Color(0xFFF5F3F3);
  static const cartQtySelectorBorder = Color(0xFFEFEDED);
  static const cartQtyBtnShadow = Color(0x0D000000);
  static const cartBtnShadow = Color(0x264CAF50);

  // Checkout screen (Figma frame 44:221)
  static const checkoutCardBorder = Color(0xFFE3E2E2);
  static const checkoutCardShadow = Color(0x0D000000);
  static const checkoutSectionBorder = Color(0xFFEFEDED);
  static const checkoutDeliveryActiveBg = Color(0x33BDEFBE);
  static const checkoutInputHint = Color(0xFF6F7A6B);
  static const checkoutSecureNote = Color(0xFF3F4A3C);

  // Order history screen
  static const orderChipBg = Color(0xFFF5F3F3);
  static const orderChipActiveBg = Color(0xFF006E1C);
  static const orderCardBorder = Color(0xFFE3E2E2);
  static const orderStatusDelivering = Color(0xFFE65100);
  static const orderStatusDeliveringBg = Color(0xFFFFF3E0);
  static const orderStatusPending = Color(0xFFFF8F00);
  static const orderStatusPendingBg = Color(0xFFFFF8E1);
  static const orderStatusDelivered = Color(0xFF2E7D32);
  static const orderStatusDeliveredBg = Color(0xFFE8F5E9);
  static const orderStatusCancelled = Color(0xFFC62828);
  static const orderStatusCancelledBg = Color(0xFFFFEBEE);
  static const orderSuggestionBg = Color(0xFFF1F8E9);
  static const alertCardShadow = Color(0x144CAF50);
  static const alertGreenBg = Color(0xFFBDEFBE);
  static const alertGreenText = Color(0xFF426E47);
  static const alertRedBg = Color(0xFFFFDAD6);
  static const alertOfflineBg = Color(0xFFE3E2E2);
  static const profileAvatarBorder = Color(0xFFF5F3F3);
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

  // Shop screen styles
  static const shopProductName = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const shopProductDesc = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const shopPrice = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.shopPrice,
  );

  static const shopCategoryActive = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: Colors.white,
  );

  static const shopCategoryInactive = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopTextSecondary,
  );

  static const shopSearchHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const shopBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const shopRating = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopTextSecondary,
  );

  // Product detail screen styles
  static const shopDetailName = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.24,
    color: AppColors.shopTextPrimary,
  );

  static const shopDetailPrice = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.24,
    color: AppColors.shopPrice,
  );

  static const shopDetailDescription = TextStyle(
    fontSize: 16,
    height: 26 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const shopFeatureChip = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopTextPrimary,
  );

  static const shopQuantity = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const shopSectionTitle = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const shopRecommendedProductName = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextPrimary,
  );

  static const shopRecommendedPrice = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopPrice,
  );

  static const shopBuyNowBtn = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const shopAddToCartBtn = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.shopPrice,
  );

  // Cart screen styles
  static const cartItemTitle = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const cartItemDesc = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const cartItemPrice = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.shopPrice,
  );

  static const cartQtyValue = TextStyle(
    fontSize: 16,
    height: 28 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const cartSummaryLabel = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const cartSummaryValue = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextPrimary,
  );

  static const cartSummaryTotalLabel = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const cartSummaryTotalValue = TextStyle(
    fontSize: 32,
    height: 32 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.64,
    color: AppColors.shopPrice,
  );

  static const cartSummaryCurrency = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopTextSecondary,
  );

  static const cartSectionLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.shopTextSecondary,
  );

  static const cartCheckoutBtn = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const cartSecureNote = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopTextSecondary,
  );

  static const cartItemCount = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.64,
    color: AppColors.shopTextPrimary,
  );

  static const cartClearBtn = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.shopPrice,
  );

  // Checkout screen styles
  static const checkoutSectionTitle = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const checkoutAddressName = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const checkoutAddressDetail = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const checkoutEditBtn = TextStyle(
    fontSize: 14,
    height: 24 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.8,
    color: AppColors.shopPrice,
  );

  static const checkoutOrderItemName = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const checkoutOrderItemQty = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopTextSecondary,
  );

  static const checkoutOrderItemPrice = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.shopPrice,
  );

  static const checkoutDeliveryName = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextPrimary,
  );

  static const checkoutDeliveryPrice = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextSecondary,
  );

  static const checkoutPaymentName = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextPrimary,
  );

  static const checkoutPromoInput = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.checkoutInputHint,
  );

  static const checkoutApplyBtn = TextStyle(
    fontSize: 14,
    height: 24 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.6,
    color: Colors.white,
  );

  static const checkoutBreakdownLabel = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const checkoutBreakdownValue = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const checkoutTotalLabel = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const checkoutTotalValue = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.64,
    color: AppColors.shopPrice,
  );

  static const checkoutPlaceOrderBtn = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const checkoutSecureNote = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.checkoutSecureNote,
  );

  // Order history styles
  static const orderChipLabel = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
    color: AppColors.shopTextSecondary,
  );

  static const orderChipLabelActive = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const orderCardId = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w700,
    color: AppColors.shopTextPrimary,
  );

  static const orderCardDate = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const orderCardProducts = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const orderCardTotal = TextStyle(
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w700,
    color: AppColors.shopPrice,
  );

  static const orderSuggestionText = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.shopTextPrimary,
  );

  // Alerts screen styles
  static const alertSummaryLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopTextSecondary,
  );

  static const alertSummaryValue = TextStyle(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const alertCardTitle = TextStyle(
    fontSize: 16,
    height: 25 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.shopTextPrimary,
  );

  static const alertCardDesc = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextSecondary,
  );

  static const alertCardTime = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.shopTextSecondary,
  );

  static const alertAutoBadge = TextStyle(
    fontSize: 10,
    height: 15 / 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.alertGreenText,
  );

  static const alertViewBoxBtn = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: Colors.white,
  );

  // Profile screen styles
  static const profileSectionHeader = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    color: AppColors.shopPrice,
  );

  static const profileMenuItem = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.shopTextPrimary,
  );

  static const profileLogoutBtn = TextStyle(
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF003C0B),
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
