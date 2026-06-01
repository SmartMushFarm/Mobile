import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/models/maintenance_ticket.dart';

class MaintenanceStatusBadge extends StatelessWidget {
  const MaintenanceStatusBadge({super.key, required this.status});

  final MaintenanceStatus status;

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor, label) = _config;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: textColor,
        ),
      ),
    );
  }

  (Color, Color, String) get _config {
    switch (status) {
      case MaintenanceStatus.pending:
        return (
          AppColors.maintenancePendingBg,
          AppColors.maintenancePendingText,
          'ĐANG CHỜ',
        );
      case MaintenanceStatus.accepted:
        return (
          AppColors.maintenanceAcceptedBg,
          AppColors.maintenanceAcceptedText,
          'ĐÃ TIẾP NHẬN',
        );
      case MaintenanceStatus.technicianAssigned:
        return (
          AppColors.maintenanceAssignedBg,
          AppColors.maintenanceAssignedText,
          'KỸ THUẬT VIÊN ĐƯỢC CHỈ ĐỊNH',
        );
      case MaintenanceStatus.completed:
        return (
          AppColors.maintenanceCompletedBg,
          AppColors.maintenanceCompletedText,
          'HOÀN THÀNH',
        );
    }
  }
}
