import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_metric_tile.dart';

enum DeviceStatus { online, offline, warning }

class AdminDeviceCard extends StatelessWidget {
  final String name;
  final DeviceStatus status;
  final String lastSync;
  final String? alert;
  final double? temperature;
  final double? humidity;
  final int? co2;
  final List<String> actions;

  const AdminDeviceCard({
    super.key,
    required this.name,
    required this.status,
    required this.lastSync,
    this.alert,
    this.temperature,
    this.humidity,
    this.co2,
    required this.actions,
  });

  bool get _isOnline => status == DeviceStatus.online;
  bool get _isWarning => status == DeviceStatus.warning;
  bool get _isOffline => status == DeviceStatus.offline;

  Color get _statusColor {
    if (_isOnline) return AppColors.success;
    if (_isWarning) return AppColors.warning;
    return const Color(0xFF9CA3AF);
  }

  String get _statusLabel {
    if (_isOnline) return 'Online';
    if (_isWarning) return 'Warning';
    return 'Offline';
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'restart':
        _showSnackBar(context, 'Restarting $name...');
        break;
      case 'ota_update':
        _showSnackBar(context, 'OTA Update for $name...');
        break;
      case 'details':
        _showSnackBar(context, 'Opening details for $name...');
        break;
      case 'reconnect':
        _showSnackBar(context, 'Reconnecting $name...');
        break;
      case 'diagnostics':
        _showSnackBar(context, 'Running diagnostics for $name...');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isOffline
              ? AppColors.border
              : _statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDeviceIcon(),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDeviceInfo()),
                    _buildStatusBadge(),
                  ],
                ),
                if (alert != null) ...[
                  const SizedBox(height: 10),
                  _buildAlertBadge(),
                ],
                if (!_isOffline) ...[
                  const SizedBox(height: 12),
                  _buildMetrics(),
                ],
                const SizedBox(height: 12),
                _buildLastSync(),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDeviceIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _isOffline
            ? AppColors.alertOfflineBg
            : _statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.sensors,
        color: _isOffline ? const Color(0xFF9CA3AF) : _statusColor,
        size: 26,
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isOffline
                ? const Color(0xFF9CA3AF)
                : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'ID: ${name.replaceAll(' ', '_').toUpperCase()}-001',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary.withValues(alpha: _isOffline ? 0.4 : 1.0),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _statusLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBadge() {
    final isHighTemp = alert!.toLowerCase().contains('temp');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isHighTemp
            ? AppColors.danger.withValues(alpha: 0.1)
            : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighTemp
              ? AppColors.danger.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: isHighTemp ? AppColors.danger : AppColors.warning,
          ),
          const SizedBox(width: 4),
          Text(
            alert!,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isHighTemp ? AppColors.danger : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        AdminMetricTile(
          icon: Icons.thermostat,
          value: temperature != null ? '${temperature!.toStringAsFixed(1)}°C' : '--',
          label: 'Temperature',
          enabled: temperature != null,
        ),
        AdminMetricTile(
          icon: Icons.water_drop,
          value: humidity != null ? '${humidity!.toStringAsFixed(0)}%' : '--',
          label: 'Humidity',
          enabled: humidity != null,
        ),
        AdminMetricTile(
          icon: Icons.cloud_outlined,
          value: co2 != null ? '$co2 ppm' : '--',
          label: 'CO2',
          enabled: co2 != null,
        ),
      ],
    );
  }

  Widget _buildLastSync() {
    final disconnectText = _isOffline ? 'Disconnected' : 'Last sync';
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 13,
          color: _isOffline
              ? const Color(0xFF9CA3AF)
              : AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          '$disconnectText: $lastSync',
          style: TextStyle(
            fontSize: 11,
            color: _isOffline
                ? const Color(0xFF9CA3AF)
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: actions.asMap().entries.map((entry) {
          final action = entry.value;
          final isLast = entry.key == actions.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: isLast ? 0 : 4, right: isLast ? 0 : 4),
              child: _ActionButton(
                action: action,
                isOffline: _isOffline,
                onTap: () => _handleAction(context, action),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String action;
  final bool isOffline;
  final VoidCallback onTap;

  const _ActionButton({
    required this.action,
    required this.isOffline,
    required this.onTap,
  });

  String get _label {
    switch (action) {
      case 'restart':
        return 'Restart';
      case 'ota_update':
        return 'OTA Update';
      case 'details':
        return 'Details';
      case 'reconnect':
        return 'Reconnect';
      case 'diagnostics':
        return 'Diagnostics';
      default:
        return action;
    }
  }

  IconData get _icon {
    switch (action) {
      case 'restart':
        return Icons.refresh;
      case 'ota_update':
        return Icons.system_update;
      case 'details':
        return Icons.info_outline;
      case 'reconnect':
        return Icons.wifi;
      case 'diagnostics':
        return Icons.build_outlined;
      default:
        return Icons.circle;
    }
  }

  Color get _color {
    switch (action) {
      case 'restart':
        return AppColors.warning;
      case 'ota_update':
        return AppColors.primary;
      case 'details':
        return AppColors.primary;
      case 'reconnect':
        return AppColors.success;
      case 'diagnostics':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: 14, color: _color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                _label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
