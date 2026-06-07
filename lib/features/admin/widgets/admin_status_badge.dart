import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

enum AdminStatusType {
  online,
  offline,
  active,
  pending,
  processing,
  delivered,
  cancelled,
  success,
  warning,
  danger,
}

class AdminStatusBadge extends StatelessWidget {
  final String label;
  final AdminStatusType type;
  final bool small;

  const AdminStatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.small = false,
  });

  Color get _backgroundColor {
    switch (type) {
      case AdminStatusType.online:
        return AppColors.statusOnlineBackground;
      case AdminStatusType.offline:
        return AppColors.alertOfflineBg;
      case AdminStatusType.active:
        return AppColors.alertGreenBg;
      case AdminStatusType.pending:
        return AppColors.maintenancePendingBg;
      case AdminStatusType.processing:
        return AppColors.orderStatusPendingBg;
      case AdminStatusType.delivered:
        return AppColors.orderStatusDeliveredBg;
      case AdminStatusType.cancelled:
        return AppColors.orderStatusCancelledBg;
      case AdminStatusType.success:
        return AppColors.orderStatusDeliveredBg;
      case AdminStatusType.warning:
        return AppColors.maintenancePendingBg;
      case AdminStatusType.danger:
        return AppColors.orderStatusCancelledBg;
    }
  }

  Color get _textColor {
    switch (type) {
      case AdminStatusType.online:
        return AppColors.statusOnlineText;
      case AdminStatusType.offline:
        return const Color(0xFF6F7A6B);
      case AdminStatusType.active:
        return AppColors.alertGreenText;
      case AdminStatusType.pending:
        return AppColors.maintenancePendingText;
      case AdminStatusType.processing:
        return AppColors.orderStatusPending;
      case AdminStatusType.delivered:
        return AppColors.orderStatusDelivered;
      case AdminStatusType.cancelled:
        return AppColors.orderStatusCancelled;
      case AdminStatusType.success:
        return AppColors.orderStatusDelivered;
      case AdminStatusType.warning:
        return AppColors.maintenancePendingText;
      case AdminStatusType.danger:
        return AppColors.orderStatusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(small ? 6 : 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
          letterSpacing: small ? 0 : 0.4,
          color: _textColor,
        ),
      ),
    );
  }
}
