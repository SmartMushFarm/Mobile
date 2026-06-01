import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    required this.onTap,
    this.iconBgColor,
    this.valueColor,
    this.labelColor,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final Color? iconBgColor;
  final Color? valueColor;
  final Color? labelColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor ?? const Color(0xFFEFEDED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 22,
                color: AppColors.shopTextPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.settingsItemLabel.copyWith(
                  color: labelColor,
                ),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: AppTextStyles.settingsItemValue.copyWith(
                  color: valueColor ?? AppColors.shopTextSecondary,
                ),
              ),
              const SizedBox(width: 4),
            ],
            trailing ??
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.shopTextSecondary,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}
