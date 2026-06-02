import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/brand_logo_badge.dart';
import 'package:smartmush_farmer/core/widgets/splash_loading_bar.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _splashDuration = Duration(milliseconds: 2200);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _splashDuration,
    )..forward();

    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(_splashDuration);
    if (!mounted) return;

    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.splashBackground,
          gradient: RadialGradient(
            center: Alignment(0, 0.5),
            radius: 1.2,
            colors: [
              Color(0x084CAF50),
              Color(0x004CAF50),
            ],
            stops: [0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 96),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const BrandLogoBadge(),
                        const SizedBox(height: 24),
                        Text(
                          'SmartMush Farmer',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: AppTextStyles.splashTitle(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hệ thống nấm tự động',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            textStyle: AppTextStyles.splashTagline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 384),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Column(
                          children: [
                            SplashLoadingBar(progress: _controller.value),
                            const SizedBox(height: 12),
                            Text(
                              'Sẵn sàng.',
                              style: GoogleFonts.inter(
                                textStyle: AppTextStyles.splashStatus,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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
