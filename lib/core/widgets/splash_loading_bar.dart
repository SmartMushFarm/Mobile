import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class SplashLoadingBar extends StatelessWidget {
  const SplashLoadingBar({
    super.key,
    required this.progress,
    this.height = 4,
  });

  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.splashTrack),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedProgress,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.splashGradientStart,
                      AppColors.splashGradientEnd,
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
