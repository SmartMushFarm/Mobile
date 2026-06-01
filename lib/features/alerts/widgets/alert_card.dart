import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/alerts/models/alert_item.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.alert,
    required this.onMarkRead,
  });

  final AlertItem alert;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.shopCategoryBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.alertCardShadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left severity stripe
              Container(width: 4, color: _stripeColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            alert.icon,
                            size: 20,
                            color: AppColors.shopTextPrimary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alert.title,
                                  style: AppTextStyles.alertCardTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (alert.automationBadge != null) ...[
                                  const SizedBox(height: 8),
                                  _AutomationBadge(label: alert.automationBadge!),
                                ],
                                const SizedBox(height: 4),
                                Text(
                                  alert.description,
                                  style: AppTextStyles.alertCardDesc,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            alert.timestamp,
                            style: AppTextStyles.alertCardTime,
                          ),
                        ],
                      ),
                      if (alert.hasViewBox) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              context.push('/box/overview', extra: alert.boxId ?? '');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.orderStatusCancelled,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Xem hộp',
                                style: AppTextStyles.alertViewBoxBtn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!alert.isRead)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.shopPrice,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color get _stripeColor {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return AppColors.orderStatusCancelled;
      case AlertSeverity.warning:
        return const Color(0xFFEAB308);
      case AlertSeverity.automation:
      case AlertSeverity.info:
        return AppColors.shopPrice;
      case AlertSeverity.device:
        return AppColors.shopCategoryBorder;
      case AlertSeverity.maintenance:
        return const Color(0xFF7C3AED);
    }
  }
}

class _AutomationBadge extends StatelessWidget {
  const _AutomationBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.alertGreenBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.alertAutoBadge,
      ),
    );
  }
}
