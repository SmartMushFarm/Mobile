import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/models/device_item.dart';
import 'package:smartmush_farmer/features/user/widgets/device_status_badge.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    super.key,
    required this.device,
    required this.onRename,
    required this.onRestart,
    required this.onRemove,
    required this.onRetry,
    required this.onViewDetails,
  });

  final DeviceItem device;
  final VoidCallback onRename;
  final VoidCallback onRestart;
  final VoidCallback onRemove;
  final VoidCallback onRetry;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final isOnline = device.status == DeviceStatus.online;

    return Container(
      decoration: BoxDecoration(
        color: isOnline
            ? Colors.white
            : const Color(0xFFF2F0EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orderCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.alertCardShadow,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isOnline),
                if (isOnline) ...[
                  const SizedBox(height: 16),
                  _buildSensorStats(),
                  const SizedBox(height: 12),
                  _buildActiveIndicators(),
                ],
                if (!isOnline && device.offlineMessage != null) ...[
                  const SizedBox(height: 12),
                  _buildOfflineOverlay(),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.orderCardBorder),
          _buildActions(isOnline),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isOnline) {
    return Row(
      children: [
        Icon(
          Icons.thermostat_outlined,
          size: 20,
          color: isOnline
              ? AppColors.shopTextPrimary
              : const Color(0xFF6F7A6B),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            device.name,
            style: isOnline
                ? AppTextStyles.deviceCardTitle
                : AppTextStyles.deviceCardOfflineTitle,
          ),
        ),
        DeviceStatusBadge(status: device.status),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onViewDetails,
          child: const Icon(
            Icons.chevron_right,
            color: AppColors.shopTextSecondary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSensorStats() {
    return Row(
      children: [
        if (device.temperature != null)
          _SensorTile(
            icon: Icons.thermostat_outlined,
            label: 'NHIỆT ĐỘ',
            value: device.temperature!,
          ),
        if (device.temperature != null && device.humidity != null)
          const SizedBox(width: 16),
        if (device.humidity != null)
          _SensorTile(
            icon: Icons.water_drop_outlined,
            label: 'ĐỘ ẨM',
            value: device.humidity!,
          ),
      ],
    );
  }

  Widget _buildActiveIndicators() {
    final items = <Widget>[];
    if (device.isLedOn) {
      items.add(_ActiveBadge(label: 'ĐÈN LED BẬT', icon: Icons.lightbulb_outline));
    }
    if (device.isMistOn) {
      items.add(_ActiveBadge(label: 'PHUN SƯƠNG BẬT', icon: Icons.water_drop_outlined));
    }
    if (device.isFanOn) {
      items.add(_ActiveBadge(label: 'QUẠT BẬT', icon: Icons.wind_power));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items,
    );
  }

  Widget _buildOfflineOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off,
            size: 16,
            color: AppColors.shopTextSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              device.offlineMessage!,
              style: AppTextStyles.alertCardDesc,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(bool isOnline) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionButton(
            label: 'ĐỔI TÊN',
            color: AppColors.shopPrice,
            onTap: onRename,
          ),
          _ActionButton(
            label: isOnline ? 'KHỞI ĐỘNG LẠI' : 'THỬ LẠI',
            color: AppColors.shopPrice,
            onTap: isOnline ? onRestart : onRetry,
          ),
          _ActionButton(
            label: 'XÓA',
            color: AppColors.orderStatusCancelled,
            onTap: onRemove,
          ),
        ],
      ),
    );
  }
}

class _SensorTile extends StatelessWidget {
  const _SensorTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.shopTextSecondary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.deviceSensorLabel),
            Text(value, style: AppTextStyles.deviceSensorValue),
          ],
        ),
      ],
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.shopPrice,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.deviceActiveBadge.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          label,
          style: AppTextStyles.deviceActionLabel.copyWith(color: color),
        ),
      ),
    );
  }
}
