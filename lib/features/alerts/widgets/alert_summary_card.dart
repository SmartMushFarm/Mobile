import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class AlertSummaryCard extends StatelessWidget {
  const AlertSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBgColor,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.shopCategoryBorder.withValues(alpha: 0.3)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D4CAF50),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: AppColors.shopTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.alertSummaryLabel,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.alertSummaryValue,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
