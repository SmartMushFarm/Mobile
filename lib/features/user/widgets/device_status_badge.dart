import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/models/device_item.dart';

class DeviceStatusBadge extends StatelessWidget {
  const DeviceStatusBadge({super.key, required this.status});

  final DeviceStatus status;

  @override
  Widget build(BuildContext context) {
    final isOnline = status == DeviceStatus.online;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isOnline ? AppColors.alertGreenBg : AppColors.alertOfflineBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline
                  ? AppColors.shopPrice
                  : const Color(0xFF6F7A6B),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'ONLINE' : 'OFFLINE',
            style: isOnline
                ? AppTextStyles.deviceActiveBadge
                : AppTextStyles.deviceOfflineBadge,
          ),
        ],
      ),
    );
  }
}
