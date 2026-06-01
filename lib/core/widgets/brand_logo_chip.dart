import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class BrandLogoChip extends StatelessWidget {
  const BrandLogoChip({
    super.key,
    this.size = 48,
    this.logoAssetPath = 'assets/images/splash_logo.svg',
  });

  final double size;
  final String logoAssetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.splashLogoSurface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.splashGlow.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: SvgPicture.asset(
          logoAssetPath,
          width: size * 0.4375,
          height: size * 0.4861,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
