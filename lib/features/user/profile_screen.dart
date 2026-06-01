import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        backgroundColor: AppColors.loginBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
          onPressed: () => context.go('/home'),
        ),
          title: Text(
            'Hồ sơ',
            style: GoogleFonts.plusJakartaSans(
              textStyle: AppTextStyles.registerTitle,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Màn hình hồ sơ',
            style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
          ),
        ),
    );
  }
}
