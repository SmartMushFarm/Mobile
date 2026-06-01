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
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.shopCategoryBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D4CAF50),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.alertSummaryLabel,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: AppTextStyles.alertSummaryValue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
