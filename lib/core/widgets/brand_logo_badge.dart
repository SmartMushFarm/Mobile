import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class BrandLogoBadge extends StatelessWidget {
  const BrandLogoBadge({
    super.key,
    this.size = 128,
    this.logoAssetPath = 'assets/images/splash_logo.svg',
  });

  final double size;
  final String logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final logoWidth = size * 0.375;
    final logoHeight = size * 0.4167;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.splashGlow.withValues(alpha: 0.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.splashGlow.withValues(alpha: 0.2),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.splashLogoSurface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.splashGlow.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                logoAssetPath,
                width: logoWidth,
                height: logoHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
