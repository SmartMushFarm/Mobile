import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_dashboard_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_stat_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_device_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_alert_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_action_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_severity_badge.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildStatGrid(),
                    const SizedBox(height: 24),
                    _buildRealtimeDevices(),
                    const SizedBox(height: 24),
                    _buildCriticalAlerts(),
                    const SizedBox(height: 24),
                    _buildMaintenanceSummary(),
                    const SizedBox(height: 24),
                    _buildManagementActions(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SmartFarm Admin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          AdminNotificationBell(badgeCount: 3),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid() {
    final stats = AdminDashboardData.stats;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return AdminStatCard(
          label: stat['label'] as String,
          value: stat['value'] as String,
          icon: _iconFromString(stat['icon'] as String),
          color: Color(stat['color'] as int),
        );
      },
    );
  }

  Widget _buildRealtimeDevices() {
    final devices = AdminDashboardData.devices;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Realtime Device Monitoring',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...devices.map((d) {
          final statusStr = d['status'] as String;
          final status = statusStr == 'offline'
              ? DeviceStatus.offline
              : statusStr == 'warning'
                  ? DeviceStatus.warning
                  : DeviceStatus.online;
          return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AdminDeviceCard(
                name: d['name'] as String,
                status: status,
                lastSync: d['lastSync'] as String? ?? 'Unknown',
                temperature: d['temperature'] as double?,
                humidity: d['humidity'] as double?,
                alert: d['alert'] as String?,
                co2: d['co2'] as int?,
                actions: List<String>.from(d['actions'] as List),
              ));
        }),
      ],
    );
  }

  Widget _buildCriticalAlerts() {
    final alerts = AdminDashboardData.alerts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Critical Alerts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...alerts.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AdminAlertCard(
                device: a['device'] as String,
                time: a['time'] as String,
                title: a['title'] as String,
                description: a['description'] as String,
                severity: AlertSeverity.values.firstWhere(
                  (s) => s.name == a['severity'],
                  orElse: () => AlertSeverity.success,
                ),
                buttons: List<String>.from(a['buttons'] as List),
              ),
            )),
      ],
    );
  }

  Widget _buildMaintenanceSummary() {
    final summary = AdminDashboardData.maintenanceSummary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maintenance Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _buildMaintenanceItem(
                'Pending',
                '${summary['pending']}',
                AppColors.warning,
              ),
              _buildMaintenanceDivider(),
              _buildMaintenanceItem(
                'Assigned',
                '${summary['assigned']}',
                const Color(0xFF0EA5E9),
              ),
              _buildMaintenanceDivider(),
              _buildMaintenanceItem(
                'Done Today',
                '${summary['doneToday']}',
                AppColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceDivider() {
    return Container(
      width: 1,
      height: 50,
      color: AppColors.border,
    );
  }

  Widget _buildManagementActions() {
    final actions = AdminDashboardData.actions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Management Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.95,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return AdminActionCard(
              label: action['label'] as String,
              icon: _iconFromString(action['icon'] as String),
              route: action['route'] as String,
            );
          },
        ),
      ],
    );
  }

  IconData _iconFromString(String name) {
    switch (name) {
      case 'sensors':
        return Icons.sensors;
      case 'sensors_off':
        return Icons.sensors_off;
      case 'confirmation_number':
        return Icons.confirmation_number;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'receipt_long':
        return Icons.receipt_long;
      case 'people':
        return Icons.people;
      case 'system_update':
        return Icons.system_update;
      case 'notifications':
        return Icons.notifications;
      default:
        return Icons.circle;
    }
  }
}
