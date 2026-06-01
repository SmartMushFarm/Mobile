import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.isDanger = false,
  });

  final String title;
  final List<Widget> children;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: isDanger
                ? AppTextStyles.settingsDangerSectionHeader
                : AppTextStyles.settingsSectionHeader,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDanger
                ? const Color(0x1AFF0000)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDanger
                  ? AppColors.orderStatusCancelled.withValues(alpha: 0.2)
                  : AppColors.shopCategoryBorder.withValues(alpha: 0.2),
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.alertCardShadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(children: children),
        ),
      ],
    );
  }
}
