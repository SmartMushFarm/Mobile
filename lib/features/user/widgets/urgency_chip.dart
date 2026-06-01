import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class UrgencyChip extends StatelessWidget {
  const UrgencyChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: isActive ? AppColors.shopPrice : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: isActive
                ? null
                : Border.all(color: AppColors.loginInputBorder),
          ),
          child: Center(
            child: Text(
              label,
              style: isActive
                  ? AppTextStyles.formUrgencyActive
                  : AppTextStyles.formUrgencyInactive,
            ),
          ),
        ),
      ),
    );
  }
}
